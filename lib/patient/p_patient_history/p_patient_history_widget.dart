import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';
import 'p_patient_history_model.dart';
export 'p_patient_history_model.dart';

/// 8.
///
/// Patient Treatment History
///
/// Design a patient history page where user can see their treatment history
/// with detailed, note, what treatment/procedure was made, the doctor who
/// performed the treatment, the price, and a filter
class PPatientHistoryWidget extends StatefulWidget {
  const PPatientHistoryWidget({super.key});

  static String routeName = 'P_PatientHistory';
  static String routePath = '/pPatientHistory';

  @override
  State<PPatientHistoryWidget> createState() => _PPatientHistoryWidgetState();
}

class HistoryDisplayItem {
  final HistoryRow history;
  final ProcedureRow? procedure;
  final UserRow? dentist;
  final AppointmentRow? appointment;

  HistoryDisplayItem({
    required this.history,
    this.procedure,
    this.dentist,
    this.appointment,
  });
}

class _PPatientHistoryWidgetState extends State<PPatientHistoryWidget> {
  late PPatientHistoryModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<HistoryDisplayItem> allHistoryItems = [];
  List<HistoryDisplayItem> filteredHistoryItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PPatientHistoryModel());
    _model.searchFocusNode = FocusNode();
    _model.searchController = TextEditingController();
    _model.searchController!.addListener(_onSearchOrFilterChanged);
    _loadHistoryData();
  }

  @override
  void dispose() {
    _model.searchController?.removeListener(_onSearchOrFilterChanged);
    _model.searchController?.dispose();
    _model.searchFocusNode?.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadHistoryData() async {
    try {
      final fetchedProcedures = await ProcedureTable().queryRows(queryFn: (q) => q);
      final fetchedDentists = await UserTable().queryRows(queryFn: (q) => q.eq('user_type', 'Dentist'));
      final fetchedAppointments = await AppointmentTable().queryRows(queryFn: (q) => q.eq('patient_id', currentUserUid));
      final fetchedHistory = await HistoryTable().queryRows(queryFn: (q) => q.eq('patient_id', currentUserUid));

      final procMap = {for (var p in fetchedProcedures) if (p.procedureId != null) p.procedureId!: p};
      final dentistMap = {for (var d in fetchedDentists) if (d.userId != null) d.userId!: d};
      final appMap = {for (var a in fetchedAppointments) if (a.appointmentId != null) a.appointmentId!: a};

      final List<HistoryDisplayItem> items = [];
      for (var hist in fetchedHistory) {
        items.add(HistoryDisplayItem(
          history: hist,
          procedure: procMap[hist.procedureId],
          dentist: dentistMap[hist.dentistId],
          appointment: appMap[hist.appointmentId],
        ));
      }

      items.sort((a, b) {
        final dateA = a.history.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final dateB = b.history.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return dateB.compareTo(dateA);
      });

      setState(() {
        allHistoryItems = items;
        filteredHistoryItems = items;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading history data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onSearchOrFilterChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    final query = _model.searchController?.text.toLowerCase() ?? '';
    final statusFilter = _model.choiceChipsValue ?? 'All';

    setState(() {
      filteredHistoryItems = allHistoryItems.where((item) {
        final procName = item.procedure?.procedureName.toLowerCase() ?? '';
        final procCat = item.procedure?.category?.toLowerCase() ?? '';
        final remarks = item.history.remarks?.toLowerCase() ?? '';
        final dentName = item.dentist?.fullname?.toLowerCase() ?? '';
        
        final matchesQuery = query.isEmpty ||
            procName.contains(query) ||
            procCat.contains(query) ||
            remarks.contains(query) ||
            dentName.contains(query);

        final appStatus = item.appointment?.status ?? 'Completed';
        bool matchesStatus = true;
        if (statusFilter == 'Completed') {
          matchesStatus = appStatus == 'Completed';
        } else if (statusFilter == 'Ongoing') {
          matchesStatus = appStatus == 'Approved' || appStatus == 'Pending';
        } else if (statusFilter == 'Cancelled') {
          matchesStatus = appStatus == 'Cancelled';
        }

        return matchesQuery && matchesStatus;
      }).toList();
    });
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
            'Treatment History',
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
                      title: const Text('Treatment History'),
                      content: const Text(
                        'This page shows your past dental treatments and procedures, performed by your dentists, clinical notes, and their cost details.',
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 0.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Icon(Icons.search_rounded, size: 20.0),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _model.searchController,
                                focusNode: _model.searchFocusNode,
                                decoration: const InputDecoration(
                                  hintText: 'Search treatments...',
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium,
                                onChanged: (_) => _applyFilters(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                  child: FlutterFlowChoiceChips(
                    options: [
                      ChipData('All'),
                      ChipData('Completed'),
                      ChipData('Ongoing'),
                      ChipData('Cancelled')
                    ],
                    onChanged: (val) {
                      safeSetState(() => _model.choiceChipsValue = val?.firstOrNull);
                      _applyFilters();
                    },
                    selectedChipStyle: ChipStyle(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).labelMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                                color: Colors.white,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                      iconColor: Color(0x00000000),
                      iconSize: 0.0,
                      elevation: 0.0,
                      borderColor: FlutterFlowTheme.of(context).primary,
                      borderWidth: 1.0,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    unselectedChipStyle: ChipStyle(
                      backgroundColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      textStyle: FlutterFlowTheme.of(context)
                          .labelMedium
                          .override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontStyle,
                          ),
                      iconColor: Color(0x00000000),
                      iconSize: 0.0,
                      elevation: 0.0,
                      borderColor: FlutterFlowTheme.of(context).alternate,
                      borderWidth: 1.0,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    chipSpacing: 8.0,
                    rowSpacing: 8.0,
                    multiselect: false,
                    initialized: _model.choiceChipsValue != null,
                    alignment: WrapAlignment.start,
                    controller: _model.choiceChipsValueController ??=
                        FormFieldController<List<String>>(
                      ['All'],
                    ),
                    wrapped: true,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filteredHistoryItems.length} records found',
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontStyle,
                          ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.filter_list_rounded,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 16.0,
                        ),
                        Text(
                          'Sort by Date',
                          style:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                        ),
                      ].divide(SizedBox(width: 4.0)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isLoading
                    ? Center(
                        child: SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                      )
                    : filteredHistoryItems.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                'No treatment records found.',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            itemCount: filteredHistoryItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredHistoryItems[index];
                              final procName = item.procedure?.procedureName ?? 'General Treatment';
                              final procCat = item.procedure?.category ?? 'General';
                              final dentName = item.dentist?.fullname ?? 'Dentist';
                              final cost = item.procedure?.pricing ?? 0;
                              final dateStr = item.history.createdAt != null
                                  ? DateFormat('MMMM dd, yyyy').format(item.history.createdAt!)
                                  : (item.appointment != null
                                      ? DateFormat('MMMM dd, yyyy').format(item.appointment!.appointmentDate)
                                      : 'N/A');
                              final status = item.appointment?.status ?? 'Completed';
                              
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 8.0,
                                        color: Color(0x1A000000),
                                        offset: Offset(0.0, 2.0),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                FlutterFlowTheme.of(context).primary,
                                                const Color(0xFF3A7BD5)
                                              ],
                                              stops: const [0.0, 1.0],
                                              begin: AlignmentDirectional.topEnd,
                                              end: AlignmentDirectional.bottomStart,
                                            ),
                                            borderRadius: BorderRadius.circular(16.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'TREATMENT DATE',
                                                      style: FlutterFlowTheme.of(context).labelSmall.override(
                                                            fontFamily: GoogleFonts.inter().fontFamily,
                                                            color: const Color(0xAAFFFFFF),
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                    ),
                                                    Text(
                                                      dateStr,
                                                      style: FlutterFlowTheme.of(context).titleMedium.override(
                                                            fontFamily: GoogleFonts.interTight().fontFamily,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0x33FFFFFF),
                                                    borderRadius: BorderRadius.circular(14.0),
                                                  ),
                                                  child: Text(
                                                    status,
                                                    style: FlutterFlowTheme.of(context).labelSmall.override(
                                                          fontFamily: GoogleFonts.inter().fontFamily,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 0.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 44.0,
                                                    height: 44.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).accent1,
                                                      borderRadius: BorderRadius.circular(12.0),
                                                    ),
                                                    child: Align(
                                                      alignment: AlignmentDirectional.center,
                                                      child: Icon(
                                                        Icons.medical_services_outlined,
                                                        color: FlutterFlowTheme.of(context).primary,
                                                        size: 22.0,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          procName,
                                                          style: FlutterFlowTheme.of(context).titleSmall.override(
                                                                fontFamily: GoogleFonts.interTight().fontFamily,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Text(
                                                          procCat,
                                                          style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                fontFamily: GoogleFonts.inter().fontFamily,
                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                height: 20.0,
                                                thickness: 1.0,
                                                color: FlutterFlowTheme.of(context).alternate,
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 44.0,
                                                    height: 44.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).accent2,
                                                      borderRadius: BorderRadius.circular(12.0),
                                                    ),
                                                    child: Align(
                                                      alignment: AlignmentDirectional.center,
                                                      child: Icon(
                                                        Icons.person_outlined,
                                                        color: FlutterFlowTheme.of(context).secondary,
                                                        size: 22.0,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'PERFORMED BY',
                                                          style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                fontFamily: GoogleFonts.inter().fontFamily,
                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                        ),
                                                        Text(
                                                          dentName,
                                                          style: FlutterFlowTheme.of(context).titleSmall.override(
                                                                fontFamily: GoogleFonts.interTight().fontFamily,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                height: 20.0,
                                                thickness: 1.0,
                                                color: FlutterFlowTheme.of(context).alternate,
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 44.0,
                                                    height: 44.0,
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFFF0FDF4),
                                                      borderRadius: BorderRadius.circular(12.0),
                                                    ),
                                                    child: const Align(
                                                      alignment: AlignmentDirectional.center,
                                                      child: Icon(
                                                        Icons.notes_rounded,
                                                        color: Colors.green,
                                                        size: 22.0,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'CLINICAL NOTES',
                                                          style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                fontFamily: GoogleFonts.inter().fontFamily,
                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                        ),
                                                        const SizedBox(height: 4),
                                                        Text(
                                                          item.history.remarks ?? 'No clinical notes provided.',
                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                fontFamily: GoogleFonts.inter().fontFamily,
                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                lineHeight: 1.5,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                height: 20.0,
                                                thickness: 1.0,
                                                color: FlutterFlowTheme.of(context).alternate,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 44.0,
                                                        height: 44.0,
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xFFFEF3C7),
                                                          borderRadius: BorderRadius.circular(12.0),
                                                        ),
                                                        child: const Align(
                                                          alignment: AlignmentDirectional.center,
                                                          child: Icon(
                                                            Icons.attach_money_rounded,
                                                            color: Color(0xFFF59E0B),
                                                            size: 22.0,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            'TOTAL COST',
                                                            style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                  fontFamily: GoogleFonts.inter().fontFamily,
                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                          ),
                                                          Text(
                                                            '₱$cost',
                                                            style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                  fontFamily: GoogleFonts.interTight().fontFamily,
                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
