import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import 'package:intl/intl.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/patient/a_i_chat_bot/a_i_chat_bot_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'p_dashboard_patient_model.dart';
export 'p_dashboard_patient_model.dart';

/// 4.
///
/// Home Dashboard
///
/// Design a patient dashboard with greeting message, upcoming appointment
/// card, featured dental services, dentist availability preview, clinic
/// announcements, quick action buttons, bottom navigation.
class PDashboardPatientWidget extends StatefulWidget {
  const PDashboardPatientWidget({super.key});

  static String routeName = 'P_Dashboard_patient';
  static String routePath = '/pDashboardPatient';

  @override
  State<PDashboardPatientWidget> createState() =>
      _PDashboardPatientWidgetState();
}

class _PDashboardPatientWidgetState extends State<PDashboardPatientWidget> {
  late PDashboardPatientModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PDashboardPatientModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  String generateUUID() {
    final r = DateTime.now().microsecondsSinceEpoch;
    String hex(int val, int len) => val.toRadixString(16).padLeft(len, '0');
    return '${hex(r & 0xFFFFFFFF, 8)}-${hex((r >> 32) & 0xFFFF, 4)}-4${hex((r >> 48) & 0xFFF, 3)}-8${hex((r >> 56) & 0xFFF, 3)}-${hex(r & 0xFFFFFFFFFFFF, 12)}';
  }

  Future<UserRow?> fetchCurrentUser() async {
    if (currentUserUid.isEmpty) return null;
    try {
      final users = await UserTable().queryRows(
        queryFn: (q) => q.eq('user_id', currentUserUid),
      );
      if (users.isNotEmpty) {
        return users.first;
      }
    } catch (e) {
      print('Error fetching current user: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchUpcomingAppointment() async {
    if (currentUserUid.isEmpty) return null;
    try {
      final now = DateTime.now();
      final apps = await AppointmentTable().queryRows(
        queryFn: (q) => q
            .eq('patient_id', currentUserUid)
            .neq('status', 'Cancelled')
            .order('appointment_date', ascending: true)
            .order('appointment_time', ascending: true),
      );
      if (apps.isEmpty) return null;
      AppointmentRow? soonestApp;
      DateTime? soonestDateTime;
      for (var app in apps) {
        final date = app.appointmentDate;
        final timeVal = app.appointmentTime.time;
        if (timeVal == null) continue;
        final appDateTime = DateTime(date.year, date.month, date.day, timeVal.hour, timeVal.minute, timeVal.second);
        if (appDateTime.isAfter(now)) {
          soonestApp = app;
          soonestDateTime = appDateTime;
          break;
        }
      }
      if (soonestApp == null) return null;
      UserRow? dentist;
      if (soonestApp.doctorId != null) {
        final dentists = await UserTable().queryRows(
          queryFn: (q) => q.eq('user_id', soonestApp!.doctorId!),
        );
        if (dentists.isNotEmpty) {
          dentist = dentists.first;
        }
      }
      ProcedureRow? procedure;
      if (soonestApp.procedureId != null) {
        final procs = await ProcedureTable().queryRows(
          queryFn: (q) => q.eq('procedure_id', soonestApp!.procedureId!),
        );
        if (procs.isNotEmpty) {
          procedure = procs.first;
        }
      }
      return {
        'appointment': soonestApp,
        'dateTime': soonestDateTime,
        'dentist': dentist,
        'procedure': procedure,
      };
    } catch (e) {
      print('Error fetching upcoming appointment: $e');
      return null;
    }
  }

  void _showChatbotBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      barrierColor: FlutterFlowTheme.of(context).primaryBackground,
      isDismissible: false,
      enableDrag: false,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: AIChatBotWidget(),
          ),
        );
      },
    ).then((value) => safeSetState(() {}));
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
        backgroundColor: Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Color(0xFFF5F7FA),
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good Morning 👋',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                            color: Color(0xFF6B7A8D),
                            fontSize: 13.0,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontStyle,
                          ),
                    ),
                    FutureBuilder<UserRow?>(
                      future: fetchCurrentUser(),
                      builder: (context, snapshot) {
                        final name = snapshot.data?.fullname ?? currentUserDisplayName;
                        return Text(
                          name.isEmpty ? 'Patient' : name,
                          style: FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: GoogleFonts.interTight().fontFamily,
                                color: const Color(0xFF1A2340),
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                        );
                      },
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Container(
                      width: 44.0,
                      height: 44.0,
                      decoration: BoxDecoration(
                        color: Color(0xFFE8F0FE),
                        shape: BoxShape.circle,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Icon(
                          Icons.notifications_none,
                          color: Color(0xFF3D6BE8),
                          size: 22.0,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(1.0, -1.0),
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF4757),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFFF5F7FA),
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              FutureBuilder<Map<String, dynamic>?>(
                future: fetchUpcomingAppointment(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        height: 165.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF3D6BE8),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 30.0,
                            height: 30.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  
                  final data = snapshot.data;
                  if (data == null) {
                    return Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        height: 120.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 48.0,
                                height: 48.0,
                                decoration: BoxDecoration(
                                  color: Color(0x1A3D6BE8),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.calendar_today_rounded,
                                  color: Color(0xFF3D6BE8),
                                  size: 24.0,
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'No Upcoming Appointments',
                                      style: FlutterFlowTheme.of(context).titleMedium.override(
                                        fontFamily: GoogleFonts.interTight().fontFamily,
                                        color: FlutterFlowTheme.of(context).primaryText,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      'Schedule a visit to see your dentist.',
                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                        fontFamily: GoogleFonts.inter().fontFamily,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  context.pushNamed(PBookAppointmentPatientWidget.routeName);
                                },
                                text: 'Book Now',
                                options: FFButtonOptions(
                                  width: 90.0,
                                  height: 36.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  color: Color(0xFF3D6BE8),
                                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: GoogleFonts.interTight().fontFamily,
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  final soonestApp = data['appointment'] as AppointmentRow;
                  final soonestDateTime = data['dateTime'] as DateTime;
                  final dentist = data['dentist'] as UserRow?;
                  final procedure = data['procedure'] as ProcedureRow?;

                  return Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: InkWell(
                      onTap: () async {
                        context.pushNamed(
                          PBookAppointmentPatientWidget.routeName,
                          queryParameters: {
                            if (soonestApp.doctorId != null) 'initialDentistId': soonestApp.doctorId!,
                            if (soonestApp.procedureId != null) 'initialProcedureId': soonestApp.procedureId!,
                            if (soonestApp.appointmentId != null) 'rescheduleAppointmentId': soonestApp.appointmentId!,
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 165.0,
                      decoration: BoxDecoration(
                        color: Color(0xFF3D6BE8),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20.0,
                            color: Color(0x403D6BE8),
                            offset: Offset(0.0, 8.0),
                          )
                        ],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: AlignmentDirectional(1.0, -1.0),
                            child: Container(
                              width: 120.0,
                              height: 120.0,
                              decoration: BoxDecoration(
                                color: Color(0x1AFFFFFF),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(1.5, 1.0),
                            child: Container(
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                color: Color(0x0DFFFFFF),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: 36.0,
                                      height: 36.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x33FFFFFF),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Align(
                                        alignment: AlignmentDirectional(0.0, 0.0),
                                        child: Icon(
                                          Icons.calendar_today_rounded,
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Next Appointment - ${procedure?.procedureName ?? "General Visit"}',
                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                            fontFamily: GoogleFonts.inter().fontFamily,
                                            color: Color(0xB3FFFFFF),
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          dentist?.fullname ?? 'Dr. Sarah Mitchell',
                                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                            fontFamily: GoogleFonts.interTight().fontFamily,
                                            color: Colors.white,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ].divide(SizedBox(width: 8.0)),
                                ),
                                Divider(
                                  height: 1.0,
                                  thickness: 1.0,
                                  color: Color(0x33FFFFFF),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.access_time_rounded,
                                          color: Color(0xB3FFFFFF),
                                          size: 14.0,
                                        ),
                                        Text(
                                          DateFormat('EEEE, MMM d - h:mm a').format(soonestDateTime),
                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                            fontFamily: GoogleFonts.inter().fontFamily,
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 6.0)),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.bookmark_added_rounded,
                                          color: Color(0xB3FFFFFF),
                                          size: 14.0,
                                        ),
                                        Text(
                                          procedure?.category ?? 'General',
                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                            fontFamily: GoogleFonts.inter().fontFamily,
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 6.0)),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final diff = soonestDateTime.difference(DateTime.now());
                                        if (diff.isNegative || diff.inHours < 12) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Row(
                                                children: [
                                                  Icon(Icons.warning_amber_rounded, color: Colors.white),
                                                  SizedBox(width: 8.0),
                                                  Expanded(child: Text('Cannot cancel appointments scheduled in less than 12 hours.')),
                                                ],
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }

                                        final confirmCancel = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Cancel Appointment'),
                                            content: Text('Are you sure you want to cancel your appointment with ${dentist?.fullname ?? "your dentist"} on ${DateFormat('MMM dd').format(soonestDateTime)}?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, false),
                                                child: Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, true),
                                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                                child: Text('Yes, Cancel'),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirmCancel == true) {
                                          try {
                                            await AppointmentTable().update(
                                              data: {
                                                'status': 'Cancelled',
                                                'updated_at': DateTime.now().toIso8601String(),
                                              },
                                              matchingRows: (rows) => rows.eq('appointment_id', soonestApp.appointmentId!),
                                            );

                                            final patientRows = await UserTable().queryRows(
                                              queryFn: (q) => q.eq('user_id', currentUserUid),
                                            );
                                            final patientName = patientRows.isNotEmpty ? (patientRows.first.fullname ?? 'A patient') : 'A patient';
                                            final procName = procedure?.procedureName ?? 'General Visit';
                                            final dateFormatted = DateFormat('MMM dd, yyyy').format(soonestApp.appointmentDate);
                                            final timeFormatted = soonestApp.appointmentTime.toIso8601String()?.substring(0, 5) ?? '';

                                            await NotificationTable().insert({
                                              'notification_id': generateUUID(),
                                              'user_id': soonestApp.doctorId!,
                                              'title': 'Appointment Cancelled',
                                              'body': '$patientName cancelled their appointment for $procName on $dateFormatted at $timeFormatted.',
                                              'type': 'Cancel',
                                              'reference_id': soonestApp.appointmentId,
                                              'is_read': false,
                                              'created_at': DateTime.now().toIso8601String(),
                                            });

                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('🗑️ Appointment cancelled successfully.'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );

                                            setState(() {});
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Error cancelling appointment: $e')),
                                            );
                                          }
                                        }
                                      },
                                      child: Container(
                                        height: 28.0,
                                        decoration: BoxDecoration(
                                          color: Color(0x1BFFFFFF),
                                          borderRadius: BorderRadius.circular(20.0),
                                          border: Border.all(color: Colors.white30),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                          child: Center(
                                            child: Text(
                                              'Cancel',
                                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                                fontFamily: GoogleFonts.inter().fontFamily,
                                                color: Colors.white,
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    InkWell(
                                      onTap: () async {
                                        context.pushNamed(
                                          PBookAppointmentPatientWidget.routeName,
                                          queryParameters: {
                                            if (soonestApp.doctorId != null) 'initialDentistId': soonestApp.doctorId!,
                                            if (soonestApp.procedureId != null) 'initialProcedureId': soonestApp.procedureId!,
                                            if (soonestApp.appointmentId != null) 'rescheduleAppointmentId': soonestApp.appointmentId!,
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: 28.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                          child: Center(
                                            child: Text(
                                              'Reschedule',
                                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                                fontFamily: GoogleFonts.inter().fontFamily,
                                                color: Color(0xFF3D6BE8),
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                },
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                      child: Text(
                        'Quick Actions',
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  color: Color(0xFF1A2340),
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(
                                PBookAppointmentPatientWidget.routeName);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed(
                                      PBookAppointmentPatientWidget.routeName);
                                },
                                child: Container(
                                  width: 56.0,
                                  height: 56.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE8F0FE),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Icon(
                                      Icons.add_circle_outline_rounded,
                                      color: Color(0xFF3D6BE8),
                                      size: 26.0,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'Book',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF1A2340),
                                      fontSize: 11.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                              ),
                            ].divide(SizedBox(height: 6.0)),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(PPatientHistoryWidget.routeName);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed(
                                      PPatientHistoryWidget.routeName);
                                },
                                child: Container(
                                  width: 56.0,
                                  height: 56.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFF3E0),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Icon(
                                      Icons.receipt_long_rounded,
                                      color: Colors.orange,
                                      size: 26.0,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'Records',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF1A2340),
                                      fontSize: 11.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                              ),
                            ].divide(SizedBox(height: 6.0)),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AIChatBotWidget()),
                                ).then((value) => safeSetState(() {}));
                              },
                              child: Container(
                                width: 56.0,
                                height: 56.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFCE4EC),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    color: Color(0xFFEC407A),
                                    size: 26.0,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'Chat',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF1A2340),
                                    fontSize: 11.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                            ),
                          ].divide(SizedBox(height: 6.0)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Our Services',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  color: Color(0xFF1A2340),
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                  PProceduresNpricingPatientWidget.routeName);
                            },
                            child: Text(
                              'See all',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF3D6BE8),
                                    fontSize: 13.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<List<ProcedureRow>>(
                      future: ProcedureTable().queryRows(
                        queryFn: (q) => q,
                      ),
                      builder: (context, snapshot) {
                        // Customize what your widget looks like when it's loading.
                        if (!snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),
                          );
                        }
                        List<ProcedureRow> rowProcedureRowList = snapshot.data!;

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: List.generate(rowProcedureRowList.length,
                                (rowIndex) {
                              final rowProcedureRow =
                                  rowProcedureRowList[rowIndex];
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 0.0, 12.0, 0.0),
                                child: Container(
                                  width: 130.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 10.0,
                                        color: Color(0x1A3D6BE8),
                                        offset: Offset(
                                          0.0,
                                          4.0,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          valueOrDefault<String>(
                                            rowProcedureRow.procedureName,
                                            'name',
                                          ),
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFF1A2340),
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Container(
                                          height: 22.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFE8F0FE),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 0.0, 8.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                RichText(
                                                  textScaler:
                                                      MediaQuery.of(context)
                                                          .textScaler,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'From \$',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodySmall
                                                            .override(
                                                              font: GoogleFonts
                                                                  .inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                              ),
                                                              color: Color(
                                                                  0xFF3D6BE8),
                                                              fontSize: 10.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontStyle,
                                                            ),
                                                      ),
                                                      TextSpan(
                                                        text: valueOrDefault<
                                                            String>(
                                                          rowProcedureRow
                                                              .pricing
                                                              .toString(),
                                                          '0',
                                                        ),
                                                        style: TextStyle(),
                                                      )
                                                    ],
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                          ),
                                                          color:
                                                              Color(0xFF3D6BE8),
                                                          fontSize: 10.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ].divide(SizedBox(height: 8.0)),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Available Dentists',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  color: Color(0xFF1A2340),
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context
                                  .pushNamed(PViewDentistsAllWidget.routeName);
                            },
                            child: Text(
                              'View all',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF3D6BE8),
                                    fontSize: 13.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8.0,
                                color: Color(0x0D000000),
                                offset: Offset(
                                  0.0,
                                  2.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: 52.0,
                                          height: 52.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: Image.network(
                                                '200x200?dentist1',
                                              ).image,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(1.0, 1.0),
                                          child: Container(
                                            width: 14.0,
                                            height: 14.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF2ECC71),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Dr. Sarah Mitchell',
                                          style: FlutterFlowTheme.of(context)
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
                                                color: Color(0xFF1A2340),
                                                fontSize: 14.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          'Orthodontist',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFF6B7A8D),
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 2.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(
                                                Icons.star_rounded,
                                                color: Color(0xFFFFC107),
                                                size: 12.0,
                                              ),
                                              Text(
                                                '4.9  •  Available Today',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodySmall
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .fontStyle,
                                                      ),
                                                      color: Color(0xFF6B7A8D),
                                                      fontSize: 11.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ].divide(SizedBox(width: 4.0)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                                FFButtonWidget(
                                  onPressed: () async {
                                    context.pushNamed(
                                        PBookAppointmentPatientWidget
                                            .routeName);
                                  },
                                  text: 'Book',
                                  options: FFButtonOptions(
                                    height: 34.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: Color(0xFF3D6BE8),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8.0,
                                color: Color(0x0D000000),
                                offset: Offset(
                                  0.0,
                                  2.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: 52.0,
                                          height: 52.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: Image.network(
                                                'https://images.unsplash.com/photo-1627023063469-7a78d2588878?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NzY3ODI0ODF8&ixlib=rb-4.1.0&q=80&w=1080',
                                              ).image,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(1.0, 1.0),
                                          child: Container(
                                            width: 14.0,
                                            height: 14.0,
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Dr. James Carter',
                                          style: FlutterFlowTheme.of(context)
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
                                                color: Color(0xFF1A2340),
                                                fontSize: 14.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          'Cosmetic Dentist',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFF6B7A8D),
                                                fontSize: 12.0,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 2.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(
                                                Icons.star_rounded,
                                                color: Color(0xFFFFC107),
                                                size: 12.0,
                                              ),
                                              Text(
                                                '4.7  •  Next: 2:00 PM',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodySmall
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .fontStyle,
                                                      ),
                                                      color: Color(0xFF6B7A8D),
                                                      fontSize: 11.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ].divide(SizedBox(width: 4.0)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                                FFButtonWidget(
                                  onPressed: () {
                                    print('Button pressed ...');
                                  },
                                  text: 'Book',
                                  options: FFButtonOptions(
                                    height: 34.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: Color(0xFFE8F0FE),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                          color: Color(0xFF3D6BE8),
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                    elevation: 0.0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ].divide(SizedBox(height: 10.0)),
                    ),
                  ],
                ),
              ),
            ]
                .addToStart(SizedBox(height: 16.0))
                .addToEnd(SizedBox(height: 32.0)),
          ),
        ),
      ),
    );
  }
}
