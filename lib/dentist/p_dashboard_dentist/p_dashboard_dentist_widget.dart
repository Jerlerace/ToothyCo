import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/database/database.dart';
import 'p_dashboard_dentist_model.dart';
export 'p_dashboard_dentist_model.dart';

/// 2.
///
/// Dentist Dashboard
///
/// Design a dashboard showing welcome message, today’s appointments count,
/// pending requests count, completed treatments count, quick stats cards,
/// shortcuts to schedule and patients.
class PDashboardDentistWidget extends StatefulWidget {
  const PDashboardDentistWidget({super.key});

  static String routeName = 'P_Dashboard_dentist';
  static String routePath = '/pDashboardDentist';

  @override
  State<PDashboardDentistWidget> createState() =>
      _PDashboardDentistWidgetState();
}

class _PDashboardDentistWidgetState extends State<PDashboardDentistWidget> {
  late PDashboardDentistModel _model;
  late Future<Map<String, dynamic>> _dashboardDataFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PDashboardDentistModel());
    _dashboardDataFuture = _fetchDashboardData();
  }

  Future<Map<String, dynamic>> _fetchDashboardData() async {
    final todayStr = DateTime.now().toIso8601String().split('T').first;

    // Fetch User Info
    final users = await UserTable().querySingleRow(
      queryFn: (q) => q.eq('user_id', currentUserUid),
    );
    final userRow = users.isNotEmpty ? users.first : null;

    // Fetch Dentist Info
    final dentists = await DentistTable().querySingleRow(
      queryFn: (q) => q.eq('dentist_id', currentUserUid),
    );
    final dentistRow = dentists.isNotEmpty ? dentists.first : null;

    // Fetch Today's Appointments
    final todayApps = await AppointmentTable().queryRows(
      queryFn: (q) => q
          .eq('doctor_id', currentUserUid)
          .eq('appointment_date', todayStr)
          .neq('status', 'Cancelled'),
    );

    // Fetch Pending Appointments
    final pendingApps = await AppointmentTable().queryRows(
      queryFn: (q) => q.eq('doctor_id', currentUserUid).eq('status', 'Pending'),
    );

    // Fetch Completed Appointments
    final completedApps = await AppointmentTable().queryRows(
      queryFn: (q) =>
          q.eq('doctor_id', currentUserUid).eq('status', 'Completed'),
    );

    final List<Map<String, dynamic>> resolvedTodayApps = [];
    for (var app in todayApps) {
      String patientName = 'Unknown Patient';
      String? patientImg = null;
      if (app.patientId != null) {
        final patients = await UserTable().querySingleRow(
          queryFn: (q) => q.eq('user_id', app.patientId!),
        );
        if (patients.isNotEmpty) {
          patientName = patients.first.fullname ?? 'Unknown Patient';
          patientImg = patients.first.userImgUrl;
        }
      }

      String procedureName = 'General Checkup';
      if (app.procedureId != null) {
        final procedures = await ProcedureTable().querySingleRow(
          queryFn: (q) => q.eq('procedure_id', app.procedureId!),
        );
        if (procedures.isNotEmpty) {
          procedureName = procedures.first.procedureName;
        }
      }

      resolvedTodayApps.add({
        'appointment': app,
        'patientName': patientName,
        'patientImg': patientImg,
        'procedureName': procedureName,
      });
    }

    return {
      'fullname': userRow?.fullname ?? 'Doctor',
      'userImgUrl': userRow?.userImgUrl,
      'specialization': dentistRow?.specialization ?? 'General Dentistry',
      'todayCount': todayApps.length,
      'pendingCount': pendingApps.length,
      'completedCount': completedApps.length,
      'todayAppointments': resolvedTodayApps,
    };
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _dashboardDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final data = snapshot.data ?? {
          'fullname': 'Doctor',
          'userImgUrl': null,
          'specialization': 'General Dentistry',
          'todayCount': 0,
          'pendingCount': 0,
          'completedCount': 0,
          'todayAppointments': [],
        };
        final fullname = data['fullname'] as String;
        final userImgUrl = data['userImgUrl'] as String?;
        final specialization = data['specialization'] as String;
        final todayCount = data['todayCount'] as int;
        final pendingCount = data['pendingCount'] as int;
        final completedCount = data['completedCount'] as int;
        final todayAppointments = data['todayAppointments'] as List<Map<String, dynamic>>;

        return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.network(
                      userImgUrl != null && userImgUrl.isNotEmpty
                          ? userImgUrl
                          : 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=200',
                    ).image,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning,',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          fontWeight:
                              FlutterFlowTheme.of(context).bodySmall.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodySmall.fontStyle,
                        ),
                  ),
                  Text(
                    fullname,
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontStyle,
                        ),
                  ),
                ],
              ),
            ].divide(SizedBox(width: 12.0)),
          ),
          actions: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
                  child: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 12.0,
                    buttonSize: 40.0,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    icon: Icon(
                      Icons.notifications_none,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 22.0,
                    ),
                    onPressed: () {
                      print('IconButton pressed ...');
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                  child: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 12.0,
                    buttonSize: 40.0,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    icon: Icon(
                      Icons.settings_outlined,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 22.0,
                    ),
                    onPressed: () async {
                      context.pushNamed(PProfileDentistWidget.routeName);
                    },
                  ),
                ),
              ].divide(SizedBox(width: 4.0)),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    height: 120.0,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 16.0,
                          color: Color(0x331565C0),
                          offset: Offset(
                            0.0,
                            6.0,
                          ),
                        )
                      ],
                      gradient: LinearGradient(
                        colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                        stops: [0.0, 1.0],
                        begin: AlignmentDirectional(1.0, 1.0),
                        end: AlignmentDirectional(-1.0, -1.0),
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Today\'s Overview',
                                style: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .override(
                                      font: GoogleFonts.interTight(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontStyle,
                                      ),
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .fontStyle,
                                    ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 4.0, 0.0, 0.0),
                                child: Text(
                                  DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
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
                                        color: Color(0xB3FFFFFF),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 0.0),
                                child: Container(
                                  height: 28.0,
                                  decoration: BoxDecoration(
                                    color: Color(0x33FFFFFF),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 12.0, 0.0),
                                    child: Text(
                                      '🦷  Dental Clinic',
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Lottie.network(
                            'https://assets2.lottiefiles.com/packages/lf20_tutvdkg0.json',
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.contain,
                            animate: true,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.refresh_rounded,
                                color: Colors.grey,
                                size: 36.0,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Text(
                    'Quick Stats',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontStyle,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFF0F7FF),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8.0,
                                color: Color(0x1A1565C0),
                                offset: Offset(
                                  0.0,
                                  2.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(PAppointmentsWidget.routeName);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 36.0,
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF1565C0),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.calendar_today_rounded,
                                    color: Colors.white,
                                    size: 18.0,
                                  ),
                                ),
                                Text(
                                  todayCount.toString(),
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
                                        color: Color(0xFF1565C0),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Appointments',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(height: 4.0)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 8.0,
                      ),
                      Expanded(
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFF8E1),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8.0,
                                color: Color(0x1AF57F17),
                                offset: Offset(
                                  0.0,
                                  2.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(PAppointmentsWidget.routeName);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 36.0,
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF57F17),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.pending_actions_rounded,
                                    color: Colors.white,
                                    size: 18.0,
                                  ),
                                ),
                                Text(
                                  pendingCount.toString(),
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
                                        color: Color(0xFFF57F17),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Pending',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(height: 4.0)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 8.0,
                      ),
                      Expanded(
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFF1F8E8),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8.0,
                                color: Color(0x1A2E7D32),
                                offset: Offset(
                                  0.0,
                                  2.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              await context.pushNamed(
                                  DentistTotalPatientHistoryFocusWidget
                                      .routeName);
                              setState(() {
                                _dashboardDataFuture = _fetchDashboardData();
                              });
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 36.0,
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2E7D32),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check_circle_outline_rounded,
                                    color: Colors.white,
                                    size: 18.0,
                                  ),
                                ),
                                Text(
                                  completedCount.toString(),
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
                                        color: Color(0xFF2E7D32),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Completed',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(height: 4.0)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 0.0),
                  child: Text(
                    'Today\'s Appointments',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontStyle,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
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
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: todayAppointments.isEmpty
                            ? [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  child: Text(
                                    'No appointments scheduled for today',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          font: GoogleFonts.inter(),
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                        ),
                                  ),
                                )
                              ]
                            : todayAppointments.map((appData) {
                                final app = appData['appointment'] as AppointmentRow;
                                final pName = appData['patientName'] as String;
                                final pImg = appData['patientImg'] as String?;
                                final procName = appData['procedureName'] as String;

                                final timeStr = app.appointmentTime.toIso8601String()?.substring(0, 5) ?? '';
                                final statusStr = app.status ?? 'Pending';

                                Color statusColor;
                                Color statusBg;
                                if (statusStr == 'Confirmed') {
                                  statusColor = Color(0xFF1565C0);
                                  statusBg = Color(0xFFE3F2FD);
                                } else if (statusStr == 'Completed' || statusStr == 'Done') {
                                  statusColor = Color(0xFF2E7D32);
                                  statusBg = Color(0xFFF1F8E8);
                                } else {
                                  statusColor = Color(0xFFF57F17);
                                  statusBg = Color(0xFFFFF8E1);
                                }

                                return Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 44.0,
                                                height: 44.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: Image.network(
                                                      pImg != null && pImg.isNotEmpty
                                                          ? pImg
                                                          : 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
                                                    ).image,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    pName,
                                                    style: FlutterFlowTheme.of(context).titleSmall.override(
                                                          font: GoogleFonts.interTight(fontWeight: FontWeight.w600),
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '$procName · $timeStr',
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          font: GoogleFonts.inter(),
                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ].divide(SizedBox(width: 12.0)),
                                          ),
                                          Container(
                                            height: 26.0,
                                            decoration: BoxDecoration(
                                              color: statusBg,
                                              borderRadius: BorderRadius.circular(20.0),
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional(0.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                                                child: Text(
                                                  statusStr,
                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                                        color: statusColor,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      thickness: 1.0,
                                      color: Color(0x0D000000),
                                    ),
                                  ],
                                );
                              }).toList(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 0.0),
                  child: Text(
                    'Quick Shortcuts',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontStyle,
                        ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await context.pushNamed(PScheduleDentistWidget.routeName);
                            setState(() {
                              _dashboardDataFuture = _fetchDashboardData();
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(1.0, 1.0),
                                end: AlignmentDirectional(-1.0, -1.0),
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: Color(0x33FFFFFF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.calendar_month_rounded,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Schedule',
                                        style: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        'Manage slots',
                                        style: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .fontStyle,
                                              ),
                                              color: Color(0xB3FFFFFF),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                ].divide(SizedBox(width: 10.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await context.pushNamed(
                                DentistTotalPatientHistoryFocusWidget
                                    .routeName);
                            setState(() {
                              _dashboardDataFuture = _fetchDashboardData();
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(1.0, 1.0),
                                end: AlignmentDirectional(-1.0, -1.0),
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: Color(0x33FFFFFF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.people_alt_rounded,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Patients',
                                        style: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        'View records',
                                        style: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .fontStyle,
                                              ),
                                              color: Color(0xB3FFFFFF),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                ].divide(SizedBox(width: 10.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(width: 15.0)),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await context.pushNamed(TreatmentRecordsWidget.routeName);
                            setState(() {
                              _dashboardDataFuture = _fetchDashboardData();
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF00695C), Color(0xFF26A69A)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(1.0, 1.0),
                                end: AlignmentDirectional(-1.0, -1.0),
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: Color(0x33FFFFFF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.medical_services_rounded,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Treatments',
                                        style: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        'Track progress',
                                        style: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .fontStyle,
                                              ),
                                              color: Color(0xB3FFFFFF),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                ].divide(SizedBox(width: 10.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(
                                DentistFulfillmentFocusWidget.routeName);
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFC62828), Color(0xFFEF5350)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(1.0, 1.0),
                                end: AlignmentDirectional(-1.0, -1.0),
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: Color(0x33FFFFFF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.medical_services_rounded,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Fulfillment ',
                                        style: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        'Success Rate',
                                        style: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .fontStyle,
                                              ),
                                              color: Color(0xB3FFFFFF),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                ].divide(SizedBox(width: 10.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(width: 15.0)),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 4.0, 16.0, 4.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(
                                DentistAnalyticsFocusWidget.routeName);
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFC69128), Color(0xFFC1AD77)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(1.0, 1.0),
                                end: AlignmentDirectional(-1.0, -1.0),
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: Color(0x33FFFFFF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.medical_services_rounded,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Revenue',
                                        style: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        'Track revenue',
                                        style: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .fontStyle,
                                              ),
                                              color: Color(0xB3FFFFFF),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                ].divide(SizedBox(width: 10.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 0.0),
                  child: Text(
                    'Monthly Performance',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontStyle,
                        ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 16.0, 16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
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
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 5.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Treatments Completed',
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                  ),
                                  Text(
                                    '48 / 60',
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                          color: Color(0xFF1565C0),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 10.0,
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 10.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE3F2FD),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.8,
                                    height: 10.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF1565C0),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(),
                          ].divide(SizedBox(height: 12.0)),
                        ),
                      ),
                    ),
                  ),
                ),
              ]
                  .addToStart(SizedBox(height: 16.0))
                  .addToEnd(SizedBox(height: 32.0)),
            ),
          ),
        ),
      ),
    );
  },
);
  }
}
