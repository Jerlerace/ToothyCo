import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/database/database.dart';
import 'dentist_patient_focus_model.dart';
export 'dentist_patient_focus_model.dart';

class DentistPatientFocusWidget extends StatefulWidget {
  const DentistPatientFocusWidget({super.key});

  static String routeName = 'DentistPatientFocus';
  static String routePath = '/dentistPatientFocus';
  static UserRow? selectedPatient;

  @override
  State<DentistPatientFocusWidget> createState() =>
      _DentistPatientFocusWidgetState();
}

class _DentistPatientFocusWidgetState extends State<DentistPatientFocusWidget> {
  late DentistPatientFocusModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late Future<List<HistoryRow>> _historyFuture;
  late Future<List<Map<String, dynamic>>> _todaySessionFuture;
  String _doctorName = 'Dr. Dentist';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DentistPatientFocusModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    if (DentistPatientFocusWidget.selectedPatient != null) {
      _loadData();
    }
  }

  void _loadData() {
    _historyFuture = HistoryTable().queryRows(
      queryFn: (q) => q
          .eq('patient_id', DentistPatientFocusWidget.selectedPatient!.userId ?? '')
          .order('created_at', ascending: false),
    );
    _todaySessionFuture = _fetchTodaySession();
    _fetchDoctorName();
  }

  Future<void> _fetchDoctorName() async {
    try {
      final docRows = await UserTable().queryRows(
        queryFn: (q) => q.eq('user_id', currentUserUid).limit(1),
      );
      if (docRows.isNotEmpty) {
        setState(() {
          _doctorName = docRows.first.fullname ?? 'Dr. Dentist';
        });
      }
    } catch (_) {}
  }

  Future<List<Map<String, dynamic>>> _fetchTodaySession() async {
    if (DentistPatientFocusWidget.selectedPatient == null) return [];
    
    final todayStr = dateTimeFormat('yyyy-MM-dd', DateTime.now());
    final appointments = await AppointmentTable().queryRows(
      queryFn: (q) => q
          .eq('patient_id', DentistPatientFocusWidget.selectedPatient!.userId ?? '')
          .eq('doctor_id', currentUserUid)
          .eq('appointment_date', todayStr),
    );
    
    if (appointments.isEmpty) return [];
    
    final procIds = appointments.map((a) => a.procedureId).whereType<String>().toSet().toList();
    final procedures = procIds.isEmpty ? <ProcedureRow>[] : await ProcedureTable().queryRows(
      queryFn: (q) => q.inFilter('procedure_id', procIds),
    );
    
    final procMap = {for (var p in procedures) if (p.procedureId != null) p.procedureId!: p};
    
    List<Map<String, dynamic>> results = [];
    for (var appt in appointments) {
      final proc = procMap[appt.procedureId];
      if (proc != null) {
        results.add({
          'appointment': appt,
          'procedure': proc,
        });
      }
    }
    return results;
  }

  int _calculateTotal(List<Map<String, dynamic>> sessionItems) {
    int total = 0;
    for (var item in sessionItems) {
      final proc = item['procedure'] as ProcedureRow;
      total += proc.pricing ?? 0;
    }
    return total;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (DentistPatientFocusWidget.selectedPatient == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Patient Session'),
        ),
        body: const Center(
          child: Text('No patient selected. Please select a patient from the My Patients list.'),
        ),
      );
    }

    final patient = DentistPatientFocusWidget.selectedPatient!;
    final initials = patient.fullname != null
        ? patient.fullname!.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
        : '??';

    int age = 0;
    if (patient.dateOfBirth != null) {
      age = DateTime.now().year - patient.dateOfBirth!.year;
    }

    final dateOfBirthStr = patient.dateOfBirth != null
        ? dateTimeFormat('yMMMd', patient.dateOfBirth!)
        : 'N/A';

    final List<Map<String, Color>> cardColors = [
      {'bg': const Color(0xFFE3F2FD), 'icon': const Color(0xFF1565C0)},
      {'bg': const Color(0xFFFCE4EC), 'icon': const Color(0xFFC62828)},
      {'bg': const Color(0xFFE8F5E9), 'icon': const Color(0xFF2E7D32)},
    ];

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
            'Patient Session',
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
                      title: const Text('Patient Session'),
                      content: const Text(
                        'This dashboard shows details for the active patient session including demographic details, services provided today, editable clinical notes, and session summary statistics.',
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Header Patient Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 12.0,
                          color: Color(0x331565C0),
                          offset: Offset(0.0, 4.0),
                        )
                      ],
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                        stops: [0.0, 1.0],
                        begin: AlignmentDirectional(1.0, 1.0),
                        end: AlignmentDirectional(-1.0, -1.0),
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 64.0,
                            height: 64.0,
                            decoration: BoxDecoration(
                              color: const Color(0x33FFFFFF),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0x66FFFFFF),
                                width: 2.0,
                              ),
                            ),
                            child: (patient.userImgUrl != null && patient.userImgUrl!.isNotEmpty)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(32.0),
                                    child: Image.network(
                                      patient.userImgUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      initials,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  patient.fullname ?? 'No Name',
                                  style: FlutterFlowTheme.of(context).titleLarge.override(
                                        font: GoogleFonts.interTight(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        color: Colors.white,
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    'DOB: $dateOfBirthStr  •  Age: ${age > 0 ? age : "N/A"}',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          font: GoogleFonts.inter(),
                                          color: const Color(0xCCFFFFFF),
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0x33FFFFFF),
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                          child: Text(
                                            'ID: #${patient.userId?.substring(0, 8) ?? "N/A"}',
                                            style: FlutterFlowTheme.of(context).labelSmall.override(
                                                  font: GoogleFonts.inter(),
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0x4400C853),
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                          child: Text(
                                            patient.status ?? 'Active',
                                            style: FlutterFlowTheme.of(context).labelSmall.override(
                                                  font: GoogleFonts.inter(),
                                                  color: const Color(0xFF69F0A0),
                                                ),
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

                  // Today's Session Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8.0,
                          color: Color(0x14000000),
                          offset: Offset(0.0, 2.0),
                        )
                      ],
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Today's Session",
                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                      font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                    ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF3E0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(
                                        Icons.calendar_today_rounded,
                                        color: Color(0xFFE65100),
                                        size: 14.0,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        dateTimeFormat('yMMMd', DateTime.now()),
                                        style: FlutterFlowTheme.of(context).labelSmall.override(
                                              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                              color: const Color(0xFFE65100),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 20.0,
                            thickness: 1.0,
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: _todaySessionFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              final list = snapshot.data ?? [];
                              if (list.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                    child: Text(
                                      'No services recorded for today.',
                                      style: FlutterFlowTheme.of(context).labelMedium,
                                    ),
                                  ),
                                );
                              }
                              return Column(
                                children: [
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: list.length,
                                    separatorBuilder: (_, __) => Divider(
                                      height: 1.0,
                                      thickness: 1.0,
                                      indent: 58.0,
                                      color: FlutterFlowTheme.of(context).alternate,
                                    ),
                                    itemBuilder: (context, index) {
                                      final item = list[index];
                                      final proc = item['procedure'] as ProcedureRow;
                                      final colors = cardColors[index % cardColors.length];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 36.0,
                                                  height: 36.0,
                                                  decoration: BoxDecoration(
                                                    color: colors['bg'],
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.medical_services_rounded,
                                                    color: colors['icon'],
                                                    size: 18.0,
                                                  ),
                                                ),
                                                const SizedBox(width: 10.0),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      proc.procedureName,
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                                          ),
                                                    ),
                                                    Text(
                                                      proc.procedureDescription ?? proc.category ?? 'Treatment',
                                                      style: FlutterFlowTheme.of(context).labelSmall,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '\$${proc.pricing ?? 0}.00',
                                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                                    font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                                    color: const Color(0xFF1565C0),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  Divider(
                                    height: 20.0,
                                    thickness: 1.0,
                                    color: FlutterFlowTheme.of(context).alternate,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Session Total',
                                        style: FlutterFlowTheme.of(context).titleSmall.override(
                                              font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                            ),
                                      ),
                                      Text(
                                        '\$${_calculateTotal(list)}.00',
                                        style: FlutterFlowTheme.of(context).titleMedium.override(
                                              font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                              color: const Color(0xFF1565C0),
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await context.pushNamed(TreatmentRecordsWidget.routeName);
                                    setState(() {
                                      _todaySessionFuture = _fetchTodaySession();
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE3F2FD),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.add_rounded,
                                            color: Color(0xFF1565C0),
                                            size: 14.0,
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            'Add Service',
                                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                                  color: const Color(0xFF1565C0),
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
                        ],
                      ),
                    ),
                  ),

                  // Clinical Notes Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8.0,
                          color: Color(0x14000000),
                          offset: Offset(0.0, 2.0),
                        )
                      ],
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Clinical Notes',
                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                      font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                    ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE3F2FD),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.edit_note_rounded,
                                        color: Color(0xFF1565C0),
                                        size: 14.0,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        'Editable',
                                        style: FlutterFlowTheme.of(context).labelSmall.override(
                                              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                              color: const Color(0xFF1565C0),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 20.0,
                            thickness: 1.0,
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                          TextFormField(
                            controller: _model.textController,
                            focusNode: _model.textFieldFocusNode,
                            autofocus: false,
                            textCapitalization: TextCapitalization.sentences,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Enter clinical notes, observations, treatment details...',
                              hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(),
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF1565C0),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context).primaryBackground,
                              contentPadding: const EdgeInsets.all(14.0),
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.inter(),
                                  lineHeight: 1.6,
                                ),
                            maxLines: 6,
                            minLines: 4,
                            keyboardType: TextInputType.multiline,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      size: 16.0,
                                    ),
                                    const SizedBox(width: 6.0),
                                    Text(
                                      'Session notes',
                                      style: FlutterFlowTheme.of(context).labelSmall,
                                    ),
                                  ],
                                ),
                                FFButtonWidget(
                                  onPressed: _isSaving
                                      ? null
                                      : () async {
                                          if (_model.textController.text.trim().isEmpty) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Please enter some notes first.')),
                                            );
                                            return;
                                          }
                                          setState(() => _isSaving = true);
                                          try {
                                            final remarksText = 'Category: Session Notes\nProcedure: Clinical Note\nNotes: ${_model.textController?.text ?? ""}';
                                            await HistoryTable().insert({
                                              'patient_id': patient.userId,
                                              'dentist_id': currentUserUid,
                                              'remarks': remarksText,
                                              'created_at': DateTime.now().toIso8601String(),
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Notes saved successfully!')),
                                            );
                                            _model.textController?.clear();
                                            setState(() {
                                              _loadData();
                                            });
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Error saving notes: $e')),
                                            );
                                          } finally {
                                            setState(() => _isSaving = false);
                                          }
                                        },
                                  text: _isSaving ? 'Saving...' : 'Save Notes',
                                  options: FFButtonOptions(
                                    height: 36.0,
                                    color: FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                          font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                          color: Colors.white,
                                          fontSize: 13.0,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Treatment History Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8.0,
                          color: Color(0x14000000),
                          offset: Offset(0.0, 2.0),
                        )
                      ],
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Treatment History',
                            style: FlutterFlowTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                ),
                          ),
                          Divider(
                            height: 20.0,
                            thickness: 1.0,
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                          FutureBuilder<List<HistoryRow>>(
                            future: _historyFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              final list = snapshot.data ?? [];
                              if (list.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                    child: Text(
                                      'No past treatment history found.',
                                      style: FlutterFlowTheme.of(context).labelMedium,
                                    ),
                                  ),
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  final history = list[index];
                                  final remarks = history.remarks ?? '';
                                  String procedure = 'Service';
                                  String notes = remarks;
                                  
                                  if (remarks.contains('Procedure:')) {
                                    final lines = remarks.split('\n');
                                    final procLine = lines.firstWhere((l) => l.startsWith('Procedure:'), orElse: () => '');
                                    if (procLine.isNotEmpty) {
                                      procedure = procLine.substring(10).trim();
                                    }
                                    final notesLine = lines.firstWhere((l) => l.startsWith('Notes:'), orElse: () => '');
                                    if (notesLine.isNotEmpty) {
                                      notes = notesLine.substring(6).trim();
                                    }
                                  }

                                  final isLast = index == list.length - 1;
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: 10.0,
                                            height: 10.0,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF1565C0),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          if (!isLast)
                                            Container(
                                              width: 2.0,
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).alternate,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(width: 12.0),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      procedure,
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                                          ),
                                                    ),
                                                  ),
                                                  Text(
                                                    history.createdAt != null
                                                        ? dateTimeFormat('yMMMd', history.createdAt!)
                                                        : 'N/A',
                                                    style: FlutterFlowTheme.of(context).labelSmall,
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 2.0),
                                                child: Text(
                                                  notes,
                                                  style: FlutterFlowTheme.of(context).labelMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
                    .divide(const SizedBox(height: 16.0))
                    .addToStart(const SizedBox(height: 16.0))
                    .addToEnd(const SizedBox(height: 32.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
