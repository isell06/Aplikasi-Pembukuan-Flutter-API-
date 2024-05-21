import 'dart:convert';
import 'package:apk_pembukuan_konter_hp/constant.dart';
import 'package:apk_pembukuan_konter_hp/models/api_response.dart';
import 'package:apk_pembukuan_konter_hp/models/transaction.dart';
import 'package:http/http.dart' as http;

class TransactionService {
  final String baseUrl =
      'http://127.0.0.1:8000/api'; // Replace with your API URL

  Future<ApiResponse> getTransaction() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await http.get(Uri.parse('$baseUrl/transaction'),
          headers: {'Accept': 'application/json'});

      switch (response.statusCode) {
        case 200:
          final List<dynamic> data = jsonDecode(response.body)['transaction'];
          apiResponse.data =
              data.map((json) => Transaction.fromJson(json)).toList();
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  Future<ApiResponse> createTransaction(int amount, int categoryId, DateTime transaction_date, String description ) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transaction'),
        headers: {'Accept': 'application/json'},
        body: jsonEncode({
          'amount': amount,
          'categoryId': categoryId.toString(),
          'transaction_date': transaction_date.toIso8601String(),
          'description': description,
        }),

      );

      switch (response.statusCode) {
        case 201:
          apiResponse.data = jsonDecode(response.body);
          break;
        case 422:
          final errors = jsonDecode(response.body)['errors'];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  Future<ApiResponse> editTransaction(
      int transactionId, int amount,
      int categoryId, DateTime transaction_date, String description) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/transaction/$transactionId'),
        headers: {'Accept': 'application/json'},
        body: {
          'amount': amount,
          'categoryId': categoryId.toString(),
          'transaction_date': transaction_date,
          'description': description
        },
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body)['message'];
          break;
        case 403:
          apiResponse.error = jsonDecode(response.body)['message'];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  Future<ApiResponse> deleteTransaction(int transactionId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/transaction/$transactionId'),
        headers: {'Accept': 'application/json'},
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body)['message'];
          break;
        case 403:
          apiResponse.error = jsonDecode(response.body)['message'];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }
}
