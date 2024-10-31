import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:payroll/API/api_login.dart';
import 'package:payroll/API/api_otp.dart';
import 'package:payroll/new_password.dart';

final dio = Dio();
String? status_forget_password;

Future<void> forgetPass(String email, BuildContext context) async {
  try {
    final response = await dio.post('$baseurl/forget?email=$email');
    print(response.data);
    int? res = response.statusCode;
    print(res);
    status_forget_password = response.data['status'] ?? 'failed';
    if (res == 200 && response.data['status'] == 'success') {
      print("Success");
      showOtpDialog(context, email); // Show OTP dialog on success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email not registered'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    print('Error: $e');
  }
}

void showOtpDialog(BuildContext context, email) {
  TextEditingController otpController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter OTP'),
        content: TextField(
          controller: otpController,
          decoration: InputDecoration(hintText: "OTP"),
        ),
        actions: [
          TextButton(
            child: Text('Submit'),
            onPressed: () async {
              String otp = otpController.text;
              await otpApi(email, otp);
              print('OTP entered: $otp');
              Navigator.of(context).pop();
              if (status_otp == "success") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewPassword(
                              email: email,
                            )));
              }
              if (status_otp == "success") {
              } else {
                print('Failed');
              }
            },
          ),
        ],
      );
    },
  );
}
