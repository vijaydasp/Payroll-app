import 'package:flutter/material.dart';
import 'package:payroll/EditEmployeeDetails.dart';

class EmployeeDetails extends StatefulWidget {
  final Map<String, dynamic> employee;

  const EmployeeDetails({super.key, required this.employee});

  @override
  _EmployeeDetailsState createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  late Map<String, dynamic> employee;

  @override
  void initState() {
    super.initState();
    employee = widget.employee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name: ${employee['name']}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${employee['email']}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Phone Number: ${employee['phonenumber']}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Date of Birth: ${employee['dob']}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Age: ${employee['age']}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Gender: ${employee['gender']}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Country: ${employee['country']}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Address: ${employee['address']}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Pincode: ${employee['pincode']}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updatedEmployee = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditEmployeeDetails(employee: employee),
                  ),
                );

                if (updatedEmployee != null &&
                    updatedEmployee is Map<String, dynamic>) {
                  setState(() {
                    employee = updatedEmployee;
                  });
                }
              },
              child: const Text('Edit Details'),
            ),
          ],
        ),
      ),
    );
  }
}
