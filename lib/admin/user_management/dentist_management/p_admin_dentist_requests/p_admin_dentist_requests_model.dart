import '/admin/user_management/dentist_management/c_confirm_application/c_confirm_application_widget.dart';
import '/admin/user_management/dentist_management/c_reject_application/c_reject_application_widget.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'p_admin_dentist_requests_widget.dart' show PAdminDentistRequestsWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PAdminDentistRequestsModel
    extends FlutterFlowModel<PAdminDentistRequestsWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for ChoiceChips_statuses widget.
  FormFieldController<List<String>>? choiceChipsStatusesValueController;
  String? get choiceChipsStatusesValue =>
      choiceChipsStatusesValueController?.value?.firstOrNull;
  set choiceChipsStatusesValue(String? val) =>
      choiceChipsStatusesValueController?.value = val != null ? [val] : [];
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
