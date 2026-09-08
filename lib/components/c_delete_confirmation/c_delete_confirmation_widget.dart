import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_delete_confirmation_model.dart';
export 'c_delete_confirmation_model.dart';

class CDeleteConfirmationWidget extends StatefulWidget {
  const CDeleteConfirmationWidget({
    super.key,
    required this.itemType,
    required this.warningText,
    required this.onConfirm,
  });

  final String itemType;
  final String warningText;
  final Future<void> Function() onConfirm;

  @override
  State<CDeleteConfirmationWidget> createState() =>
      _CDeleteConfirmationWidgetState();
}

class _CDeleteConfirmationWidgetState extends State<CDeleteConfirmationWidget> {
  late CDeleteConfirmationModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CDeleteConfirmationModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 24.0,
                  color: Color(0x33000000),
                  offset: Offset(0.0, 8.0),
                )
              ],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 32.0, 24.0, 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 56.0,
                        height: 56.0,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF5E6),
                          shape: BoxShape.circle,
                        ),
                        child: const Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xFFFF0000),
                            size: 30.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          'Confirm Deletion',
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: GoogleFonts.interTight().fontFamily,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      widget.itemType,
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontWeight: FontWeight.bold,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    widget.warningText,
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          lineHeight: 1.5,
                        ),
                  ),
                  const SizedBox(height: 24.0),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FFButtonWidget(
                        onPressed: _model.isDeleting
                            ? null
                            : () async {
                                setState(() {
                                  _model.isDeleting = true;
                                });
                                try {
                                  await widget.onConfirm();
                                  if (mounted) {
                                    Navigator.pop(context, true);
                                  }
                                } catch (e) {
                                  // Callers should handle their errors, but we catch to ensure isDeleting clears
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _model.isDeleting = false;
                                    });
                                  }
                                }
                              },
                        text: _model.isDeleting ? 'DELETING...' : 'CONFIRM',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 52.0,
                          padding: const EdgeInsets.all(8.0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).error,
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: GoogleFonts.interTight().fontFamily,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                          elevation: 0.0,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      FFButtonWidget(
                        onPressed: _model.isDeleting
                            ? null
                            : () async {
                                Navigator.pop(context);
                              },
                        text: 'CANCEL',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 52.0,
                          padding: const EdgeInsets.all(8.0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: GoogleFonts.interTight().fontFamily,
                                fontWeight: FontWeight.w600,
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                          elevation: 0.0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
