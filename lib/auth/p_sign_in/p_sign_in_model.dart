import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'p_sign_in_widget.dart' show PSignInWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PSignInModel extends FlutterFlowModel<PSignInWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
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

  // State field(s) for TextField_password widget.
  FocusNode? textFieldPasswordFocusNode;
  TextEditingController? textFieldPasswordTextController;
  late bool textFieldPasswordVisibility;
  String? Function(BuildContext, String?)?
      textFieldPasswordTextControllerValidator;
  String? _textFieldPasswordTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Password is required';
    }

    if (val.length < 8) {
      return 'Requires at least 8 characters.';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    textFieldEmailTextControllerValidator =
        _textFieldEmailTextControllerValidator;
    textFieldPasswordVisibility = false;
    textFieldPasswordTextControllerValidator =
        _textFieldPasswordTextControllerValidator;
  }

  @override
  void dispose() {
    textFieldEmailFocusNode?.dispose();
    textFieldEmailTextController?.dispose();

    textFieldPasswordFocusNode?.dispose();
    textFieldPasswordTextController?.dispose();
  }
}
