import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:payroll/API/api_register.dart';

class UserRegistrationPage extends StatefulWidget {
  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String _gender = '';
  String _country = 'Choose country';
  String _countryCode = '';
  DateTime? _dob;
  File? _profileImage;
  int? agecheck;

  final Map<String, String> countryCodes = {
    'Choose country': '',
    'USA': '+1',
    'India': '+91',
    'UK': '+44',
  };

  bool _isObscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    _phoneNumberController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your age';
    }
    final n = num.tryParse(value);
    if (n == null) {
      return '"$value" is not a valid number';
    }
    return null;
  }

  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }
    final n = num.tryParse(value);
    if (n == null) {
      return '"$value" is not a valid number';
    }
    return null;
  }

  String? _validatePincode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your pincode';
    }
    if (value.length != 6) {
      return 'Pincode must be 6 digits';
    }
    final n = num.tryParse(value);
    if (n == null) {
      return '"$value" is not a valid number';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    if (!value.endsWith('@gmail.com')) {
      return 'Username must end with @gmail.com';
    }
    return null;
  }

  void _calculateAge(DateTime dob) {
    DateTime now = DateTime.now();
    int age = now.year - dob.year;
    agecheck = age;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Registration'),
        foregroundColor: const Color.fromARGB(255, 243, 243, 244),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 20),
                  Center(
                    child: _profileImage == null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey.shade300,
                            child: Icon(Icons.person,
                                size: 60, color: Colors.white),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: FileImage(_profileImage!),
                          ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: _pickImage,
                      child: Text('Upload Profile Picture',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextFormField(
                    controller: _nameController,
                    label: 'Name',
                    validator: _validateNotEmpty,
                  ),
                  SizedBox(height: 10),
                  _buildTextFormField(
                    controller: _usernameController,
                    label: 'Username',
                    validator: _validateUsername,
                  ),
                  SizedBox(height: 10),
                  _buildTextFormField(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: _isObscure,
                    validator: _validateNotEmpty,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildDateOfBirthField(),
                  SizedBox(height: 20),
                  Text(
                    'Age: $agecheck',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  _buildGenderField(),
                  SizedBox(height: 10),
                  _buildDropdownField(),
                  SizedBox(height: 10),
                  _buildTextFormField(
                    controller: _addressController,
                    label: 'Address',
                    validator: _validateNotEmpty,
                  ),
                  SizedBox(height: 10),
                  _buildTextFormField(
                    controller: _pincodeController,
                    label: 'Pincode',
                    keyboardType: TextInputType.number,
                    validator: _validatePincode,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Text(_countryCode,
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      Expanded(
                        child: _buildTextFormField(
                          controller: _phoneNumberController,
                          label: 'Phone Number',
                          keyboardType: TextInputType.number,
                          validator: _validatePhoneNumber,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_profileImage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please upload a profile picture'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (_formKey.currentState!.validate()) {
                        // Process the registration data
                        Map<String, dynamic> data = {
                          'name': _nameController.text,
                          'username': _usernameController.text,
                          'password': _passwordController.text,
                          'date_of_birth': _dobController.text,
                          'age': agecheck,
                          'gender': _gender,
                          'country': _country,
                          'address': _addressController.text,
                          'pincode': int.parse(_pincodeController.text),
                          'phone_number':
                              int.parse(_phoneNumberController.text),
                        };
                        await regPost(data, _profileImage!.path);
                        if (message != "Already registered") {
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message!),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Register'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 212, 210, 215),
                      padding: EdgeInsets.symmetric(vertical: 14),
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    required String? Function(String?) validator,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      style: TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDateOfBirthField() {
    return TextFormField(
      controller: _dobController,
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
      ),
      style: TextStyle(color: Colors.white),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            _dob = pickedDate;
            _dobController.text = DateFormat.yMd().format(_dob!);
            _calculateAge(_dob!);
          });
        }
      },
      validator: _validateNotEmpty,
    );
  }

  Widget _buildGenderField() {
    return Row(
      children: <Widget>[
        Text('Gender:', style: TextStyle(color: Colors.white, fontSize: 16)),
        SizedBox(width: 10),
        Row(
          children: <Widget>[
            Radio<String>(
              value: 'Male',
              groupValue: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
              activeColor: Colors.white,
            ),
            Icon(Icons.male, color: Colors.white),
            SizedBox(width: 5),
            Text('Male', style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        SizedBox(width: 20),
        Row(
          children: <Widget>[
            Radio<String>(
              value: 'Female',
              groupValue: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
              activeColor: Colors.white,
            ),
            Icon(Icons.female, color: Colors.white),
            SizedBox(width: 5),
            Text('Female', style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Country',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
      ),
      dropdownColor: Colors.deepPurple.shade300,
      value: _country,
      items: countryCodes.keys.map((String country) {
        return DropdownMenuItem<String>(
          value: country,
          child: Text(country, style: TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _country = value!;
          _countryCode = countryCodes[value]!;
        });
      },
      validator: (value) {
        if (value == 'Choose country') {
          return 'Please select a country';
        }
        return null;
      },
    );
  }
}
