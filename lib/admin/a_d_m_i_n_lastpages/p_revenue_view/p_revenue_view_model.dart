import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'p_revenue_view_widget.dart' show PRevenueViewWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class PRevenueViewModel extends FlutterFlowModel<PRevenueViewWidget> {
  ///  Local state fields for this page.

  List<dynamic> localRevenueList = [];
  void addToLocalRevenueList(dynamic item) => localRevenueList.add(item);
  void removeFromLocalRevenueList(dynamic item) =>
      localRevenueList.remove(item);
  void removeAtIndexFromLocalRevenueList(int index) =>
      localRevenueList.removeAt(index);
  void insertAtIndexInLocalRevenueList(int index, dynamic item) =>
      localRevenueList.insert(index, item);
  void updateLocalRevenueListAtIndex(int index, Function(dynamic) updateFn) =>
      localRevenueList[index] = updateFn(localRevenueList[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getMonthlyRevenueMetrics] action in P_RevenueView widget.
  List<dynamic>? revenueData;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
