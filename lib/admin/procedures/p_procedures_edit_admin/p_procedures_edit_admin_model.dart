import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'p_procedures_edit_admin_widget.dart' show PProceduresEditAdminWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PProceduresEditAdminModel
    extends FlutterFlowModel<PProceduresEditAdminWidget> {
  ///  State fields for stateful widgets in this page.

  Stream<List<ProcedureRow>>? columnSupabaseStream;
  // State field(s) for TextField_name widget.
  FocusNode? textFieldNameFocusNode;
  TextEditingController? textFieldNameTextController;
  String? Function(BuildContext, String?)? textFieldNameTextControllerValidator;
  // State field(s) for DropDown_category widget.
  String? dropDownCategoryValue;
  FormFieldController<String>? dropDownCategoryValueController;
  // State field(s) for DropDown_timeDuration widget.
  String? dropDownTimeDurationValue;
  FormFieldController<String>? dropDownTimeDurationValueController;
  // State field(s) for TextField_pricing widget.
  FocusNode? textFieldPricingFocusNode;
  TextEditingController? textFieldPricingTextController;
  String? Function(BuildContext, String?)?
      textFieldPricingTextControllerValidator;
  // State field(s) for TextField_desc widget.
  FocusNode? textFieldDescFocusNode;
  TextEditingController? textFieldDescTextController;
  String? Function(BuildContext, String?)? textFieldDescTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldNameFocusNode?.dispose();
    textFieldNameTextController?.dispose();

    textFieldPricingFocusNode?.dispose();
    textFieldPricingTextController?.dispose();

    textFieldDescFocusNode?.dispose();
    textFieldDescTextController?.dispose();
  }
}
