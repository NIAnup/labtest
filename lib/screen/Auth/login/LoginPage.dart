import 'package:flutter/material.dart';
import 'package:labtest/screen/Auth/login/loginform.dart';
import 'package:labtest/screen/Auth/registration/Registrationpage.dart';
import 'package:labtest/widget/Myscaffold.dart';
import 'package:labtest/widget/customTextfield.dart';
import 'package:labtest/widget/custombutton.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Myscaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.shade400,
              )),
          // Constrain the max width (adjust to your preference)
          constraints: const BoxConstraints(maxWidth: 1000, maxHeight: 800),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 800;
              return Row(
                children: [
                  if (isWide)
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.blue.shade500,
                        child: const Center(
                          child: Text(
                            'Blood Lab',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'uber',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32.0),
                      child: LoginForm(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
