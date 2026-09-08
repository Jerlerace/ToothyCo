import '/admin/user_management/dentist_management/c_confirm_application/c_confirm_application_widget.dart';
import '/admin/user_management/dentist_management/c_reject_application/c_reject_application_widget.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'p_admin_dentist_requests_model.dart';
export 'p_admin_dentist_requests_model.dart';

///
///
class PAdminDentistRequestsWidget extends StatefulWidget {
  const PAdminDentistRequestsWidget({super.key});

  static String routeName = 'P_AdminDentistRequests';
  static String routePath = '/pAdminDentistRequests';

  @override
  State<PAdminDentistRequestsWidget> createState() =>
      _PAdminDentistRequestsWidgetState();
}

class _PAdminDentistRequestsWidgetState
    extends State<PAdminDentistRequestsWidget> {
  late PAdminDentistRequestsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<DentistRow>>? _dentistsFuture;
  Future<List<UserRow>>? _usersFuture;

  void _loadData() {
    _dentistsFuture = DentistTable().queryRows(queryFn: (q) => q);
    _usersFuture = UserTable().queryRows(queryFn: (q) => q);
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PAdminDentistRequestsModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _loadData();
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
            'Dentist Requests',
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
                        'Dentist Requests',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily: GoogleFonts.interTight().fontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      content: Text(
                        'View and manage registration or schedule requests filed by dentist users. Approve or decline dentist profiles and schedule vacation requests.',
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: FlutterFlowChoiceChips(
                            options: [
                              ChipData('All'),
                              ChipData('Pending'),
                              ChipData('Approved'),
                              ChipData('Rejected')
                            ],
                            onChanged: (val) => safeSetState(() => _model
                                .choiceChipsStatusesValue = val?.firstOrNull),
                            selectedChipStyle: ChipStyle(
                              backgroundColor:
                                  FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context).info,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                              iconColor: FlutterFlowTheme.of(context).info,
                              iconSize: 16.0,
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            unselectedChipStyle: ChipStyle(
                              backgroundColor: Color(0x5357636C),
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                              iconColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                              iconSize: 16.0,
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            chipSpacing: 4.0,
                            rowSpacing: 4.0,
                            multiselect: false,
                            initialized:
                                _model.choiceChipsStatusesValue != null,
                            alignment: WrapAlignment.start,
                            controller:
                                _model.choiceChipsStatusesValueController ??=
                                    FormFieldController<List<String>>(
                              ['All'],
                            ),
                            wrapped: true,
                          ),
                        ),
                        FlutterFlowIconButton(
                          borderColor: FlutterFlowTheme.of(context).alternate,
                          borderRadius: 10.0,
                          borderWidth: 1.0,
                          buttonSize: 36.0,
                          fillColor: Color(0xFFF5F5F5),
                          icon: Icon(
                            Icons.filter_list_rounded,
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
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                  child: TextFormField(
                    controller: _model.textController,
                    focusNode: _model.textFieldFocusNode,
                    onChanged: (_) => safeSetState(() {}),
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Search by name, email or specialization',
                      hintStyle: FlutterFlowTheme.of(context)
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
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
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
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                    validator:
                        _model.textControllerValidator.asValidator(context),
                  ),
                ),
              ),
              FutureBuilder<List<dynamic>>(
                future: Future.wait([_dentistsFuture!, _usersFuture!]),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
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
                  final dentists = snapshot.data![0] as List<DentistRow>;
                  final users = snapshot.data![1] as List<UserRow>;
                  final userMap = {for (var u in users) u.userId: u};

                  // Filter for pending count banner
                  final pendingCount = dentists.where((d) => d.status == 'Pending').length;

                  // Filter based on choice chips status
                  final selectedStatus = _model.choiceChipsStatusesValue;
                  var filteredDentists = dentists;
                  if (selectedStatus != null && selectedStatus != 'All') {
                    filteredDentists = filteredDentists.where((d) => d.status == selectedStatus).toList();
                  }

                  // Filter based on search query
                  final query = _model.textController?.text.trim().toLowerCase() ?? '';
                  if (query.isNotEmpty) {
                    filteredDentists = filteredDentists.where((d) {
                      final user = userMap[d.dentistId];
                      final name = user?.fullname?.toLowerCase() ?? '';
                      final email = user?.email?.toLowerCase() ?? '';
                      final spec = d.specialization?.toLowerCase() ?? '';
                      return name.contains(query) || email.contains(query) || spec.contains(query);
                    }).toList();
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Count banner
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 16.0, 10.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFF7ED),
                            border: Border.all(
                              color: Color(0xFFFED7AA),
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  color: Color(0xFFF97316),
                                  size: 18.0,
                                ),
                                RichText(
                                  textScaler: MediaQuery.of(context).textScaler,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: formatNumber(
                                          pendingCount,
                                          formatType: FormatType.compact,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
                                              color: Color(0xFFF97316),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                      TextSpan(
                                        text: ' requests awaiting your review',
                                        style: TextStyle(),
                                      )
                                    ],
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .fontStyle,
                                          ),
                                          color: Color(0xFFF97316),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .fontStyle,
                                        ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                          ),
                        ),
                      ),

                      // List of dentists
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 24.0),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: filteredDentists.length,
                          itemBuilder: (context, listViewIndex) {
                            final listViewDentistRow = filteredDentists[listViewIndex];
                            
                            // Load User data directly from userMap
                            final rowUserRow = userMap[listViewDentistRow.dentistId];
                            
                            // Dynamic initials calculation
                            final nameText = rowUserRow?.fullname ?? 'Dentist';
                            final nameParts = nameText.trim().split(RegExp(r'\\s+'));
                            final userInitials = nameParts.length >= 2
                                ? '${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}'.toUpperCase()
                                : nameParts.isNotEmpty && nameParts[0].isNotEmpty
                                    ? nameParts[0][0].toUpperCase()
                                    : 'D';
                            
                            // Specialization colors
                            Color specBgColor = const Color(0xFFECEFF1);
                            Color specTextColor = const Color(0xFF607D8B);
                            final specText = listViewDentistRow.specialization?.trim().toLowerCase() ?? '';
                            if (specText == 'general dentistry') {
                              specBgColor = const Color(0xFFE8F5E9);
                              specTextColor = const Color(0xFF2E7D32);
                            } else if (specText == 'orthodontics') {
                              specBgColor = const Color(0xFFE3F2FD);
                              specTextColor = const Color(0xFF1565C0);
                            } else if (specText == 'periodontics') {
                              specBgColor = const Color(0xFFF3E5F5);
                              specTextColor = const Color(0xFF6A1B9A);
                            } else if (specText == 'endodontics') {
                              specBgColor = const Color(0xFFFCE4EC);
                              specTextColor = const Color(0xFFC2185B);
                            } else if (specText == 'pediatric dentistry') {
                              specBgColor = const Color(0xFFFFF3E0);
                              specTextColor = const Color(0xFFE65100);
                            } else if (specText == 'oral surgery') {
                              specBgColor = const Color(0xFFFFEBEE);
                              specTextColor = const Color(0xFFC62828);
                            }

                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 8.0,
                                      color: Color(0x0F000000),
                                      offset: Offset(0.0, 2.0),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      if (listViewDentistRow.status == 'Pending')
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Color(0xFFFEF3C7), Color(0xFFFEF9EE)],
                                              stops: [0.0, 1.0],
                                              begin: AlignmentDirectional(1.0, 0.0),
                                              end: AlignmentDirectional(-1.0, 0.0),
                                            ),
                                            borderRadius: BorderRadius.circular(16.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Icon(
                                                      Icons.access_time_rounded,
                                                      color: Color(0xFFF59E0B),
                                                      size: 14.0,
                                                    ),
                                                    Text(
                                                      'PENDING REVIEW',
                                                      style: FlutterFlowTheme.of(context).labelSmall.override(
                                                        font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                                        color: Color(0xFFF59E0B),
                                                        letterSpacing: 0.0,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ].divide(SizedBox(width: 6.0)),
                                                ),
                                                RichText(
                                                  textScaler: MediaQuery.of(context).textScaler,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Submitted ',
                                                        style: FlutterFlowTheme.of(context).labelSmall.override(
                                                          font: GoogleFonts.inter(),
                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                          letterSpacing: 0.0,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: listViewDentistRow.updatedAt != null 
                                                            ? dateTimeFormat("relative", listViewDentistRow.updatedAt!)
                                                            : 'recently',
                                                      )
                                                    ],
                                                    style: FlutterFlowTheme.of(context).labelSmall.override(
                                                      font: GoogleFonts.inter(),
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                      letterSpacing: 0.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    width: 56.0,
                                                    height: 56.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).accent1,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      userInitials,
                                                      style: FlutterFlowTheme.of(context).titleMedium.override(
                                                        font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                                        color: FlutterFlowTheme.of(context).primary,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: AlignmentDirectional(1.0, 1.0),
                                                    child: Container(
                                                      width: 16.0,
                                                      height: 16.0,
                                                      decoration: BoxDecoration(
                                                        color: listViewDentistRow.status == 'Approved' 
                                                            ? Color(0xFF16A34A) 
                                                            : (listViewDentistRow.status == 'Rejected' 
                                                                ? Color(0xFFDC2626) 
                                                                : Color(0xFFF59E0B)),
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    nameText,
                                                    style: FlutterFlowTheme.of(context).titleMedium.override(
                                                      font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    rowUserRow?.email ?? 'no email',
                                                    style: FlutterFlowTheme.of(context).labelMedium.override(
                                                      font: GoogleFonts.inter(),
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                      letterSpacing: 0.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ].divide(SizedBox(width: 12.0)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Container(
                                              height: 28.0,
                                              decoration: BoxDecoration(
                                                color: specBgColor,
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              alignment: AlignmentDirectional(0.0, 0.0),
                                              child: Text(
                                                listViewDentistRow.specialization ?? 'General',
                                                style: FlutterFlowTheme.of(context).labelSmall.override(
                                                  font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                                  color: specTextColor,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        height: 20.0,
                                        thickness: 1.0,
                                        indent: 12.0,
                                        endIndent: 12.0,
                                        color: FlutterFlowTheme.of(context).alternate,
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Icon(
                                                        Icons.business_outlined,
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                        size: 16.0,
                                                      ),
                                                      Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            'Clinic',
                                                            style: FlutterFlowTheme.of(context).labelSmall.override(
                                                              font: GoogleFonts.inter(),
                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                              letterSpacing: 0.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            listViewDentistRow.clinicName ?? 'Clinic Name',
                                                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                                              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ].divide(SizedBox(width: 6.0)),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Icon(
                                                        Icons.location_on_outlined,
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                        size: 16.0,
                                                      ),
                                                      Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            'Location',
                                                            style: FlutterFlowTheme.of(context).labelSmall.override(
                                                              font: GoogleFonts.inter(),
                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                              letterSpacing: 0.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            listViewDentistRow.clinicLocation ?? 'Location',
                                                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                                              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ].divide(SizedBox(width: 6.0)),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 16.0)),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Icon(
                                                        Icons.work_outline,
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                        size: 16.0,
                                                      ),
                                                      Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            'Experience',
                                                            style: FlutterFlowTheme.of(context).labelSmall.override(
                                                              font: GoogleFonts.inter(),
                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                              letterSpacing: 0.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            listViewDentistRow.experience ?? 'N/A',
                                                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                                              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ].divide(SizedBox(width: 6.0)),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 16.0)),
                                            ),
                                          ].divide(SizedBox(height: 8.0)),
                                        ),
                                      ),
                                      if (listViewDentistRow.status == 'Pending')
                                        Column(
                                          children: [
                                            Divider(
                                              height: 20.0,
                                              thickness: 1.0,
                                              indent: 12.0,
                                              endIndent: 12.0,
                                              color: FlutterFlowTheme.of(context).alternate,
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                FFButtonWidget(
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
                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery.viewInsetsOf(context),
                                                            child: CRejectApplicationWidget(
                                                              dentistIDreference: listViewDentistRow,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) {
                                                      _loadData();
                                                      safeSetState(() {});
                                                    });
                                                  },
                                                  text: 'Reject',
                                                  options: FFButtonOptions(
                                                    height: 38.0,
                                                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                    color: Color(0xFFFEF2F2),
                                                    textStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                                      color: Color(0xFFDC2626),
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    elevation: 0.0,
                                                    borderSide: BorderSide(color: Colors.transparent),
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                ),
                                                FFButtonWidget(
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
                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                          },
                                                          child: Padding(
                                                            padding: MediaQuery.viewInsetsOf(context),
                                                            child: CConfirmApplicationWidget(
                                                              dentistIDreference: listViewDentistRow,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) {
                                                      _loadData();
                                                      safeSetState(() {});
                                                    });
                                                  },
                                                  text: 'Approve',
                                                  options: FFButtonOptions(
                                                    height: 38.0,
                                                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                    color: Color(0xFF16A34A),
                                                    textStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                                      color: Colors.white,
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    elevation: 0.0,
                                                    borderSide: BorderSide(color: Colors.transparent),
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 8.0)),
                                            ),
                                          ],
                                        ),
                                    ].divide(SizedBox(height: 10.0)),
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
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 24.0),
                child: FutureBuilder<List<DentistRow>>(
                  future: DentistTable().queryRows(
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
                    List<DentistRow> listViewDentistRowList = snapshot.data!;

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: listViewDentistRowList.length,
                      itemBuilder: (context, listViewIndex) {
                        final listViewDentistRow =
                            listViewDentistRowList[listViewIndex];
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 12.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 8.0,
                                  color: Color(0x0F000000),
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
                                children: [
                                  if (listViewDentistRow.status == 'Pending')
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFFEF3C7),
                                            Color(0xFFFEF9EE)
                                          ],
                                          stops: [0.0, 1.0],
                                          begin: AlignmentDirectional(1.0, 0.0),
                                          end: AlignmentDirectional(-1.0, 0),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Icon(
                                                  Icons.access_time_rounded,
                                                  color: Color(0xFFF59E0B),
                                                  size: 14.0,
                                                ),
                                                Text(
                                                  'PENDING REVIEW',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelSmall
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelSmall
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            Color(0xFFF59E0B),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ].divide(SizedBox(width: 6.0)),
                                            ),
                                            RichText(
                                              textScaler: MediaQuery.of(context)
                                                  .textScaler,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'Submitted ',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelSmall
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
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
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                                  TextSpan(
                                                    text: dateTimeFormat(
                                                        "relative",
                                                        listViewDentistRow
                                                            .updatedAt!),
                                                    style: TextStyle(),
                                                  )
                                                ],
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
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FutureBuilder<List<UserRow>>(
                                        future: UserTable().querySingleRow(
                                          queryFn: (q) => q.eqOrNull(
                                            'user_id',
                                            listViewDentistRow.dentistId,
                                          ),
                                        ),
                                        builder: (context, snapshot) {
                                          // Customize what your widget looks like when it's loading.
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: SizedBox(
                                                width: 50.0,
                                                height: 50.0,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          List<UserRow> rowUserRowList =
                                              snapshot.data!;

                                          final rowUserRow =
                                              rowUserRowList.isNotEmpty
                                                  ? rowUserRowList.first
                                                  : null;

                                          return Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    width: 56.0,
                                                    height: 56.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent1,
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
                                                        AlignmentDirectional(
                                                            1.0, 1.0),
                                                    child: Container(
                                                      width: 16.0,
                                                      height: 16.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFF59E0B),
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
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
                                                    valueOrDefault<String>(
                                                      rowUserRow?.fullname,
                                                      'fullname',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
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
                                                  Text(
                                                    valueOrDefault<String>(
                                                      rowUserRow?.email,
                                                      'email',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ].divide(SizedBox(width: 12.0)),
                                          );
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Container(
                                          width: 70.0,
                                          height: 28.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFEF3C7),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Text(
                                              valueOrDefault<String>(
                                                listViewDentistRow.status,
                                                'status',
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelSmall
                                                  .override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelSmall
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0xFFF59E0B),
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelSmall
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 20.0,
                                    thickness: 1.0,
                                    indent: 12.0,
                                    endIndent: 12.0,
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 12.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Icon(
                                                    Icons.school_outlined,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 16.0,
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Specialization',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelSmall
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelSmall
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                      Text(
                                                        valueOrDefault<String>(
                                                          listViewDentistRow
                                                              .specialization,
                                                          'specialization',
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(SizedBox(width: 6.0)),
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Icon(
                                                    Icons.business_outlined,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 16.0,
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Clinic',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelSmall
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelSmall
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                      Text(
                                                        valueOrDefault<String>(
                                                          listViewDentistRow
                                                              .clinicName,
                                                          'clinic_name',
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(SizedBox(width: 6.0)),
                                              ),
                                            ),
                                          ].divide(SizedBox(width: 16.0)),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Icon(
                                                    Icons.location_on_outlined,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 16.0,
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Location',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelSmall
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelSmall
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                      Text(
                                                        valueOrDefault<String>(
                                                          listViewDentistRow
                                                              .clinicLocation,
                                                          'clinic_location',
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(SizedBox(width: 6.0)),
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Icon(
                                                    Icons.work_outline,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 16.0,
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Experience',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelSmall
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelSmall
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelSmall
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                      Text(
                                                        valueOrDefault<String>(
                                                          listViewDentistRow
                                                              .experience,
                                                          'experience',
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(SizedBox(width: 6.0)),
                                              ),
                                            ),
                                          ].divide(SizedBox(width: 16.0)),
                                        ),
                                      ].divide(SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  Divider(
                                    height: 20.0,
                                    thickness: 1.0,
                                    indent: 12.0,
                                    endIndent: 12.0,
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FFButtonWidget(
                                          onPressed: () async {
                                            await showModalBottomSheet(
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              enableDrag: false,
                                              context: context,
                                              builder: (context) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        MediaQuery.viewInsetsOf(
                                                            context),
                                                    child:
                                                        CRejectApplicationWidget(
                                                      dentistIDreference:
                                                          listViewDentistRow,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).then(
                                                (value) => safeSetState(() {}));
                                          },
                                          text: 'Reject',
                                          options: FFButtonOptions(
                                            height: 38.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 0.0, 16.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Color(0xFFFEF2F2),
                                            textStyle: FlutterFlowTheme.of(
                                                    context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFFDC2626),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                            elevation: 0.0,
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        FFButtonWidget(
                                          onPressed: () async {
                                            await showModalBottomSheet(
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              enableDrag: false,
                                              context: context,
                                              builder: (context) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        MediaQuery.viewInsetsOf(
                                                            context),
                                                    child:
                                                        CConfirmApplicationWidget(
                                                      dentistIDreference:
                                                          listViewDentistRow,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).then(
                                                (value) => safeSetState(() {}));
                                          },
                                          text: 'Approve',
                                          options: FFButtonOptions(
                                            height: 38.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 0.0, 16.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Color(0xFF16A34A),
                                            textStyle: FlutterFlowTheme.of(
                                                    context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: Colors.white,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                            elevation: 0.0,
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 8.0)),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 10.0)),
                              ),
                            ),
                          ),
                        );
                      },
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
