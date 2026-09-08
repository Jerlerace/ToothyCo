import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'p_sign_up_widget.dart' show PSignUpWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PSignUpModel extends FlutterFlowModel<PSignUpWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField_fullname widget.
  FocusNode? textFieldFullnameFocusNode;
  TextEditingController? textFieldFullnameTextController;
  String? Function(BuildContext, String?)?
      textFieldFullnameTextControllerValidator;
  // State field(s) for TextField_dob widget.
  FocusNode? textFieldDobFocusNode;
  TextEditingController? textFieldDobTextController;
  String? Function(BuildContext, String?)? textFieldDobTextControllerValidator;
  DateTime? datePicked;
  // State field(s) for TextField_email widget.
  FocusNode? textFieldEmailFocusNode;
  TextEditingController? textFieldEmailTextController;
  String? Function(BuildContext, String?)?
      textFieldEmailTextControllerValidator;
  String? _textFieldEmailTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Email is required';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  // State field(s) for TextField_pw widget.
  FocusNode? textFieldPwFocusNode;
  TextEditingController? textFieldPwTextController;
  late bool textFieldPwVisibility;
  String? Function(BuildContext, String?)? textFieldPwTextControllerValidator;
  String? _textFieldPwTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Password must have min. 8 characters';
    }

    if (val.length < 8) {
      return 'Requires at least 8 characters.';
    }

    return null;
  }

  // State field(s) for TextField_confirmpw widget.
  FocusNode? textFieldConfirmpwFocusNode;
  TextEditingController? textFieldConfirmpwTextController;
  late bool textFieldConfirmpwVisibility;
  String? Function(BuildContext, String?)?
      textFieldConfirmpwTextControllerValidator;
  String? _textFieldConfirmpwTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Confirm Password is required';
    }

    if (val != textFieldPwTextController?.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    textFieldEmailTextControllerValidator =
        _textFieldEmailTextControllerValidator;
    textFieldPwVisibility = false;
    textFieldPwTextControllerValidator = _textFieldPwTextControllerValidator;
    textFieldConfirmpwVisibility = false;
    textFieldConfirmpwTextControllerValidator =
        _textFieldConfirmpwTextControllerValidator;
  }

  @override
  void dispose() {
    textFieldFullnameFocusNode?.dispose();
    textFieldFullnameTextController?.dispose();

    textFieldDobFocusNode?.dispose();
    textFieldDobTextController?.dispose();

    textFieldEmailFocusNode?.dispose();
    textFieldEmailTextController?.dispose();

    textFieldPwFocusNode?.dispose();
    textFieldPwTextController?.dispose();

    textFieldConfirmpwFocusNode?.dispose();
    textFieldConfirmpwTextController?.dispose();
  }
}
