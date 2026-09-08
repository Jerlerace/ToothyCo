import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'splash_model.dart';
export 'splash_model.dart';

/// 1.
///
/// Splash Screen
///
/// Design a premium splash screen for Toothy & Co. with logo, tagline “Smile
/// with Confidence”, soft purple gradient background, subtle animation, clean
/// centered layout, modern healthcare branding.
class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  static String routeName = 'Splash';
  static String routePath = '/splash';

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  late SplashModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SplashModel());
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
        backgroundColor: Color(0xFF6B4FA8),
        body: Stack(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.pushNamed(PSignInWidget.routeName);
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: BoxDecoration(
                        color: Color(0x33FFFFFF),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 40.0,
                            color: Color(0x44FFFFFF),
                            offset: Offset(
                              0.0,
                              8.0,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(40.0),
                        border: Border.all(
                          color: Color(0x55FFFFFF),
                          width: 2.0,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Text(
                                '🦷',
                                style: FlutterFlowTheme.of(context)
                                    .displayLarge
                                    .override(
                                      font: GoogleFonts.interTight(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .displayLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .displayLarge
                                            .fontStyle,
                                      ),
                                      fontSize: 64.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .displayLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .displayLarge
                                          .fontStyle,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 28.0, 0.0, 0.0),
                      child: Container(
                        width: 200.0,
                        height: 4.0,
                        decoration: BoxDecoration(
                          color: Color(0x44FFFFFF),
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: Text(
                        'Toothy & Co.',
                        textAlign: TextAlign.center,
                        style:
                            FlutterFlowTheme.of(context).displaySmall.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .displaySmall
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  fontSize: 36.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .displaySmall
                                      .fontStyle,
                                ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                      child: Container(
                        width: 60.0,
                        height: 3.0,
                        decoration: BoxDecoration(
                          color: Color(0xAAFFFFFF),
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                      child: Text(
                        'Smile with Confidence',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.normal,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .fontStyle,
                              ),
                              color: Color(0xDDFFFFFF),
                              fontSize: 16.0,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.normal,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .fontStyle,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 60.0, 0.0, 0.0),
                      child: Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: BoxDecoration(
                          color: Color(0x22FFFFFF),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: Lottie.network(
                          'https://assets10.lottiefiles.com/packages/lf20_jcikwtux.json',
                          width: 48.0,
                          height: 48.0,
                          fit: BoxFit.contain,
                          animate: true,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.refresh_rounded,
                              color: Colors.white,
                              size: 24.0,
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 48.0, 0.0, 0.0),
                      child: Container(
                        width: 200.0,
                        height: 4.0,
                        decoration: BoxDecoration(
                          color: Color(0x33FFFFFF),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Container(
                            width: 100.0,
                            height: 4.0,
                            decoration: BoxDecoration(
                              color: Color(0xCCFFFFFF),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                      child: Text(
                        'Premium Dental Care',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).labelSmall.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelSmall
                                    .fontStyle,
                              ),
                              color: Color(0x99FFFFFF),
                              fontSize: 11.0,
                              letterSpacing: 3.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 1.0),
              child: Container(
                width: double.infinity,
                height: 120.0,
                decoration: BoxDecoration(),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              color: Color(0x66FFFFFF),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              color: Color(0x66FFFFFF),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ].divide(SizedBox(width: 8.0)),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                        child: Text(
                          'v1.0.0',
                          textAlign: TextAlign.center,
                          style:
                              FlutterFlowTheme.of(context).labelSmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .fontStyle,
                                    ),
                                    color: Color(0x66FFFFFF),
                                    fontSize: 10.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontStyle,
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
