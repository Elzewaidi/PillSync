import 'dart:convert';

import 'package:pillsync/api/api_manager.dart';
import 'package:pillsync/api/end_points.dart';
import 'package:pillsync/injection_container.dart' as di;
import 'package:pillsync/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:pillsync/core/errors/exceptions.dart' show UnauthorizedException;

import '../model/medication_model.dart';

class MedicationRepository {
  final ApiManager _apiManager;

  MedicationRepository({ApiManager? apiManager})
      : _apiManager = apiManager ?? ApiManager();

  Future<String> _getCurrentUserId() async {
    try {
      final user = await di.sl<AuthLocalDataSource>().getCachedUser();
      if (user != null && user.userId.isNotEmpty) {
        return user.userId;
      }
      return "";
    } catch (_) {
      return "";
    }
  }

  Future<List<Medication>> getMedications() async {
    try {
      final response = await _apiManager.getRequest(
        endpoint: EndPoints.getAllMedicines,
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'Failed to load medications (status ${response.statusCode})',
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw const FormatException('Invalid medications response format');
      }

      final userId = await _getCurrentUserId();
      return decoded
          .map((item) => Medication.fromJson(item as Map<String, dynamic>))
          .where((med) =>
      med.memberId == userId && med.isDeleted == false)
          .toList();
    } on UnauthorizedException {
      rethrow;
    } on FormatException catch (e) {
      throw Exception('Failed to parse medications data: ${e.message}');
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to load medications: $e');
    }
  }

  Future<void> addMedication(Medication medication) async {
    try {
      final userId = await _getCurrentUserId();
      final body = medication.toJson()
        ..['memberId'] = userId;

      final response = await _apiManager.postRequest(
        endpoint: EndPoints.addMedication,
        body: body,
      );

      if (response.statusCode != 204) {
        throw Exception(
          'Failed to add medication (status ${response.statusCode})',
        );
      }
    } on UnauthorizedException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to add medication: $e');
    }
  }

  Future<void> deleteMedication(String medicineId) async {
    try {
      final response = await _apiManager.putRequest(
        endpoint: '${EndPoints.removeMedicine}/$medicineId',
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'Failed to delete medication (status ${response.statusCode})',
        );
      }
    } on UnauthorizedException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to delete medication: $e');
    }
  }
}