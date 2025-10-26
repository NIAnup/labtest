import 'package:flutter/material.dart';
import 'package:labtest/screen/Auth/login/LoginPage.dart';
import 'package:labtest/screen/Auth/registration/registrationform.dart';
import 'package:labtest/widget/Myscaffold.dart';
import 'package:labtest/widget/customTextfield.dart';
import 'package:labtest/widget/custombutton.dart';
import 'package:labtest/responsive/responsive_layout.dart';

import '../../../store/app_theme.dart';

class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Myscaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 12,
              tablet: 16,
              desktop: 20,
            )),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: double.infinity,
              tablet: 900,
              desktop: 1200,
            ),
            maxHeight: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: double.infinity,
              tablet: 800,
              desktop: 900,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 800;

              return Row(
                children: [
                  // Branding panel
                  if (isWide)
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.shade600,
                              Colors.blue.shade800,
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                ResponsiveHelper.getResponsiveValue(
                              context,
                              mobile: 12,
                              tablet: 16,
                              desktop: 20,
                            )),
                            bottomLeft: Radius.circular(
                                ResponsiveHelper.getResponsiveValue(
                              context,
                              mobile: 12,
                              tablet: 16,
                              desktop: 20,
                            )),
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.science,
                                size: ResponsiveHelper.getResponsiveValue(
                                  context,
                                  mobile: 60,
                                  tablet: 80,
                                  desktop: 100,
                                ),
                                color: Colors.white,
                              ),
                              SizedBox(height: 20),
                              ResponsiveText(
                                'Blood Lab',
                                style: TextStyle(
                                  fontSize:
                                      ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    mobile: 32,
                                    tablet: 40,
                                    desktop: 48,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'uber',
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 16),
                              ResponsiveText(
                                'Management System',
                                style: TextStyle(
                                  fontSize:
                                      ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    mobile: 16,
                                    tablet: 18,
                                    desktop: 20,
                                  ),
                                  fontFamily: 'uber',
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 40),
                              ResponsiveText(
                                'Professional Lab Registration',
                                style: TextStyle(
                                  fontSize:
                                      ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    mobile: 14,
                                    tablet: 16,
                                    desktop: 18,
                                  ),
                                  fontFamily: 'uber',
                                  color: Colors.white60,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Form area
                  Expanded(
                    flex: isWide ? 1 : 2,
                    child: SingleChildScrollView(
                      padding:
                          EdgeInsets.all(ResponsiveHelper.getResponsiveValue(
                        context,
                        mobile: 24,
                        tablet: 32,
                        desktop: 40,
                      )),
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
