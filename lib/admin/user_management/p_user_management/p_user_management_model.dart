import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'p_user_management_widget.dart' show PUserManagementWidget;
import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PUserManagementModel extends FlutterFlowModel<PUserManagementWidget> {
  ///  State fields for stateful widgets in this page.

  Stream<List<UserRow>>? pUserManagementSupabaseStream;

  FocusNode? searchFocusNode;
  TextEditingController? searchController;
  String? Function(BuildContext, String?)? searchControllerValidator;

  @override
  void initState(BuildContext context) {
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    searchFocusNode?.dispose();
    searchController?.dispose();
  }
}
