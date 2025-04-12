import 'package:flutter/material.dart';
import 'package:labtest/screen/Auth/login/LoginPage.dart';
import 'package:labtest/screen/Auth/registration/registrationform.dart';
import 'package:labtest/widget/Myscaffold.dart';
import 'package:labtest/widget/customTextfield.dart';
import 'package:labtest/widget/custombutton.dart';

class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Myscaffold(
      body: Center(
        // Center the content horizontally & vertically in the screen
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.shade400,
              )),
          // Constrain the max width (adjust to your preference)
          constraints: BoxConstraints(maxWidth: 1000, maxHeight: 800),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Decide if it’s a wide layout (web/desktop) or narrow layout (mobile/tablet)
              bool isWide = constraints.maxWidth > 800;
              // You can tweak this breakpoint

              return Row(
                children: [
                  // Branding panel (optional)
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
                  // Form area
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(32.0),
                      child: RegistrationForm(),
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
