import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'p_book_appointment_patient_model.dart';
export 'p_book_appointment_patient_model.dart';

class PBookAppointmentPatientWidget extends StatefulWidget {
  const PBookAppointmentPatientWidget({
    super.key,
    this.initialDentistId,
    this.initialProcedureId,
    this.rescheduleAppointmentId,
  });

  final String? initialDentistId;
  final String? initialProcedureId;
  final String? rescheduleAppointmentId;

  static String routeName = 'P_BookAppointment_patient';
  static String routePath = '/pBookAppointmentPatient';

  @override
  State<PBookAppointmentPatientWidget> createState() =>
      _PBookAppointmentPatientWidgetState();
}

class _PBookAppointmentPatientWidgetState
    extends State<PBookAppointmentPatientWidget> {
  late PBookAppointmentPatientModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Database lists
  List<ProcedureRow> procedures = [];
  List<UserRow> dentists = [];
  Map<String, String> dentistSpecializations = {};
  List<LeaveRequestRow> activeLeavesForSelectedDate = [];
  bool isLoadingData = true;

  // Selected details for display
  ProcedureRow? selectedProcedure;
  UserRow? selectedDentist;

  // Slots lists
  List<String> availableSlots = [];
  List<String> aiSuggestedSlots = [];
  bool isLoadingSlots = false;

  // Slide-down notification state
  bool showNotification = false;
  String notificationMessage = '';

  final List<String> _defaultSlots = [
    '09:00:00',
    '10:00:00',
    '11:00:00',
    '13:00:00',
    '14:00:00',
    '15:00:00',
    '16:00:00',
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PBookAppointmentPatientModel());
    _loadInitialData();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final fetchedProcedures = await ProcedureTable().queryRows(queryFn: (q) => q.eq('status', 'Active')).catchError((_) => <ProcedureRow>[]);
      final fetchedDentists = await UserTable().queryRows(queryFn: (q) => q.eq('user_type', 'Dentist')).catchError((_) => <UserRow>[]);
      final fetchedDentistDetails = await DentistTable().queryRows(queryFn: (q) => q).catchError((_) => <DentistRow>[]);
      
      setState(() {
        dentistSpecializations = {
          for (var d in fetchedDentistDetails) d.dentistId: d.specialization ?? 'General Dentistry'
        };
        if (fetchedProcedures.isEmpty) {
          procedures = [
            ProcedureRow({'procedure_id': 'proc_1', 'procedure_name': 'Teeth Cleaning', 'pricing': 1500, 'category': 'General', 'status': 'Active'}),
            ProcedureRow({'procedure_id': 'proc_2', 'procedure_name': 'Teeth Whitening', 'pricing': 3000, 'category': 'Cosmetic', 'status': 'Active'}),
            ProcedureRow({'procedure_id': 'proc_3', 'procedure_name': 'Dental Filling', 'pricing': 2000, 'category': 'Restorative', 'status': 'Active'}),
            ProcedureRow({'procedure_id': 'proc_4', 'procedure_name': 'Root Canal', 'pricing': 8000, 'category': 'Endodontic', 'status': 'Active'}),
          ];
        } else {
          procedures = fetchedProcedures;
        }

        if (fetchedDentists.isEmpty) {
          dentists = [
            UserRow({'user_id': 'dentist_1', 'fullname': 'Dr. Sarah Mitchell', 'user_type': 'Dentist'}),
            UserRow({'user_id': 'dentist_2', 'fullname': 'Dr. James Carter', 'user_type': 'Dentist'}),
            UserRow({'user_id': 'dentist_3', 'fullname': 'Dr. Priya Nair', 'user_type': 'Dentist'}),
          ];
        } else {
          dentists = fetchedDentists;
        }

        if (widget.initialProcedureId != null) {
          _model.selectedProcedureId = widget.initialProcedureId;
          try {
            selectedProcedure = procedures.firstWhere((p) => p.procedureId == widget.initialProcedureId);
          } catch (_) {}
        }

        if (widget.initialDentistId != null) {
          _model.selectedDentistId = widget.initialDentistId;
          try {
            selectedDentist = dentists.firstWhere((d) => d.userId == widget.initialDentistId);
          } catch (_) {}
        }

        isLoadingData = false;
      });

      if (widget.rescheduleAppointmentId != null) {
        try {
          final resAppList = await AppointmentTable().queryRows(
            queryFn: (q) => q.eq('appointment_id', widget.rescheduleAppointmentId!),
          );
          if (resAppList.isNotEmpty) {
            final resApp = resAppList.first;
            setState(() {
              _model.selectedProcedureId = resApp.procedureId;
              try {
                selectedProcedure = procedures.firstWhere((p) => p.procedureId == resApp.procedureId);
              } catch (_) {}

              _model.selectedDentistId = resApp.doctorId;
              try {
                selectedDentist = dentists.firstWhere((d) => d.userId == resApp.doctorId);
              } catch (_) {}

              _model.selectedDate = resApp.appointmentDate;
              _model.notesTextController?.text = resApp.notes ?? '';
            });
            await _updateLeavesForSelectedDate();
            _updateTimeSlots();
          }
        } catch (e) {
          print('Error loading reschedule appointment: $e');
        }
      } else {
        if (_model.selectedDate != null) {
          await _updateLeavesForSelectedDate();
        }
        if (_model.selectedDentistId != null) {
          _updateTimeSlots();
        }
      }
    } catch (e) {
      print('Error loading master data: $e');
      setState(() {
        isLoadingData = false;
      });
    }
  }

  Future<void> _updateLeavesForSelectedDate() async {
    if (_model.selectedDate == null) {
      setState(() {
        activeLeavesForSelectedDate = [];
      });
      return;
    }
    try {
      final date = _model.selectedDate!;
      final leaves = await LeaveRequestTable().queryRows(
        queryFn: (q) => q.eq('status', 'Approved'),
      );
      final targetDate = DateTime(date.year, date.month, date.day);
      setState(() {
        activeLeavesForSelectedDate = leaves.where((leave) {
          final start = DateTime(leave.startDate.year, leave.startDate.month, leave.startDate.day);
          final end = DateTime(leave.endDate.year, leave.endDate.month, leave.endDate.day);
          return (targetDate.isAfter(start) || targetDate.isAtSameMomentAs(start)) &&
                 (targetDate.isBefore(end) || targetDate.isAtSameMomentAs(end));
        }).toList();
      });
    } catch (e) {
      print('Error updating leaves: $e');
    }
  }

  List<String> _generateSlots(PostgresTime start, PostgresTime end) {
    List<String> slots = [];
    if (start.time == null || end.time == null) return slots;
    int startHour = start.time!.hour;
    int endHour = end.time!.hour;
    for (int h = startHour; h < endHour; h++) {
      slots.add('${h.toString().padLeft(2, '0')}:00:00');
    }
    return slots;
  }

  Future<void> _updateTimeSlots() async {
    if (_model.selectedDentistId == null || _model.selectedDate == null) {
      setState(() {
        availableSlots = [];
        aiSuggestedSlots = [];
      });
      return;
    }

    setState(() {
      isLoadingSlots = true;
    });

    final dentistOnLeave = activeLeavesForSelectedDate.any((leave) => leave.dentistId == _model.selectedDentistId);
    if (dentistOnLeave) {
      setState(() {
        availableSlots = [];
        aiSuggestedSlots = [];
        isLoadingSlots = false;
      });
      return;
    }

    try {
      final date = _model.selectedDate!;
      final daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      final selectedDayStr = daysOfWeek[date.weekday - 1];

      // 1. Fetch dentist availability
      final availRows = await DentistAvailabilityTable().queryRows(
        queryFn: (q) => q
            .eq('dentist_id', _model.selectedDentistId!)
            .eq('day', selectedDayStr)
            .eq('is_avail', true),
      );

      List<String> generated = [];
      if (availRows.isNotEmpty) {
        for (var row in availRows) {
          generated.addAll(_generateSlots(row.startTime, row.endTime));
        }
      } else {
        generated = List.from(_defaultSlots);
      }

      // 2. Fetch existing bookings on selected date
      final dateIsoStr = date.toIso8601String().split('T').first;
      final appointments = await AppointmentTable().queryRows(
        queryFn: (q) => q
            .eq('doctor_id', _model.selectedDentistId!)
            .eq('appointment_date', dateIsoStr)
            .neq('status', 'Cancelled'),
      );

      final bookedTimes = appointments
          .where((app) => widget.rescheduleAppointmentId == null || app.appointmentId != widget.rescheduleAppointmentId)
          .map((app) => app.appointmentTime.toIso8601String() ?? '')
          .toSet();

      // Filter out double-booked slots
      final filtered = generated.where((slot) {
        return !bookedTimes.any((bt) => bt.startsWith(slot.substring(0, 5)));
      }).toList();

      // 3. AI optimal prediction slots (TC008)
      // Fetch historical clinic bookings for this dentist to find quiet periods
      final allApps = await AppointmentTable().queryRows(
        queryFn: (q) => q.eq('doctor_id', _model.selectedDentistId!),
      );

      Map<String, int> timeSlotTraffic = {};
      for (var app in allApps) {
        final timeStr = app.appointmentTime.toIso8601String()?.substring(0, 2) ?? '09';
        timeSlotTraffic[timeStr] = (timeSlotTraffic[timeStr] ?? 0) + 1;
      }

      // Filter slots by morning/afternoon preference
      List<String> prefSlots = filtered.where((slot) {
        int hour = int.parse(slot.split(':').first);
        return _model.aiPreference == 'Morning' ? hour < 12 : hour >= 12;
      }).toList();

      // Sort slots by lowest historical volume (meaning less clinic traffic)
      prefSlots.sort((a, b) {
        final trafficA = timeSlotTraffic[a.substring(0, 2)] ?? 0;
        final trafficB = timeSlotTraffic[b.substring(0, 2)] ?? 0;
        return trafficA.compareTo(trafficB);
      });

      setState(() {
        availableSlots = filtered;
        aiSuggestedSlots = prefSlots.take(3).toList();
        isLoadingSlots = false;
      });
    } catch (e) {
      print('Error updating slots: $e');
      setState(() {
        isLoadingSlots = false;
      });
    }
  }

  void _triggerPushNotification(String text) {
    setState(() {
      notificationMessage = text;
      showNotification = true;
    });
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          showNotification = false;
        });
      }
    });
  }

  String generateUUID() {
    final r = DateTime.now().microsecondsSinceEpoch;
    String hex(int val, int len) => val.toRadixString(16).padLeft(len, '0');
    return '${hex(r & 0xFFFFFFFF, 8)}-${hex((r >> 32) & 0xFFFF, 4)}-4${hex((r >> 48) & 0xFFF, 3)}-8${hex((r >> 56) & 0xFFF, 3)}-${hex(r & 0xFFFFFFFFFFFF, 12)}';
  }

  Future<void> _handleBookingSubmit() async {
    if (_model.selectedProcedureId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a procedure')),
      );
      return;
    }
    if (_model.selectedDentistId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a dentist')),
      );
      return;
    }
    if (_model.selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a date')),
      );
      return;
    }
    if (_model.selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time slot')),
      );
      return;
    }

    try {
      final dateIsoStr = _model.selectedDate!.toIso8601String().split('T').first;

      // Real-time double-booking check right before insertion
      final existing = await AppointmentTable().queryRows(
        queryFn: (q) => q
            .eq('doctor_id', _model.selectedDentistId!)
            .eq('appointment_date', dateIsoStr)
            .neq('status', 'Cancelled'),
      );

      final isDoubleBooked = existing.any((app) {
        if (widget.rescheduleAppointmentId != null && app.appointmentId == widget.rescheduleAppointmentId) {
          return false;
        }
        final timeStr = app.appointmentTime.toIso8601String() ?? '';
        return timeStr.startsWith(_model.selectedTime!.substring(0, 5));
      });

      if (isDoubleBooked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: This slot was just booked by another user. Please choose a different slot.')),
        );
        _updateTimeSlots();
        return;
      }

      final dentistName = selectedDentist?.fullname ?? 'Dentist';
      final procedureName = selectedProcedure?.procedureName ?? 'General Visit';
      final dateFormatted = DateFormat('MMM dd, yyyy').format(_model.selectedDate!);
      final timeFormatted = _model.selectedTime!.substring(0, 5);
      final patientName = currentUserDisplayName.isNotEmpty ? currentUserDisplayName : 'A patient';

      if (widget.rescheduleAppointmentId != null) {
        await AppointmentTable().update(
          data: {
            'doctor_id': _model.selectedDentistId,
            'procedure_id': _model.selectedProcedureId,
            'appointment_date': dateIsoStr,
            'appointment_time': _model.selectedTime,
            'notes': _model.notesTextController?.text.trim() ?? '',
            'status': 'Pending',
            'updated_at': DateTime.now().toIso8601String(),
          },
          matchingRows: (rows) => rows.eq('appointment_id', widget.rescheduleAppointmentId!),
        );

        await NotificationTable().insert({
          'notification_id': generateUUID(),
          'user_id': _model.selectedDentistId!,
          'title': 'Appointment Rescheduled',
          'body': '$patientName rescheduled their appointment for $procedureName to $dateFormatted at $timeFormatted.',
          'type': 'Reschedule',
          'reference_id': widget.rescheduleAppointmentId,
          'is_read': false,
          'created_at': DateTime.now().toIso8601String(),
        });
      } else {
        final newAppId = generateUUID();
        await AppointmentTable().insert({
          'appointment_id': newAppId,
          'patient_id': currentUserUid,
          'doctor_id': _model.selectedDentistId,
          'procedure_id': _model.selectedProcedureId,
          'appointment_date': dateIsoStr,
          'appointment_time': _model.selectedTime,
          'notes': _model.notesTextController?.text.trim() ?? '',
          'status': 'Pending',
          'created_at': DateTime.now().toIso8601String(),
        });

        await NotificationTable().insert({
          'notification_id': generateUUID(),
          'user_id': _model.selectedDentistId!,
          'title': 'New Appointment Scheduled',
          'body': '$patientName scheduled a new appointment for $procedureName on $dateFormatted at $timeFormatted.',
          'type': 'Appointment',
          'reference_id': newAppId,
          'is_read': false,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      setState(() {
        _model.selectedProcedureId = null;
        _model.selectedDentistId = null;
        _model.selectedDate = null;
        _model.selectedTime = null;
        selectedProcedure = null;
        selectedDentist = null;
        _model.notesTextController?.clear();
        availableSlots = [];
        aiSuggestedSlots = [];
      });

      context.safePop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🔔 Booking Confirmed!\nYour appointment with $dentistName on $dateFormatted at $timeFormatted is scheduled.'),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      print('Error saving booking: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving booking: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
            'Book Appointment',
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
                        'Book Appointment',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily: GoogleFonts.interTight().fontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      content: Text(
                        'Schedule a dental appointment. Select a procedure, choose your preferred dentist, select an available date/time slot, and confirm your booking.',
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
        body: Stack(
          children: [
            // Main Body Content
            isLoadingData
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                    top: true,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Select dental procedure and dentist',
                              style: FlutterFlowTheme.of(context).labelMedium,
                            ),
                            const SizedBox(height: 16.0),


  // UI Selection elements
                            // Procedure Selection Selector
                            Card(
                              elevation: 0,
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: Icon(Icons.medical_services_outlined, color: FlutterFlowTheme.of(context).primary),
                                title: Text(
                                  selectedProcedure == null
                                      ? 'Choose Procedure'
                                      : selectedProcedure!.procedureName,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.inter(),
                                        fontWeight: selectedProcedure != null ? FontWeight.bold : FontWeight.normal,
                                      ),
                                ),
                                trailing: const Icon(Icons.search_rounded),
                                onTap: () async {
                                  final proc = await _showSearchableProcedurePicker(context);
                                  if (proc != null) {
                                    setState(() {
                                      _model.selectedProcedureId = proc.procedureId;
                                      selectedProcedure = proc;
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 12.0),

                            // Dentist Selection Selector
                            Card(
                              elevation: 0,
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: Icon(Icons.person_outline, color: FlutterFlowTheme.of(context).primary),
                                title: Text(
                                  selectedDentist == null
                                      ? 'Choose Dentist'
                                      : (selectedDentist!.fullname ?? 'Dentist'),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.inter(),
                                        fontWeight: selectedDentist != null ? FontWeight.bold : FontWeight.normal,
                                      ),
                                ),
                                trailing: const Icon(Icons.search_rounded),
                                onTap: () async {
                                  final dentist = await _showSearchableDentistPicker(context);
                                  if (dentist != null) {
                                    setState(() {
                                      _model.selectedDentistId = dentist.userId;
                                      selectedDentist = dentist;
                                      _model.selectedTime = null;
                                    });
                                    _updateTimeSlots();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 16.0),

                            // Dynamic Price Card (TC005 Cost Transparency)
                            if (selectedProcedure != null)
                              Container(
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).accent1,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: FlutterFlowTheme.of(context).primary, width: 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.local_offer, color: FlutterFlowTheme.of(context).primary),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Estimated Cost',
                                              style: FlutterFlowTheme.of(context).labelSmall.override(
                                                    font: GoogleFonts.inter(),
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                  ),
                                            ),
                                            Text(
                                              '₱${selectedProcedure!.pricing ?? 0}',
                                              style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                    font: GoogleFonts.interTight(),
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16.0),

                            // Date Selection Card
                            Card(
                              elevation: 0,
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: Icon(Icons.calendar_month, color: FlutterFlowTheme.of(context).primary),
                                title: Text(
                                  _model.selectedDate == null
                                      ? 'Choose Appointment Date'
                                      : DateFormat('EEEE, MMMM dd, yyyy').format(_model.selectedDate!),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.inter(),
                                        fontWeight: _model.selectedDate != null ? FontWeight.bold : FontWeight.normal,
                                      ),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now().add(const Duration(days: 1)),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 90)),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      _model.selectedDate = pickedDate;
                                      _model.selectedTime = null;
                                    });
                                    await _updateLeavesForSelectedDate();
                                    _updateTimeSlots();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 16.0),

                            // AI slot prediction section (TC008)
                            if (_model.selectedDentistId != null && _model.selectedDate != null) ...[
                              Text(
                                'Preferred Time of Day (for AI Slots)',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.inter(),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  ChoiceChip(
                                    label: const Text('Morning'),
                                    selected: _model.aiPreference == 'Morning',
                                    selectedColor: FlutterFlowTheme.of(context).primary,
                                    labelStyle: TextStyle(
                                      color: _model.aiPreference == 'Morning' ? Colors.white : Colors.black,
                                    ),
                                    onSelected: (val) {
                                      if (val) {
                                        setState(() {
                                          _model.aiPreference = 'Morning';
                                        });
                                        _updateTimeSlots();
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 8.0),
                                  ChoiceChip(
                                    label: const Text('Afternoon'),
                                    selected: _model.aiPreference == 'Afternoon',
                                    selectedColor: FlutterFlowTheme.of(context).primary,
                                    labelStyle: TextStyle(
                                      color: _model.aiPreference == 'Afternoon' ? Colors.white : Colors.black,
                                    ),
                                    onSelected: (val) {
                                      if (val) {
                                        setState(() {
                                          _model.aiPreference = 'Afternoon';
                                        });
                                        _updateTimeSlots();
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12.0),
                              Text(
                                '🤖 Suggested Optimal Slots (Lowest Traffic)',
                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                      font: GoogleFonts.inter(),
                                      color: FlutterFlowTheme.of(context).primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8.0),
                              isLoadingSlots
                                  ? const Center(child: Padding(padding: EdgeInsets.all(8.0), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))))
                                  : aiSuggestedSlots.isEmpty
                                      ? Text('No slots fit your preference.', style: FlutterFlowTheme.of(context).bodySmall)
                                      : Wrap(
                                          spacing: 8.0,
                                          children: aiSuggestedSlots.map((slot) {
                                            final isSelected = _model.selectedTime == slot;
                                            return ChoiceChip(
                                              label: Text(slot.substring(0, 5)),
                                              selected: isSelected,
                                              selectedColor: FlutterFlowTheme.of(context).primary,
                                              labelStyle: TextStyle(
                                                color: isSelected ? Colors.white : Colors.black,
                                              ),
                                              onSelected: (selected) {
                                                setState(() {
                                                  _model.selectedTime = selected ? slot : null;
                                                });
                                              },
                                            );
                                          }).toList(),
                                        ),
                              const SizedBox(height: 16.0),
                            ],

                            // Time Slots Section
                            if (_model.selectedDentistId != null && _model.selectedDate != null) ...[
                              Text(
                                'Available Time Slots',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.inter(),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8.0),
                              isLoadingSlots
                                  ? const Center(child: CircularProgressIndicator())
                                  : availableSlots.isEmpty
                                      ? Text(
                                          'No slots available on this day. Please choose another date.',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                font: GoogleFonts.inter(),
                                                color: Colors.red,
                                              ),
                                        )
                                      : Wrap(
                                          spacing: 8.0,
                                          runSpacing: 4.0,
                                          children: availableSlots.map((slot) {
                                            final isSelected = _model.selectedTime == slot;
                                            return ChoiceChip(
                                              label: Text(slot.substring(0, 5)),
                                              selected: isSelected,
                                              selectedColor: FlutterFlowTheme.of(context).primary,
                                              labelStyle: TextStyle(
                                                color: isSelected ? Colors.white : Colors.black,
                                              ),
                                              onSelected: (selected) {
                                                setState(() {
                                                  _model.selectedTime = selected ? slot : null;
                                                });
                                              },
                                            );
                                          }).toList(),
                                        ),
                              const SizedBox(height: 16.0),
                            ],

                            // Notes/Concerns input field
                            Text(
                              'Notes / Concerns',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: _model.notesTextController,
                              focusNode: _model.notesFocusNode,
                              decoration: InputDecoration(
                                hintText: 'Type any details or symptoms here...',
                                hintStyle: FlutterFlowTheme.of(context).labelMedium,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).alternate,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                              ),
                              maxLines: 3,
                            ),
                            // Submit Button
                            FFButtonWidget(
                              onPressed: _handleBookingSubmit,
                              text: 'Schedule Appointment',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 50.0,
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                      font: GoogleFonts.interTight(),
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                elevation: 2.0,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            if (widget.rescheduleAppointmentId != null) ...[
                              FFButtonWidget(
                                onPressed: () async {
                                  context.safePop();
                                },
                                text: 'Cancel Editing',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 50.0,
                                  color: Colors.transparent,
                                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: GoogleFonts.interTight().fontFamily,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).alternate,
                                    width: 1.0,
                                  ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              FFButtonWidget(
                                onPressed: () async {
                                  // Enforce 12-hour cancel policy
                                  DateTime? appDateTime;
                                  if (_model.selectedDate != null) {
                                    if (_model.selectedTime != null) {
                                      final timeVal = PostgresTime.tryParse(_model.selectedTime!)?.time;
                                      if (timeVal != null) {
                                        appDateTime = DateTime(
                                          _model.selectedDate!.year,
                                          _model.selectedDate!.month,
                                          _model.selectedDate!.day,
                                          timeVal.hour,
                                          timeVal.minute,
                                          timeVal.second,
                                        );
                                      }
                                    }
                                    appDateTime ??= DateTime(
                                      _model.selectedDate!.year,
                                      _model.selectedDate!.month,
                                      _model.selectedDate!.day,
                                      12, 0, 0,
                                    );
                                  }

                                  if (appDateTime != null) {
                                    final diff = appDateTime.difference(DateTime.now());
                                    if (diff.isNegative || diff.inHours < 12) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Cannot cancel appointments scheduled in less than 12 hours.'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                  }

                                  final confirmCancel = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Cancel Appointment'),
                                      content: const Text('Are you sure you want to cancel this appointment? This action cannot be undone.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                                          child: const Text('Yes, Cancel'),
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
                                        matchingRows: (rows) => rows.eq('appointment_id', widget.rescheduleAppointmentId!),
                                      );

                                      final patientName = currentUserDisplayName.isNotEmpty ? currentUserDisplayName : 'A patient';
                                      final procName = selectedProcedure?.procedureName ?? 'General Visit';
                                      final dateFormatted = _model.selectedDate != null ? DateFormat('MMM dd, yyyy').format(_model.selectedDate!) : '';
                                      final timeFormatted = _model.selectedTime != null ? _model.selectedTime!.substring(0, 5) : '';

                                      if (_model.selectedDentistId != null) {
                                        await NotificationTable().insert({
                                          'notification_id': generateUUID(),
                                          'user_id': _model.selectedDentistId!,
                                          'title': 'Appointment Cancelled',
                                          'body': '$patientName cancelled their appointment for $procName on $dateFormatted at $timeFormatted.',
                                          'type': 'Cancel',
                                          'reference_id': widget.rescheduleAppointmentId,
                                          'is_read': false,
                                          'created_at': DateTime.now().toIso8601String(),
                                        });
                                      }

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('🗑️ Appointment cancelled successfully.'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );

                                      context.safePop();
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error cancelling appointment: $e')),
                                      );
                                    }
                                  }
                                },
                                text: 'Cancel Appointment',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 50.0,
                                  color: Colors.transparent,
                                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: GoogleFonts.interTight().fontFamily,
                                        color: FlutterFlowTheme.of(context).error,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 1.0,
                                  ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ] else ...[
                              FFButtonWidget(
                                onPressed: () async {
                                  context.safePop();
                                },
                                text: 'Cancel',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 50.0,
                                  color: Colors.transparent,
                                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: GoogleFonts.interTight().fontFamily,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).alternate,
                                    width: 1.0,
                                  ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

            // Sliding Banner simulated notification (TC006)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              top: showNotification ? 10.0 : -100.0,
              left: 16.0,
              right: 16.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notificationMessage,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                          onPressed: () {
                            setState(() {
                              showNotification = false;
                            });
                          },
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
    );
  }
  Future<ProcedureRow?> _showSearchableProcedurePicker(BuildContext context) async {
    String searchQuery = '';
    return showModalBottomSheet<ProcedureRow>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = procedures.where((p) =>
                p.procedureName.toLowerCase().contains(searchQuery.toLowerCase()) ||
                (p.category?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false)
            ).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Select Procedure',
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: GoogleFonts.interTight().fontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search procedure...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      onChanged: (val) {
                        setModalState(() {
                          searchQuery = val;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? const Center(child: Text('No procedures found'))
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final proc = filtered[index];
                              return ListTile(
                                title: Text(
                                  proc.procedureName,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(proc.category ?? 'General'),
                                trailing: Text('₱${proc.pricing ?? 0}'),
                                onTap: () {
                                  Navigator.pop(context, proc);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<UserRow?> _showSearchableDentistPicker(BuildContext context) async {
    String searchQuery = '';
    return showModalBottomSheet<UserRow>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = dentists.where((d) =>
                (d.fullname ?? 'Dentist').toLowerCase().contains(searchQuery.toLowerCase()) ||
                ((dentistSpecializations[d.userId] ?? 'General Dentistry').toLowerCase().contains(searchQuery.toLowerCase()))
            ).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Select Dentist',
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: GoogleFonts.interTight().fontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search dentist...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      onChanged: (val) {
                        setModalState(() {
                          searchQuery = val;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? const Center(child: Text('No dentists found'))
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final dentist = filtered[index];
                              final isOnLeave = activeLeavesForSelectedDate.any((leave) => leave.dentistId == dentist.userId);
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isOnLeave ? Colors.red[100] : FlutterFlowTheme.of(context).primary,
                                  child: Text(
                                    (dentist.fullname ?? 'D').substring(0, 1).toUpperCase(),
                                    style: TextStyle(color: isOnLeave ? Colors.red : Colors.white),
                                  ),
                                ),
                                title: Text(
                                  dentist.fullname ?? 'Dentist',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(dentistSpecializations[dentist.userId] ?? 'General Dentistry'),
                                trailing: isOnLeave
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.red[100],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text('On Leave', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                                      )
                                    : null,
                                onTap: () {
                                  Navigator.pop(context, dentist);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
