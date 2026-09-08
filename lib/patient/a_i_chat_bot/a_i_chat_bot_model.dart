import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'a_i_chat_bot_widget.dart' show AIChatBotWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AIChatBotModel extends FlutterFlowModel<AIChatBotWidget> {
  // Chat messages history: [{'text': 'Hello', 'isUser': false}]
  List<Map<String, dynamic>> chatMessages = [
    {
      'text': 'Hello! I am your AI Clinic Assistant. How can I help you today? I can answer questions about our services, opening hours, dentists, locations, or pricing.',
      'isUser': false,
    }
  ];

  // State field(s) for input message
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;

  @override
  void initState(BuildContext context) {
    textFieldFocusNode = FocusNode();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
