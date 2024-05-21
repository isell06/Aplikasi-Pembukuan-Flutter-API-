import 'dart:convert';
import 'package:apk_pembukuan_konter_hp/constant.dart';
import 'package:apk_pembukuan_konter_hp/models/api_response.dart';
import 'package:apk_pembukuan_konter_hp/models/category.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  final String baseUrl =
      'http://127.0.0.1:8000/api'; // Replace with your API URL

  Future<ApiResponse> getCategory() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: {'Accept': 'application/json'},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['categories']
              .map((p) => Category.fromJson(p))
              .toList();
          // we get list of posts, so we need to map each item to post model
          apiResponse.data as List<dynamic>;
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


  Future<ApiResponse> createCategory(String name, int type) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/category'),
        headers: {'Accept': 'application/json'},
        body: {
          'name': name,
          'type': type.toString(),
        },
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

  Future<ApiResponse> editCategory(
      int categoryId, String name, int type) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/category/$categoryId'),
        headers: {'Accept': 'application/json'},
        body: {
          'name': name,
          'type': type.toString(),
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

  Future<ApiResponse> deleteCategory(int categoryId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/category/$categoryId'),
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
