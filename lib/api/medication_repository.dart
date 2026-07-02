import 'dart:convert';

import 'package:pillsync/api/api_manager.dart';
import 'package:pillsync/api/end_points.dart';

import '../model/medication_model.dart';

class MedicationRepository {
  static const String currentUserId = '7bc4aafa-649f-40b6-95c9-c67930528b15';
  final ApiManager _apiManager;

  MedicationRepository({ApiManager? apiManager})
      : _apiManager = apiManager ?? ApiManager();

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

      return decoded
          .map((item) => Medication.fromJson(item as Map<String, dynamic>))
          .where((med) =>
      med.memberId == currentUserId && med.isDeleted == false)
          .toList();
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
      final body = medication.toJson()
        ..['memberId'] = currentUserId;

      final response = await _apiManager.postRequest(
        endpoint: EndPoints.addMedication,
        body: body,
      );

      if (response.statusCode != 204) {
        throw Exception(
          'Failed to add medication (status ${response.statusCode})',
        );
      }
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
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to delete medication: $e');
    }
  }
}
