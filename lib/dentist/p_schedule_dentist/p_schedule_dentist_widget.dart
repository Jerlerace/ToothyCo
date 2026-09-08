import '/components/c_delete_confirmation/c_delete_confirmation_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/database/database.dart';
import 'p_schedule_dentist_model.dart';
export 'p_schedule_dentist_model.dart';

/// 3.
///
/// My Availability / Schedule Page
///
/// Design a schedule management page where dentists can select working days,
/// set available hours, add break times, block leave dates, and save
/// schedule. Include calendar preview.
class PScheduleDentistWidget extends StatefulWidget {
  const PScheduleDentistWidget({super.key});

  static String routeName = 'P_Schedule_dentist';
  static String routePath = '/pScheduleDentist';

  @override
  State<PScheduleDentistWidget> createState() => _PScheduleDentistWidgetState();
}

class _PScheduleDentistWidgetState extends State<PScheduleDentistWidget> {
  late PScheduleDentistModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final Map<String, bool> _selectedDays = {
    'Monday': true,
    'Tuesday': true,
    'Wednesday': true,
    'Thursday': true,
    'Friday': true,
    'Saturday': false,
    'Sunday': false,
  };

  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);
  List<LeaveRequestRow> _leaveRequests = [];

  late Future<List<DentistAvailabilityRow>> _availabilityFuture;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PScheduleDentistModel());
    _availabilityFuture = _fetchAvailability();
  }

  Future<List<DentistAvailabilityRow>> _fetchAvailability() async {
    final rows = await DentistAvailabilityTable().queryRows(
      queryFn: (q) => q.eq('dentist_id', currentUserUid),
    );
    final leaveRows = await LeaveRequestTable().queryRows(
      queryFn: (q) => q.eq('dentist_id', currentUserUid).order('start_date', ascending: false),
    );
    _leaveRequests = leaveRows;
    if (rows.isNotEmpty) {
      for (var r in rows) {
        final dayStr = r.day;
        if (_selectedDays.containsKey(dayStr)) {
          _selectedDays[dayStr] = r.isAvail ?? false;
          if (r.isAvail == true && r.startTime.time != null && r.endTime.time != null) {
            _startTime = TimeOfDay.fromDateTime(r.startTime.time!);
            _endTime = TimeOfDay.fromDateTime(r.endTime.time!);
          }
        }
      }
    }
    return rows;
  }

  Future<void> _saveAvailability() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving availability...')),
      );

      final startStr = '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}:00';
      final endStr = '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}:00';

      final existingRows = await DentistAvailabilityTable().queryRows(
        queryFn: (q) => q.eq('dentist_id', currentUserUid),
      );

      final Map<String, DentistAvailabilityRow> existingMap = {
        for (var r in existingRows) r.day: r
      };

      for (var dayName in _selectedDays.keys) {
        final isAvail = _selectedDays[dayName]!;
        final data = {
          'dentist_id': currentUserUid,
          'day': dayName,
          'start_time': startStr,
          'end_time': endStr,
          'is_avail': isAvail,
          'updated_at': DateTime.now().toIso8601String(),
        };

        if (existingMap.containsKey(dayName)) {
          final row = existingMap[dayName]!;
          await DentistAvailabilityTable().update(
            data: data,
            matchingRows: (q) => q.eq('da_id', row.daId!),
          );
        } else {
          await DentistAvailabilityTable().insert(data);
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schedule saved successfully!')),
      );
      
      setState(() {
        _availabilityFuture = _fetchAvailability();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving availability: $e')),
      );
    }
  }

  Future<void> _addLeaveRequest() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      try {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Filing leave request...')),
        );
        
        await LeaveRequestTable().insert({
          'dentist_id': currentUserUid,
          'start_date': picked.start.toIso8601String().split('T').first,
          'end_date': picked.end.toIso8601String().split('T').first,
          'reason': 'Vacation / Leave Request',
          'status': 'Pending',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Leave request filed successfully! Pending Admin approval.')),
        );
        
        setState(() {
          _availabilityFuture = _fetchAvailability();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error filing leave: $e')),
        );
      }
    }
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
            'My Schedule',
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
                        'Schedule & Availability',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily: GoogleFonts.interTight().fontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      content: Text(
                        'Manage your weekly schedule, set active times/breaks, and block specific vacation or leave dates. Click Save to sync availability to the database so patients can see when you are available.',
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
          child: FutureBuilder<List<DentistAvailabilityRow>>(
            future: _availabilityFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        await _saveAvailability();
                      },
                      text: 'Save Availability',
                      icon: const Icon(
                        Icons.save_rounded,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 48.0,
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: GoogleFonts.interTight().fontFamily,
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                        elevation: 2.0,
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
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
                          colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                          stops: [0.0, 1.0],
                          begin: AlignmentDirectional(1.0, 1.0),
                          end: AlignmentDirectional(-1.0, -1.0),
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Schedule',
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
                                        color: Color(0xB3FFFFFF),
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 0.0),
                                  child: Text(
                                    'Dr. Sarah Mitchell',
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
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineSmall
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 2.0, 0.0, 0.0),
                                  child: Text(
                                    'General Dentistry',
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
                                          color: Color(0xCCFFFFFF),
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
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Container(
                              width: 56.0,
                              height: 56.0,
                              decoration: BoxDecoration(
                                color: Color(0x33FFFFFF),
                                shape: BoxShape.circle,
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Icon(
                                  Icons.calendar_today_rounded,
                                  color: Colors.white,
                                  size: 28.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Working Days',
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
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                ),
                                Container(
                                  height: 28.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE3F2FD),
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 12.0, 0.0),
                                      child: Text(
                                        '${_selectedDays.values.where((v) => v).length} selected',
                                        style: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelSmall
                                                        .fontStyle,
                                              ),
                                              color: Color(0xFF1565C0),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(7, (index) {
                                final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
                                final dayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                final dayAbbrevs = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                final dayName = dayNames[index];
                                final dayLetter = dayLetters[index];
                                final dayAbbrev = dayAbbrevs[index];
                                final isSelected = _selectedDays[dayName] ?? false;
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedDays[dayName] = !isSelected;
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 35.0,
                                          height: 35.0,
                                          decoration: BoxDecoration(
                                            color: isSelected ? FlutterFlowTheme.of(context).primary : Color(0xFFF5F5F5),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Align(
                                            alignment: AlignmentDirectional(0.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                dayLetter,
                                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                                  font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                                  color: isSelected ? Colors.white : FlutterFlowTheme.of(context).secondaryText,
                                                  letterSpacing: 0.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          dayAbbrev,
                                          style: FlutterFlowTheme.of(context).labelSmall.override(
                                            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                            color: isSelected ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).secondaryText,
                                            letterSpacing: 0.0,
                                          ),
                                        ),
                                      ].divide(SizedBox(height: 6.0)),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Working Hours',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
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
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Start Time',
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
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
                                      InkWell(
                                        onTap: () async {
                                          final TimeOfDay? picked = await showTimePicker(
                                            context: context,
                                            initialTime: _startTime,
                                          );
                                          if (picked != null) {
                                            setState(() {
                                              _startTime = picked;
                                            });
                                          }
                                        },
                                        child: Container(
                                          height: 52.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF0F4FF),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: Color(0xFFBBDEFB),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    5.0, 0.0, 5.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Icon(
                                                  Icons.access_time_rounded,
                                                  color:
                                                      FlutterFlowTheme.of(context)
                                                          .primary,
                                                  size: 20.0,
                                                ),
                                                Text(
                                                  '${_startTime.hourOfPeriod.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')} ${_startTime.period == DayPeriod.am ? 'AM' : 'PM'}',
                                                  style:
                                                      FlutterFlowTheme.of(context)
                                                          .titleMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .interTight(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .fontStyle,
                                                            ),
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                          ),
                                                ),
                                              ].divide(SizedBox(width: 10.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'End Time',
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
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
                                      InkWell(
                                        onTap: () async {
                                          final TimeOfDay? picked = await showTimePicker(
                                            context: context,
                                            initialTime: _endTime,
                                          );
                                          if (picked != null) {
                                            setState(() {
                                              _endTime = picked;
                                            });
                                          }
                                        },
                                        child: Container(
                                          height: 52.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF0F4FF),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: Color(0xFFBBDEFB),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    5.0, 0.0, 5.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Icon(
                                                  Icons.access_time_rounded,
                                                  color:
                                                      FlutterFlowTheme.of(context)
                                                          .primary,
                                                  size: 20.0,
                                                ),
                                                Text(
                                                  '${_endTime.hourOfPeriod.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')} ${_endTime.period == DayPeriod.am ? 'AM' : 'PM'}',
                                                  style:
                                                      FlutterFlowTheme.of(context)
                                                          .titleMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .interTight(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .fontStyle,
                                                            ),
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                          ),
                                                ),
                                              ].divide(SizedBox(width: 10.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              height: 1.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Appointment Duration',
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
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
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
                                    Text(
                                      'Time per patient slot',
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
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
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
                                  ].divide(SizedBox(height: 4.0)),
                                ),
                                FlutterFlowDropDown<String>(
                                  controller: _model.dropDownValueController ??=
                                      FormFieldController<String>(null),
                                  options: [
                                    '15 min',
                                    '30 min',
                                    '45 min',
                                    '60 min'
                                  ],
                                  onChanged: (val) => safeSetState(
                                      () => _model.dropDownValue = val),
                                  width: 130.0,
                                  height: 44.0,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                  hintText: '30 min',
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 20.0,
                                  ),
                                  fillColor: Color(0xFFF0F4FF),
                                  elevation: 2.0,
                                  borderColor: Color(0xFFBBDEFB),
                                  borderWidth: 1.5,
                                  borderRadius: 12.0,
                                  margin: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 0.0, 8.0, 0.0),
                                  hidesUnderline: true,
                                  isSearchable: false,
                                  isMultiSelect: false,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Max Patients Per Day',
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
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
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
                                    Text(
                                      'Daily appointment limit',
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
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
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
                                  ].divide(SizedBox(height: 4.0)),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: 36.0,
                                      height: 36.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF0F4FF),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Color(0xFFBBDEFB),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Icon(
                                          Icons.remove_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 18.0,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '16',
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
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                    Container(
                                      width: 36.0,
                                      height: 36.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Icon(
                                          Icons.add_rounded,
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ],
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Break Times',
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
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                ),
                                Container(
                                  width: 32.0,
                                  height: 32.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE3F2FD),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Icon(
                                      Icons.add_rounded,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 18.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFAFAFA),
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: Color(0xFFE0E0E0),
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: 40.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFF3E0),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Icon(
                                                Icons.free_breakfast_rounded,
                                                color: Color(0xFFEF6C00),
                                                size: 20.0,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Lunch Break',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                              Text(
                                                '01:00 PM – 02:00 PM',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .labelSmall
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelSmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelSmall
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ].divide(SizedBox(width: 12.0)),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: 28.0,
                                            height: 28.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFE8F5E9),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Icon(
                                                Icons.edit_rounded,
                                                color: Color(0xFF2E7D32),
                                                size: 14.0,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 28.0,
                                            height: 28.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFEBEE),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Icon(
                                                Icons.delete_outline_rounded,
                                                color: Color(0xFFC62828),
                                                size: 14.0,
                                              ),
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 8.0)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFFFAFAFA),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ),
                    ),
                  ),
                ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8.0,
                            color: Color(0x0D000000),
                            offset: Offset(0.0, 2.0),
                          )
                        ],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Leave & Vacation',
                                  style: FlutterFlowTheme.of(context).titleMedium.override(
                                    font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                    letterSpacing: 0.0,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await _addLeaveRequest();
                                  },
                                  child: Container(
                                    width: 32.0,
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE3F2FD),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Icon(
                                        Icons.add_rounded,
                                        color: FlutterFlowTheme.of(context).primary,
                                        size: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (_leaveRequests.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                  'No leaves filed yet.',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                  ),
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _leaveRequests.length,
                                itemBuilder: (context, index) {
                                  final leave = _leaveRequests[index];
                                  Color statusColor = const Color(0xFFF59E0B);
                                  Color statusBgColor = const Color(0xFFFFF7ED);
                                  if (leave.status == 'Approved') {
                                    statusColor = const Color(0xFF10B981);
                                    statusBgColor = const Color(0xFFECFDF5);
                                  } else if (leave.status == 'Rejected') {
                                    statusColor = const Color(0xFFEF4444);
                                    statusBgColor = const Color(0xFFFEF2F2);
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        borderRadius: BorderRadius.circular(12.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context).alternate,
                                          width: 1.0,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.calendar_today_rounded, color: statusColor, size: 16.0),
                                                  const SizedBox(width: 8.0),
                                                  Text(
                                                    '${dateTimeFormat("yMMMd", leave.startDate)} - ${dateTimeFormat("yMMMd", leave.endDate)}',
                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      fontFamily: GoogleFonts.inter().fontFamily,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                                decoration: BoxDecoration(
                                                  color: statusBgColor,
                                                  borderRadius: BorderRadius.circular(6.0),
                                                ),
                                                child: Text(
                                                  leave.status.toUpperCase(),
                                                  style: TextStyle(
                                                    color: statusColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (leave.reason != null && leave.reason!.isNotEmpty) ...[
                                            const SizedBox(height: 6.0),
                                            Text(
                                              'Reason: ${leave.reason}',
                                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                                fontFamily: GoogleFonts.inter().fontFamily,
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                              ),
                                            ),
                                          ],
                                          if (leave.status == 'Pending') ...[
                                            const SizedBox(height: 8.0),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: InkWell(
                                                onTap: () async {
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
                                                                const SnackBar(content: Text('Leave cancelled.')),
                                                              );
                                                              setState(() {
                                                                _availabilityFuture = _fetchAvailability();
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  'Cancel Request',
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                    fontFamily: GoogleFonts.inter().fontFamily,
                                                    color: const Color(0xFFEF4444),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ].divide(SizedBox(height: 12.0)),
                        ),
                      ),
                    ),
                  ),
                ]
                    .divide(SizedBox(height: 20.0))
                    .addToStart(SizedBox(height: 16.0))
                    .addToEnd(SizedBox(height: 32.0)),
              ),
            ),
          );
        },
      ),
    ),
  ),
);
  }
}
