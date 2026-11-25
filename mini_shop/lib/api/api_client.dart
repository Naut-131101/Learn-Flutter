import 'dart:convert';
import 'package:http/http.dart' as http;

/// Lỗi tầng API – UI chỉ cần hiển thị message, không cần biết chi tiết HTTP
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiClient {
  // ⚠️ THAY bằng URL Render thật của bạn – KHÔNG có dấu / ở cuối
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<dynamic> get(String path, {Map<String, String>? params}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: params);
    try {
      final res = await http
          .get(uri)
          .timeout(const Duration(seconds: 10)); // Render sleep => fail nhanh

      if (res.statusCode >= 200 && res.statusCode < 300) {
        // utf8.decode(bodyBytes) thay vì res.body => tiếng Việt không bị lỗi font
        return jsonDecode(utf8.decode(res.bodyBytes));
      }
      throw ApiException(
        'Server trả lỗi ${res.statusCode}',
        statusCode: res.statusCode,
      );
    } on ApiException {
      rethrow; // lỗi đã đẹp sẵn, ném tiếp
    } on FormatException {
      // body không phải JSON (server trả HTML khi lỗi 500...)
      throw ApiException('Dữ liệu server trả về không hợp lệ');
    } catch (e) {
      // mất mạng, timeout, DNS fail... đều rơi vào đây
      throw ApiException('Không kết nối được server. Kiểm tra mạng rồi thử lại.');
    }
  }
}