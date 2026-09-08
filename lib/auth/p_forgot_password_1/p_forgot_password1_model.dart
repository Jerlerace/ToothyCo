import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'p_forgot_password1_widget.dart' show PForgotPassword1Widget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PForgotPassword1Model extends FlutterFlowModel<PForgotPassword1Widget> {
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
      return 'Valid Email is required';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  @override
  void initState(BuildContext context) {
    textFieldEmailTextControllerValidator =
        _textFieldEmailTextControllerValidator;
  }

  @override
  void dispose() {
    textFieldEmailFocusNode?.dispose();
    textFieldEmailTextController?.dispose();
  }
}
