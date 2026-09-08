import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/profile/user_registration/p_user_application_confirmation/p_user_application_confirmation_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'p_dentist_registration_form_widget.dart'
    show PDentistRegistrationFormWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PDentistRegistrationFormModel
    extends FlutterFlowModel<PDentistRegistrationFormWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for DropDown_specialization widget.
  String? dropDownSpecializationValue;
  FormFieldController<String>? dropDownSpecializationValueController;
  // State field(s) for DropDown_yrs_of_Exp widget.
  String? dropDownYrsOfExpValue;
  FormFieldController<String>? dropDownYrsOfExpValueController;
  // State field(s) for TextField_clinicName widget.
  FocusNode? textFieldClinicNameFocusNode;
  TextEditingController? textFieldClinicNameTextController;
  String? Function(BuildContext, String?)?
      textFieldClinicNameTextControllerValidator;
  // State field(s) for TextField_clinicLoc widget.
  FocusNode? textFieldClinicLocFocusNode;
  TextEditingController? textFieldClinicLocTextController;
  String? Function(BuildContext, String?)?
      textFieldClinicLocTextControllerValidator;
  // State field(s) for TextField_dentalSchool widget.
  FocusNode? textFieldDentalSchoolFocusNode;
  TextEditingController? textFieldDentalSchoolTextController;
  String? Function(BuildContext, String?)?
      textFieldDentalSchoolTextControllerValidator;
  // State field(s) for TextField_gradYear widget.
  FocusNode? textFieldGradYearFocusNode;
  TextEditingController? textFieldGradYearTextController;
  String? Function(BuildContext, String?)?
      textFieldGradYearTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    textFieldClinicNameFocusNode?.dispose();
    textFieldClinicNameTextController?.dispose();

    textFieldClinicLocFocusNode?.dispose();
    textFieldClinicLocTextController?.dispose();

    textFieldDentalSchoolFocusNode?.dispose();
    textFieldDentalSchoolTextController?.dispose();

    textFieldGradYearFocusNode?.dispose();
    textFieldGradYearTextController?.dispose();
  }
}
