import 'package:dio/dio.dart';
import '../models/supplement_model.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<List<Supplement>> fetchSupplements() async {
    try {
      final response = await _dio.get('/posts');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.take(12).map((item) => Supplement.fromJson(item)).toList();
      }
      throw Exception('Server returned code ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error occurred');
    }
  }

  Future<Supplement> createSupplement(Supplement supplement) async {
    try {
      final response = await _dio.post('/posts', data: supplement.toJson());
      if (response.statusCode == 201) {
        return Supplement.fromJson(response.data);
      }
      throw Exception('Failed to log entry');
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error occurred');
    }
  }

  Future<Supplement> updateSupplement(Supplement supplement) async {
    try {
      final response = await _dio.put('/posts/${supplement.id}', data: supplement.toJson());
      if (response.statusCode == 200) {
        return Supplement.fromJson(response.data);
      }
      throw Exception('Failed to update entry');
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error occurred');
    }
  }

  Future<void> deleteSupplement(int id) async {
    try {
      final response = await _dio.delete('/posts/$id');
      if (response.statusCode != 200) {
        throw Exception('Failed to remove entry');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error occurred');
    }
  }
}