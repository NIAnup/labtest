import 'package:flutter/material.dart';
import 'package:labtest/widget/customTextfield.dart';
import 'package:labtest/widget/custombutton.dart';

import '../registration/Registrationpage.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Customtextfield(
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                value!.isEmpty ? 'Please enter your email' : null,
            onSaved: (value) => _email = value,
          ),
          const SizedBox(height: 16),
          Customtextfield(
            hintText: 'Password',
            obscureText: true,
            validator: (value) =>
                value!.isEmpty ? 'Please enter your password' : null,
            onSaved: (value) => _password = value,
          ),
          const SizedBox(height: 24),
          Custombutton(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logging in...')),
                );
              }
            },
            text: "Sign In",
          ),
          const SizedBox(height: 24),
          TextButton(
            style: TextButton.styleFrom(
                elevation: 0, foregroundColor: Colors.white),
            onPressed: () {
              // Navigate to registration page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationPage()),
              );
            },
            child: const Text(
              'Don\'t have an account? Sign Up',
              style: TextStyle(
                  color: Colors.black, fontFamily: "uber", fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
