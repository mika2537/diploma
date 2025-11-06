import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Change this depending on your setup:
  static const String baseUrl = "http://10.0.2.2:5050/api"; // Android emulator
  // For iOS simulator use: "http://127.0.0.1:5050/api"

  // Common request helper
  static Future<Map<String, dynamic>> _request(
      String endpoint, {
        String method = 'GET',
        Map<String, dynamic>? body,
        Map<String, String>? headers,
      }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final defaultHeaders = {
      'Content-Type': 'application/json',
      ...?headers,
    };

    http.Response response;
    switch (method) {
      case 'POST':
        response =
        await http.post(url, headers: defaultHeaders, body: jsonEncode(body));
        break;
      case 'PUT':
        response =
        await http.put(url, headers: defaultHeaders, body: jsonEncode(body));
        break;
      case 'DELETE':
        response = await http.delete(url, headers: defaultHeaders);
        break;
      default:
        response = await http.get(url, headers: defaultHeaders);
    }

    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data['error'] ?? 'API error: ${response.statusCode}');
    }
  }

  // ---------- Auth ----------
  static Future<Map<String, dynamic>> login(
      String email, String password, String role) async {
    return await _request('/auth/login',
        method: 'POST', body: {'email': email, 'password': password, 'role': role});
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> body) async {
    return await _request('/auth/register', method: 'POST', body: body);
  }

  // ---------- Driver ----------
  static Future<Map<String, dynamic>> createRoute(Map<String, dynamic> route) async {
    return await _request('/routes/create', method: 'POST', body: route);
  }

  static Future<Map<String, dynamic>> getDashboard(String driverId) async {
    return await _request('/driver/dashboard?userId=$driverId');
  }

  static Future<Map<String, dynamic>> getIncomingRequests(String driverId) async {
    return await _request('/rides/requests?driverId=$driverId');
  }

  static Future<Map<String, dynamic>> updateRideStatus(
      String rideId, String status, Map<String, dynamic>? body) async {
    return await _request('/rides/$rideId/$status', method: 'PUT', body: body);
  }

  // ---------- Passenger ----------
  static Future<Map<String, dynamic>> findRoutes() async {
    return await _request('/routes');
  }

  static Future<Map<String, dynamic>> requestRide(Map<String, dynamic> request) async {
    return await _request('/rides/request', method: 'POST', body: request);
  }
}