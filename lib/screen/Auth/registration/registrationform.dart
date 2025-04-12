import 'package:flutter/material.dart';
import 'package:labtest/screen/Auth/login/LoginPage.dart';
import 'package:labtest/screen/dashboard/dashboard.dart';
import 'package:labtest/widget/customTextfield.dart';
import 'package:labtest/widget/custombutton.dart';

import 'Registrationpage.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  String? _firstName;
  String? _lastName;
  String? _organizationName;
  String? _email;
  String? _password;
  String? _confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // First Name
          Customtextfield(
            hintText: 'First Name',
            validator: (p0) =>
                p0 == null ? 'Please enter your first name' : null,
            onSaved: (value) => _firstName = value,
          ),

          const SizedBox(height: 16),
          // Last Name
          Customtextfield(
            hintText: 'Last Name',
            validator: (value) =>
                value!.isEmpty ? 'Please enter your last name' : null,
            onSaved: (value) => _lastName = value,
          ),
          const SizedBox(height: 16),
          // Organization Name
          Customtextfield(
            hintText: 'Organization Name',
            validator: (value) =>
                value!.isEmpty ? 'Please enter your organization name' : null,
            onSaved: (value) => _organizationName = value,
          ),
          const SizedBox(height: 16),
          // Email
          Customtextfield(
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter an email address';
              }
              return null;
            },
            onSaved: (value) => _email = value,
          ),
          const SizedBox(height: 16),
          // Password
          Customtextfield(
            hintText: 'Password',
            obscureText: true,
            validator: (value) => value!.length < 6
                ? 'Password must be at least 6 characters'
                : null,
            onSaved: (value) => _password = value,
          ),
          const SizedBox(height: 16),
          // Confirm Password
          Customtextfield(
            hintText: 'Confirm Password',
            obscureText: true,
            validator: (value) {
              if (value != _password) {
                return 'Passwords do not match';
              }
              return null;
            },
            onSaved: (value) => _confirmPassword = value,
          ),
          const SizedBox(height: 24),
          // Sign Up Button
          Custombutton(
            onTap: () {
              // if (_formKey.currentState!.validate()) {
              //   _formKey.currentState!.save();
              //   // TODO: Perform registration logic (API call, etc.)
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(content: Text('Registering...')),
              //   );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BloodLabHomePage()),
              );
              // }
            },
            text: 'Sign Up',
          ),
          const SizedBox(height: 24),
          TextButton(
            style: TextButton.styleFrom(
                elevation: 0, foregroundColor: Colors.white),
            onPressed: () {
              // Navigate to login page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text(
              'Already have an account? Sign In',
              style: TextStyle(
                  color: Colors.black, fontFamily: "uber", fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
