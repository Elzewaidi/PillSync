import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pillsync/api/pharmacy_repository.dart';
import 'package:pillsync/services/location_service.dart';
import 'package:pillsync/model/pharmacy_model.dart';
import 'package:pillsync/cubit/location_pharmacy/pharmacy/pharmacy_state.dart';

class PharmacyCubit extends Cubit<PharmacyState> {
  final PharmacyRepository pharmacyRepository;
  final LocationService locationService;
  StreamSubscription<LocationDetails>? _locationSubscription;
  
  // Static variables persist in RAM across screen exits and entries
  static List<PharmacyModel> _cachedPharmacies = [];
  static String _cachedLocationName = "موقع غير معروف";
  static LocationDetails? _lastFetchedLocation;

  String get currentLocationName => _cachedLocationName;

  PharmacyCubit({
    required this.pharmacyRepository, 
    required this.locationService
  }) : super(PharmacyInitial());

  Future<void> fetchNearbyPharmacies() async {
    // 1. Cache First: Show instantly if we have data
    if (_cachedPharmacies.isNotEmpty) {
      emit(PharmacyLoaded(List.from(_cachedPharmacies), _cachedLocationName));
    } else {
      emit(PharmacyLoading());
    }

    try {
      // 2. Fetch current location quietly
      final initialLocation = await locationService.getCurrentLocationDetails();
      
      bool shouldFetchNew = true;
      if (_lastFetchedLocation != null) {
        final distance = Geolocator.distanceBetween(
           _lastFetchedLocation!.latitude,
           _lastFetchedLocation!.longitude,
           initialLocation.latitude,
           initialLocation.longitude,
        );
        // If distance is less than 1.5km and we have cache, no need to API fetch
        if (distance < 1500 && _cachedPharmacies.isNotEmpty) {
           shouldFetchNew = false;
        }
      }

      if (shouldFetchNew) {
         if (_cachedPharmacies.isEmpty) {
             emit(PharmacyLoading());
         }
         _lastFetchedLocation = initialLocation;
         await _fetchPharmaciesForLocation(initialLocation);
      }

      // 3. Set up Live Background Tracking with Distance Caching
      _locationSubscription?.cancel();
      _locationSubscription = locationService.getLocationStream().listen(
        (locationDetails) async {
           if (_lastFetchedLocation != null) {
              final distance = Geolocator.distanceBetween(
                 _lastFetchedLocation!.latitude,
                 _lastFetchedLocation!.longitude,
                 locationDetails.latitude,
                 locationDetails.longitude,
              );
              
              if (distance < 1500) {
                 return; // Ignore slight location changes
              }
           }
           
           _lastFetchedLocation = locationDetails;
           await _fetchPharmaciesForLocation(locationDetails);
        },
        onError: (e) {
          // Ignore minor geostream drops
        }
      );

    } catch (e) {
      // Only show error screen if we don't have any cached data to show
      if (_cachedPharmacies.isEmpty) {
        String cleanE = e.toString().replaceAll("Exception: ", "");
        emit(PharmacyError(cleanE));
      }
    }
  }

  Future<void> _fetchPharmaciesForLocation(LocationDetails location) async {
    final failureOrPharmacies = await pharmacyRepository.getNearbyPharmacies(
      location.latitude, 
      location.longitude
    );
    
    failureOrPharmacies.fold(
      (failure) {
        if (_cachedPharmacies.isEmpty) {
          emit(PharmacyError(failure.message));
        }
      },
      (pharmacies) {
        if (pharmacies.isEmpty && _cachedPharmacies.isEmpty) {
           emit(const PharmacyError("لم نتمكن من إيجاد صيدليات قريبة منك."));
        } else if (pharmacies.isNotEmpty) {
           _cachedPharmacies = pharmacies;
           _cachedLocationName = location.localityName;
           emit(PharmacyLoaded(List.from(pharmacies), location.localityName));
        }
      }
    );
  }

  void searchPharmacies(String query) {
    if (_cachedPharmacies.isEmpty) return;
    
    if (query.trim().isEmpty) {
      emit(PharmacyLoaded(List.from(_cachedPharmacies), _cachedLocationName));
      return;
    }

    final lowerQuery = query.toLowerCase();
    final filtered = _cachedPharmacies.where((pharmacy) {
      return pharmacy.name.toLowerCase().contains(lowerQuery) ||
             pharmacy.address.toLowerCase().contains(lowerQuery);
    }).toList();

    emit(PharmacyLoaded(filtered, _cachedLocationName));
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
