import 'package:pillsync/api/core/api_manager.dart';
import 'package:pillsync/api/core/api_constants.dart';

abstract class PharmacyRemoteDataSource {
  Future<Map<String, dynamic>> fetchNearbyPharmacies(double latitude, double longitude);
}

class PharmacyRemoteDataSourceImpl implements PharmacyRemoteDataSource {
  final ApiManager apiManager;

  PharmacyRemoteDataSourceImpl({required this.apiManager});

  @override
  Future<Map<String, dynamic>> fetchNearbyPharmacies(double latitude, double longitude) async {
    final query = '[out:json][timeout:25];node(around:1500,$latitude,$longitude)[amenity=pharmacy];out body;';
    
    final response = await apiManager.getData(
      ApiConstants.overpassBaseUrl,
      queryParameters: {
        'data': query,
      },
      headers: {
        'User-Agent': 'PillSyncApp/1.0 (moham@pillsync.com)',
      },
    );
    
    return response as Map<String, dynamic>;
  }
}

