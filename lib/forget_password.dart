import 'package:flutter/material.dart';
import 'package:payroll/API/api_forget_password.dart';

class forgetPassword extends StatefulWidget {
  const forgetPassword({super.key});

  @override
  State<forgetPassword> createState() => _forgetPasswordState();
}

class _forgetPasswordState extends State<forgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  String? email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forget Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                  'Enter your email address and we will send you a link to reset your password.'),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    email = _emailController.text;
                    await forgetPass(_emailController.text, context);
                  },
                  child: Text('Send')),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
