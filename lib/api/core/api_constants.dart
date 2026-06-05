class ApiConstants {
  static const String baseUrl = "https://pillsync-api.onrender.com/api/";
  static const String weeklyAdherence = "medicines/weeklyAdherence";
  
  // Bearer Token for Authentication (Paste your token from Postman here)
  static const String authToken = "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InRlc3R1c2VyQGV4YW1wbGUuY29tIiwibmFtZWlkIjoiMTIzNDhmZDEtOTc5ZS00ZjhlLWEzODQtMWM4MjQ1NDBiZGU2IiwibmJmIjoxNzgwNjg0MTk1LCJleHAiOjE3ODMyNzYxOTUsImlhdCI6MTc4MDY4NDE5NX0.NguXwVz8gyxdVDbnOGQ1Q2W9z074d6brp-LJld6zwPVXFMzDFP_kwmgcIpiPmVsXFRtYPcC95CNq4nQZy42_iw"; 

  // Overpass API for Nearby Pharmacies (No API Key Required)
  static const String overpassBaseUrl = "https://overpass-api.de/api/interpreter";
  
  static const int apiTimeOutInSeconds = 60;
}

