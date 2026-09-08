import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'p_edit_password_widget.dart' show PEditPasswordWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PEditPasswordModel extends FlutterFlowModel<PEditPasswordWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField_pw widget.
  FocusNode? textFieldPwFocusNode;
  TextEditingController? textFieldPwTextController;
  late bool textFieldPwVisibility;
  String? Function(BuildContext, String?)? textFieldPwTextControllerValidator;
  // State field(s) for TextField_cpw widget.
  FocusNode? textFieldCpwFocusNode;
  TextEditingController? textFieldCpwTextController;
  late bool textFieldCpwVisibility;
  String? Function(BuildContext, String?)? textFieldCpwTextControllerValidator;

  @override
  void initState(BuildContext context) {
    textFieldPwVisibility = false;
    textFieldCpwVisibility = false;
  }

  @override
  void dispose() {
    textFieldPwFocusNode?.dispose();
    textFieldPwTextController?.dispose();

    textFieldCpwFocusNode?.dispose();
    textFieldCpwTextController?.dispose();
  }
}
