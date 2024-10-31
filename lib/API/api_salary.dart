import 'package:dio/dio.dart';
import 'package:payroll/API/api_login.dart';

final dio = Dio();

Future<List<Map<String, dynamic>>> getSalary() async {
  try {
    final response = await dio.get('$baseurl/fetchsalary');
    if (response.statusCode == 200) {
      List<dynamic> details = response.data['details'];
      return List<Map<String, dynamic>>.from(details);
    } else {
      return [];
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

Future<void> updateSalaryOnServer(String email, String newSalary) async {
  try {
    final response = await dio.post(
      '$baseurl/updatesalary',
      data: {'email': email, 'salary': newSalary},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update salary');
    }
  } catch (e) {
    print('Error updating salary: $e');
    throw e;
  }
}
