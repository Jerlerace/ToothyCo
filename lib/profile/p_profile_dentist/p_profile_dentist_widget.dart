import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/navbars/unified_nav_bar/unified_nav_bar_widget.dart';
import '/navbars/dentist_nav_bar/dentist_nav_bar_widget.dart';
import 'p_profile_dentist_model.dart';
export 'p_profile_dentist_model.dart';

/// 9.
///
/// Dentist Profile Page
///
/// Design a profile page with dentist photo, specialty, contact info, edit
/// profile, change password, logout.
class PProfileDentistWidget extends StatefulWidget {
  const PProfileDentistWidget({super.key});

  static String routeName = 'P_ProfileDentist';
  static String routePath = '/pProfileDentist';

  @override
  State<PProfileDentistWidget> createState() => _PProfileDentistWidgetState();
}

class _PProfileDentistWidgetState extends State<PProfileDentistWidget> {
  late PProfileDentistModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PProfileDentistModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
        List<UserRow> pProfileDentistUserRowList = snapshot.data!;

        final pProfileDentistUserRow = pProfileDentistUserRowList.isNotEmpty
            ? pProfileDentistUserRowList.first
            : null;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            bottomNavigationBar: pProfileDentistUserRow?.userType == 'Admin'
                ? const UnifiedNavBarWidget(selectedIndex: 3)
                : (pProfileDentistUserRow?.userType == 'Dentist'
                    ? const DentistNavBarWidget()
                    : null),
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 23.0,
                buttonSize: 46.0,
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
                'My Profile',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FontWeight.w600,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                  child: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 23.0,
                    buttonSize: 46.0,
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 24.0,
                    ),
                    onPressed: () {
                      print('IconButton pressed ...');
                    },
                  ),
                ),
              ],
              centerTitle: false,
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                          stops: [0.0, 1.0],
                          begin: AlignmentDirectional(0.0, 1.0),
                          end: AlignmentDirectional(0, -1.0),
                        ),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Stack(
                                  alignment: AlignmentDirectional(1.0, 1.0),
                                  children: [
                                    Container(
                                      width: 110.0,
                                      height: 110.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: Image.network(
                                            'https://images.unsplash.com/photo-1629909613654-28e377c37b09?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NzY3ODY0MTZ8&ixlib=rb-4.1.0&q=80&w=1080',
                                          ).image,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3.0,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(1.0, 1.0),
                                      child: Container(
                                        width: 32.0,
                                        height: 32.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.camera_alt_rounded,
                                          color: Colors.white,
                                          size: 16.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ].divide(SizedBox(height: 12.0)),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                textScaler: MediaQuery.of(context).textScaler,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Dr. ',
                                      style: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .override(
                                            font: GoogleFonts.interTight(
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineMedium
                                                      .fontStyle,
                                            ),
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                    TextSpan(
                                      text: valueOrDefault<String>(
                                        pProfileDentistUserRow?.fullname,
                                        'fullname',
                                      ),
                                      style: TextStyle(),
                                    )
                                  ],
                                  style: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .override(
                                        font: GoogleFonts.interTight(
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineMedium
                                                  .fontStyle,
                                        ),
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .fontStyle,
                                      ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Orthodontist & Cosmetic Dentist',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
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
                                      color: Color(0xCCFFFFFF),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ].divide(SizedBox(height: 4.0)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: FutureBuilder<List<DentistRow>>(
                                future: DentistTable().querySingleRow(
                                  queryFn: (q) => q.eqOrNull(
                                    'dentist_id',
                                    currentUserUid,
                                  ),
                                ),
                                builder: (context, snapshot) {
                                  // Customize what your widget looks like when it's loading.
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  List<DentistRow> containerDentistRowList =
                                      snapshot.data!;

                                  final containerDentistRow =
                                      containerDentistRowList.isNotEmpty
                                          ? containerDentistRowList.first
                                          : null;

                                  return Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 8.0,
                                          color: Color(0x1A000000),
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
                                          Text(
                                            'Contact Information',
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
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 40.0,
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFE3F2FD),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.email_rounded,
                                                  color: Color(0xFF1565C0),
                                                  size: 20.0,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Email Address',
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
                                                        pProfileDentistUserRow
                                                            ?.email,
                                                        'email',
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ].divide(SizedBox(width: 12.0)),
                                          ),
                                          Divider(
                                            height: 1.0,
                                            thickness: 1.0,
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 40.0,
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFE3F2FD),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.phone_rounded,
                                                  color: Color(0xFF1565C0),
                                                  size: 20.0,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Phone Number',
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
                                                        pProfileDentistUserRow
                                                            ?.phone
                                                            ?.toString(),
                                                        '#',
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ].divide(SizedBox(width: 12.0)),
                                          ),
                                          Divider(
                                            height: 1.0,
                                            thickness: 1.0,
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 40.0,
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFE3F2FD),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.location_on_rounded,
                                                  color: Color(0xFF1565C0),
                                                  size: 20.0,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Clinic Address',
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
                                                        containerDentistRow
                                                            ?.clinicLocation,
                                                        'clinic_location',
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ].divide(SizedBox(width: 12.0)),
                                          ),
                                          Divider(
                                            height: 1.0,
                                            thickness: 1.0,
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 40.0,
                                                height: 40.0,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFE3F2FD),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.work_outline,
                                                  color: Color(0xFF1565C0),
                                                  size: 20.0,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                        containerDentistRow
                                                            ?.experience,
                                                        'experience',
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ].divide(SizedBox(width: 12.0)),
                                          ),
                                        ].divide(SizedBox(height: 16.0)),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: 80.0,
                                    height: 80.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE3F2FD),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '320',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .headlineSmall
                                                .override(
                                                  font: GoogleFonts.interTight(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineSmall
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFF1565C0),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineSmall
                                                          .fontStyle,
                                                ),
                                          ),
                                          Text(
                                            'Patients',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
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
                                                  color: FlutterFlowTheme.of(
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
                                        ].divide(SizedBox(height: 4.0)),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 80.0,
                                    height: 80.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '12+',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .headlineSmall
                                                .override(
                                                  font: GoogleFonts.interTight(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineSmall
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFF2E7D32),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineSmall
                                                          .fontStyle,
                                                ),
                                          ),
                                          Text(
                                            'Years Exp.',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
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
                                                  color: FlutterFlowTheme.of(
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
                                        ].divide(SizedBox(height: 4.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                            Text(
                              'Account Settings',
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
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8.0,
                                    color: Color(0x1A000000),
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
                                    Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                              PEditProfileWidget.routeName);
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 42.0,
                                                  height: 42.0,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFE3F2FD),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .person_outline_rounded,
                                                    color: Color(0xFF1565C0),
                                                    size: 20.0,
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Edit Profile',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .interTight(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                    Text(
                                                      'Update your personal info',
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
                                                  ],
                                                ),
                                              ].divide(SizedBox(width: 14.0)),
                                            ),
                                            Icon(
                                              Icons.chevron_right_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 20.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      thickness: 1.0,
                                      indent: 16.0,
                                      endIndent: 16.0,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                              PEditPasswordWidget.routeName);
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 42.0,
                                                  height: 42.0,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFE8F5E9),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.lock_outline_rounded,
                                                    color: Color(0xFF2E7D32),
                                                    size: 20.0,
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Change Password',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .interTight(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                    Text(
                                                      'Update your security credentials',
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
                                                  ],
                                                ),
                                              ].divide(SizedBox(width: 14.0)),
                                            ),
                                            Icon(
                                              Icons.chevron_right_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 20.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      thickness: 1.0,
                                      indent: 16.0,
                                      endIndent: 16.0,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 42.0,
                                                height: 42.0,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFFF8E1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.schedule_rounded,
                                                  color: Color(0xFFF57F00),
                                                  size: 20.0,
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Working Hours',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                  Text(
                                                    'Manage your availability',
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
                                                ],
                                              ),
                                            ].divide(SizedBox(width: 14.0)),
                                          ),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 20.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: 1.0,
                                      thickness: 1.0,
                                      indent: 16.0,
                                      endIndent: 16.0,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 42.0,
                                                height: 42.0,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFE3F2FD),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons
                                                      .notifications_none_rounded,
                                                  color: Color(0xFF1565C0),
                                                  size: 20.0,
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Notifications',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                  Text(
                                                    'Manage your alerts',
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
                                                ],
                                              ),
                                            ].divide(SizedBox(width: 14.0)),
                                          ),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 20.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                GoRouter.of(context).prepareAuthEvent();
                                await authManager.signOut();
                                GoRouter.of(context).clearRedirectLocation();

                                context.goNamedAuth(
                                    SplashWidget.routeName, context.mounted);
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFDECEA),
                                  borderRadius: BorderRadius.circular(16.0),
                                  border: Border.all(
                                    color: Color(0xFFE57373),
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: 42.0,
                                            height: 42.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFCDD2),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.logout_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              size: 20.0,
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Logout',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                              ),
                                              Text(
                                                'Sign out of your account',
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
                                        ].divide(SizedBox(width: 14.0)),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        size: 20.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
