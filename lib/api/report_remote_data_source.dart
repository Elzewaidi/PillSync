import 'package:flutter/foundation.dart';
import 'package:pillsync/api/core/api_constants.dart';
import 'package:pillsync/api/core/api_manager.dart';
import 'package:pillsync/model/report_model.dart';

abstract class ReportRemoteDataSource {
  Future<List<ReportModel>> getMedicineReports();
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final ApiManager apiManager;

  ReportRemoteDataSourceImpl({required this.apiManager});

  @override
  Future<List<ReportModel>> getMedicineReports() async {
    final response = await apiManager.getData(
      ApiConstants.baseUrl + ApiConstants.weeklyAdherence,
    );

    debugPrint("📋 Report API Response Type: ${response.runtimeType}");
    debugPrint("📋 Report API Response: $response");

    // Case 1: API returns a direct List
    if (response is List) {
      return response
          .map((json) => ReportModel.fromJson(Map<String, dynamic>.from(json as Map)))
          .toList();
    }

    // Case 2: API returns a Map with nested data
    if (response is Map<String, dynamic>) {
      // Try common nested keys
      final data = response['data'] ?? response['weeklyAdherence'] ?? response['reports'];
      if (data is List) {
        return data
            .map((json) => ReportModel.fromJson(Map<String, dynamic>.from(json as Map)))
            .toList();
      }
      
      // If the Map itself looks like a single report, wrap it
      if (response.containsKey('medicineName') || response.containsKey('medicineId')) {
        return [ReportModel.fromJson(response)];
      }
    }

    // Fallback
    debugPrint("⚠️ Report API: Unexpected response format");
    return [];
  }
}

