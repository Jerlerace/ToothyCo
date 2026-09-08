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
import 'p_patient_management_model.dart';
export 'p_patient_management_model.dart';

/// 6.
///
/// Dentist Management Page
///
/// Design a page to add/edit dentists, manage contact info, view schedules,
/// active/inactive status, searchable list.
class PPatientManagementWidget extends StatefulWidget {
  const PPatientManagementWidget({super.key});

  static String routeName = 'P_PatientManagement';
  static String routePath = '/pPatientManagement';

  @override
  State<PPatientManagementWidget> createState() =>
      _PPatientManagementWidgetState();
}

class _PPatientManagementWidgetState extends State<PPatientManagementWidget> {
  late PPatientManagementModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String generateUUID() {
    final r = DateTime.now().microsecondsSinceEpoch;
    // Simple fast pseudorandom UUID generator in Dart
    String hex(int val, int len) => val.toRadixString(16).padLeft(len, '0');
    return '${hex(r & 0xFFFFFFFF, 8)}-${hex((r >> 32) & 0xFFFF, 4)}-4${hex((r >> 48) & 0xFFF, 3)}-8${hex((r >> 56) & 0xFFF, 3)}-${hex(r & 0xFFFFFFFFFFFF, 12)}';
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PPatientManagementModel());
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
            'Patient Management',
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
                        'Patient Management',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily: GoogleFonts.interTight().fontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      content: Text(
                        'Search clinical patient records, add new patient profiles, and view contact details.',
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      final nameController = TextEditingController();
                      final emailController = TextEditingController();
                      final phoneController = TextEditingController();
                      final addressController = TextEditingController();
                      final formKey = GlobalKey<FormState>();

                      await showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: Text(
                              'Add New Patient',
                              style: FlutterFlowTheme.of(context).headlineSmall,
                            ),
                            content: Form(
                              key: formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Full Name',
                                        hintText: 'Enter patient name',
                                      ),
                                      validator: (val) => val == null || val.trim().isEmpty ? 'Name is required' : null,
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        labelText: 'Email Address',
                                        hintText: 'Enter email address',
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (val) {
                                        if (val == null || val.trim().isEmpty) return 'Email is required';
                                        if (!val.contains('@')) return 'Enter valid email';
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: phoneController,
                                      decoration: const InputDecoration(
                                        labelText: 'Phone Number',
                                        hintText: 'Enter phone number',
                                      ),
                                      keyboardType: TextInputType.phone,
                                      validator: (val) => val == null || val.trim().isEmpty ? 'Phone is required' : null,
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: addressController,
                                      decoration: const InputDecoration(
                                        labelText: 'Address',
                                        hintText: 'Enter home address',
                                      ),
                                      validator: (val) => val == null || val.trim().isEmpty ? 'Address is required' : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    final uuid = supaSerialize<String>(generateUUID());
                                    await UserTable().insert({
                                      'user_id': uuid,
                                      'fullname': nameController.text.trim(),
                                      'email': emailController.text.trim(),
                                      'phone': phoneController.text.trim(),
                                      'address': addressController.text.trim(),
                                      'user_type': 'Patient',
                                    });

                                    await PatientTable().insert({
                                      'patient_id': uuid,
                                      'updated_at': DateTime.now().toIso8601String(),
                                    });

                                    Navigator.pop(dialogContext);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Patient added successfully')),
                                    );
                                    safeSetState(() {});
                                  }
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    text: 'Add Patient',
                    icon: const Icon(
                      Icons.person_add_rounded,
                      size: 20.0,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50.0,
                      padding: const EdgeInsets.all(8.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: GoogleFonts.interTight().fontFamily,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _model.searchController,
                  focusNode: _model.searchFocusNode,
                  onChanged: (_) => safeSetState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search patients by name or email...',
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
                    prefixIcon: Icon(
                      Icons.search,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    suffixIcon: _model.searchController!.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _model.searchController!.clear();
                              safeSetState(() {});
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: StreamBuilder<List<UserRow>>(
                    stream: _model.listViewSupabaseStream ??= SupaFlow.client
                        .from("User")
                        .stream(primaryKey: ['user_id']).map((list) =>
                            list.map((item) => UserRow(item)).toList()),
                    builder: (context, snapshot) {
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
                      List<UserRow> fullUserRowList = snapshot.data!;
                      final query = _model.searchController?.text.toLowerCase() ?? '';
                      List<UserRow> listViewPatientUserList = fullUserRowList.where((u) {
                        if (u.userType != 'Patient') return false;
                        if (query.isEmpty) return true;
                        final name = (u.fullname ?? '').toLowerCase();
                        final email = (u.email ?? '').toLowerCase();
                        return name.contains(query) || email.contains(query);
                      }).toList();

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: listViewPatientUserList.length,
                        itemBuilder: (context, listViewIndex) {
                          final columnUserRow =
                              listViewPatientUserList[listViewIndex];
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
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 16.0, 16.0, 12.0),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    width: 60.0,
                                                    height: 60.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent1,
                                                      image: columnUserRow
                                                                      .userImgUrl !=
                                                                  null &&
                                                              columnUserRow
                                                                  .userImgUrl!
                                                                  .isNotEmpty
                                                          ? DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  Image.network(
                                                                columnUserRow
                                                                    .userImgUrl!,
                                                              ).image,
                                                            )
                                                          : null,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: columnUserRow
                                                                    .userImgUrl ==
                                                                null ||
                                                            columnUserRow
                                                                .userImgUrl!
                                                                .isEmpty
                                                        ? Center(
                                                            child: Text(
                                                              valueOrDefault<
                                                                  String>(
                                                                columnUserRow
                                                                            .fullname !=
                                                                        null &&
                                                                        columnUserRow
                                                                            .fullname!
                                                                            .isNotEmpty
                                                                    ? columnUserRow
                                                                        .fullname!
                                                                        .substring(
                                                                            0,
                                                                            columnUserRow.fullname!.length > 1 ? 2 : 1)
                                                                        .toUpperCase()
                                                                    : 'PT',
                                                                'PT',
                                                              ),
                                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                    font: GoogleFonts.inter(
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                    letterSpacing: 0.0,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                            ),
                                                          )
                                                        : null,
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
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .success,
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
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            RichText(
                                                              textScaler:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: '',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.interTight(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: valueOrDefault<
                                                                        String>(
                                                                      columnUserRow
                                                                          ?.fullname,
                                                                      'fullname',
                                                                    ),
                                                                    style:
                                                                        TextStyle(),
                                                                  )
                                                                ],
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .interTight(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
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
                                                          ].divide(SizedBox(
                                                              height: 2.0)),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      10.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Container(
                                                            height: 26.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0x1A22C55E),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10.0,
                                                                          0.0,
                                                                          10.0,
                                                                          0.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      columnUserRow
                                                                          ?.status,
                                                                      'status',
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Color(0xFF22C55E),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelSmall
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ].divide(
                                                      SizedBox(height: 4.0)),
                                                ),
                                              ),
                                            ].divide(SizedBox(width: 12.0)),
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
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 10.0, 16.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  final confirm = await showDialog<bool>(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: const Text('Confirm Deactivation'),
                                                      content: const Text('Are you sure you want to deactivate this patient profile?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context, false),
                                                          child: const Text('Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context, true),
                                                          style: TextButton.styleFrom(
                                                            foregroundColor: FlutterFlowTheme.of(context).error,
                                                          ),
                                                          child: const Text('Deactivate'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  if (confirm != true) return;

                                                  await UserTable().update(
                                                    data: {
                                                      'status': 'Archived',
                                                    },
                                                    matchingRows: (rows) =>
                                                        rows.eqOrNull(
                                                      'user_id',
                                                      columnUserRow
                                                          .userId,
                                                    ),
                                                  );
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Information Dialog'),
                                                        content: Text(
                                                            'Archiving of User Success'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    alertDialogContext),
                                                            child: Text('Ok'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  safeSetState(() {});
                                                },
                                                child: Container(
                                                  height: 32.0,
                                                  decoration: BoxDecoration(
                                                    color: Color(0x1AEF4444),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(3.05),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      4.0,
                                                                      0.0,
                                                                      4.0,
                                                                      0.0),
                                                          child: Icon(
                                                            Icons.block_rounded,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .error,
                                                            size: 14.0,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      5.0,
                                                                      0.0),
                                                          child: Text(
                                                            'Deactivate',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
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
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
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
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                context.pushNamed(
                                                  PPatientUpdateWidget
                                                      .routeName,
                                                  queryParameters: {
                                                    'patientID': serializeParam(
                                                      columnUserRow,
                                                      ParamType.SupabaseRow,
                                                    ),
                                                  }.withoutNulls,
                                                );
                                              },
                                              child: Container(
                                                height: 32.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .accent1,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 0.0, 12.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    4.0,
                                                                    0.0,
                                                                    4.0,
                                                                    0.0),
                                                        child: Icon(
                                                          Icons.edit_note,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          size: 14.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Edit',
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
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
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
        ),
    );
  }
}
