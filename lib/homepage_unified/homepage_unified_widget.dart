import '/components/c_delete_confirmation/c_delete_confirmation_widget.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/patient/a_i_chat_bot/a_i_chat_bot_widget.dart';
import '/navbars/admin_nav_bar/admin_nav_bar_widget.dart';
import '/navbars/dentist_nav_bar/dentist_nav_bar_widget.dart';
import '/navbars/patient_nav_bar/patient_nav_bar_widget.dart';
import '/navbars/unified_nav_bar/unified_nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'dart:ui';
import 'dart:math' as math;
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'homepage_unified_model.dart';
export 'homepage_unified_model.dart';

class HomepageUnifiedWidget extends StatefulWidget {
  final int? initialTabIndex;

  const HomepageUnifiedWidget({
    super.key,
    this.initialTabIndex,
  });

  static String routeName = 'Homepage_Unified';
  static String routePath = '/homepageUnified';

  @override
  State<HomepageUnifiedWidget> createState() => _HomepageUnifiedWidgetState();
}

class _HomepageUnifiedWidgetState extends State<HomepageUnifiedWidget> {
  late HomepageUnifiedModel _model;
  bool _isIndexInitialized = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Patient Medical Records state
  TextEditingController? _allergiesController;
  TextEditingController? _conditionsController;
  TextEditingController? _bloodTypeController;
  TextEditingController? _contactNameController;
  TextEditingController? _contactPhoneController;
  bool _isEditingMedical = false;
  bool _showMedicalRecords = false;
  String _dentistDateFilter = 'This Month';
  String _revenueBreakdownMode = 'Service';

  void _initMedicalControllers(PatientRow row) {
    _allergiesController ??= TextEditingController(text: row.allergies ?? '');
    _conditionsController ??= TextEditingController(text: row.medicalConditions ?? '');
    _bloodTypeController ??= TextEditingController(text: row.bloodType ?? '');
    _contactNameController ??= TextEditingController(text: row.emergencyContactName ?? '');
    _contactPhoneController ??= TextEditingController(text: row.emergencyContactPhone ?? '');
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomepageUnifiedModel());
  }

  @override
  void dispose() {
    _model.dispose();
    _allergiesController?.dispose();
    _conditionsController?.dispose();
    _bloodTypeController?.dispose();
    _contactNameController?.dispose();
    _contactPhoneController?.dispose();
    super.dispose();
  }

  String generateUUID() {
    final r = DateTime.now().microsecondsSinceEpoch;
    String hex(int val, int len) => val.toRadixString(16).padLeft(len, '0');
    return '${hex(r & 0xFFFFFFFF, 8)}-${hex((r >> 32) & 0xFFFF, 4)}-4${hex((r >> 48) & 0xFFF, 3)}-8${hex((r >> 56) & 0xFFF, 3)}-${hex(r & 0xFFFFFFFFFFFF, 12)}';
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AIChatBotWidget()),
    ).then((value) => safeSetState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserRow>>(
      future: UserTable().querySingleRow(
        queryFn: (q) => q.eqOrNull(
          'user_id',
          currentUserUid,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<UserRow> homepageUnifiedUserRowList = snapshot.data!;

        final homepageUnifiedUserRow = homepageUnifiedUserRowList.isNotEmpty
            ? homepageUnifiedUserRowList.first
            : null;

        if (!_isIndexInitialized) {
          _isIndexInitialized = true;
          if (widget.initialTabIndex != null) {
            _model.selectedIndex = widget.initialTabIndex!;
          } else {
            final userRole = homepageUnifiedUserRow?.userType;
            if (userRole == 'Admin' || userRole == 'Dentist') {
              _model.selectedIndex = 1; // Workflow
            } else {
              _model.selectedIndex = 0; // Home
            }
          }
        }

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
              title: Text(
                _model.selectedIndex == 0
                    ? 'Home'
                    : (_model.selectedIndex == 1
                        ? (homepageUnifiedUserRow?.userType == 'Admin'
                            ? 'Admin Dashboard'
                            : (homepageUnifiedUserRow?.userType == 'Dentist'
                                ? 'Dentist Dashboard'
                                : 'Patient Dashboard'))
                        : (_model.selectedIndex == 2
                            ? 'Notifications'
                            : 'My Profile')),
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
                      final String infoText = _model.selectedIndex == 0
                          ? 'Welcome to Toothy Clinic! This is your Home tab showing your profile details and clinic hours.'
                          : (_model.selectedIndex == 1
                              ? 'This is your Workflow tab containing your dashboard events, quick links, and active management tasks.'
                              : (_model.selectedIndex == 2
                                  ? 'This is your Notifications tab. Tapping an item marks it as read.'
                                  : 'This is your Profile tab. You can update details, change password, or log out.'));
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            'About this Tab',
                            style: FlutterFlowTheme.of(context).titleLarge.override(
                                  fontFamily: GoogleFonts.interTight().fontFamily,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          content: Text(
                            infoText,
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
            bottomNavigationBar: UnifiedNavBarWidget(
              selectedIndex: _model.selectedIndex,
              onTap: (index) {
                safeSetState(() {
                  _model.selectedIndex = index;
                });
              },
            ),
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (_model.selectedIndex == 1) ...[
                      if (homepageUnifiedUserRow?.userType == 'Admin')
                      FutureBuilder<List<dynamic>>(
                        future: Future.wait([
                          LeaveRequestTable().queryRows(queryFn: (q) => q.order('created_at', ascending: false)),
                          UserTable().queryRows(queryFn: (q) => q),
                          DentistTable().queryRows(queryFn: (q) => q),
                          PatientTable().queryRows(queryFn: (q) => q),
                          ProcedureTable().queryRows(queryFn: (q) => q),
                          actions.getMonthlyRevenueMetrics(filterType: '6M'),
                          AppointmentTable().queryRows(queryFn: (q) => q),
                          PaymentsTable().queryRows(queryFn: (q) => q.eq('status', 'Paid')),
                        ]),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ),
                            );
                          }
                          final leaves = snapshot.data![0] as List<LeaveRequestRow>;
                          final users = snapshot.data![1] as List<UserRow>;
                          final dentists = snapshot.data![2] as List<DentistRow>;
                          final patients = snapshot.data![3] as List<PatientRow>;
                          final procedures = snapshot.data![4] as List<ProcedureRow>;
                          final revenue6M = snapshot.data![5] as List<dynamic>;
                          final appointments = snapshot.data![6] as List<AppointmentRow>;
                          final payments = snapshot.data![7] as List<PaymentsRow>;

                          final userMap = {for (var u in users) if (u.userId != null) u.userId!: u};
                          final pendingLeaves = leaves.where((l) => l.status == 'Pending').toList();
                          final otherLeaves = leaves.where((l) => l.status != 'Pending').toList();
                          final pendingDentistApps = dentists.where((d) => d.status == 'Pending').length;

                          final now = DateTime.now();
                          final currentMonthPayments = payments.where((p) => p.createdAt != null && p.createdAt!.year == now.year && p.createdAt!.month == now.month);
                          final monthlyRevenue = currentMonthPayments.fold<int>(0, (sum, p) => sum + (p.amount ?? 0));
                          final totalAppointmentsCount = appointments.length;
                          final completedAppointmentsCount = appointments.where((a) => a.status == 'Completed').length;
                          final fulfillmentRate = appointments.isEmpty ? 0.0 : (completedAppointmentsCount / totalAppointmentsCount) * 100.0;

                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // 1. Metric Cards Row 1 (Total Appointments & Monthly Revenue)
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: InkWell(
                                          onTap: () async {
                                            context.pushNamed(AdminTotalPatientHistoryFocusWidget.routeName);
                                          },
                                          child: Container(
                                            width: 100.0,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 12.0,
                                                  color: const Color(0x334F46E5),
                                                  offset: const Offset(0.0, 4.0),
                                                )
                                              ],
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                                                stops: [0.0, 1.0],
                                                begin: AlignmentDirectional(1.0, 1.0),
                                                end: AlignmentDirectional(-1.0, -1.0),
                                              ),
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 36.0,
                                                        height: 36.0,
                                                        decoration: BoxDecoration(
                                                          color: const Color(0x33FFFFFF),
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        child: const Align(
                                                          alignment: AlignmentDirectional(0.0, 0.0),
                                                          child: Icon(
                                                            Icons.calendar_today_rounded,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: const AlignmentDirectional(1.0, -1.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: const Color(0x33FFFFFF),
                                                            borderRadius: BorderRadius.circular(12.0),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                const Icon(
                                                                  Icons.arrow_upward_rounded,
                                                                  color: Colors.white,
                                                                  size: 14.0,
                                                                ),
                                                                Text(
                                                                  '+12%',
                                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                        fontFamily: GoogleFonts.inter().fontFamily,
                                                                        color: Colors.white,
                                                                        fontSize: 11.0,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    formatNumber(
                                                      totalAppointmentsCount,
                                                      formatType: FormatType.compact,
                                                    ),
                                                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                          fontFamily: GoogleFonts.interTight().fontFamily,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                  Text(
                                                    'Total Appointments',
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          fontFamily: GoogleFonts.inter().fontFamily,
                                                          color: const Color(0xCCFFFFFF),
                                                          fontSize: 11.0,
                                                        ),
                                                  ),
                                                ].divide(const SizedBox(height: 8.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: InkWell(
                                          onTap: () async {
                                            context.pushNamed(PRevenueViewWidget.routeName);
                                          },
                                          child: Container(
                                            width: 100.0,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 12.0,
                                                  color: const Color(0x3310B981),
                                                  offset: const Offset(0.0, 4.0),
                                                )
                                              ],
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFF10B981), Color(0xFF059669)],
                                                stops: [0.0, 1.0],
                                                begin: AlignmentDirectional(1.0, 1.0),
                                                end: AlignmentDirectional(-1.0, -1.0),
                                              ),
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 36.0,
                                                        height: 36.0,
                                                        decoration: BoxDecoration(
                                                          color: const Color(0x33FFFFFF),
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        child: const Align(
                                                          alignment: AlignmentDirectional(0.0, 0.0),
                                                          child: Icon(
                                                            Icons.attach_money_rounded,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: const AlignmentDirectional(1.0, -1.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: const Color(0x33FFFFFF),
                                                            borderRadius: BorderRadius.circular(12.0),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                const Icon(
                                                                  Icons.arrow_upward_rounded,
                                                                  color: Colors.white,
                                                                  size: 14.0,
                                                                ),
                                                                Text(
                                                                  '+8%',
                                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                        fontFamily: GoogleFonts.inter().fontFamily,
                                                                        color: Colors.white,
                                                                        fontSize: 11.0,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    monthlyRevenue < 1000
                                                        ? '\$$monthlyRevenue'
                                                        : '\$${(monthlyRevenue / 1000.0).toStringAsFixed(1)}K',
                                                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                          fontFamily: GoogleFonts.interTight().fontFamily,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                  Text(
                                                    'Monthly Revenue',
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          fontFamily: GoogleFonts.inter().fontFamily,
                                                          color: const Color(0xCCFFFFFF),
                                                          fontSize: 11.0,
                                                        ),
                                                  ),
                                                ].divide(const SizedBox(height: 8.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ].divide(const SizedBox(width: 12.0)),
                                ),
                              ),
                              // 2. Metric Cards Row 2 (Patients & Fulfillment Rate)
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: InkWell(
                                          onTap: () async {
                                            context.pushNamed(PPatientManagementWidget.routeName);
                                          },
                                          child: Container(
                                            width: 100.0,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 12.0,
                                                  color: const Color(0x33F59E0B),
                                                  offset: const Offset(0.0, 4.0),
                                                )
                                              ],
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                                                stops: [0.0, 1.0],
                                                begin: AlignmentDirectional(1.0, 1.0),
                                                end: AlignmentDirectional(-1.0, -1.0),
                                              ),
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 36.0,
                                                        height: 36.0,
                                                        decoration: BoxDecoration(
                                                          color: const Color(0x33FFFFFF),
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        child: const Align(
                                                          alignment: AlignmentDirectional(0.0, 0.0),
                                                          child: Icon(
                                                            Icons.people_alt_rounded,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: const AlignmentDirectional(1.0, -1.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: const Color(0x33FFFFFF),
                                                            borderRadius: BorderRadius.circular(12.0),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                const Icon(
                                                                  Icons.arrow_upward_rounded,
                                                                  color: Colors.white,
                                                                  size: 14.0,
                                                                ),
                                                                Text(
                                                                  '+24%',
                                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                        fontFamily: GoogleFonts.inter().fontFamily,
                                                                        color: Colors.white,
                                                                        fontSize: 11.0,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    formatNumber(
                                                      patients.length,
                                                      formatType: FormatType.compact,
                                                    ),
                                                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                          fontFamily: GoogleFonts.interTight().fontFamily,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                  Text(
                                                    'Patients',
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          fontFamily: GoogleFonts.inter().fontFamily,
                                                          color: const Color(0xCCFFFFFF),
                                                          fontSize: 11.0,
                                                        ),
                                                  ),
                                                ].divide(const SizedBox(height: 8.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: InkWell(
                                          onTap: () async {
                                            context.pushNamed(AdminFulfillmentRateFocusWidget.routeName);
                                          },
                                          child: Container(
                                            width: 100.0,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 12.0,
                                                  color: const Color(0x33EF4444),
                                                  offset: const Offset(0.0, 4.0),
                                                )
                                              ],
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                                                stops: [0.0, 1.0],
                                                begin: AlignmentDirectional(1.0, 1.0),
                                                end: AlignmentDirectional(-1.0, -1.0),
                                              ),
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 36.0,
                                                        height: 36.0,
                                                        decoration: BoxDecoration(
                                                          color: const Color(0x33FFFFFF),
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        child: const Align(
                                                          alignment: AlignmentDirectional(0.0, 0.0),
                                                          child: Icon(
                                                            Icons.trending_up_rounded,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: const AlignmentDirectional(1.0, -1.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: const Color(0x33FFFFFF),
                                                            borderRadius: BorderRadius.circular(12.0),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                const Icon(
                                                                  Icons.arrow_upward_rounded,
                                                                  color: Colors.white,
                                                                  size: 14.0,
                                                                ),
                                                                Text(
                                                                  '+3%',
                                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                        fontFamily: GoogleFonts.inter().fontFamily,
                                                                        color: Colors.white,
                                                                        fontSize: 11.0,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    '${fulfillmentRate.toStringAsFixed(1)}%',
                                                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                          fontFamily: GoogleFonts.interTight().fontFamily,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                  Text(
                                                    'Fulfillment Rate',
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          fontFamily: GoogleFonts.inter().fontFamily,
                                                          color: const Color(0xCCFFFFFF),
                                                          fontSize: 11.0,
                                                        ),
                                                  ),
                                                ].divide(const SizedBox(height: 8.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ].divide(const SizedBox(width: 12.0)),
                                ),
                              ),
                              // 3. Revenue Overview Chart Section
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).alternate,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Revenue Overview',
                                                  style: FlutterFlowTheme.of(context).titleMedium.override(
                                                        fontFamily: GoogleFonts.interTight().fontFamily,
                                                        fontWeight: FontWeight.bold,
                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                      ),
                                                ),
                                                Text(
                                                  'Last 6 months performance',
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: GoogleFonts.inter().fontFamily,
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                        fontSize: 11.0,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: 30.0,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF0F2F5),
                                                borderRadius: BorderRadius.circular(20.0),
                                              ),
                                              child: Align(
                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                child: Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                                  child: Text(
                                                    now.year.toString(),
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          fontFamily: GoogleFonts.inter().fontFamily,
                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                          fontSize: 12.0,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Builder(
                                          builder: (context) {
                                            final maxRevVal = revenue6M.isEmpty
                                                ? 150000.0
                                                : revenue6M.map<double>((e) => math.max((e['current_revenue'] as num).toDouble(), (e['target_revenue'] as num).toDouble())).reduce(math.max);
                                            final double capHeight = 120.0;
                                            return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: revenue6M.map<Widget>((item) {
                                                final month = item['month'] as String? ?? '';
                                                final currentRevenue = (item['current_revenue'] as num? ?? 0).toDouble();
                                                final targetRevenue = (item['target_revenue'] as num? ?? 0).toDouble();
                                                
                                                final currentHeight = maxRevVal > 0 ? (currentRevenue / maxRevVal) * capHeight : 0.0;
                                                final targetHeight = maxRevVal > 0 ? (targetRevenue / maxRevVal) * capHeight : 0.0;
                                                
                                                return Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      month,
                                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: GoogleFonts.inter().fontFamily,
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                        fontSize: 11.0,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        Container(
                                                          width: 28.0,
                                                          height: math.max(currentHeight, 4.0),
                                                          decoration: BoxDecoration(
                                                            gradient: const LinearGradient(
                                                              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                                                              stops: [0.0, 1.0],
                                                              begin: AlignmentDirectional(0.0, -1.0),
                                                              end: AlignmentDirectional(0, 1.0),
                                                            ),
                                                            borderRadius: BorderRadius.circular(6.0),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 28.0,
                                                          height: math.max(targetHeight, 4.0),
                                                          decoration: BoxDecoration(
                                                            color: const Color(0xFFF0F2F5),
                                                            borderRadius: BorderRadius.circular(6.0),
                                                          ),
                                                        ),
                                                      ].divide(const SizedBox(width: 4.0)),
                                                    ),
                                                  ].divide(const SizedBox(height: 4.0)),
                                                );
                                              }).toList().divide(const SizedBox(width: 8.0)),
                                            );
                                          },
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 10.0,
                                                  height: 10.0,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF4F46E5),
                                                    borderRadius: BorderRadius.circular(2.0),
                                                  ),
                                                ),
                                                Text(
                                                  'Revenue',
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: GoogleFonts.inter().fontFamily,
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                      ),
                                                ),
                                              ].divide(const SizedBox(width: 4.0)),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 10.0,
                                                  height: 10.0,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFF0F2F5),
                                                    borderRadius: BorderRadius.circular(2.0),
                                                  ),
                                                ),
                                                Text(
                                                  'Target',
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: GoogleFonts.inter().fontFamily,
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                      ),
                                                ),
                                              ].divide(const SizedBox(width: 4.0)),
                                            ),
                                          ].divide(const SizedBox(width: 16.0)),
                                        ),
                                      ].divide(const SizedBox(height: 20.0)),
                                    ),
                                  ),
                                ),
                              ),
                              // 4. Workflow Control GridView
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Workflow Control',
                                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                                            fontFamily: GoogleFonts.interTight().fontFamily,
                                            fontWeight: FontWeight.bold,
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            fontSize: 20.0,
                                          ),
                                    ),
                                    Text(
                                      'Quick shortcuts to manage clinic data and users',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: GoogleFonts.inter().fontFamily,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                    ),
                                    const SizedBox(height: 12.0),
                                    GridView(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12.0,
                                        mainAxisSpacing: 12.0,
                                        childAspectRatio: 1.5,
                                      ),
                                      children: [
                                        _buildWorkflowCard(
                                          title: 'Dentist Requests',
                                          count: pendingDentistApps,
                                          icon: Icons.assignment_ind_rounded,
                                          color: const Color(0xFFF97316),
                                          bgColor: const Color(0xFFFFF7ED),
                                          onTap: () => context.pushNamed(PAdminDentistRequestsWidget.routeName),
                                        ),
                                        _buildWorkflowCard(
                                          title: 'User Roles',
                                          count: users.length,
                                          icon: Icons.people_alt_rounded,
                                          color: const Color(0xFF3B82F6),
                                          bgColor: const Color(0xFFEFF6FF),
                                          onTap: () => context.pushNamed(PUserManagementWidget.routeName),
                                        ),
                                        _buildWorkflowCard(
                                          title: 'Patients Directory',
                                          count: patients.length,
                                          icon: Icons.folder_shared_rounded,
                                          color: const Color(0xFF10B981),
                                          bgColor: const Color(0xFFECFDF5),
                                          onTap: () => context.pushNamed(PPatientManagementWidget.routeName),
                                        ),
                                        _buildWorkflowCard(
                                          title: 'Dentist Directory',
                                          count: dentists.length,
                                          icon: Icons.supervised_user_circle_rounded,
                                          color: const Color(0xFF0F766E),
                                          bgColor: const Color(0xFFF0FDFA),
                                          onTap: () => context.pushNamed(PDentistManagementWidget.routeName),
                                        ),
                                        _buildWorkflowCard(
                                          title: 'Procedures',
                                          count: procedures.length,
                                          icon: Icons.medical_services_rounded,
                                          color: const Color(0xFF8B5CF6),
                                          bgColor: const Color(0xFFF5F3FF),
                                          onTap: () => context.pushNamed(PProceduresViewAdminWidget.routeName),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // 5. Dentist Leave Approvals Section
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                child: InkWell(
                                  onTap: () async {
                                    context.pushNamed(PAdminLeaveApprovalsWidget.routeName);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                      borderRadius: BorderRadius.circular(16.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context).alternate,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Dentist Leave Approvals',
                                                  style: FlutterFlowTheme.of(context).titleMedium.override(
                                                        fontFamily: GoogleFonts.interTight().fontFamily,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                ),
                                                const SizedBox(height: 4.0),
                                                Text(
                                                  'Review, approve, or reject vacation and leave requests submitted by doctors.',
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: GoogleFonts.inter().fontFamily,
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 16.0),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10.0,
                                                  vertical: 6.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: pendingLeaves.isNotEmpty
                                                      ? const Color(0xFFFFF7ED)
                                                      : FlutterFlowTheme.of(context).accent1,
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                child: Text(
                                                  '${pendingLeaves.length} Pending',
                                                  style: TextStyle(
                                                    color: pendingLeaves.isNotEmpty
                                                        ? const Color(0xFFF59E0B)
                                                        : FlutterFlowTheme.of(context).primary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              Icon(
                                                Icons.chevron_right_rounded,
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                size: 24.0,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ].divide(const SizedBox(height: 24.0)),
                          );
                        },
                      ),
                    if (homepageUnifiedUserRow?.userType == 'Dentist')
                      FutureBuilder<List<dynamic>>(
                        future: Future.wait([
                          AppointmentTable().queryRows(
                            queryFn: (q) => q.eq('doctor_id', currentUserUid),
                          ),
                          HistoryTable().queryRows(
                            queryFn: (q) => q.eq('dentist_id', currentUserUid),
                          ),
                          PaymentsTable().queryRows(queryFn: (q) => q),
                          ProcedureTable().queryRows(queryFn: (q) => q),
                          LeaveRequestTable().queryRows(
                            queryFn: (q) => q.eq('dentist_id', currentUserUid),
                          ),
                        ]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text('Error loading dashboard: ${snapshot.error}'),
                              ),
                            );
                          }
                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          try {
                          final appointments = snapshot.data![0] as List<AppointmentRow>;
                          final histories = snapshot.data![1] as List<HistoryRow>;
                          final allPayments = snapshot.data![2] as List<PaymentsRow>;
                          final procedures = snapshot.data![3] as List<ProcedureRow>;
                          final leaves = snapshot.data![4] as List<LeaveRequestRow>;

                          // Check if currently on approved leave
                          final now = DateTime.now();
                          final today = DateTime(now.year, now.month, now.day);
                          LeaveRequestRow? approvedLeave;
                          for (var l in leaves) {
                            if (l.status == 'Approved') {
                              final start = DateTime(l.startDate.year, l.startDate.month, l.startDate.day);
                              final end = DateTime(l.endDate.year, l.endDate.month, l.endDate.day);
                              if (!today.isBefore(start) && !today.isAfter(end)) {
                                approvedLeave = l;
                                break;
                              }
                            }
                          }

                          final procMap = {for (var p in procedures) if (p.procedureId != null) p.procedureId!: p};

                          // Filter records by _dentistDateFilter
                          final filteredAppts = appointments.where((a) {
                            if (_dentistDateFilter == 'Overall') return true;
                            final date = a.appointmentDate;
                            if (_dentistDateFilter == 'This Month') {
                              return date.year == now.year && date.month == now.month;
                            } else {
                              final prevMonth = now.month == 1 ? 12 : now.month - 1;
                              final prevYear = now.month == 1 ? now.year - 1 : now.year;
                              return date.year == prevYear && date.month == prevMonth;
                            }
                          }).toList();

                          final apptIds = appointments.map((a) => a.appointmentId).whereType<String>().toList();
                          final dentistPayments = allPayments.where((p) => apptIds.contains(p.appointmentId)).toList();

                          final filteredPayments = dentistPayments.where((p) {
                            if (_dentistDateFilter == 'Overall') return true;
                            final date = p.createdAt;
                            if (date == null) return false;
                            if (_dentistDateFilter == 'This Month') {
                              return date.year == now.year && date.month == now.month;
                            } else {
                              final prevMonth = now.month == 1 ? 12 : now.month - 1;
                              final prevYear = now.month == 1 ? now.year - 1 : now.year;
                              return date.year == prevYear && date.month == prevMonth;
                            }
                          }).toList();

                          // Calculate Revenue
                          int totalRevenue = 0;
                          int collected = 0;
                          int pending = 0;
                          int overdue = 0;

                          if (filteredPayments.isNotEmpty) {
                            for (var p in filteredPayments) {
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
                            // Fallback estimation using completed appointments
                            for (var appt in filteredAppts) {
                              final proc = procMap[appt.procedureId];
                              final price = proc?.pricing ?? 0;
                              final status = appt.status?.toLowerCase() ?? 'pending';
                              if (status == 'completed' || status == 'accepted' || status == 'approved') {
                                totalRevenue += price;
                                collected += price;
                              } else if (status == 'pending') {
                                pending += price;
                              }
                            }
                          }

                          // Patient & Appointment Counts
                          final uniquePatients = filteredAppts.map((a) => a.patientId).whereType<String>().toSet().length;
                          final totalFilteredAppts = filteredAppts.length;

                          // Revenue Breakdown mapping
                          final Map<String, int> breakdownMap = {};
                          for (var appt in filteredAppts) {
                            final proc = procMap[appt.procedureId];
                            if (proc == null) continue;
                            final key = _revenueBreakdownMode == 'Category' ? (proc.category ?? 'Other') : (proc.procedureName);
                            final price = proc.pricing ?? 0;
                            breakdownMap[key] = (breakdownMap[key] ?? 0) + price;
                          }

                          final sortedBreakdown = breakdownMap.entries.toList()
                            ..sort((a, b) => b.value.compareTo(a.value));
                          final topBreakdowns = sortedBreakdown.take(3).toList();
                          final int totalBreakdownSum = breakdownMap.values.fold(0, (sum, val) => sum + val);

                          final rawGreetingName = homepageUnifiedUserRow?.fullname ?? 'Smith';
                          final cleanGreetingName = rawGreetingName.toLowerCase().startsWith('dr.')
                              ? rawGreetingName.substring(3).trim()
                              : rawGreetingName;

                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 1. Greeting
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Hello, Dr. $cleanGreetingName 👋',
                                          style: FlutterFlowTheme.of(context).headlineMedium.override(
                                            fontFamily: GoogleFonts.interTight().fontFamily,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Here\'s your dashboard overview',
                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                            fontFamily: GoogleFonts.inter().fontFamily,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                                      decoration: BoxDecoration(
                                        color: approvedLeave != null ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5),
                                        borderRadius: BorderRadius.circular(20.0),
                                        border: Border.all(
                                          color: approvedLeave != null ? const Color(0xFFFCA5A5) : const Color(0xFF6EE7B7),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 8.0,
                                            height: 8.0,
                                            decoration: BoxDecoration(
                                              color: approvedLeave != null ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6.0),
                                          Text(
                                            approvedLeave != null ? 'On Leave' : 'Active',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: GoogleFonts.inter().fontFamily,
                                              color: approvedLeave != null ? const Color(0xFF991B1B) : const Color(0xFF065F46),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              if (approvedLeave != null)
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFFBEB),
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(color: const Color(0xFFFDE68A)),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.info_outline_rounded, color: Color(0xFFD97706), size: 20.0),
                                        const SizedBox(width: 8.0),
                                        Expanded(
                                          child: Text(
                                            'Approved Leave: ${DateFormat('MMM dd').format(approvedLeave.startDate)} - ${DateFormat('MMM dd, yyyy').format(approvedLeave.endDate)}',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: GoogleFonts.inter().fontFamily,
                                              color: const Color(0xFF92400E),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              // 2. Date filters Choice Chips
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                                child: Row(
                                  children: ['This Month', 'Last Month', 'Overall'].map((filterName) {
                                    final isSelected = _dentistDateFilter == filterName;
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _dentistDateFilter = filterName;
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(20.0),
                                        child: Container(
                                          height: 36.0,
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? FlutterFlowTheme.of(context).primary
                                                : FlutterFlowTheme.of(context).secondaryBackground,
                                            borderRadius: BorderRadius.circular(20.0),
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.transparent
                                                  : FlutterFlowTheme.of(context).alternate,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              filterName,
                                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                                fontFamily: GoogleFonts.inter().fontFamily,
                                                color: isSelected ? Colors.white : FlutterFlowTheme.of(context).secondaryText,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                              // 3. Quick Actions Redirects
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Quick Actions',
                                      style: FlutterFlowTheme.of(context).titleMedium.override(
                                        fontFamily: GoogleFonts.interTight().fontFamily,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => context.pushNamed(PScheduleDentistWidget.routeName),
                                            child: Container(
                                              padding: const EdgeInsets.all(12.0),
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                borderRadius: BorderRadius.circular(12.0),
                                                border: Border.all(color: FlutterFlowTheme.of(context).alternate),
                                              ),
                                              child: Column(
                                                children: [
                                                  const Icon(Icons.calendar_month_rounded, color: Color(0xFF1565C0), size: 24.0),
                                                  const SizedBox(height: 6.0),
                                                  Text(
                                                    'Schedules & Leaves',
                                                    textAlign: TextAlign.center,
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                      fontFamily: GoogleFonts.inter().fontFamily,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12.0),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => context.pushNamed(TreatmentRecordsWidget.routeName),
                                            child: Container(
                                              padding: const EdgeInsets.all(12.0),
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                borderRadius: BorderRadius.circular(12.0),
                                                border: Border.all(color: FlutterFlowTheme.of(context).alternate),
                                              ),
                                              child: Column(
                                                children: [
                                                  const Icon(Icons.edit_note_rounded, color: Color(0xFF00695C), size: 24.0),
                                                  const SizedBox(height: 6.0),
                                                  Text(
                                                    'Treatment Entry',
                                                    textAlign: TextAlign.center,
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                      fontFamily: GoogleFonts.inter().fontFamily,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12.0),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => context.pushNamed(DentistFulfillmentFocusWidget.routeName),
                                            child: Container(
                                              padding: const EdgeInsets.all(12.0),
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                borderRadius: BorderRadius.circular(12.0),
                                                border: Border.all(color: FlutterFlowTheme.of(context).alternate),
                                              ),
                                              child: Column(
                                                children: [
                                                  const Icon(Icons.trending_up_rounded, color: Color(0xFFC62828), size: 24.0),
                                                  const SizedBox(height: 6.0),
                                                  Text(
                                                    'Fulfillment Rate',
                                                    textAlign: TextAlign.center,
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                      fontFamily: GoogleFonts.inter().fontFamily,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12.0),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => context.pushNamed(DentistAnalyticsFocusWidget.routeName),
                                            child: Container(
                                              padding: const EdgeInsets.all(12.0),
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                borderRadius: BorderRadius.circular(12.0),
                                                border: Border.all(color: FlutterFlowTheme.of(context).alternate),
                                              ),
                                              child: Column(
                                                children: [
                                                  const Icon(Icons.bar_chart_rounded, color: Color(0xFFC69128), size: 24.0),
                                                  const SizedBox(height: 6.0),
                                                  Text(
                                                    'My Analytics',
                                                    textAlign: TextAlign.center,
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                      fontFamily: GoogleFonts.inter().fontFamily,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // 4. Revenue Overview Card
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 8.0,
                                        color: const Color(0x0D000000),
                                        offset: const Offset(0.0, 2.0),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'TOTAL REVENUE',
                                          style: FlutterFlowTheme.of(context).labelSmall.override(
                                            fontFamily: GoogleFonts.inter().fontFamily,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                                          child: Text(
                                            '\$${formatNumber(totalRevenue, formatType: FormatType.decimal)}',
                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                              fontFamily: GoogleFonts.interTight().fontFamily,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const Divider(height: 20.0),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Collected', style: FlutterFlowTheme.of(context).labelSmall),
                                                Text('\$${formatNumber(collected, formatType: FormatType.decimal)}',
                                                    style: FlutterFlowTheme.of(context).titleMedium.override(
                                                      fontFamily: GoogleFonts.interTight().fontFamily,
                                                      color: const Color(0xFF22C55E),
                                                      fontWeight: FontWeight.bold,
                                                    )),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Pending', style: FlutterFlowTheme.of(context).labelSmall),
                                                Text('\$${formatNumber(pending, formatType: FormatType.decimal)}',
                                                    style: FlutterFlowTheme.of(context).titleMedium.override(
                                                      fontFamily: GoogleFonts.interTight().fontFamily,
                                                      color: const Color(0xFFF59E0B),
                                                      fontWeight: FontWeight.bold,
                                                    )),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Overdue', style: FlutterFlowTheme.of(context).labelSmall),
                                                Text('\$${formatNumber(overdue, formatType: FormatType.decimal)}',
                                                    style: FlutterFlowTheme.of(context).titleMedium.override(
                                                      fontFamily: GoogleFonts.interTight().fontFamily,
                                                      color: const Color(0xFFEF4444),
                                                      fontWeight: FontWeight.bold,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // 5. Revenue Breakdown Card
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 8.0,
                                        color: const Color(0x0D000000),
                                        offset: const Offset(0.0, 2.0),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Revenue Breakdown',
                                              style: FlutterFlowTheme.of(context).titleMedium.override(
                                                fontFamily: GoogleFonts.interTight().fontFamily,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                final choice = await showMenu<String>(
                                                  context: context,
                                                  position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                                                  items: const [
                                                    PopupMenuItem(value: 'Service', child: Text('By Service')),
                                                    PopupMenuItem(value: 'Category', child: Text('By Category')),
                                                  ],
                                                );
                                                if (choice != null) {
                                                  setState(() {
                                                    _revenueBreakdownMode = choice;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                height: 28.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(context).accent1,
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'By $_revenueBreakdownMode',
                                                        style: FlutterFlowTheme.of(context).labelSmall.override(
                                                          fontFamily: GoogleFonts.inter().fontFamily,
                                                          color: FlutterFlowTheme.of(context).primary,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.keyboard_arrow_down_rounded,
                                                        color: FlutterFlowTheme.of(context).primary,
                                                        size: 14.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16.0),
                                        if (topBreakdowns.isEmpty)
                                          Text(
                                            'No data available.',
                                            style: FlutterFlowTheme.of(context).bodyMedium,
                                          )
                                        else
                                          ...topBreakdowns.map((entry) {
                                            final percent = totalBreakdownSum > 0 ? entry.value / totalBreakdownSum : 0.0;
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 12.0),
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
                                                              fontFamily: GoogleFonts.inter().fontFamily,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        '\$${formatNumber(entry.value, formatType: FormatType.decimal)}',
                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: GoogleFonts.inter().fontFamily,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 6.0),
                                                  LinearPercentIndicator(
                                                    percent: percent,
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
                                          }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // 6. Patients & Appointments row
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 8.0, 0.0),
                                        child: InkWell(
                                          onTap: () => context.pushNamed(DentistTotalPatientHistoryFocusWidget.routeName),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                              borderRadius: BorderRadius.circular(16.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 8.0,
                                                  color: const Color(0x0D000000),
                                                  offset: const Offset(0.0, 2.0),
                                                )
                                              ],
                                            ),
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
                                                      child: Icon(Icons.people_outline, color: FlutterFlowTheme.of(context).primary, size: 18.0),
                                                    ),
                                                    Icon(Icons.arrow_forward_ios_rounded, color: FlutterFlowTheme.of(context).secondaryText, size: 16.0),
                                                  ],
                                                ),
                                                const SizedBox(height: 10.0),
                                                Text(
                                                  '$uniquePatients',
                                                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                    fontFamily: GoogleFonts.interTight().fontFamily,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'Total Patients',
                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                    fontFamily: GoogleFonts.inter().fontFamily,
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 16.0, 0.0),
                                        child: InkWell(
                                          onTap: () => context.pushNamed(PAppointmentsWidget.routeName),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                              borderRadius: BorderRadius.circular(16.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 8.0,
                                                  color: const Color(0x0D000000),
                                                  offset: const Offset(0.0, 2.0),
                                                )
                                              ],
                                            ),
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
                                                        color: const Color(0xFFFFF3E0),
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),
                                                      child: const Icon(Icons.event_available_outlined, color: Color(0xFFEF6C00), size: 18.0),
                                                    ),
                                                    Icon(Icons.arrow_forward_ios_rounded, color: FlutterFlowTheme.of(context).secondaryText, size: 16.0),
                                                  ],
                                                ),
                                                const SizedBox(height: 10.0),
                                                Text(
                                                  '$totalFilteredAppts',
                                                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                    fontFamily: GoogleFonts.interTight().fontFamily,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'Appointments',
                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                    fontFamily: GoogleFonts.inter().fontFamily,
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                  ),
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
                            ],
                          );
                          } catch (e, stackTrace) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.error_outline_rounded, color: Colors.red, size: 36.0),
                                          SizedBox(width: 8.0),
                                          Text(
                                            'Dentist Dashboard Error',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12.0),
                                      Text(
                                        e.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        'Stack Trace:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        stackTrace.toString(),
                                        style: TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 10.0,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    if (homepageUnifiedUserRow?.userType == 'Patient')
                      SingleChildScrollView(
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

                                                          final patientName = homepageUnifiedUserRow?.fullname ?? 'A patient';
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
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 12.0),
                                    child: Text(
                                      'Quick Actions',
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            font: GoogleFonts.interTight(
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF1A2340),
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                              PBookAppointmentPatientWidget
                                                  .routeName);
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                context.pushNamed(
                                                    PBookAppointmentPatientWidget
                                                        .routeName);
                                              },
                                              child: Container(
                                                width: 56.0,
                                                height: 56.0,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFE8F0FE),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                ),
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Icon(
                                                    Icons
                                                        .add_circle_outline_rounded,
                                                    color: Color(0xFF3D6BE8),
                                                    size: 26.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Book',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodySmall
                                                  .override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0xFF1A2340),
                                                    fontSize: 11.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
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
                                          context.pushNamed(
                                              PPatientHistoryWidget.routeName);
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                context.pushNamed(
                                                    PPatientHistoryWidget
                                                        .routeName);
                                              },
                                              child: Container(
                                                width: 56.0,
                                                height: 56.0,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFFF3E0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                ),
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
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
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodySmall
                                                  .override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0xFF1A2340),
                                                    fontSize: 11.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ].divide(SizedBox(height: 6.0)),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            onTap: () async {
                                              _showChatbotBottomSheet(context);
                                            },
                                            child: Container(
                                              width: 56.0,
                                              height: 56.0,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFCE4EC),
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                              ),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Icon(
                                                  Icons
                                                      .chat_bubble_outline_rounded,
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
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFF1A2340),
                                                  fontSize: 11.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
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
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 12.0, 0.0, 12.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Our Services',
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                font: GoogleFonts.interTight(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFF1A2340),
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
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
                                                PProceduresNpricingPatientWidget
                                                    .routeName);
                                          },
                                          child: Text(
                                            'See all',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFF3D6BE8),
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
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
                                  ListView(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 12.0, 0.0),
                                        child: Container(
                                          width: 130.0,
                                          height: 140.0,
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
                                            borderRadius:
                                                BorderRadius.circular(16.0),
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
                                                Container(
                                                  width: 52.0,
                                                  height: 52.0,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFE8F0FE),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14.0),
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Icon(
                                                      Icons
                                                          .cleaning_services_rounded,
                                                      color: Color(0xFF3D6BE8),
                                                      size: 26.0,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'Teeth Cleaning',
                                                  textAlign: TextAlign.center,
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
                                                        color:
                                                            Color(0xFF1A2340),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Container(
                                                  height: 22.0,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFE8F0FE),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(8.0, 0.0,
                                                                8.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          'From \$80',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .override(
                                                                font:
                                                                    GoogleFonts
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
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
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
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 12.0, 0.0, 12.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Available Dentists',
                                          style: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                font: GoogleFonts.interTight(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFF1A2340),
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
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
                                                PViewDentistsAllWidget
                                                    .routeName);
                                          },
                                          child: Text(
                                            'View all',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFF3D6BE8),
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
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
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(14.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        width: 52.0,
                                                        height: 52.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image:
                                                                Image.network(
                                                              '200x200?dentist1',
                                                            ).image,
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                1.0, 1.0),
                                                        child: Container(
                                                          width: 14.0,
                                                          height: 14.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFF2ECC71),
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Dr. Sarah Mitchell',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .titleSmall
                                                            .override(
                                                              font: GoogleFonts
                                                                  .interTight(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                              ),
                                                              color: Color(
                                                                  0xFF1A2340),
                                                              fontSize: 14.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                      ),
                                                      Text(
                                                        'Orthodontist',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodySmall
                                                            .override(
                                                              font: GoogleFonts
                                                                  .inter(
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                              ),
                                                              color: Color(
                                                                  0xFF6B7A8D),
                                                              fontSize: 12.0,
                                                              letterSpacing:
                                                                  0.0,
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
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    2.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .star_rounded,
                                                              color: Color(
                                                                  0xFFFFC107),
                                                              size: 12.0,
                                                            ),
                                                            Text(
                                                              '4.9  •  Available Today',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodySmall
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .fontStyle,
                                                                    ),
                                                                    color: Color(
                                                                        0xFF6B7A8D),
                                                                    fontSize:
                                                                        11.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ].divide(SizedBox(
                                                              width: 4.0)),
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
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 16.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFF3D6BE8),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .interTight(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                  elevation: 0.0,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
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
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(14.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        width: 52.0,
                                                        height: 52.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image:
                                                                Image.network(
                                                              'https://images.unsplash.com/photo-1627023063469-7a78d2588878?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NzY3ODI0ODF8&ixlib=rb-4.1.0&q=80&w=1080',
                                                            ).image,
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                1.0, 1.0),
                                                        child: Container(
                                                          width: 14.0,
                                                          height: 14.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Colors.orange,
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Dr. James Carter',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .titleSmall
                                                            .override(
                                                              font: GoogleFonts
                                                                  .interTight(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                              ),
                                                              color: Color(
                                                                  0xFF1A2340),
                                                              fontSize: 14.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                      ),
                                                      Text(
                                                        'Cosmetic Dentist',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodySmall
                                                            .override(
                                                              font: GoogleFonts
                                                                  .inter(
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                              ),
                                                              color: Color(
                                                                  0xFF6B7A8D),
                                                              fontSize: 12.0,
                                                              letterSpacing:
                                                                  0.0,
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
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    2.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .star_rounded,
                                                              color: Color(
                                                                  0xFFFFC107),
                                                              size: 12.0,
                                                            ),
                                                            Text(
                                                              '4.7  •  Next: 2:00 PM',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodySmall
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .fontStyle,
                                                                    ),
                                                                    color: Color(
                                                                        0xFF6B7A8D),
                                                                    fontSize:
                                                                        11.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ].divide(SizedBox(
                                                              width: 4.0)),
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
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 16.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: Color(0xFFE8F0FE),
                                                  textStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .titleSmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .interTight(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            Color(0xFF3D6BE8),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontStyle,
                                                      ),
                                                  elevation: 0.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
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
                    ], // closing selectedIndex == 1
                    if (_model.selectedIndex == 0) ...[
                      _buildHomeView(context, homepageUnifiedUserRow),
                    ],
                    if (_model.selectedIndex == 2) ...[
                      if (homepageUnifiedUserRow?.userType == 'Admin')
                        _buildAdminNotifications(homepageUnifiedUserRow)
                      else
                        _buildNotificationsPlaceholder(homepageUnifiedUserRow),
                    ],
                    if (_model.selectedIndex == 3) ...[
                      if (homepageUnifiedUserRow?.userType == 'Admin')
                        _buildAdminProfile(homepageUnifiedUserRow)
                      else
                        _buildProfilePlaceholder(homepageUnifiedUserRow),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomeView(BuildContext context, UserRow? userRow) {
    final String greetingName = userRow?.fullname ?? 'Guest';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Welcoming Hero Banner
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    FlutterFlowTheme.of(context).primary,
                    FlutterFlowTheme.of(context).secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
                    blurRadius: 12.0,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back,',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: GoogleFonts.interTight().fontFamily,
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    greetingName,
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: GoogleFonts.interTight().fontFamily,
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12.0),
                  Container(
                    height: 1.0,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          '"Your Smile, Our Priority"',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: GoogleFonts.inter().fontFamily,
                                color: Colors.white,
                                fontSize: 16.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // 2. Clinic Operating Hours & Details
            Text(
              'Clinic Overview',
              style: FlutterFlowTheme.of(context).titleLarge.override(
                    fontFamily: GoogleFonts.interTight().fontFamily,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
            ),
            const SizedBox(height: 12.0),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 1.0,
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 24.0,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Operating Hours',
                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Monday - Saturday: 8:00 AM - 5:00 PM\nSunday: Closed',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 24.0,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Toothy Clinic Dental Center, Suite 101, Medical Plaza',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.phone_rounded,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 24.0,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contact & Emergency',
                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Phone: +1 (555) 123-4567\nFor urgent pain, call our 24/7 emergency care line.',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // 3. General Services Showcase
            Text(
              'Our Services',
              style: FlutterFlowTheme.of(context).titleLarge.override(
                    fontFamily: GoogleFonts.interTight().fontFamily,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
            ),
            const SizedBox(height: 12.0),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 1.35,
              ),
              children: [
                _buildServiceCard(
                  title: 'Preventive Care',
                  description: 'Cleanings, checkups, & oral health guidance.',
                  icon: Icons.shield_rounded,
                  color: const Color(0xFF4B39EF),
                  bgColor: const Color(0x264B39EF),
                ),
                _buildServiceCard(
                  title: 'Cosmetic Care',
                  description: 'Veneers, professional teeth whitening, & bonding.',
                  icon: Icons.auto_awesome_rounded,
                  color: const Color(0xFFFF5964),
                  bgColor: const Color(0x26FF5964),
                ),
                _buildServiceCard(
                  title: 'Restoration',
                  description: 'High-quality composite fillings, crowns, & bridges.',
                  icon: Icons.build_rounded,
                  color: const Color(0xFF39D2C0),
                  bgColor: const Color(0x2639D2C0),
                ),
                _buildServiceCard(
                  title: 'Dental Surgery',
                  description: 'Safe extractions, dental implants, & root canals.',
                  icon: Icons.healing_rounded,
                  color: const Color(0xFFEE8B60),
                  bgColor: const Color(0x26EE8B60),
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // 4. Dental Health Tips & News
            Text(
              'Dental Care Tips',
              style: FlutterFlowTheme.of(context).titleLarge.override(
                    fontFamily: GoogleFonts.interTight().fontFamily,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
            ),
            const SizedBox(height: 12.0),
            _buildTipCard(
              title: 'Brush Twice, Floss Once',
              content: 'Brushing takes care of the front and back of teeth, but flossing is critical to clean the tight spaces in between where bacteria thrives.',
              icon: Icons.tips_and_updates_rounded,
            ),
            const SizedBox(height: 12.0),
            _buildTipCard(
              title: 'Watch the Acid & Sugar',
              content: 'Sugary and acidic beverages can soften enamel. Try rinsing your mouth with water after drinking soda, juices, or coffee.',
              icon: Icons.apple_rounded,
            ),
            const SizedBox(height: 24.0),

            // 5. AI Chatbot Promo
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                _showChatbotBottomSheet(context);
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).accent1,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).primary.withOpacity(0.3),
                    width: 1.0,
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.assistant_rounded,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Need Quick Answers?',
                            style: FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: GoogleFonts.interTight().fontFamily,
                                  fontWeight: FontWeight.bold,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Ask our 24/7 AI Chatbot about clinic schedules, doctor qualifications, services, or locations.',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  fontSize: 13.0,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18.0),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  title,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Expanded(
            child: Text(
              description,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: GoogleFonts.inter().fontFamily,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 11.0,
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 20.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  content,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: GoogleFonts.inter().fontFamily,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDentistWorkflow(UserRow? userRow) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        LeaveRequestTable().queryRows(
          queryFn: (q) => q.eq('dentist_id', currentUserUid).order('created_at', ascending: false),
        ),
        AppointmentTable().queryRows(
          queryFn: (q) => q.eq('dentist_id', currentUserUid),
        ),
        PatientTable().queryRows(queryFn: (q) => q),
        ProcedureTable().queryRows(queryFn: (q) => q),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }

        final leaves = snapshot.data![0] as List<LeaveRequestRow>;
        final appointments = snapshot.data![1] as List<AppointmentRow>;
        final patients = snapshot.data![2] as List<PatientRow>;
        final procedures = snapshot.data![3] as List<ProcedureRow>;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dentist Workspaces',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: GoogleFonts.interTight().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
              Text(
                'Manage your schedules, leaves, and treatment records',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
              const SizedBox(height: 20.0),

              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 1.5,
                ),
                children: [
                  _buildWorkflowCard(
                    title: 'My Schedule',
                    count: appointments.length,
                    icon: Icons.calendar_month_rounded,
                    color: const Color(0xFF1565C0),
                    bgColor: const Color(0xFFEFF6FF),
                    onTap: () => context.pushNamed(PScheduleDentistWidget.routeName),
                  ),
                  _buildWorkflowCard(
                    title: 'Treatment Entry',
                    count: patients.length,
                    icon: Icons.edit_note_rounded,
                    color: const Color(0xFF00695C),
                    bgColor: const Color(0xFFE0F2F1),
                    onTap: () => context.pushNamed(TreatmentRecordsWidget.routeName),
                  ),
                  _buildWorkflowCard(
                    title: 'Fulfillment Rate',
                    count: 100,
                    icon: Icons.trending_up_rounded,
                    color: const Color(0xFFC62828),
                    bgColor: const Color(0xFFFFEBEE),
                    onTap: () => context.pushNamed(DentistFulfillmentFocusWidget.routeName),
                  ),
                  _buildWorkflowCard(
                    title: 'My Analytics',
                    count: procedures.length,
                    icon: Icons.bar_chart_rounded,
                    color: const Color(0xFFC69128),
                    bgColor: const Color(0xFFFFFDE7),
                    onTap: () => context.pushNamed(DentistAnalyticsFocusWidget.routeName),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              Text(
                'My Leave Requests',
                style: FlutterFlowTheme.of(context).titleLarge.override(
                  fontFamily: GoogleFonts.interTight().fontFamily,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12.0),

              if (leaves.isEmpty)
                Card(
                  elevation: 0,
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        'No leave requests filed yet.',
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                    ),
                  ),
                )
              else
                ...leaves.map((l) => _buildDentistLeaveCard(l)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDentistLeaveCard(LeaveRequestRow leave) {
    Color statusColor = const Color(0xFFF59E0B);
    Color statusBgColor = const Color(0xFFFFF7ED);
    String statusText = 'PENDING';
    if (leave.status == 'Approved') {
      statusColor = const Color(0xFF10B981);
      statusBgColor = const Color(0xFFECFDF5);
      statusText = 'APPROVED';
    } else if (leave.status == 'Rejected') {
      statusColor = const Color(0xFFEF4444);
      statusBgColor = const Color(0xFFFEF2F2);
      statusText = 'REJECTED';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 0,
      color: FlutterFlowTheme.of(context).secondaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundColor: statusBgColor,
                  child: Icon(
                    Icons.date_range_rounded,
                    color: statusColor,
                    size: 20.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${dateTimeFormat("yMMMd", leave.startDate)} - ${dateTimeFormat("yMMMd", leave.endDate)}',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Reason: ${leave.reason ?? "No reason specified"}',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  ),
                ),
              ],
            ),
            if (leave.status == 'Pending') ...[
              const Divider(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              FocusManager.instance.primaryFocus
                                  ?.unfocus();
                            },
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(
                                  context),
                              child: CDeleteConfirmationWidget(
                                itemType: 'Leave Request',
                                warningText: 'Are you sure you want to cancel this leave request? This action cannot be undone.',
                                onConfirm: () async {
                                  await LeaveRequestTable().delete(
                                    matchingRows: (q) => q.eq('request_id', leave.requestId!),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Leave request cancelled successfully!')),
                                  );
                                  setState(() {});
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                    ),
                    child: const Text('Cancel Request'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10.0,
              offset: const Offset(0, 4),
            )
          ],
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20.0),
                ),
                Text(
                  count.toString(),
                  style: FlutterFlowTheme.of(context).titleLarge.override(
                    fontFamily: GoogleFonts.interTight().fontFamily,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
              ],
            ),
            Text(
              title,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.w600,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveCard(LeaveRequestRow leave, UserRow? dentistUser, bool isPending) {
    final String dentistName = dentistUser?.fullname ?? 'Dentist';
    
    final nameParts = dentistName.trim().split(RegExp(r'\s+'));
    final initials = nameParts.length >= 2
        ? '${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}'.toUpperCase()
        : nameParts.isNotEmpty && nameParts[0].isNotEmpty
            ? nameParts[0][0].toUpperCase()
            : 'DR';

    Color statusColor = const Color(0xFFF59E0B);
    Color statusBgColor = const Color(0xFFFFF7ED);
    String statusText = 'PENDING';
    if (leave.status == 'Approved') {
      statusColor = const Color(0xFF10B981);
      statusBgColor = const Color(0xFFECFDF5);
      statusText = 'APPROVED';
    } else if (leave.status == 'Rejected') {
      statusColor = const Color(0xFFEF4444);
      statusBgColor = const Color(0xFFFEF2F2);
      statusText = 'REJECTED';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 0,
      color: FlutterFlowTheme.of(context).secondaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundColor: FlutterFlowTheme.of(context).accent1,
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dentistName,
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${dateTimeFormat("yMMMd", leave.startDate)} - ${dateTimeFormat("yMMMd", leave.endDate)}',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              'Reason: ${leave.reason ?? "No reason specified"}',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: GoogleFonts.inter().fontFamily,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            if (isPending) ...[
              const Divider(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await LeaveRequestTable().update(
                        data: {
                          'status': 'Rejected',
                          'reviewed_by': currentUserUid,
                          'updated_at': DateTime.now().toIso8601String(),
                        },
                        matchingRows: (q) => q.eq('request_id', leave.requestId!),
                      );
                      await NotificationTable().insert({
                        'user_id': leave.dentistId,
                        'title': 'Leave Request Rejected',
                        'body': 'Your leave request for ${dateTimeFormat("yMMMd", leave.startDate)} to ${dateTimeFormat("yMMMd", leave.endDate)} has been rejected.',
                        'type': 'leave_rejected',
                        'reference_id': leave.requestId,
                        'is_read': false,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Leave request rejected.')),
                      );
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEF2F2),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                    child: const Text('Reject', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12.0),
                  ElevatedButton(
                    onPressed: () async {
                      await LeaveRequestTable().update(
                        data: {
                          'status': 'Approved',
                          'reviewed_by': currentUserUid,
                          'updated_at': DateTime.now().toIso8601String(),
                        },
                        matchingRows: (q) => q.eq('request_id', leave.requestId!),
                      );
                      await NotificationTable().insert({
                        'user_id': leave.dentistId,
                        'title': 'Leave Request Approved',
                        'body': 'Your leave request for ${dateTimeFormat("yMMMd", leave.startDate)} to ${dateTimeFormat("yMMMd", leave.endDate)} has been approved.',
                        'type': 'leave_approved',
                        'reference_id': leave.requestId,
                        'is_read': false,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Leave request approved.')),
                      );
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                    child: const Text('Approve', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildAdminNotifications(UserRow? adminRow) {
    return FutureBuilder<List<NotificationRow>>(
      future: NotificationTable().queryRows(
        queryFn: (q) => q.eq('user_id', currentUserUid).order('created_at', ascending: false),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }

        final notifications = snapshot.data!;
        final unreadCount = notifications.where((n) => n.isRead == false).length;

        return Padding(
          padding: const EdgeInsets.all(16.0),
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
                        'Notifications',
                        style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: GoogleFonts.interTight().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'You have $unreadCount unread notifications',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
                  if (unreadCount > 0)
                    TextButton(
                      onPressed: () async {
                        await NotificationTable().update(
                          data: {'is_read': true},
                          matchingRows: (q) => q.eq('user_id', currentUserUid).eq('is_read', false),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('All notifications marked as read.')),
                        );
                        setState(() {});
                      },
                      child: const Text('Mark all as read'),
                    ),
                ],
              ),
              const SizedBox(height: 20.0),

              if (notifications.isEmpty)
                Card(
                  elevation: 0,
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.notifications_none_rounded, size: 48.0, color: FlutterFlowTheme.of(context).secondaryText),
                          const SizedBox(height: 12.0),
                          Text(
                            "You're all caught up! No notifications yet.",
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: GoogleFonts.inter().fontFamily,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  IconData iconData = Icons.notifications_rounded;
                  Color iconColor = FlutterFlowTheme.of(context).secondaryText;
                  Color iconBgColor = FlutterFlowTheme.of(context).alternate;

                  if (notif.type == 'leave_approved') {
                    iconData = Icons.check_circle_rounded;
                    iconColor = const Color(0xFF10B981);
                    iconBgColor = const Color(0xFFECFDF5);
                  } else if (notif.type == 'leave_rejected') {
                    iconData = Icons.cancel_rounded;
                    iconColor = const Color(0xFFEF4444);
                    iconBgColor = const Color(0xFFFEF2F2);
                  } else if (notif.type == 'booking_confirmed') {
                    iconData = Icons.calendar_today_rounded;
                    iconColor = const Color(0xFF3B82F6);
                    iconBgColor = const Color(0xFFEFF6FF);
                  } else if (notif.type == 'appointment_reminder') {
                    iconData = Icons.alarm_rounded;
                    iconColor = const Color(0xFFF59E0B);
                    iconBgColor = const Color(0xFFFFF7ED);
                  } else if (notif.type == 'status_change') {
                    iconData = Icons.sync_rounded;
                    iconColor = const Color(0xFF8B5CF6);
                    iconBgColor = const Color(0xFFF5F3FF);
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    elevation: 0,
                    color: notif.isRead == true 
                        ? FlutterFlowTheme.of(context).secondaryBackground 
                        : const Color(0xFFF8FAFC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(
                        color: notif.isRead == true
                            ? FlutterFlowTheme.of(context).alternate
                            : FlutterFlowTheme.of(context).primary.withOpacity(0.2),
                        width: 1.0,
                      ),
                    ),
                    child: ListTile(
                      onTap: () async {
                        if (notif.isRead == false) {
                          await NotificationTable().update(
                            data: {'is_read': true},
                            matchingRows: (q) => q.eq('notification_id', notif.notificationId!),
                          );
                          setState(() {});
                        }
                      },
                      leading: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: iconBgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(iconData, color: iconColor, size: 20.0),
                      ),
                      title: Text(
                        notif.title,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontWeight: notif.isRead == false ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0),
                          Text(
                            notif.body,
                            style: FlutterFlowTheme.of(context).bodySmall,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            notif.createdAt != null
                                ? dateTimeFormat("relative", notif.createdAt!)
                                : 'recently',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: GoogleFonts.inter().fontFamily,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 10.0,
                            ),
                          ),
                        ],
                      ),
                      trailing: notif.isRead == false
                          ? Container(
                              width: 8.0,
                              height: 8.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdminProfile(UserRow? adminRow) {
    final String userType = adminRow?.userType ?? 'Patient';
    final String defaultName = userType == 'Admin' ? 'Admin' : (userType == 'Dentist' ? 'Dentist' : 'Patient');
    final String defaultEmail = userType == 'Admin' ? 'admin@gmail.com' : (userType == 'Dentist' ? 'dentist@gmail.com' : 'patient@gmail.com');
    final String name = adminRow?.fullname ?? defaultName;
    final String email = adminRow?.email ?? defaultEmail;
    
    final nameParts = name.trim().split(RegExp(r'\s+'));
    final String defaultInitials = userType == 'Admin' ? 'AD' : (userType == 'Dentist' ? 'DR' : 'PT');
    final initials = nameParts.length >= 2
        ? '${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}'.toUpperCase()
        : nameParts.isNotEmpty && nameParts[0].isNotEmpty
            ? nameParts[0][0].toUpperCase()
            : defaultInitials;

    Color badgeColor = const Color(0xFF3B82F6);
    Color badgeBgColor = const Color(0xFFEFF6FF);
    String badgeText = 'Patient';
    if (userType == 'Admin') {
      badgeColor = const Color(0xFF3B82F6);
      badgeBgColor = const Color(0xFFEFF6FF);
      badgeText = 'Administrator';
    } else if (userType == 'Dentist') {
      badgeColor = const Color(0xFF10B981);
      badgeBgColor = const Color(0xFFECFDF5);
      badgeText = 'Dentist';
    } else {
      badgeColor = const Color(0xFF8B5CF6);
      badgeBgColor = const Color(0xFFF5F3FF);
      badgeText = 'Patient';
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20.0),
          CircleAvatar(
            radius: 50.0,
            backgroundColor: FlutterFlowTheme.of(context).primary,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32.0,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            name,
            style: FlutterFlowTheme.of(context).headlineSmall.override(
              fontFamily: GoogleFonts.interTight().fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            email,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: GoogleFonts.inter().fontFamily,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: badgeBgColor,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: badgeColor, width: 1.0),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                color: badgeColor,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
          ),
          const SizedBox(height: 32.0),

          _buildProfileMenuOption(
            icon: Icons.person_outline_rounded,
            label: 'Edit Profile Info',
            onTap: () => context.pushNamed(PEditProfileWidget.routeName),
          ),
          _buildProfileMenuOption(
            icon: Icons.email_outlined,
            label: 'Change Email Address',
            onTap: () => context.pushNamed(PEditEmailWidget.routeName),
          ),
          _buildProfileMenuOption(
            icon: Icons.lock_outline_rounded,
            label: 'Change Security Password',
            onTap: () => context.pushNamed(PEditPasswordWidget.routeName),
          ),
          const Divider(height: 32.0),
          
          InkWell(
            onTap: () async {
              GoRouter.of(context).prepareAuthEvent();
              await authManager.signOut();
              GoRouter.of(context).clearRedirectLocation();
              context.goNamedAuth(SplashWidget.routeName, context.mounted);
            },
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: const Color(0xFFFCA5A5), width: 1.0),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
                  SizedBox(width: 8.0),
                  Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 0,
      color: FlutterFlowTheme.of(context).secondaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: FlutterFlowTheme.of(context).alternate, width: 1.0),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: FlutterFlowTheme.of(context).primary, size: 24.0),
        title: Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: GoogleFonts.inter().fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: FlutterFlowTheme.of(context).secondaryText),
      ),
    );
  }

  Widget _buildWorkflowPlaceholder(UserRow? userRow) {
    if (userRow?.userType != 'Patient') {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.dashboard_rounded, size: 64.0, color: FlutterFlowTheme.of(context).secondaryText),
              const SizedBox(height: 16.0),
              Text(
                'Workflow Panel',
                style: FlutterFlowTheme.of(context).titleLarge.override(
                  fontFamily: GoogleFonts.interTight().fontFamily,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Workflow features are currently being customized for your role.',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        AppointmentTable().queryRows(
          queryFn: (q) => q.eq('patient_id', currentUserUid).order('appointment_date', ascending: false),
        ),
        UserTable().queryRows(queryFn: (q) => q.eq('user_type', 'Dentist')),
        ProcedureTable().queryRows(queryFn: (q) => q.eq('status', 'Active')),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }

        final appointments = snapshot.data![0] as List<AppointmentRow>;
        final dentists = snapshot.data![1] as List<UserRow>;
        final procedures = snapshot.data![2] as List<ProcedureRow>;

        final dentistMap = {for (var d in dentists) if (d.userId != null) d.userId!: d.fullname ?? 'Dentist'};
        final procedureMap = {for (var p in procedures) if (p.procedureId != null) p.procedureId!: p};

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Care Hub',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: GoogleFonts.interTight().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
              Text(
                'Book new slots and manage scheduled appointments',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
              const SizedBox(height: 20.0),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => context.pushNamed(PBookAppointmentPatientWidget.routeName),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: const Color(0xFFBFDBFE), width: 1.0),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF2563EB), size: 32),
                            const SizedBox(height: 8),
                            Text(
                              'Book Appointment',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF1E40AF),
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                                fontFamily: GoogleFonts.inter().fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: InkWell(
                      onTap: () => context.pushNamed(PProceduresNpricingPatientWidget.routeName),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: const Color(0xFFA7F3D0), width: 1.0),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.local_offer_outlined, color: Color(0xFF059669), size: 32),
                            const SizedBox(height: 8),
                            Text(
                              'Procedure Costs',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF065F46),
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                                fontFamily: GoogleFonts.inter().fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              Text(
                'My Appointments',
                style: FlutterFlowTheme.of(context).titleLarge.override(
                  fontFamily: GoogleFonts.interTight().fontFamily,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12.0),

              if (appointments.isEmpty)
                Card(
                  elevation: 0,
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 40, color: FlutterFlowTheme.of(context).secondaryText),
                          const SizedBox(height: 12),
                          Text(
                            'No scheduled appointments yet.',
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => context.pushNamed(PBookAppointmentPatientWidget.routeName),
                            child: const Text('Book Your First Visit'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: FlutterFlowTheme.of(context).primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appointments.length,
                  itemBuilder: (context, idx) {
                    final app = appointments[idx];
                    final dentistName = dentistMap[app.doctorId] ?? 'Dentist';
                    final procedureName = procedureMap[app.procedureId]?.procedureName ?? 'General Visit';
                    final pricing = procedureMap[app.procedureId]?.pricing;
                    
                    final dateStr = DateFormat('MMM dd, yyyy').format(app.appointmentDate);
                    final timeStr = app.appointmentTime.toIso8601String()?.substring(0, 5) ?? '';
                    
                    final isPending = app.status == 'Pending';
                    final isConfirmed = app.status == 'Confirmed';
                    final isCancelled = app.status == 'Cancelled';
                    
                    Color badgeColor = Colors.grey;
                    Color badgeTextColor = Colors.black;
                    if (isPending) {
                      badgeColor = const Color(0xFFFEF3C7);
                      badgeTextColor = const Color(0xFF92400E);
                    } else if (isConfirmed) {
                      badgeColor = const Color(0xFFD1FAE5);
                      badgeTextColor = const Color(0xFF065F46);
                    } else if (isCancelled) {
                      badgeColor = const Color(0xFFFEE2E2);
                      badgeTextColor = const Color(0xFF991B1B);
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      elevation: 0,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: FlutterFlowTheme.of(context).alternate, width: 1.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  procedureName,
                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: badgeColor,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Text(
                                    app.status ?? 'Pending',
                                    style: TextStyle(
                                      color: badgeTextColor,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: GoogleFonts.inter().fontFamily,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.person_rounded, size: 16, color: FlutterFlowTheme.of(context).secondaryText),
                                const SizedBox(width: 8),
                                Text(
                                  dentistName,
                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.access_time_filled_rounded, size: 16, color: FlutterFlowTheme.of(context).secondaryText),
                                const SizedBox(width: 8),
                                Text(
                                  '$dateStr at $timeStr',
                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                ),
                              ],
                            ),
                            if (pricing != null) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.local_offer, size: 16, color: FlutterFlowTheme.of(context).secondaryText),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Cost: ₱$pricing',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: GoogleFonts.inter().fontFamily,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (app.notes != null && app.notes!.isNotEmpty) ...[
                              const Divider(height: 20),
                              Text(
                                'Patient Notes:',
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                app.notes!,
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationsPlaceholder(UserRow? userRow) {
    return _buildAdminNotifications(userRow);
  }

  Widget _buildProfilePlaceholder(UserRow? userRow) {
    if (userRow?.userType != 'Patient') {
      return _buildAdminProfile(userRow);
    }

    if (_showMedicalRecords) {
      return _buildPatientMedicalRecords();
    }

    final String name = userRow?.fullname ?? 'Patient';
    final String email = userRow?.email ?? '';
    final nameParts = name.trim().split(RegExp(r'\s+'));
    final initials = nameParts.length >= 2
        ? '${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}'.toUpperCase()
        : nameParts.isNotEmpty && nameParts[0].isNotEmpty
            ? nameParts[0][0].toUpperCase()
            : 'PT';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20.0),
          CircleAvatar(
            radius: 50.0,
            backgroundColor: FlutterFlowTheme.of(context).primary,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32.0,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            name,
            style: FlutterFlowTheme.of(context).headlineSmall.override(
              fontFamily: GoogleFonts.interTight().fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            email,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: GoogleFonts.inter().fontFamily,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: const Color(0xFF3B82F6), width: 1.0),
            ),
            child: const Text(
              'Patient Member',
              style: TextStyle(
                color: Color(0xFF3B82F6),
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
          ),
          const SizedBox(height: 32.0),

          // Medical records view card (container below profile)
          Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 0,
            color: const Color(0xFFEEF2F6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _showMedicalRecords = true;
                  _isEditingMedical = false;
                });
              },
              borderRadius: BorderRadius.circular(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.assignment_rounded, color: Color(0xFF1E293B), size: 36),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'View Records',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Allergies, conditions, blood type & emergency contact.',
                            style: TextStyle(
                              color: const Color(0xFF64748B),
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Color(0xFF475569)),
                  ],
                ),
              ),
            ),
          ),

          _buildProfileMenuOption(
            icon: Icons.person_outline_rounded,
            label: 'Edit Profile Info',
            onTap: () => context.pushNamed(PEditProfileWidget.routeName),
          ),
          _buildProfileMenuOption(
            icon: Icons.email_outlined,
            label: 'Change Email Address',
            onTap: () => context.pushNamed(PEditEmailWidget.routeName),
          ),
          _buildProfileMenuOption(
            icon: Icons.lock_outline_rounded,
            label: 'Change Security Password',
            onTap: () => context.pushNamed(PEditPasswordWidget.routeName),
          ),
          const Divider(height: 32.0),
          
          InkWell(
            onTap: () async {
              GoRouter.of(context).prepareAuthEvent();
              await authManager.signOut();
              GoRouter.of(context).clearRedirectLocation();
              context.goNamedAuth(SplashWidget.routeName, context.mounted);
            },
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: const Color(0xFFFCA5A5), width: 1.0),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
                  SizedBox(width: 8.0),
                  Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientMedicalRecords() {
    return FutureBuilder<List<PatientRow>>(
      future: PatientTable().querySingleRow(
        queryFn: (q) => q.eq('patient_id', currentUserUid),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }

        final patientList = snapshot.data!;
        final patientRow = patientList.isNotEmpty ? patientList.first : null;

        if (patientRow == null) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () {
                        setState(() {
                          _showMedicalRecords = false;
                        });
                      },
                    ),
                    const Text('Back', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Medical records profile not initialized. Sign up again or complete details.'),
              ],
            ),
          );
        }

        _initMedicalControllers(patientRow);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () {
                      setState(() {
                        _showMedicalRecords = false;
                      });
                    },
                  ),
                  Text(
                    'Back to Profile',
                    style: TextStyle(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Text(
                'Medical Profile & Records',
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: GoogleFonts.interTight().fontFamily,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Manage your medical details and emergency contact contacts',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
              const SizedBox(height: 20.0),

              Card(
                elevation: 0,
                color: FlutterFlowTheme.of(context).secondaryBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide(color: FlutterFlowTheme.of(context).alternate, width: 1.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _isEditingMedical ? _buildMedicalEditForm(patientRow) : _buildMedicalDisplay(patientRow),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMedicalDisplay(PatientRow row) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMedicalRow(label: 'Blood Type', value: row.bloodType ?? 'Not specified'),
        const Divider(),
        _buildMedicalRow(label: 'Allergies', value: row.allergies ?? 'None specified'),
        const Divider(),
        _buildMedicalRow(label: 'Medical Conditions', value: row.medicalConditions ?? 'None specified'),
        const Divider(),
        _buildMedicalRow(label: 'Emergency Contact Name', value: row.emergencyContactName ?? 'Not specified'),
        const Divider(),
        _buildMedicalRow(label: 'Emergency Contact Phone', value: row.emergencyContactPhone ?? 'Not specified'),
        const SizedBox(height: 24.0),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _isEditingMedical = true;
            });
          },
          icon: const Icon(Icons.edit_rounded, size: 18),
          label: const Text('Edit Details'),
          style: ElevatedButton.styleFrom(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 15.0,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalEditForm(PatientRow row) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMedicalInputField(label: 'Blood Type', controller: _bloodTypeController!, hint: 'e.g. O+'),
        _buildMedicalInputField(label: 'Allergies', controller: _allergiesController!, hint: 'e.g. Penicillin, Peanuts'),
        _buildMedicalInputField(label: 'Medical Conditions', controller: _conditionsController!, hint: 'e.g. Asthma, Hypertension'),
        _buildMedicalInputField(label: 'Emergency Contact Name', controller: _contactNameController!, hint: 'e.g. John Doe'),
        _buildMedicalInputField(label: 'Emergency Contact Phone', controller: _contactPhoneController!, hint: 'e.g. 09171234567'),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _isEditingMedical = false;
                  });
                },
                child: const Text('Cancel'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await PatientTable().update(
                      data: {
                        'blood_type': _bloodTypeController!.text.trim(),
                        'allergies': _allergiesController!.text.trim(),
                        'medical_conditions': _conditionsController!.text.trim(),
                        'emergency_contact_name': _contactNameController!.text.trim(),
                        'emergency_contact_phone': _contactPhoneController!.text.trim(),
                        'updated_at': supaSerialize<DateTime>(DateTime.now()),
                      },
                      matchingRows: (q) => q.eq('patient_id', currentUserUid),
                    );

                    setState(() {
                      _isEditingMedical = false;
                    });
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Medical records updated successfully!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error updating medical records: $e')),
                    );
                  }
                },
                child: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMedicalInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6.0),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: FlutterFlowTheme.of(context).secondaryText, fontSize: 13.0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).primary,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            ),
          ),
        ],
      ),
    );
  }
}
