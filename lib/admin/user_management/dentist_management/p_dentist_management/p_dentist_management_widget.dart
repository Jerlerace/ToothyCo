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
import 'p_dentist_management_model.dart';
export 'p_dentist_management_model.dart';

/// 6.
///
/// Dentist Management Page
///
/// Design a page to add/edit dentists, manage contact info, view schedules,
/// active/inactive status, searchable list.
class PDentistManagementWidget extends StatefulWidget {
  const PDentistManagementWidget({super.key});

  static String routeName = 'P_DentistManagement';
  static String routePath = '/pDentistManagement';

  @override
  State<PDentistManagementWidget> createState() =>
      _PDentistManagementWidgetState();
}

class _PDentistManagementWidgetState extends State<PDentistManagementWidget> {
  late PDentistManagementModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PDentistManagementModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  String generateUUID() {
    final r = DateTime.now().microsecondsSinceEpoch;
    String hex(int val, int len) => val.toRadixString(16).padLeft(len, '0');
    return '${hex(r & 0xFFFFFFFF, 8)}-${hex((r >> 32) & 0xFFFF, 4)}-4${hex((r >> 48) & 0xFFF, 3)}-8${hex((r >> 56) & 0xFFF, 3)}-${hex(r & 0xFFFFFFFFFFFF, 12)}';
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
            'Dentist Management',
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
                        'Dentist Management',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily: GoogleFonts.interTight().fontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      content: Text(
                        'Review dentist records, add new dental staff, and manage their clinical schedules.',
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: FFButtonWidget(
                onPressed: () async {
                    final nameController = TextEditingController();
                    final emailController = TextEditingController();
                    final phoneController = TextEditingController();
                    final clinicLocationController = TextEditingController();
                    final experienceController = TextEditingController();
                    final formKey = GlobalKey<FormState>();
                    String selectedSpec = 'General Dentistry';

                    await showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Text(
                                'Add New Dentist',
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
                                          hintText: 'Enter dentist name',
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
                                      DropdownButtonFormField<String>(
                                        value: selectedSpec,
                                        decoration: const InputDecoration(
                                          labelText: 'Specialization',
                                        ),
                                        items: <String>[
                                          'General Dentistry',
                                          'Orthodontics',
                                          'Periodontics',
                                          'Endodontics',
                                          'Pediatric Dentistry',
                                          'Oral Surgery'
                                        ].map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            setState(() {
                                              selectedSpec = newValue;
                                            });
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: clinicLocationController,
                                        decoration: const InputDecoration(
                                          labelText: 'Clinic Location',
                                          hintText: 'e.g., Room 204, Suite B',
                                        ),
                                        validator: (val) => val == null || val.trim().isEmpty ? 'Location is required' : null,
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: experienceController,
                                        decoration: const InputDecoration(
                                          labelText: 'Experience (e.g., 5 yrs)',
                                          hintText: 'e.g., 5 yrs',
                                        ),
                                        validator: (val) => val == null || val.trim().isEmpty ? 'Experience is required' : null,
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
                                        'phone': int.tryParse(phoneController.text.trim()),
                                        'user_type': 'Dentist',
                                        'status': 'Active',
                                      });

                                      await DentistTable().insert({
                                        'dentist_id': uuid,
                                        'specialization': selectedSpec,
                                        'clinic_name': 'Toothy Clinic',
                                        'clinic_location': clinicLocationController.text.trim(),
                                        'experience': experienceController.text.trim(),
                                        'status': 'Active',
                                        'updated_at': DateTime.now().toIso8601String(),
                                      });

                                      Navigator.pop(dialogContext);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Dentist added successfully')),
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
                    );
                  },
                  text: 'Add Dentist',
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
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 12.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                ),
              ),
              Divider(
                height: 1.0,
                thickness: 1.0,
                color: FlutterFlowTheme.of(context).alternate,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 24.0),
                  child: StreamBuilder<List<DentistRow>>(
                  stream: _model.listViewSupabaseStream ??= SupaFlow.client
                      .from("Dentist")
                      .stream(primaryKey: ['dentist_id']).map((list) =>
                          list.map((item) => DentistRow(item)).toList()),
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
                              child: FutureBuilder<List<UserRow>>(
                                future: UserTable().querySingleRow(
                                  queryFn: (q) => q.eqOrNull(
                                    'user_id',
                                    listViewDentistRow.dentistId,
                                  ),
                                ),
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
                                  List<UserRow> rowUserRowList = snapshot.data!;
                                  final rowUserRow = rowUserRowList.isNotEmpty
                                      ? rowUserRowList.first
                                      : null;
                                  return Column(
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
                                                      image: (rowUserRow?.userImgUrl != null &&
                                                              rowUserRow!
                                                                  .userImgUrl!
                                                                  .isNotEmpty)
                                                          ? DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  Image.network(
                                                                rowUserRow
                                                                    .userImgUrl!,
                                                              ).image,
                                                            )
                                                          : null,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: (rowUserRow
                                                                    ?.userImgUrl ==
                                                                null ||
                                                            rowUserRow!
                                                                .userImgUrl!
                                                                .isEmpty)
                                                        ? Center(
                                                            child: Text(
                                                              valueOrDefault<
                                                                  String>(
                                                                (rowUserRow
                                                                            ?.fullname !=
                                                                        null &&
                                                                        rowUserRow!
                                                                            .fullname!
                                                                            .isNotEmpty)
                                                                    ? rowUserRow
                                                                        .fullname!
                                                                        .substring(
                                                                            0,
                                                                            rowUserRow.fullname!.length > 1 ? 2 : 1)
                                                                        .toUpperCase()
                                                                    : 'DR',
                                                                'DR',
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
                                                                    text:
                                                                        'Dr. ',
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
                                                                      rowUserRow
                                                                          ?.fullname,
                                                                      'name',
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
                                                            Text(
                                                              valueOrDefault<
                                                                  String>(
                                                                listViewDentistRow
                                                                    .specialization,
                                                                'special',
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMedium
                                                                  .override(
                                                                    font: GoogleFonts
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
                                                             decoration: BoxDecoration(
                                                               color: (listViewDentistRow.status?.toLowerCase() == 'active')
                                                                   ? const Color(0x1A22C55E)
                                                                   : const Color(0x1AEF4444),
                                                               borderRadius: BorderRadius.circular(20.0),
                                                             ),
                                                             child: Padding(
                                                               padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                                                               child: Row(
                                                                 mainAxisSize: MainAxisSize.max,
                                                                 children: [
                                                                   Text(
                                                                     valueOrDefault<String>(listViewDentistRow.status, 'Active'),
                                                                     style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                           fontFamily: GoogleFonts.inter().fontFamily,
                                                                           color: (listViewDentistRow.status?.toLowerCase() == 'active')
                                                                               ? const Color(0xFF22C55E)
                                                                               : const Color(0xFFEF4444),
                                                                           fontWeight: FontWeight.bold,
                                                                         ),
                                                                   ),
                                                                 ],
                                                               ),
                                                             ),
                                                           ),
                                                              ),
                                                            ],
                                                          ),
Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Icon(
                                                          Icons.star_rounded,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          size: 14.0,
                                                        ),
                                                        Text(
                                                          '4.9 rating',
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
                                                          '·',
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
                                                          '${listViewDentistRow.experience ?? '0'} exp.',
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
                                                      ].divide(
                                                          SizedBox(width: 6.0)),
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
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 10.0, 16.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(
                                              Icons.phone_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 16.0,
                                            ),
                                            Expanded(
                                              child: Text(
                                                 valueOrDefault<String>(
                                                   rowUserRow?.phone?.toString(),
                                                   'No Phone',
                                                 ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodySmall
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
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
                                                              .bodySmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.email_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 16.0,
                                            ),
                                            Expanded(
                                              child: Text(
                                                 valueOrDefault<String>(
                                                   rowUserRow?.email,
                                                   'No Email',
                                                 ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodySmall
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
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
                                                              .bodySmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ),
                                          ].divide(SizedBox(width: 8.0)),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(
                                              Icons.calendar_today_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 16.0,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Mon, Wed, Fri  ·  9:00 AM – 5:00 PM',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodySmall
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
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
                                                              .bodySmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ),
                                          ].divide(SizedBox(width: 8.0)),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(
                                              Icons.meeting_room_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 16.0,
                                            ),
                                            Expanded(
                                              child: Text(
                                                 '${listViewDentistRow.clinicLocation ?? 'Room 204'}  ·  3 appointments today',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodySmall
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
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
                                                              .bodySmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ),
                                          ].divide(SizedBox(width: 8.0)),
                                        ),
                                      ].divide(SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 10.0, 16.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                context.pushNamed(
                                                    PAdminScheduleDentistWidget
                                                        .routeName);
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
                                                          Icons
                                                              .calendar_month_rounded,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          size: 14.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Schedule',
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
                                          ].divide(SizedBox(width: 8.0)),
                                        ),
                                         Padding(
                                           padding: const EdgeInsets.all(5.0),
                                           child: InkWell(
                                             onTap: () async {
                                               final bool isCurrentActive = listViewDentistRow.status?.toLowerCase() == 'active';
                                               final newStatus = isCurrentActive ? 'Inactive' : 'Active';
                                               
                                               await DentistTable().update(
                                                 data: {
                                                   'status': newStatus,
                                                   'updated_at': DateTime.now().toIso8601String(),
                                                 },
                                                 matchingRows: (q) => q.eq('dentist_id', listViewDentistRow.dentistId),
                                               );
                                               
                                               await UserTable().update(
                                                 data: {
                                                   'status': newStatus,
                                                 },
                                                 matchingRows: (q) => q.eq('user_id', listViewDentistRow.dentistId),
                                               );

                                               ScaffoldMessenger.of(context).showSnackBar(
                                                 SnackBar(content: Text('${rowUserRow?.fullname ?? 'Dentist'} ${isCurrentActive ? 'deactivated' : 'activated'} successfully')),
                                               );
                                               safeSetState(() {});
                                             },
                                             child: Container(
                                               height: 32.0,
                                               decoration: BoxDecoration(
                                                 color: listViewDentistRow.status?.toLowerCase() == 'active'
                                                     ? const Color(0x1AEF4444)
                                                     : const Color(0x1A22C55E),
                                                 borderRadius: BorderRadius.circular(8.0),
                                               ),
                                               child: Padding(
                                                 padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                                 child: Row(
                                                   mainAxisSize: MainAxisSize.max,
                                                   children: [
                                                     Icon(
                                                       listViewDentistRow.status?.toLowerCase() == 'active'
                                                           ? Icons.block_rounded
                                                           : Icons.check_circle_rounded,
                                                       color: listViewDentistRow.status?.toLowerCase() == 'active'
                                                           ? FlutterFlowTheme.of(context).error
                                                           : const Color(0xFF22C55E),
                                                       size: 14.0,
                                                     ),
                                                     const SizedBox(width: 4.0),
                                                     Text(
                                                       listViewDentistRow.status?.toLowerCase() == 'active'
                                                           ? 'Deactivate'
                                                           : 'Activate',
                                                       style: FlutterFlowTheme.of(context).labelMedium.override(
                                                             fontFamily: GoogleFonts.inter().fontFamily,
                                                             color: listViewDentistRow.status?.toLowerCase() == 'active'
                                                                 ? FlutterFlowTheme.of(context).error
                                                                 : const Color(0xFF22C55E),
                                                             fontWeight: FontWeight.w600,
                                                           ),
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
                              ],
                            );
                          },
                        ),
                    ),
                  ),
                );
            },
          );
        },
      ),
    ),
  ),
          ],
          ),
        ),
      ),
    );
}
}
