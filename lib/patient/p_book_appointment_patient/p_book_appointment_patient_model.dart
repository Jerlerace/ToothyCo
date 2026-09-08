import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'p_book_appointment_patient_widget.dart'
    show PBookAppointmentPatientWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PBookAppointmentPatientModel
    extends FlutterFlowModel<PBookAppointmentPatientWidget> {
  ///  State fields for stateful widgets in this page.

  // Selected procedure & dentist IDs
  String? selectedProcedureId;
  String? selectedDentistId;

  // Selected Date & Time
  DateTime? selectedDate;
  String? selectedTime;

  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  // State field(s) for DropDown widget.
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;

  // State field(s) for notes/concerns
  FocusNode? notesFocusNode;
  TextEditingController? notesTextController;

  // AI Preference selection ('Morning' or 'Afternoon')
  String aiPreference = 'Morning';

  @override
  void initState(BuildContext context) {
    notesFocusNode = FocusNode();
    notesTextController = TextEditingController();
  }

  @override
  void dispose() {
    notesFocusNode?.dispose();
    notesTextController?.dispose();
  }
}
