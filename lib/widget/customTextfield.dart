import 'package:flutter/material.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/responsive/responsive_layout.dart';
import 'package:provider/provider.dart';

class Customtextfield extends StatelessWidget {
  Customtextfield({
    super.key,
    this.validator,
    this.onSaved,
    this.controller,
    this.hintText,
    this.keyboardAppearance,
    this.keyboardType,
    this.obscureText = false,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
  });

  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  TextEditingController? controller;
  String? hintText;
  String? labelText;
  Widget? prefixIcon;
  Widget? suffixIcon;
  Brightness? keyboardAppearance;
  TextInputType? keyboardType;
  bool obscureText;
  int maxLines;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, theme, child) {
        return TextFormField(
          controller: controller,
          keyboardAppearance: keyboardAppearance,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          style: TextStyle(
            color: theme.colors.textPrimary,
            fontFamily: "uber",
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 14,
              tablet: 16,
              desktop: 18,
            ),
          ),
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            errorStyle: TextStyle(
              color: theme.colors.error,
              fontFamily: "uber",
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 12,
                tablet: 13,
                desktop: 14,
              ),
            ),
            hintStyle: TextStyle(
              color: theme.colors.textSecondary,
              fontFamily: "uber",
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 18,
              ),
            ),
            labelStyle: TextStyle(
              color: theme.colors.textSecondary,
              fontFamily: "uber",
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 18,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 6,
                tablet: 8,
                desktop: 10,
              )),
              borderSide: BorderSide(
                color: theme.colors.border,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 6,
                tablet: 8,
                desktop: 10,
              )),
              borderSide: BorderSide(
                color: theme.colors.primary,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 6,
                tablet: 8,
                desktop: 10,
              )),
              borderSide: BorderSide(
                color: theme.colors.border,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 6,
                tablet: 8,
                desktop: 10,
              )),
              borderSide: BorderSide(
                color: theme.colors.error,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 6,
                tablet: 8,
                desktop: 10,
              )),
              borderSide: BorderSide(
                color: theme.colors.error,
                width: 2.0,
              ),
            ),
            filled: true,
            fillColor: theme.colors.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 12,
                tablet: 16,
                desktop: 20,
              ),
              vertical: ResponsiveHelper.getResponsiveValue(
                context,
                mobile: 12,
                tablet: 16,
                desktop: 20,
              ),
            ),
          ),
          validator: validator,
          onSaved: onSaved,
        );
      },
    );
  }
}
