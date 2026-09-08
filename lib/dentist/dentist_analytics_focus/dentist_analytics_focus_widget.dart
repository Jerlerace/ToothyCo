import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/database/database.dart';
import 'dentist_analytics_focus_model.dart';
export 'dentist_analytics_focus_model.dart';

class DentistAnalyticsFocusWidget extends StatefulWidget {
  const DentistAnalyticsFocusWidget({super.key});

  static String routeName = 'DentistAnalyticsFocus';
  static String routePath = '/dentistAnalyticsFocus';

  @override
  State<DentistAnalyticsFocusWidget> createState() =>
      _DentistAnalyticsFocusWidgetState();
}

class _DentistAnalyticsFocusWidgetState
    extends State<DentistAnalyticsFocusWidget> {
  late DentistAnalyticsFocusModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late Future<Map<String, dynamic>> _analyticsFuture;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DentistAnalyticsFocusModel());
    _analyticsFuture = _fetchAnalytics();
  }

  Future<Map<String, dynamic>> _fetchAnalytics() async {
    // 1. Fetch Doctor Name
    String doctorName = 'Doctor';
    try {
      final docRows = await UserTable().queryRows(
        queryFn: (q) => q.eq('user_id', currentUserUid).limit(1),
      );
      if (docRows.isNotEmpty) {
        doctorName = docRows.first.fullname ?? 'Doctor';
      }
    } catch (_) {}

    // 2. Fetch Appointments for Doctor
    final appointments = await AppointmentTable().queryRows(
      queryFn: (q) => q.eq('doctor_id', currentUserUid),
    );

    final apptIds = appointments.map((a) => a.appointmentId).whereType<String>().toList();

    // 3. Fetch Procedures for mapping
    final procIds = appointments.map((a) => a.procedureId).whereType<String>().toSet().toList();
    final procedures = procIds.isEmpty ? <ProcedureRow>[] : await ProcedureTable().queryRows(
      queryFn: (q) => q.inFilter('procedure_id', procIds),
    );
    final procMap = {for (var p in procedures) if (p.procedureId != null) p.procedureId!: p};

    // 4. Fetch Payments
    final payments = apptIds.isEmpty ? <PaymentsRow>[] : await PaymentsTable().queryRows(
      queryFn: (q) => q.inFilter('appointment_id', apptIds),
    );

    // Calculate totals
    int totalRevenue = 0;
    int collected = 0;
    int pending = 0;
    int overdue = 0;

    if (payments.isNotEmpty) {
      for (var p in payments) {
        final amt = p.amount ?? 0;
        totalRevenue += amt;
        final status = p.status?.toLowerCase() ?? 'pending';
        if (status == 'paid' || status == 'success' || status == 'completed') {
          collected += amt;
        } else if (status == 'pending') {
          pending += amt;
        } else {
          overdue += amt;
        }
      }
    } else {
      // Fallback: estimate revenue based on completed appointments
      for (var appt in appointments) {
        final proc = procMap[appt.procedureId];
        final price = proc?.pricing ?? 0;
        if (appt.status?.toLowerCase() == 'completed') {
          totalRevenue += price;
          collected += price;
        } else if (appt.status?.toLowerCase() == 'pending') {
          pending += price;
        }
      }
    }

    // 5. Group Revenue by Procedure/Service
    final Map<String, int> breakdown = {};
    for (var appt in appointments) {
      if (appt.status?.toLowerCase() == 'completed') {
        final proc = procMap[appt.procedureId];
        if (proc != null) {
          final name = proc.procedureName;
          breakdown[name] = (breakdown[name] ?? 0) + (proc.pricing ?? 0);
        }
      }
    }

    // Sort and convert to list of Map Entry
    final sortedBreakdown = breakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Unique Patients
    final uniquePatients = appointments.map((a) => a.patientId).whereType<String>().toSet().length;

    // Today's appointments count
    final todayStr = dateTimeFormat('yyyy-MM-dd', DateTime.now());
    final todayAppts = appointments.where((a) => dateTimeFormat('yyyy-MM-dd', a.appointmentDate) == todayStr).length;

    return {
      'doctorName': doctorName,
      'totalRevenue': totalRevenue,
      'collected': collected,
      'pending': pending,
      'overdue': overdue,
      'breakdown': sortedBreakdown,
      'totalPatients': uniquePatients,
      'totalAppointments': appointments.length,
      'todayAppointments': todayAppts,
    };
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 22.0,
            borderWidth: 0.0,
            buttonSize: 44.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Text(
            'DentaMetrics Analytics',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: GoogleFonts.interTight().fontFamily,
                  color: FlutterFlowTheme.of(context).primaryText,
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
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'DentaMetrics Analytics',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily: GoogleFonts.interTight().fontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      content: Text(
                        'Analyze clinic performance metrics, including procedure fulfillment rates, common treatments, and peak hours.',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
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
          child: FutureBuilder<Map<String, dynamic>>(
            future: _analyticsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error loading analytics: ${snapshot.error}'));
              }
              final data = snapshot.data ?? {};
              final doctorName = data['doctorName'] as String;
              final totalRevenue = data['totalRevenue'] as int;
              final collected = data['collected'] as int;
              final pending = data['pending'] as int;
              final overdue = data['overdue'] as int;
              final breakdownList = data['breakdown'] as List<MapEntry<String, int>>;
              final totalPatients = data['totalPatients'] as int;
              final totalAppointments = data['totalAppointments'] as int;
              final todayAppointments = data['todayAppointments'] as int;

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, Dr. $doctorName 👋',
                                style: FlutterFlowTheme.of(context).headlineMedium.override(
                                      font: GoogleFonts.interTight(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  "Here's your overview",
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                        font: GoogleFonts.inter(),
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).accent1,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 14.0,
                                  ),
                                  const SizedBox(width: 6.0),
                                  Text(
                                    dateTimeFormat('MMM y', DateTime.now()),
                                    style: FlutterFlowTheme.of(context).labelSmall.override(
                                          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                          color: FlutterFlowTheme.of(context).primary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Total Revenue Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 16.0,
                              color: Color(0x331565C0),
                              offset: Offset(0.0, 6.0),
                            )
                          ],
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(1.0, 1.0),
                            end: AlignmentDirectional(-1.0, -1.0),
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Revenue',
                                        style: FlutterFlowTheme.of(context).labelMedium.override(
                                              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                                              color: const Color(0xB3FFFFFF),
                                            ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          '\$$totalRevenue',
                                          style: FlutterFlowTheme.of(context).displaySmall.override(
                                                font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 52.0,
                                    height: 52.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0x33FFFFFF),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: const Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Icon(
                                        Icons.account_balance_wallet_outlined,
                                        color: Colors.white,
                                        size: 26.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 24.0,
                                thickness: 1.0,
                                color: Color(0x33FFFFFF),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Collected',
                                        style: FlutterFlowTheme.of(context).labelSmall.override(
                                              font: GoogleFonts.inter(),
                                              color: const Color(0xB3FFFFFF),
                                            ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          '\$$collected',
                                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                                font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Pending',
                                        style: FlutterFlowTheme.of(context).labelSmall.override(
                                              font: GoogleFonts.inter(),
                                              color: const Color(0xB3FFFFFF),
                                            ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          '\$$pending',
                                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                                font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                                color: const Color(0xFFFEF08A),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Overdue',
                                        style: FlutterFlowTheme.of(context).labelSmall.override(
                                              font: GoogleFonts.inter(),
                                              color: const Color(0xB3FFFFFF),
                                            ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          '\$$overdue',
                                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                                font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                                color: const Color(0xFFFF8A80),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Revenue Breakdown Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 8.0,
                              color: Color(0x0D000000),
                              offset: Offset(0.0, 2.0),
                            )
                          ],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Revenue Breakdown',
                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                      font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                    ),
                              ),
                              const SizedBox(height: 16.0),
                              if (breakdownList.isEmpty)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                    child: Text(
                                      'No revenue recorded yet.',
                                      style: FlutterFlowTheme.of(context).labelMedium,
                                    ),
                                  ),
                                )
                              else
                                Column(
                                  children: breakdownList.take(4).map((entry) {
                                    final percentage = totalRevenue > 0 ? entry.value / totalRevenue : 0.0;
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 14.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 10.0,
                                                    height: 10.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).primary,
                                                      borderRadius: BorderRadius.circular(5.0),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8.0),
                                                  Text(
                                                    entry.key,
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '\$${entry.value}',
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6.0),
                                          LinearPercentIndicator(
                                            percent: percentage,
                                            lineHeight: 8.0,
                                            animation: true,
                                            animateFromLastPercent: true,
                                            progressColor: FlutterFlowTheme.of(context).primary,
                                            backgroundColor: FlutterFlowTheme.of(context).accent1,
                                            barRadius: const Radius.circular(8.0),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Summary Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                await context.pushNamed(
                                    DentistTotalPatientHistoryFocusWidget.routeName);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 8.0,
                                      color: Color(0x0D000000),
                                      offset: Offset(0.0, 2.0),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 36.0,
                                            height: 36.0,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).accent1,
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            child: Align(
                                              alignment: const AlignmentDirectional(0.0, 0.0),
                                              child: Icon(
                                                Icons.people_outline,
                                                color: FlutterFlowTheme.of(context).primary,
                                                size: 18.0,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            size: 14.0,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          '$totalPatients',
                                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                              ),
                                        ),
                                      ),
                                      Text(
                                        'Total Patients',
                                        style: FlutterFlowTheme.of(context).labelSmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                await context.pushNamed(PAppointmentsWidget.routeName);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 8.0,
                                      color: Color(0x0D000000),
                                      offset: Offset(0.0, 2.0),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 36.0,
                                            height: 36.0,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFFFF3E0),
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            ),
                                            child: const Align(
                                              alignment: AlignmentDirectional(0.0, 0.0),
                                              child: Icon(
                                                Icons.event_available_outlined,
                                                color: Color(0xFFEF6C00),
                                                size: 18.0,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            size: 14.0,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          '$totalAppointments',
                                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                              ),
                                        ),
                                      ),
                                      Text(
                                        'Appointments',
                                        style: FlutterFlowTheme.of(context).labelSmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32.0),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
