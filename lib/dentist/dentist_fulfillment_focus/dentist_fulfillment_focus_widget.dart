import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/database/database.dart';
import 'dentist_fulfillment_focus_model.dart';
export 'dentist_fulfillment_focus_model.dart';

class DentistFulfillmentFocusWidget extends StatefulWidget {
  const DentistFulfillmentFocusWidget({super.key});

  static String routeName = 'DentistFulfillmentFocus';
  static String routePath = '/dentistFulfillmentFocus';

  @override
  State<DentistFulfillmentFocusWidget> createState() =>
      _DentistFulfillmentFocusWidgetState();
}

class _DentistFulfillmentFocusWidgetState
    extends State<DentistFulfillmentFocusWidget> {
  late DentistFulfillmentFocusModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _doctorName = 'Doctor';
  String _selectedTimeframe = 'Today';
  
  int _totalSlots = 8;
  int _booked = 0;
  int _completed = 0;
  int _missed = 0;
  double _fulfillmentRate = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DentistFulfillmentFocusModel());
    _loadFulfillmentData();
  }

  Future<void> _loadFulfillmentData() async {
    setState(() => _isLoading = true);
    try {
      final docRows = await UserTable().queryRows(
        queryFn: (q) => q.eq('user_id', currentUserUid).limit(1),
      );
      if (docRows.isNotEmpty) {
        _doctorName = docRows.first.fullname ?? 'Doctor';
      }

      final appointments = await AppointmentTable().queryRows(
        queryFn: (q) => q.eq('doctor_id', currentUserUid),
      );

      final now = DateTime.now();
      final todayStr = dateTimeFormat('yyyy-MM-dd', now);

      List<AppointmentRow> filtered = [];
      if (_selectedTimeframe == 'Today') {
        _totalSlots = 8;
        filtered = appointments.where((a) => dateTimeFormat('yyyy-MM-dd', a.appointmentDate) == todayStr).toList();
      } else if (_selectedTimeframe == 'This Week') {
        _totalSlots = 40;
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        filtered = appointments.where((a) {
          final date = a.appointmentDate;
          return date.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
                 date.isBefore(endOfWeek.add(const Duration(seconds: 1)));
        }).toList();
      } else {
        _totalSlots = 160;
        filtered = appointments.where((a) {
          final date = a.appointmentDate;
          return date.year == now.year && date.month == now.month;
        }).toList();
      }

      _booked = filtered.length;
      _completed = filtered.where((a) => a.status?.toLowerCase() == 'completed').length;
      _missed = filtered.where((a) => a.status?.toLowerCase() == 'missed' || a.status?.toLowerCase() == 'cancelled').length;
      
      if (_booked > 0) {
        _fulfillmentRate = _completed / _booked;
      } else {
        _fulfillmentRate = 0.0;
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ratePercent = (_fulfillmentRate * 100).round();
    final dateStr = dateTimeFormat('yMMMMd', DateTime.now());

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
            'Fulfillment Analytics',
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
                      title: const Text('Fulfillment Analytics'),
                      content: const Text(
                        'This dashboard displays your performance metrics including total slots, bookings, completed and missed appointments, along with your overall fulfillment rate.',
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                                  'Hello, Dr. $_doctorName',
                                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                                        font: GoogleFonts.interTight(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                ),
                                Text(
                                  dateStr,
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                        font: GoogleFonts.inter(),
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                      ),
                                ),
                              ],
                            ),
                            Container(
                              width: 100.0,
                              height: 36.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).accent1,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: FlutterFlowDropDown<String>(
                                controller: _model.dropDownValueController ??=
                                    FormFieldController<String>(_selectedTimeframe),
                                options: const ['Today', 'This Week', 'This Month'],
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedTimeframe = val;
                                      _loadFulfillmentData();
                                    });
                                  }
                                },
                                width: 100.0,
                                height: 36.0,
                                textStyle: FlutterFlowTheme.of(context).labelSmall.override(
                                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                      color: FlutterFlowTheme.of(context).primary,
                                    ),
                                hintText: _selectedTimeframe,
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  size: 16.0,
                                ),
                                fillColor: FlutterFlowTheme.of(context).accent1,
                                elevation: 2.0,
                                borderColor: Colors.transparent,
                                borderWidth: 0.0,
                                borderRadius: 8.0,
                                margin: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 4.0, 0.0),
                                hidesUnderline: true,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      // Horizontal stats scroll
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              width: 130.0,
                              height: 85.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 12.0,
                                    color: Color(0x33006EE6),
                                    offset: Offset(0.0, 4.0),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total Slots',
                                      style: FlutterFlowTheme.of(context).labelSmall.override(
                                            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                            color: const Color(0xB3FFFFFF),
                                          ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      '$_totalSlots',
                                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                                            font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                            color: Colors.white,
                                            fontSize: 22.0,
                                          ),
                                    ),
                                    Text(
                                      'Capacity',
                                      style: FlutterFlowTheme.of(context).labelSmall.override(
                                            font: GoogleFonts.inter(),
                                            color: const Color(0x80FFFFFF),
                                            fontSize: 9.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 130.0,
                              height: 85.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                borderRadius: BorderRadius.circular(14.0),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Booked',
                                      style: FlutterFlowTheme.of(context).labelSmall.override(
                                            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                          ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      '$_booked',
                                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                                            font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                            fontSize: 22.0,
                                          ),
                                    ),
                                    Text(
                                      'Appointments',
                                      style: FlutterFlowTheme.of(context).labelSmall.override(
                                            font: GoogleFonts.inter(),
                                            fontSize: 9.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 130.0,
                              height: 85.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                borderRadius: BorderRadius.circular(14.0),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Completed',
                                      style: FlutterFlowTheme.of(context).labelSmall.override(
                                            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                          ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      '$_completed',
                                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                                            font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                            color: const Color(0xFF22C55E),
                                            fontSize: 22.0,
                                          ),
                                    ),
                                    Text(
                                      'Fulfilled',
                                      style: FlutterFlowTheme.of(context).labelSmall.override(
                                            font: GoogleFonts.inter(),
                                            fontSize: 9.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 130.0,
                              height: 85.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                borderRadius: BorderRadius.circular(14.0),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Missed',
                                      style: FlutterFlowTheme.of(context).labelSmall.override(
                                            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                          ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      '$_missed',
                                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                                            font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                            color: const Color(0xFFEF4444),
                                            fontSize: 22.0,
                                          ),
                                    ),
                                    Text(
                                      'No-Shows',
                                      style: FlutterFlowTheme.of(context).labelSmall.override(
                                            font: GoogleFonts.inter(),
                                            fontSize: 9.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ].divide(const SizedBox(width: 10.0))
                              .addToStart(const SizedBox(width: 16.0))
                              .addToEnd(const SizedBox(width: 16.0)),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Fulfillment Rate Circular Card
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
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fulfillment Rate',
                                  style: FlutterFlowTheme.of(context).titleMedium.override(
                                        font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                      ),
                                ),
                                Text(
                                  'Appointment success analytics',
                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                        font: GoogleFonts.inter(),
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                      ),
                                ),
                                const Divider(height: 24.0, thickness: 1.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 120.0,
                                      height: 120.0,
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 120.0,
                                            height: 120.0,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).primaryBackground,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          CircularPercentIndicator(
                                            percent: _fulfillmentRate,
                                            radius: 60.0,
                                            lineWidth: 12.0,
                                            animation: true,
                                            animateFromLastPercent: true,
                                            progressColor: FlutterFlowTheme.of(context).primary,
                                            backgroundColor: FlutterFlowTheme.of(context).alternate,
                                            center: Text(
                                              '$ratePercent%',
                                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                    font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                                    fontSize: 18.0,
                                                  ),
                                            ),
                                            startAngle: 270.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8.0),
                                                  Text(
                                                    'Completed',
                                                    style: FlutterFlowTheme.of(context).labelSmall,
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '$_completed / $_booked',
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 10.0,
                                                    height: 10.0,
                                                    decoration: const BoxDecoration(
                                                      color: Color(0xFFEF4444),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8.0),
                                                  Text(
                                                    'Missed / Cancelled',
                                                    style: FlutterFlowTheme.of(context).labelSmall,
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '$_missed / $_booked',
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 10.0,
                                                    height: 10.0,
                                                    decoration: const BoxDecoration(
                                                      color: Colors.grey,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8.0),
                                                  Text(
                                                    'Total Bookings',
                                                    style: FlutterFlowTheme.of(context).labelSmall,
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '$_booked',
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
