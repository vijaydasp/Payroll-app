import 'package:flutter/material.dart';
import 'package:payroll/API/api_logout.dart';
import 'package:payroll/add_employee.dart';
import 'package:payroll/fetch_names.dart';
import 'package:payroll/salary_page.dart';
import 'package:payroll/view_employees.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key, required this.email});
  final String email;

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you want to leave this page?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Leave'),
              onPressed: () {
                logoutApi(widget.email);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        print("didpop: $didPop");
        if (!didPop) {
          final bool shouldPop = await _showBackDialog() ?? false;
          if (context.mounted && shouldPop) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Employee Management'),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueGrey[900],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueGrey[100]!, Colors.blueGrey[300]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildElevatedButton(
                    context,
                    Icons.person_add,
                    'ADD EMPLOYEE',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserRegistrationPage(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  _buildElevatedButton(
                    context,
                    Icons.people,
                    'VIEW EMPLOYEES',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewEmployees(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  _buildElevatedButton(
                    context,
                    Icons.location_on,
                    'VIEW LOCATION',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NamePage(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  _buildElevatedButton(
                    context,
                    Icons.money,
                    'CHECK SALARY',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SalaryPage(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  _buildElevatedButton(
                    context,
                    Icons.lock,
                    'CHANGE PASSWORD',
                    () {
                      // Add your onPressed code here for changing password
                    },
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red[800],
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        logoutApi(widget.email);
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Text('LOGOUT'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildElevatedButton(BuildContext context, IconData icon, String text,
      VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 24), // Adjust size as needed
        label: Text(text),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueGrey[800],
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(fontSize: 16),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
