import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'p_forgot_password1_model.dart';
export 'p_forgot_password1_model.dart';

/// ## 🔐 Forgot Password Page Prompt
///
/// Design a high-fidelity **Forgot Password** mobile page for **Toothy &
/// Co.** matching the app’s premium purple theme.
///
/// ### Style
///
/// Dark purple, lavender, lilac, white palette. Clean healthcare UI, rounded
/// cards, soft shadows, elegant spacing, modern typography.
///
/// ### Layout
///
/// * Back button
/// * Title: **Forgot Password**
/// * Subtitle: “Enter your email or username to reset your password.”
/// * Email / Username input field
/// * **Send Reset Link** button
/// * Small lock / security illustration
/// * **Back to Login** link
///
/// ### Success State
///
/// Show confirmation card:
/// **Reset Link Sent**
/// “We sent reset instructions to your email.”
///
/// Include:
///
/// * Open Email button
/// * Resend Link option
///
/// ### Goal
///
/// Make it feel secure, simple, trustworthy, and consistent with the rest of
/// the app. Production-ready mobile UX.
class PForgotPassword1Widget extends StatefulWidget {
  const PForgotPassword1Widget({super.key});

  static String routeName = 'P_ForgotPassword_1';
  static String routePath = '/pForgotPassword1';

  @override
  State<PForgotPassword1Widget> createState() => _PForgotPassword1WidgetState();
}

class _PForgotPassword1WidgetState extends State<PForgotPassword1Widget> {
  late PForgotPassword1Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PForgotPassword1Model());

    _model.textFieldEmailTextController ??= TextEditingController();
    _model.textFieldEmailFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF1A0A2E),
        appBar: AppBar(
          backgroundColor: Color(0xFF2D1B69),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 22.0,
            borderWidth: 0.0,
            buttonSize: 44.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Text(
            'Forgot Password',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: GoogleFonts.interTight().fontFamily,
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
              child: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 22.0,
                borderWidth: 0.0,
                buttonSize: 44.0,
                icon: Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                  size: 24.0,
                ),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Forgot Password Help'),
                      content: const Text(
                        'Enter your registered email address or username, and we will send you a reset link to recover your account.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF1A0A2E),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 220.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D1B69),
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 220.0,
                              decoration: BoxDecoration(
                                color: Color(0xFF2D1B69),
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                            Opacity(
                              opacity: 0.4,
                              child: Align(
                                alignment: AlignmentDirectional(1.2, -0.5),
                                child: Container(
                                  width: 180.0,
                                  height: 180.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF4A2D8A),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: 0.3,
                              child: Align(
                                alignment: AlignmentDirectional(-1.3, 1.2),
                                child: Container(
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF7C4DCC),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Forgot Password',
                                    style: FlutterFlowTheme.of(context)
                                        .displaySmall
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .displaySmall
                                                    .fontStyle,
                                          ),
                                          color: Colors.white,
                                          fontSize: 28.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .displaySmall
                                                  .fontStyle,
                                        ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 6.0, 0.0, 0.0),
                                    child: Text(
                                      'Enter your email or username to reset your password.',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFFC9B8F0),
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                            lineHeight: 1.5,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 220.0, 0.0, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 32.0, 24.0, 32.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFF1A0A2E),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF2D1B69),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 20.0,
                                          color: Color(0x4D000000),
                                          offset: Offset(
                                            0.0,
                                            8.0,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Container(
                                              width: 80.0,
                                              height: 80.0,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF3D2080),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Icon(
                                                  Icons.lock_outline_rounded,
                                                  color: Color(0xFFB39DDB),
                                                  size: 40.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'Email or Username',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .labelMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .fontStyle,
                                                      ),
                                                      color: Color(0xFFC9B8F0),
                                                      fontSize: 13.0,
                                                      letterSpacing: 0.5,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .fontStyle,
                                                    ),
                                              ),
                                              Form(
                                                key: _model.formKey,
                                                autovalidateMode:
                                                    AutovalidateMode.always,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 54.0,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF3D2080),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14.0),
                                                    border: Border.all(
                                                      color: Color(0xFF7C4DCC),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(16.0, 0.0,
                                                                16.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .alternate_email_rounded,
                                                          color:
                                                              Color(0xFF9575CD),
                                                          size: 20.0,
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        12.0,
                                                                        0.0,
                                                                        12.0,
                                                                        0.0),
                                                            child:
                                                                TextFormField(
                                                              controller: _model
                                                                  .textFieldEmailTextController,
                                                              focusNode: _model
                                                                  .textFieldEmailFocusNode,
                                                              autofocus: false,
                                                              enabled: true,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              obscureText:
                                                                  false,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    'you@example.com',
                                                                hintStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: Color(
                                                                          0xFF7C6AAA),
                                                                      fontSize:
                                                                          15.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                enabledBorder:
                                                                    InputBorder
                                                                        .none,
                                                                focusedBorder:
                                                                    InputBorder
                                                                        .none,
                                                                errorBorder:
                                                                    InputBorder
                                                                        .none,
                                                                focusedErrorBorder:
                                                                    InputBorder
                                                                        .none,
                                                                filled: true,
                                                                fillColor: Colors
                                                                    .transparent,
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .emailAddress,
                                                              cursorColor: Color(
                                                                  0xFFB39DDB),
                                                              validator: _model
                                                                  .textFieldEmailTextControllerValidator
                                                                  .asValidator(
                                                                      context),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ].divide(SizedBox(height: 8.0)),
                                          ),
                                          FFButtonWidget(
                                            onPressed: () async {
                                              context.pushNamed(
                                                PForgotPassword2Widget
                                                    .routeName,
                                                queryParameters: {
                                                  'userEmail': serializeParam(
                                                    _model
                                                        .textFieldEmailTextController
                                                        .text,
                                                    ParamType.String,
                                                  ),
                                                }.withoutNulls,
                                              );
                                            },
                                            text: 'Send Reset Link',
                                            options: FFButtonOptions(
                                              width: double.infinity,
                                              height: 54.0,
                                              padding: EdgeInsets.all(8.0),
                                              iconPadding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color: Color(0xFF7C4DCC),
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    font:
                                                        GoogleFonts.interTight(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontStyle,
                                                    ),
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .fontStyle,
                                                  ),
                                              elevation: 0.0,
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 0.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.goNamed(PSignInWidget.routeName);
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_back_rounded,
                                        color: Color(0xFF9575CD),
                                        size: 16.0,
                                      ),
                                      Text(
                                        'Back to Login',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color: Color(0xFFC9B8F0),
                                              fontSize: 14.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ].divide(SizedBox(width: 8.0)),
                                  ),
                                ),
                              ].divide(SizedBox(height: 24.0)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
