import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'p_admin_leave_approvals_widget.dart' show PAdminLeaveApprovalsWidget;
import 'package:flutter/material.dart';

class PAdminLeaveApprovalsModel extends FlutterFlowModel<PAdminLeaveApprovalsWidget> {
  ///  State fields for stateful widgets in this page.
  TextEditingController? searchController;
  FocusNode? searchFocusNode;
  
  // State field(s) for ChoiceChips status filter.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    choiceChipsValueController = FormFieldController<List<String>>(['Pending']);
  }

  @override
  void dispose() {
    searchController?.dispose();
    searchFocusNode?.dispose();
  }
}
