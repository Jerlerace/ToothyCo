import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/database/database.dart';
import 'dentist_total_patient_history_focus_model.dart';
export 'dentist_total_patient_history_focus_model.dart';

/// make a dentist page where it shows total patients the dentist performed a
/// service, add a filter in which the dentist can filter by date, by name, by
/// procedures, and can be searched
class DentistTotalPatientHistoryFocusWidget extends StatefulWidget {
  const DentistTotalPatientHistoryFocusWidget({super.key});

  static String routeName = 'DentistTotalPatientHistoryFocus';
  static String routePath = '/dentistTotalPatientHistoryFocus';

  @override
  State<DentistTotalPatientHistoryFocusWidget> createState() =>
      _DentistTotalPatientHistoryFocusWidgetState();
}

class _DentistTotalPatientHistoryFocusWidgetState
    extends State<DentistTotalPatientHistoryFocusWidget> {
  late DentistTotalPatientHistoryFocusModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  late Future<List<Map<String, dynamic>>> _historyFuture;
  String _selectedFilter = 'Date';
  String _dateRangeFilter = 'All';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DentistTotalPatientHistoryFocusModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textController!.addListener(() {
      setState(() {});
    });
    _historyFuture = _fetchHistory();
  }

  Future<List<Map<String, dynamic>>> _fetchHistory() async {
    final historyRows = await HistoryTable().queryRows(
      queryFn: (q) => q.eq('dentist_id', currentUserUid).order('created_at', ascending: false),
    );
    final patientIds = historyRows.map((r) => r.patientId).whereType<String>().toSet().toList();
    final patientRows = patientIds.isEmpty ? <UserRow>[] : await UserTable().queryRows(
      queryFn: (q) => q.inFilter('user_id', patientIds),
    );
    final Map<String, UserRow> patientMap = {
      for (var p in patientRows) p.userId ?? '': p
    };

    List<Map<String, dynamic>> results = [];
    for (var r in historyRows) {
      final p = patientMap[r.patientId];
      if (p != null) {
        results.add({
          'history': r,
          'patient': p,
        });
      }
    }
    return results;
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
            'My Patients',
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
                        'My Patients',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily: GoogleFonts.interTight().fontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      content: Text(
                        'Browse patient records assigned to you or who have visited you. Select a patient to view session history, records, and treatments.',
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
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _historyFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error loading history: ${snapshot.error}'));
              }
              final listData = snapshot.data ?? [];
              final totalServed = listData.length;
              final thisMonthCount = listData.where((item) {
                final date = (item['history'] as HistoryRow).createdAt;
                if (date == null) return false;
                final now = DateTime.now();
                return date.year == now.year && date.month == now.month;
              }).length;
              final todayCount = listData.where((item) {
                final date = (item['history'] as HistoryRow).createdAt;
                if (date == null) return false;
                final now = DateTime.now();
                return date.year == now.year && date.month == now.month && date.day == now.day;
              }).length;

              final query = (_model.textController?.text ?? '').toLowerCase().trim();
              final filtered = listData.where((item) {
                final patient = item['patient'] as UserRow;
                final history = item['history'] as HistoryRow;
                
                final name = (patient.fullname ?? '').toLowerCase();
                if (query.isNotEmpty && !name.contains(query)) {
                  return false;
                }
                
                final date = history.createdAt;
                if (date == null) return _dateRangeFilter == 'All';
                final now = DateTime.now();
                if (_dateRangeFilter == 'This Month') {
                  return date.year == now.year && date.month == now.month;
                } else if (_dateRangeFilter == 'Today') {
                  return date.year == now.year && date.month == now.month && date.day == now.day;
                }
                return true;
              }).toList();

              if (_selectedFilter == 'Date') {
                filtered.sort((a, b) {
                  final da = (a['history'] as HistoryRow).createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                  final db = (b['history'] as HistoryRow).createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                  return db.compareTo(da);
                });
              } else if (_selectedFilter == 'Name') {
                filtered.sort((a, b) {
                  final na = ((a['patient'] as UserRow).fullname ?? '').toLowerCase();
                  final nb = ((b['patient'] as UserRow).fullname ?? '').toLowerCase();
                  return na.compareTo(nb);
                });
              } else if (_selectedFilter == 'Procedure') {
                filtered.sort((a, b) {
                  String getProc(Map<String, dynamic> item) {
                    final history = item['history'] as HistoryRow;
                    String displayProcedure = 'Teeth Treatment';
                    final remarks = history.remarks ?? '';
                    if (remarks.contains('Procedure:')) {
                      final lines = remarks.split('\n');
                      final procLine = lines.firstWhere((l) => l.startsWith('Procedure:'), orElse: () => '');
                      if (procLine.isNotEmpty) {
                        displayProcedure = procLine.substring(10).trim();
                      }
                    }
                    return displayProcedure.toLowerCase();
                  }
                  return getProc(a).compareTo(getProc(b));
                });
              }

              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 12.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    child: TextFormField(
                      controller: _model.textController,
                      focusNode: _model.textFieldFocusNode,
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: 'Search patients by name...',
                        hintStyle: FlutterFlowTheme.of(context)
                            .bodySmall
                            .override(
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
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                        contentPadding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 12.0, 16.0, 12.0),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 20.0,
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                      cursorColor: FlutterFlowTheme.of(context).primary,
                      validator:
                          _model.textControllerValidator.asValidator(context),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
                                onTap: () => setState(() => _selectedFilter = 'Date'),
                                child: Container(
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    color: _selectedFilter == 'Date'
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context).primaryBackground,
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                      color: _selectedFilter == 'Date'
                                          ? Colors.transparent
                                          : FlutterFlowTheme.of(context).alternate,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        14.0, 0.0, 14.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.calendar_today_rounded,
                                          color: _selectedFilter == 'Date'
                                              ? Colors.white
                                              : FlutterFlowTheme.of(context).secondaryText,
                                          size: 16.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              6.0, 0.0, 6.0, 0.0),
                                          child: Text(
                                            'Date',
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  fontFamily: GoogleFonts.inter().fontFamily,
                                                  color: _selectedFilter == 'Date'
                                                      ? Colors.white
                                                      : FlutterFlowTheme.of(context).secondaryText,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(() => _selectedFilter = 'Name'),
                                child: Container(
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    color: _selectedFilter == 'Name'
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context).primaryBackground,
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                      color: _selectedFilter == 'Name'
                                          ? Colors.transparent
                                          : FlutterFlowTheme.of(context).alternate,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        14.0, 0.0, 14.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person_outline_rounded,
                                          color: _selectedFilter == 'Name'
                                              ? Colors.white
                                              : FlutterFlowTheme.of(context).secondaryText,
                                          size: 16.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              6.0, 0.0, 6.0, 0.0),
                                          child: Text(
                                            'Name',
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  fontFamily: GoogleFonts.inter().fontFamily,
                                                  color: _selectedFilter == 'Name'
                                                      ? Colors.white
                                                      : FlutterFlowTheme.of(context).secondaryText,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(() => _selectedFilter = 'Procedure'),
                                child: Container(
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    color: _selectedFilter == 'Procedure'
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context).primaryBackground,
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                      color: _selectedFilter == 'Procedure'
                                          ? Colors.transparent
                                          : FlutterFlowTheme.of(context).alternate,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        14.0, 0.0, 14.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.medical_services_outlined,
                                          color: _selectedFilter == 'Procedure'
                                              ? Colors.white
                                              : FlutterFlowTheme.of(context).secondaryText,
                                          size: 16.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              6.0, 0.0, 6.0, 0.0),
                                          child: Text(
                                            'Procedure',
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  fontFamily: GoogleFonts.inter().fontFamily,
                                                  color: _selectedFilter == 'Procedure'
                                                      ? Colors.white
                                                      : FlutterFlowTheme.of(context).secondaryText,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(width: 8.0)),
                          ),
                          FlutterFlowIconButton(
                            borderColor: FlutterFlowTheme.of(context).alternate,
                            borderRadius: 10.0,
                            borderWidth: 1.0,
                            buttonSize: 36.0,
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            icon: Icon(
                              Icons.tune_rounded,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 18.0,
                            ),
                            onPressed: () {
                              print('IconButton pressed ...');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => setState(() => _dateRangeFilter = 'All'),
                          child: Opacity(
                            opacity: _dateRangeFilter == 'All' ? 1.0 : 0.6,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TOTAL PATIENTS SERVED',
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        fontFamily: GoogleFonts.inter().fontFamily,
                                        color: const Color(0xCCFFFFFF),
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Text(
                                  '$totalServed',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineLarge
                                      .override(
                                        fontFamily: GoogleFonts.interTight().fontFamily,
                                        color: Colors.white,
                                        fontSize: 28.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            InkWell(
                              onTap: () => setState(() => _dateRangeFilter = 'This Month'),
                              child: Opacity(
                                opacity: _dateRangeFilter == 'This Month' ? 1.0 : 0.6,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'THIS MONTH',
                                      style: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .override(
                                            fontFamily: GoogleFonts.inter().fontFamily,
                                            color: const Color(0xCCFFFFFF),
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 2.0, 0.0, 0.0),
                                      child: Text(
                                        '$thisMonthCount',
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                              fontFamily: GoogleFonts.interTight().fontFamily,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => setState(() => _dateRangeFilter = 'Today'),
                              child: Opacity(
                                opacity: _dateRangeFilter == 'Today' ? 1.0 : 0.6,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'TODAY',
                                      style: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .override(
                                            fontFamily: GoogleFonts.inter().fontFamily,
                                            color: const Color(0xCCFFFFFF),
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 2.0, 0.0, 0.0),
                                      child: Text(
                                        '$todayCount',
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                              fontFamily: GoogleFonts.interTight().fontFamily,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ].divide(SizedBox(width: 24.0)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 16.0, 6.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 0.0,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Patients',
                          style: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                        ),
                        InkWell(
                          onTap: () => setState(() => _dateRangeFilter = 'All'),
                          child: Text(
                            'View All',
                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  color: _dateRangeFilter == 'All'
                                      ? FlutterFlowTheme.of(context).primary
                                      : FlutterFlowTheme.of(context).secondaryText,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          'No patient history found.',
                          style: FlutterFlowTheme.of(context).labelMedium,
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          final history = item['history'] as HistoryRow;
                          final patient = item['patient'] as UserRow;
                          final initials = (patient.fullname ?? '').split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();
                          final dateStr = history.createdAt != null ? dateTimeFormat('yMMMd', history.createdAt!) : 'Unknown Date';
                          final timeStr = history.createdAt != null ? dateTimeFormat('jm', history.createdAt!) : '';

                          String remarks = history.remarks ?? '';
                          String displayProcedure = 'Teeth Treatment';
                          if (remarks.contains('Procedure:')) {
                            final lines = remarks.split('\n');
                            final procLine = lines.firstWhere((l) => l.startsWith('Procedure:'), orElse: () => '');
                            if (procLine.isNotEmpty) {
                              displayProcedure = procLine.substring(10).trim();
                            }
                            final notesLine = lines.firstWhere((l) => l.startsWith('Notes:'), orElse: () => '');
                            if (notesLine.isNotEmpty) {
                              remarks = notesLine.substring(6).trim();
                            } else {
                              remarks = lines.where((l) => !l.startsWith('Category:') && !l.startsWith('Procedure:')).join('\n').trim();
                            }
                          }

                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.0),
                            child: InkWell(
                              onTap: () async {
                                DentistPatientFocusWidget.selectedPatient = patient;
                                await context.pushNamed(DentistPatientFocusWidget.routeName);
                                setState(() {
                                  _historyFuture = _fetchHistory();
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 6.0,
                                      color: Color(0x0D000000),
                                      offset: Offset(0.0, 2.0),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(14.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 52.0,
                                        height: 52.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).accent1,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Align(
                                          alignment: AlignmentDirectional(0.0, 0.0),
                                          child: Text(
                                            initials,
                                            style: FlutterFlowTheme.of(context).titleMedium.override(
                                              font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                              color: FlutterFlowTheme.of(context).primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      patient.fullname ?? '',
                                                      style: FlutterFlowTheme.of(context).titleSmall.override(
                                                        font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                                        fontSize: 15.0,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8.0),
                                                  Container(
                                                    height: 24.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).accent1,
                                                      borderRadius: BorderRadius.circular(12.0),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(10.0, 4.0, 10.0, 4.0),
                                                      child: Text(
                                                        'Completed',
                                                        style: FlutterFlowTheme.of(context).labelSmall.override(
                                                          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                                          color: FlutterFlowTheme.of(context).primary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 3.0, 0.0, 0.0),
                                                child: Text(
                                                  '$displayProcedure · $remarks',
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                    font: GoogleFonts.inter(),
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        Icon(
                                                          Icons.calendar_today_rounded,
                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                          size: 14.0,
                                                        ),
                                                        Text(
                                                          dateStr,
                                                          style: FlutterFlowTheme.of(context).labelSmall.override(
                                                            font: GoogleFonts.inter(),
                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                          ),
                                                        ),
                                                      ].divide(SizedBox(width: 4.0)),
                                                    ),
                                                    if (timeStr.isNotEmpty)
                                                      Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Icon(
                                                            Icons.access_time_rounded,
                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                            size: 14.0,
                                                          ),
                                                          Text(
                                                            timeStr,
                                                            style: FlutterFlowTheme.of(context).labelSmall.override(
                                                              font: GoogleFonts.inter(),
                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(width: 4.0)),
                                                      ),
                                                  ],
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
                          );
                        },
                      ),
              ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
