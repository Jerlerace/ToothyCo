import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/navbars/unified_nav_bar/unified_nav_bar_widget.dart';
import 'p_user_management_model.dart';
export 'p_user_management_model.dart';

/// 3.
///
/// User Role Management Page
///
/// Design a page to manage users with searchable list, user details, role
/// selector (Patient / Dentist / Admin), save changes button.
class PUserManagementWidget extends StatefulWidget {
  const PUserManagementWidget({super.key});

  static String routeName = 'P_UserManagement';
  static String routePath = '/pUserManagement';

  @override
  State<PUserManagementWidget> createState() => _PUserManagementWidgetState();
}

class _PUserManagementWidgetState extends State<PUserManagementWidget> {
  late PUserManagementModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Color getSpecializationColor(String? specialization) {
    if (specialization == null) return const Color(0xFFEF6C00);
    switch (specialization.trim().toLowerCase()) {
      case 'general dentistry':
        return const Color(0xFF4CAF50);
      case 'orthodontics':
        return const Color(0xFF2196F3);
      case 'periodontics':
        return const Color(0xFF9C27B0);
      case 'endodontics':
        return const Color(0xFFE91E63);
      case 'pediatric dentistry':
        return const Color(0xFFFF9800);
      case 'oral surgery':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF607D8B);
    }
  }

  Color getSpecializationBgColor(String? specialization) {
    if (specialization == null) return const Color(0xFFFFF3E0);
    switch (specialization.trim().toLowerCase()) {
      case 'general dentistry':
        return const Color(0xFFE8F5E9);
      case 'orthodontics':
        return const Color(0xFFE3F2FD);
      case 'periodontics':
        return const Color(0xFFF3E5F5);
      case 'endodontics':
        return const Color(0xFFFCE4EC);
      case 'pediatric dentistry':
        return const Color(0xFFFFF3E0);
      case 'oral surgery':
        return const Color(0xFFFFEBEE);
      default:
        return const Color(0xFFECEFF1);
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PUserManagementModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserRow>>(
      stream: _model.pUserManagementSupabaseStream ??= SupaFlow.client
          .from("User")
          .stream(primaryKey: ['user_id']).map(
              (list) => list.map((item) => UserRow(item)).toList()),
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
        List<UserRow> pUserManagementUserRowList = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            bottomNavigationBar: const UnifiedNavBarWidget(selectedIndex: 1),
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
                'User Management',
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
                            'User Role Management',
                            style: FlutterFlowTheme.of(context).titleLarge.override(
                                  fontFamily: GoogleFonts.interTight().fontFamily,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          content: Text(
                            'Search registered patients and clinic staff to review details or update system permissions instantly.',
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
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 0.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _model.searchController,
                            focusNode: _model.searchFocusNode,
                            onChanged: (_) => safeSetState(() {}),
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Search by name or email...',
                              hintStyle: FlutterFlowTheme.of(context).labelMedium,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              contentPadding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                              prefixIcon: Icon(
                                Icons.search,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                              suffixIcon: _model.searchController!.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _model.searchController!.clear();
                                        safeSetState(() {});
                                      },
                                    )
                                  : null,
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 12.0,
                          borderWidth: 0.0,
                          buttonSize: 44.0,
                          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                          icon: Icon(
                            Icons.filter_list_rounded,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                          onPressed: () {
                            print('IconButton pressed ...');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            textScaler: MediaQuery.of(context).textScaler,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: formatNumber(
                                    pUserManagementUserRowList.length,
                                    formatType: FormatType.compact,
                                  ),
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
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                                TextSpan(
                                  text: ' total user/s',
                                  style: TextStyle(),
                                )
                              ],
                              style: FlutterFlowTheme.of(context)
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
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                height: 28.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).accent1,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10.0, 0.0, 10.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        'All',
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(width: 8.0)),
                          ),
                        ],
                      ),
                      Builder(
                        builder: (context) {
                          final query = _model.searchController?.text.toLowerCase() ?? '';
                          final listOfUsers = pUserManagementUserRowList.where((user) {
                            if (query.isEmpty) return true;
                            final name = (user.fullname ?? '').toLowerCase();
                            final email = (user.email ?? '').toLowerCase();
                            return name.contains(query) || email.contains(query);
                          }).toList();

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: listOfUsers.length,
                            itemBuilder: (context, listOfUsersIndex) {
                              final listOfUsersItem =
                                  listOfUsers[listOfUsersIndex];
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    color: Color(0x00000000),
                                    child: ExpandableNotifier(
                                      initialExpanded: false,
                                      child: ExpandablePanel(
                                        header: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Text(
                                            valueOrDefault<String>(
                                              listOfUsersItem.fullname,
                                              'fullname',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge
                                                .override(
                                                  font: GoogleFonts.interTight(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleLarge
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleLarge
                                                            .fontStyle,
                                                  ),
                                                  color: Colors.black,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLarge
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLarge
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                        collapsed: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        width: 48.0,
                                                        height: 48.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .accent1,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                              listOfUsersItem.fullname != null && listOfUsersItem.fullname!.trim().isNotEmpty
                                                                  ? listOfUsersItem.fullname!
                                                                      .trim()
                                                                      .split(RegExp(r'\s+'))
                                                                      .map((s) => s[0])
                                                                      .take(2)
                                                                      .join()
                                                                      .toUpperCase()
                                                                  : 'U',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .titleMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .interTight(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ),
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
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .success,
                                                            shape:
                                                                BoxShape.circle,
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
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        listOfUsersItem.email,
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
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              if (listOfUsersItem.userType == 'Patient')
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              4.0),
                                                                  child:
                                                                      Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .accent1,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4.0),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            6.0),
                                                                    child: Text(
                                                                      'Patient',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelSmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.inter(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                            ),
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              if (listOfUsersItem.userType == 'Dentist')
                                                                FutureBuilder<List<DentistRow>>(
                                                                  future: DentistTable().queryRows(
                                                                    queryFn: (q) => q.eq('dentist_id', listOfUsersItem.userId ?? ''),
                                                                  ),
                                                                  builder: (context, dentistSnapshot) {
                                                                    final dentistData = dentistSnapshot.data?.firstOrNull;
                                                                    final spec = dentistData?.specialization ?? 'General Dentistry';
                                                                    final textColor = getSpecializationColor(spec);
                                                                    final bgColor = getSpecializationBgColor(spec);
                                                                    return Padding(
                                                                      padding: const EdgeInsets.all(4.0),
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          color: bgColor,
                                                                          borderRadius: BorderRadius.circular(4.0),
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(6.0),
                                                                          child: Text(
                                                                            'Dentist - $spec',
                                                                            style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                              font: GoogleFonts.inter(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                              ),
                                                                              color: textColor,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              if (listOfUsersItem.userType == 'Admin')
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              4.0),
                                                                  child:
                                                                      Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        0xFFFCE4EC),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4.0),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            6.0),
                                                                    child: Text(
                                                                      'Admin',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelSmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.inter(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                            ),
                                                                            color:
                                                                                Color(0xFFAD1457),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            listOfUsersItem.createdAt != null
                                                                ? 'Joined ${dateTimeFormat("yMMMd", listOfUsersItem.createdAt!)}'
                                                                : 'Joined',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
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
                                                                  fontSize:
                                                                      11.0,
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
                                                        ].divide(SizedBox(
                                                            width: 5.0)),
                                                      ),
                                                    ].divide(
                                                        SizedBox(height: 5.0)),
                                                  ),
                                                ].divide(SizedBox(width: 12.0)),
                                              ),
                                            ].divide(SizedBox(height: 5.0)),
                                          ),
                                        ),
                                        expanded: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        width: 48.0,
                                                        height: 48.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .accent1,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                              listOfUsersItem.fullname != null && listOfUsersItem.fullname!.trim().isNotEmpty
                                                                  ? listOfUsersItem.fullname!
                                                                      .trim()
                                                                      .split(RegExp(r'\s+'))
                                                                      .map((s) => s[0])
                                                                      .take(2)
                                                                      .join()
                                                                      .toUpperCase()
                                                                  : 'U',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .titleMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .interTight(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ),
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
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .success,
                                                            shape:
                                                                BoxShape.circle,
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
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        listOfUsersItem.email,
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
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
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
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                if (listOfUsersItem
                                                                        .userType ==
                                                                    'Patient')
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .accent1,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4.0),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              6.0),
                                                                      child:
                                                                          Text(
                                                                        'Patient',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .labelSmall
                                                                            .override(
                                                                              font: GoogleFonts.inter(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                if (listOfUsersItem.userType == 'Dentist')
                                                                  FutureBuilder<List<DentistRow>>(
                                                                    future: DentistTable().queryRows(
                                                                      queryFn: (q) => q.eq('dentist_id', listOfUsersItem.userId ?? ''),
                                                                    ),
                                                                    builder: (context, dentistSnapshot) {
                                                                      final dentistData = dentistSnapshot.data?.firstOrNull;
                                                                      final spec = dentistData?.specialization ?? 'General Dentistry';
                                                                      final textColor = getSpecializationColor(spec);
                                                                      final bgColor = getSpecializationBgColor(spec);
                                                                      return Container(
                                                                        decoration: BoxDecoration(
                                                                          color: bgColor,
                                                                          borderRadius: BorderRadius.circular(4.0),
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(6.0),
                                                                          child: Text(
                                                                            'Dentist - $spec',
                                                                            style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                              font: GoogleFonts.inter(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                              ),
                                                                              color: textColor,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                if (listOfUsersItem
                                                                        .userType ==
                                                                    'Admin')
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xFFFCE4EC),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4.0),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              6.0),
                                                                      child:
                                                                          Text(
                                                                        'Admin',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .labelSmall
                                                                            .override(
                                                                              font: GoogleFonts.inter(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                              ),
                                                                              color: Color(0xFFAD1457),
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                          RichText(
                                                            textScaler:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .textScaler,
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      'Joined ',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelSmall
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelSmall
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                                TextSpan(
                                                                  text: dateTimeFormat(
                                                                      "yMMMd",
                                                                      listOfUsersItem
                                                                          .createdAt!),
                                                                  style:
                                                                      TextStyle(),
                                                                )
                                                              ],
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelSmall
                                                                  .override(
                                                                    font: GoogleFonts
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
                                                          ),
                                                        ].divide(SizedBox(
                                                            width: 5.0)),
                                                      ),
                                                    ].divide(
                                                        SizedBox(height: 5.0)),
                                                  ),
                                                ].divide(SizedBox(width: 12.0)),
                                              ),
                                              Divider(
                                                height: 1.0,
                                                thickness: 1.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    'ASSIGN ROLE',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 1.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            await UserTable().update(
                                                              data: {
                                                                'user_type': 'Patient',
                                                              },
                                                              matchingRows: (rows) => rows.eqOrNull(
                                                                'user_id',
                                                                listOfUsersItem.userId,
                                                              ),
                                                            );
                                                            if (listOfUsersItem.userId != null) {
                                                              final patientCheck = await PatientTable().queryRows(
                                                                queryFn: (q) => q.eq('patient_id', listOfUsersItem.userId ?? ''),
                                                              );
                                                              if (patientCheck.isEmpty) {
                                                                await PatientTable().insert({
                                                                  'patient_id': listOfUsersItem.userId,
                                                                  'updated_at': DateTime.now().toIso8601String(),
                                                                });
                                                              }
                                                            }
                                                            safeSetState(() {});
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: listOfUsersItem
                                                                          .userType ==
                                                                      'Patient'
                                                                  ? FlutterFlowTheme.of(
                                                                          context)
                                                                      .accent1
                                                                  : FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              border:
                                                                  Border.all(
                                                                color: listOfUsersItem
                                                                            .userType ==
                                                                        'Patient'
                                                                    ? FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary
                                                                    : FlutterFlowTheme.of(
                                                                            context)
                                                                        .alternate,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          12.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .person_outline_rounded,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                    size: 16.0,
                                                                  ),
                                                                  Text(
                                                                    'Patient',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    width:
                                                                        6.0)),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            await UserTable().update(
                                                              data: {
                                                                'user_type': 'Dentist',
                                                              },
                                                              matchingRows: (rows) => rows.eqOrNull(
                                                                'user_id',
                                                                listOfUsersItem.userId,
                                                              ),
                                                            );
                                                            if (listOfUsersItem.userId != null) {
                                                              final dentistCheck = await DentistTable().queryRows(
                                                                queryFn: (q) => q.eq('dentist_id', listOfUsersItem.userId ?? ''),
                                                              );
                                                              if (dentistCheck.isEmpty) {
                                                                await DentistTable().insert({
                                                                  'dentist_id': listOfUsersItem.userId,
                                                                  'updated_at': DateTime.now().toIso8601String(),
                                                                  'specialization': 'General Dentistry',
                                                                });
                                                              }
                                                            }
                                                            safeSetState(() {});
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: listOfUsersItem
                                                                          .userType ==
                                                                      'Dentist'
                                                                  ? FlutterFlowTheme.of(
                                                                          context)
                                                                      .accent1
                                                                  : FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              border:
                                                                  Border.all(
                                                                color: listOfUsersItem
                                                                            .userType ==
                                                                        'Dentist'
                                                                    ? FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary
                                                                    : FlutterFlowTheme.of(
                                                                            context)
                                                                        .alternate,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          12.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .medical_services_outlined,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                    size: 16.0,
                                                                  ),
                                                                  Text(
                                                                    'Dentist',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    width:
                                                                        6.0)),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            await UserTable()
                                                                .update(
                                                              data: {
                                                                'user_type':
                                                                    'Admin',
                                                              },
                                                              matchingRows:
                                                                  (rows) => rows
                                                                      .eqOrNull(
                                                                'user_id',
                                                                listOfUsersItem
                                                                    .userId,
                                                              ),
                                                            );
                                                            safeSetState(() {});
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: listOfUsersItem
                                                                          .userType ==
                                                                      'Admin'
                                                                  ? FlutterFlowTheme.of(
                                                                          context)
                                                                      .accent1
                                                                  : FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              border:
                                                                  Border.all(
                                                                color: listOfUsersItem
                                                                            .userType ==
                                                                        'Admin'
                                                                    ? FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary
                                                                    : FlutterFlowTheme.of(
                                                                            context)
                                                                        .alternate,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          12.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .admin_panel_settings_outlined,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                    size: 16.0,
                                                                  ),
                                                                  Text(
                                                                    'Admin',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    width:
                                                                        6.0)),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(width: 8.0)),
                                                  ),
                                                ].divide(
                                                    SizedBox(height: 10.0)),
                                              ),
                                            ].divide(SizedBox(height: 10.0)),
                                          ),
                                        ),
                                        theme: ExpandableThemeData(
                                          tapHeaderToExpand: true,
                                          tapBodyToExpand: false,
                                          tapBodyToCollapse: false,
                                          headerAlignment:
                                              ExpandablePanelHeaderAlignment
                                                  .center,
                                          hasIcon: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ].divide(SizedBox(height: 15.0)),
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
    );
  }
}