import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:payroll/API/api_login.dart';
import 'package:payroll/login_page.dart';


final dio = Dio();
String? status_change_password;

Future<void> changePassword(email, newpassword, context) async {
  try {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Processing Data'),
        duration: Duration(milliseconds: 10),
      ),
    );
    final response = await dio
        .post('$baseurl/new_password?email=$email&newpassword=$newpassword');
    print(response.data);
    int? res = response.statusCode;
    print(res);
    status_change_password = response.data['status'] ?? 'failed';
    if (res == 200 && response.data['status'] == 'success') {
      print("Success");
      if (status_change_password == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password Changed')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
      }
    } else {
      print('Failed');
    }
  } catch (e) {
    print('Error: $e');
  }
}
