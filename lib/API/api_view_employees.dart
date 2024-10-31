import 'package:dio/dio.dart';
import 'package:payroll/API/api_login.dart';

final dio = Dio();

Future<List<Map<String, dynamic>>> getEmployees() async {
  try {
    final response = await dio.get('$baseurl/fetchemployees');
    print(response.data);
    if (response.statusCode == 200) {
      List<dynamic> employeedetails = response.data['details'];
      List<Map<String, dynamic>> employeelistdata =
          List<Map<String, dynamic>>.from(employeedetails);
      return employeelistdata;
    } else {
      return [];
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}
