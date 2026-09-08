import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'p_patient_update_widget.dart' show PPatientUpdateWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PPatientUpdateModel extends FlutterFlowModel<PPatientUpdateWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField_name widget.
  FocusNode? textFieldNameFocusNode;
  TextEditingController? textFieldNameTextController;
  String? Function(BuildContext, String?)? textFieldNameTextControllerValidator;
  // State field(s) for TextField_phone widget.
  FocusNode? textFieldPhoneFocusNode;
  TextEditingController? textFieldPhoneTextController;
  String? Function(BuildContext, String?)?
      textFieldPhoneTextControllerValidator;
  // State field(s) for TextField_address widget.
  FocusNode? textFieldAddressFocusNode;
  TextEditingController? textFieldAddressTextController;
  String? Function(BuildContext, String?)?
      textFieldAddressTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldNameFocusNode?.dispose();
    textFieldNameTextController?.dispose();

    textFieldPhoneFocusNode?.dispose();
    textFieldPhoneTextController?.dispose();

    textFieldAddressFocusNode?.dispose();
    textFieldAddressTextController?.dispose();
  }
}
