import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  
  print('--- Testing Render API (Weekly Adherence) ---');
  final token = "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InRlc3R1c2VyQGV4YW1wbGUuY29tIiwibmFtZWlkIjoiMTIzNDhmZDEtOTc5ZS00ZjhlLWEzODQtMWM4MjQ1NDBiZGU2IiwibmJmIjoxNzgwNjg0MTk1LCJleHAiOjE3ODMyNzYxOTUsImlhdCI6MTc4MDY4NDE5NX0.NguXwVz8gyxdVDbnOGQ1Q2W9z074d6brp-LJld6zwPVXFMzDFP_kwmgcIpiPmVsXFRtYPcC95CNq4nQZy42_iw";

  try {
    final response = await dio.get(
      'https://pillsync-api.onrender.com/api/medicines/weeklyAdherence',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print('Render API Status Code: ${response.statusCode}');
    print('Render API Response Headers: ${response.headers}');
    print('Render API Response Data: ${response.data}');
  } catch (e) {
    print('Render API Error: $e');
    if (e is DioException) {
      print('Status: ${e.response?.statusCode}');
      print('Response Headers: ${e.response?.headers}');
      print('Response Data: ${e.response?.data}');
    }
  }

  print('\n--- Testing Render API (Medicines list) ---');
  try {
    final response = await dio.get('https://pillsync-api.onrender.com/api/medicines');
    print('Medicines API Status Code: ${response.statusCode}');
    print('Medicines API Response Data: ${response.data}');
  } catch (e) {
    print('Medicines API Error: $e');
    if (e is DioException) {
      print('Status: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
    }
  }

  print('\n--- Testing Overpass API (Pharmacies) ---');
  try {
    final double lat = 30.0444; // Cairo lat
    final double lon = 31.2357; // Cairo lon
    final query = '[out:json][timeout:25];node(around:1500,$lat,$lon)[amenity=pharmacy];out body;';
    final response = await dio.get(
      'https://overpass-api.de/api/interpreter',
      queryParameters: {'data': query},
      options: Options(
        headers: {
          'User-Agent': 'PillSyncApp/1.0 (moham@pillsync.com)',
        },
      ),
    );
    print('Overpass Status Code: ${response.statusCode}');
    final elements = response.data['elements'] as List;
    print('Found ${elements.length} pharmacies.');
    if (elements.isNotEmpty) {
      print('First pharmacy tags: ${elements.first}');
    }
  } catch (e) {
    print('Overpass Error: $e');
    if (e is DioException) {
      print('Overpass Response Status: ${e.response?.statusCode}');
      print('Overpass Response Headers: ${e.response?.headers}');
      print('Overpass Response Data: ${e.response?.data}');
    }
  }
}
