import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'p_sign_in_model.dart';
export 'p_sign_in_model.dart';

/// 2.
///
/// Login Page
///
/// Design a mobile login screen with email/username field, password field,
/// show/hide password, login button, forgot password link, sign up link,
/// tooth illustration, clean rounded inputs, purple CTA button.
class PSignInWidget extends StatefulWidget {
  const PSignInWidget({super.key});

  static String routeName = 'P_SignIn';
  static String routePath = '/pSignIn';

  @override
  State<PSignInWidget> createState() => _PSignInWidgetState();
}

class _PSignInWidgetState extends State<PSignInWidget> {
  late PSignInModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PSignInModel());

    _model.textFieldEmailTextController ??= TextEditingController();
    _model.textFieldEmailFocusNode ??= FocusNode();

    _model.textFieldPasswordTextController ??= TextEditingController();
    _model.textFieldPasswordFocusNode ??= FocusNode();
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
        backgroundColor: Color(0xFFF8F7FF),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              height: 207.42,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 280.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFEAE2FF),
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      height: 280.0,
                      decoration: BoxDecoration(
                        color: Color(0x1A000000),
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.0, -1.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      'assets/images/Untitled_(2)_(1)_2.png',
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 32.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 28.0, 24.0, 28.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 20.0,
                                color: Color(0x1A6C3FC7),
                                offset: Offset(
                                  0.0,
                                  8.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Welcome Back 👋',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        font: GoogleFonts.interTight(
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineSmall
                                                  .fontStyle,
                                        ),
                                        color: Color(0xFF2D1B6E),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontStyle,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 24.0),
                                  child: Text(
                                    'Sign in to continue your dental journey',
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
                                          color: Color(0xFF8E8E9A),
                                          fontSize: 13.0,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                                Form(
                                  key: _model.formKey,
                                  autovalidateMode: AutovalidateMode.always,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        child: TextFormField(
                                          controller: _model
                                              .textFieldEmailTextController,
                                          focusNode:
                                              _model.textFieldEmailFocusNode,
                                          autofocus: false,
                                          enabled: true,
                                          autofillHints: [AutofillHints.email],
                                          textInputAction: TextInputAction.next,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            hintText: 'Email',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color: Color(0xFFB0AEC8),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFE8E6F5),
                                                width: 1.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF6C3FC7),
                                                width: 1.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                            ),
                                            filled: true,
                                            fillColor: Color(0xFFF8F7FF),
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    18.0, 16.0, 18.0, 16.0),
                                            prefixIcon: Icon(
                                              Icons.email_outlined,
                                              color: Color(0xFF9B8FD4),
                                              size: 20.0,
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFF2D1B6E),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: _model
                                              .textFieldEmailTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: TextFormField(
                                          controller: _model
                                              .textFieldPasswordTextController,
                                          focusNode:
                                              _model.textFieldPasswordFocusNode,
                                          autofocus: false,
                                          enabled: true,
                                          autofillHints: [
                                            AutofillHints.password
                                          ],
                                          textInputAction: TextInputAction.done,
                                          obscureText: !_model
                                              .textFieldPasswordVisibility,
                                          decoration: InputDecoration(
                                            hintText: 'Password',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color: Color(0xFFB0AEC8),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFE8E6F5),
                                                width: 1.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF6C3FC7),
                                                width: 1.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                            ),
                                            filled: true,
                                            fillColor: Color(0xFFF8F7FF),
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    18.0, 16.0, 18.0, 16.0),
                                            prefixIcon: Icon(
                                              Icons.lock_outline,
                                              color: Color(0xFF9B8FD4),
                                              size: 20.0,
                                            ),
                                            suffixIcon: InkWell(
                                              onTap: () async {
                                                safeSetState(() => _model
                                                        .textFieldPasswordVisibility =
                                                    !_model
                                                        .textFieldPasswordVisibility);
                                              },
                                              focusNode: FocusNode(
                                                  skipTraversal: true),
                                              child: Icon(
                                                _model.textFieldPasswordVisibility
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                color: Color(0xFF9B8FD4),
                                                size: 20.0,
                                              ),
                                            ),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFF2D1B6E),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                          validator: _model
                                              .textFieldPasswordTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                  PForgotPassword1Widget
                                                      .routeName);
                                            },
                                            child: Text(
                                              'Forgot Password?',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0xFF6C3FC7),
                                                    fontSize: 13.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      FFButtonWidget(
                                        onPressed: () async {
                                          if (_model.formKey.currentState ==
                                                  null ||
                                              !_model.formKey.currentState!
                                                  .validate()) {
                                            return;
                                          }
                                          GoRouter.of(context)
                                              .prepareAuthEvent();

                                          final user = await authManager
                                              .signInWithEmail(
                                            context,
                                            _model
                                                .textFieldEmailTextController
                                                .text,
                                            _model
                                                .textFieldPasswordTextController
                                                .text,
                                          );
                                          if (user == null) {
                                            return;
                                          }

                                          context.goNamedAuth(
                                              HomepageUnifiedWidget.routeName,
                                              context.mounted);
                                        },
                                        text: 'Sign In',
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 54.0,
                                          padding: EdgeInsets.all(8.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: Color(0xFF6C3FC7),
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.interTight(
                                                  fontWeight: FontWeight.bold,
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
                                                    FlutterFlowTheme.of(context)
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
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 60.0,
                                            height: 1.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFE0DDF0),
                                            ),
                                          ),
                                          Text(
                                            '  or continue with  ',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFFB0AEC8),
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          Container(
                                            width: 60.0,
                                            height: 1.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFE0DDF0),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Informational Dialog'),
                                                    content: Text(
                                                        'This feature is yet to be implemented.'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext),
                                                        child: Text('Ok'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              width: 56.0,
                                              height: 56.0,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFF8F7FF),
                                                borderRadius:
                                                    BorderRadius.circular(14.0),
                                                border: Border.all(
                                                  color: Color(0xFFE8E6F5),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Icon(
                                                  Icons.g_mobiledata_rounded,
                                                  color: Colors.black,
                                                  size: 26.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 16.0)),
                                      ),
                                    ].divide(SizedBox(height: 16.0)),
                                  ),
                                ),
                              ].divide(SizedBox(height: 0.0)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 20.0, 24.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(PSignUpWidget.routeName);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account? ',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF8E8E9A),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                'Sign Up',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF6C3FC7),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
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
            ),
          ],
        ),
      ),
    );
  }
}
