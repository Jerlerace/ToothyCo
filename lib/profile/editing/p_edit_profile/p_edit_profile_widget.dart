import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'p_edit_profile_model.dart';
export 'p_edit_profile_model.dart';

/// 7.
///
/// Dentist Account information Registration Request form
///
/// Design a page where Users can request to become a dentist while filling in
/// necessary form/information needed to submit request
class PEditProfileWidget extends StatefulWidget {
  const PEditProfileWidget({super.key});

  static String routeName = 'P_EditProfile';
  static String routePath = '/pEditProfile';

  @override
  State<PEditProfileWidget> createState() => _PEditProfileWidgetState();
}

class _PEditProfileWidgetState extends State<PEditProfileWidget> {
  late PEditProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PEditProfileModel());

    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textFieldClinicNameFocusNode ??= FocusNode();

    _model.textFieldClinicLocFocusNode ??= FocusNode();

    _model.textFieldDentalSchoolFocusNode ??= FocusNode();

    _model.textFieldGradYearFocusNode ??= FocusNode();
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
        List<UserRow> pEditProfileUserRowList = snapshot.data!;

        final pEditProfileUserRow = pEditProfileUserRowList.isNotEmpty
            ? pEditProfileUserRowList.first
            : null;

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
                'Edit Profile',
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
                            'Edit Profile',
                            style: FlutterFlowTheme.of(context).titleLarge.override(
                                  fontFamily: GoogleFonts.interTight().fontFamily,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          content: Text(
                            'Update your personal details, including your full name, phone number, profile photo, and specialization/clinic details if you are a dentist. Click the Save button to apply changes.',
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
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 8.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        await UserTable().update(
                          data: {
                            'fullname': _model.textController1.text,
                            'phone': int.tryParse(_model.textController3.text),
                          },
                          matchingRows: (rows) => rows.eqOrNull(
                            'user_id',
                            currentUserUid,
                          ),
                        );
                        if (_model.selectedLocalPfpMedia != null &&
                            _model.selectedLocalPfpMedia!.isNotEmpty) {
                          safeSetState(() =>
                              _model.isDataUploading_uploadedPfpToDb = true);
                          var downloadUrls = <String>[];
                          try {
                            downloadUrls = await uploadSupabaseStorageFiles(
                              bucketName: 'Profile_Image_Bucket',
                              selectedFiles: _model.selectedLocalPfpMedia!,
                            );
                          } finally {
                            _model.isDataUploading_uploadedPfpToDb = false;
                          }
                          if (downloadUrls.length ==
                              _model.selectedLocalPfpMedia!.length) {
                            _model.uploadedFileUrl_uploadedPfpToDb =
                                downloadUrls.first;
                          } else {
                            showUploadMessage(
                                context, 'Failed to upload profile image.');
                            return;
                          }

                          await UserTable().update(
                            data: {
                              'user_imgUrl':
                                  _model.uploadedFileUrl_uploadedPfpToDb,
                            },
                            matchingRows: (rows) => rows.eqOrNull(
                              'user_id',
                              currentUserUid,
                            ),
                          );

                          safeSetState(() {
                            _model.selectedLocalPfpMedia = null;
                            _model.isDataUploading_uploadedPfp = false;
                            _model.uploadedLocalFile_uploadedPfp = FFUploadedFile(
                                bytes: Uint8List.fromList([]),
                                originalFilename: '');
                            _model.isDataUploading_uploadedPfpToDb = false;
                            _model.uploadedLocalFile_uploadedPfpToDb =
                                FFUploadedFile(
                                    bytes: Uint8List.fromList([]),
                                    originalFilename: '');
                            _model.uploadedFileUrl_uploadedPfpToDb = '';
                          });
                        }
                        if (pEditProfileUserRow?.userType == 'Dentist') {
                          await DentistTable().update(
                            data: {
                              'specialization':
                                  _model.dropDownSpecializationValue,
                              'clinic_name':
                                  _model.textFieldClinicNameTextController.text,
                              'clinic_location':
                                  _model.textFieldClinicLocTextController.text,
                              'experience': _model.dropDownYrsOfExpValue,
                              'dental_school':
                                  _model.textFieldDentalSchoolTextController.text,
                              'graduation_year':
                                  _model.textFieldGradYearTextController.text,
                            },
                            matchingRows: (rows) => rows.eqOrNull(
                              'dentist_id',
                              currentUserUid,
                            ),
                          );
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Successful Editing of Profile',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            duration: Duration(milliseconds: 4000),
                            backgroundColor:
                                FlutterFlowTheme.of(context).secondary,
                          ),
                        );
                        context.safePop();
                      },
                      text: 'Save Changes',
                      icon: const Icon(
                        Icons.check_rounded,
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
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 10.0, 24.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      child: Form(
                        key: _model.formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PERSONAL INFORMATION',
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF0077B6),
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .fontStyle,
                                  ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 100.0,
                                  height: 100.0,
                                  child: Stack(
                                    alignment: AlignmentDirectional(1.0, 1.0),
                                    children: [
                                      if (_model.uploadedLocalFile_uploadedPfp !=
                                              null &&
                                          (_model.uploadedLocalFile_uploadedPfp
                                                  .bytes?.isNotEmpty ??
                                              false))
                                        Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: Image.memory(
                                                _model.uploadedLocalFile_uploadedPfp
                                                        .bytes ??
                                                    Uint8List.fromList([]),
                                              ).image,
                                            ),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 3.0,
                                            ),
                                          ),
                                        ),
                                      if (pEditProfileUserRow?.userImgUrl !=
                                              null &&
                                          pEditProfileUserRow?.userImgUrl != '')
                                        Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: Image.network(
                                                pEditProfileUserRow!
                                                    .userImgUrl!,
                                              ).image,
                                            ),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 3.0,
                                            ),
                                          ),
                                        ),
                                      if (pEditProfileUserRow?.userImgUrl ==
                                              null ||
                                          pEditProfileUserRow?.userImgUrl == '')
                                        Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: Image.asset(
                                                'assets/images/Untitled_(2)_(1)_2.png',
                                              ).image,
                                            ),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 3.0,
                                            ),
                                          ),
                                        ),
                                      FlutterFlowIconButton(
                                        borderColor: Colors.white,
                                        borderRadius: 8.0,
                                        buttonSize: 40.0,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .primary,
                                        icon: Icon(
                                          Icons.upload,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          size: 22.5,
                                        ),
                                        onPressed: () async {
                                          final selectedMedia =
                                              await selectMediaWithSourceBottomSheet(
                                            context: context,
                                            storageFolderPath: 'Profile_Image',
                                            allowPhoto: true,
                                          );
                                          if (selectedMedia != null &&
                                              selectedMedia.every((m) =>
                                                  validateFileFormat(
                                                      m.storagePath,
                                                      context))) {
                                            safeSetState(() => _model
                                                    .isDataUploading_uploadedPfp =
                                                true);
                                            var selectedUploadedFiles =
                                                <FFUploadedFile>[];

                                            try {
                                              selectedUploadedFiles =
                                                  selectedMedia
                                                      .map(
                                                          (m) => FFUploadedFile(
                                                                name: m
                                                                    .storagePath
                                                                    .split('/')
                                                                    .last,
                                                                bytes: m.bytes,
                                                                height: m
                                                                    .dimensions
                                                                    ?.height,
                                                                width: m
                                                                    .dimensions
                                                                    ?.width,
                                                                blurHash:
                                                                    m.blurHash,
                                                                originalFilename:
                                                                    m.originalFilename,
                                                              ))
                                                      .toList();
                                            } finally {
                                              _model.isDataUploading_uploadedPfp =
                                                  false;
                                            }
                                            if (selectedUploadedFiles.length ==
                                                selectedMedia.length) {
                                              safeSetState(() {
                                                _model.selectedLocalPfpMedia = selectedMedia;
                                                _model.uploadedLocalFile_uploadedPfp =
                                                    selectedUploadedFiles.first;
                                              });
                                            } else {
                                              safeSetState(() {});
                                              return;
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Full Name',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                      TextFormField(
                                        controller: _model.textController1 ??=
                                            TextEditingController(
                                          text: pEditProfileUserRow?.fullname,
                                        ),
                                        focusNode: _model.textFieldFocusNode1,
                                        autofocus: false,
                                        enabled: true,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        textInputAction: TextInputAction.next,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          hintText: 'John',
                                          hintStyle: FlutterFlowTheme.of(
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
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF0077B6),
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          filled: true,
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                        ),
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
                                        keyboardType: TextInputType.name,
                                        validator: _model
                                            .textController1Validator
                                            .asValidator(context),
                                        inputFormatters: [
                                          if (!isAndroid && !isiOS)
                                            TextInputFormatter.withFunction(
                                                (oldValue, newValue) {
                                              return TextEditingValue(
                                                selection: newValue.selection,
                                                text: newValue.text
                                                    .toCapitalization(
                                                        TextCapitalization
                                                            .words),
                                              );
                                            }),
                                        ],
                                      ),
                                    ].divide(SizedBox(height: 6.0)),
                                  ),
                                ),
                              ].divide(SizedBox(width: 10.0)),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Email Address',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                    TextFormField(
                                      controller: _model.textController2 ??=
                                          TextEditingController(
                                        text: pEditProfileUserRow?.email,
                                      ),
                                      focusNode: _model.textFieldFocusNode2,
                                      autofocus: false,
                                      enabled: false,
                                      autofillHints: [AutofillHints.email],
                                      textInputAction: TextInputAction.next,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: 'dr.john@example.com',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontStyle,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 1.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFF0077B6),
                                            width: 1.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 20.0,
                                        ),
                                      ),
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
                                      keyboardType: TextInputType.emailAddress,
                                      validator: _model.textController2Validator
                                          .asValidator(context),
                                    ),
                                  ].divide(SizedBox(height: 6.0)),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Phone Number',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                    TextFormField(
                                      controller: _model.textController3,
                                      focusNode: _model.textFieldFocusNode3,
                                      autofocus: false,
                                      enabled: true,
                                      textInputAction: TextInputAction.next,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: pEditProfileUserRow?.phone
                                            ?.toString(),
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontStyle,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 1.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFF0077B6),
                                            width: 1.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        prefixIcon: Icon(
                                          Icons.phone_outlined,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 20.0,
                                        ),
                                      ),
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
                                      keyboardType: TextInputType.phone,
                                      validator: _model.textController3Validator
                                          .asValidator(context),
                                    ),
                                  ].divide(SizedBox(height: 6.0)),
                                ),
                              ].divide(SizedBox(height: 12.0)),
                            ),
                            Divider(
                              height: 8.0,
                              thickness: 1.0,
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            if (pEditProfileUserRow?.userType == 'Dentist')
                              FutureBuilder<List<DentistRow>>(
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
                                  List<DentistRow> columnDentistRowList =
                                      snapshot.data!;

                                  final columnDentistRow =
                                      columnDentistRowList.isNotEmpty
                                          ? columnDentistRowList.first
                                          : null;

                                  return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'PROFESSIONAL DETAILS',
                                        style: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .fontStyle,
                                              ),
                                              color: Color(0xFF0077B6),
                                              letterSpacing: 1.2,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .fontStyle,
                                            ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Specialization',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                              FlutterFlowDropDown<String>(
                                                controller: _model
                                                        .dropDownSpecializationValueController ??=
                                                    FormFieldController<String>(
                                                  _model.dropDownSpecializationValue ??=
                                                      columnDentistRow
                                                          ?.specialization,
                                                ),
                                                options: [
                                                  'General Dentistry',
                                                  'Orthodontics',
                                                  'Periodontics',
                                                  'Endodontics',
                                                  'Oral Surgery',
                                                  'Pediatric Dentistry',
                                                  'Prosthodontics'
                                                ],
                                                onChanged: (val) =>
                                                    safeSetState(() => _model
                                                            .dropDownSpecializationValue =
                                                        val),
                                                width: double.infinity,
                                                height: 52.0,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                hintText:
                                                    'Select your specialization',
                                                icon: Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 24.0,
                                                ),
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                elevation: 2.0,
                                                borderColor:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                borderWidth: 1.5,
                                                borderRadius: 10.0,
                                                margin: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 0.0),
                                                hidesUnderline: true,
                                                isSearchable: false,
                                                isMultiSelect: false,
                                              ),
                                            ].divide(SizedBox(height: 6.0)),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Years of Experience',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                              FlutterFlowDropDown<String>(
                                                controller: _model
                                                        .dropDownYrsOfExpValueController ??=
                                                    FormFieldController<String>(
                                                  _model.dropDownYrsOfExpValue ??=
                                                      columnDentistRow
                                                          ?.experience,
                                                ),
                                                options: [
                                                  'Less than 1 year',
                                                  '1 - 3 years',
                                                  '3 - 5 years',
                                                  '5 - 10 years',
                                                  '10+ years'
                                                ],
                                                onChanged: (val) =>
                                                    safeSetState(() => _model
                                                            .dropDownYrsOfExpValue =
                                                        val),
                                                width: double.infinity,
                                                height: 52.0,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                hintText:
                                                    'Select years of experience',
                                                icon: Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 24.0,
                                                ),
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                elevation: 2.0,
                                                borderColor:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                borderWidth: 1.5,
                                                borderRadius: 10.0,
                                                margin: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 0.0),
                                                hidesUnderline: true,
                                                isSearchable: false,
                                                isMultiSelect: false,
                                              ),
                                            ].divide(SizedBox(height: 6.0)),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Clinic / Hospital Name',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                              TextFormField(
                                                controller: _model
                                                        .textFieldClinicNameTextController ??=
                                                    TextEditingController(
                                                  text: columnDentistRow
                                                      ?.clinicName,
                                                ),
                                                focusNode: _model
                                                    .textFieldClinicNameFocusNode,
                                                autofocus: false,
                                                enabled: true,
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                textInputAction:
                                                    TextInputAction.next,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'e.g. Bright Smile Dental Clinic',
                                                  hintStyle: FlutterFlowTheme
                                                          .of(context)
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
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                      width: 1.5,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFF0077B6),
                                                      width: 1.5,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.5,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.5,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                  prefixIcon: Icon(
                                                    Icons
                                                        .local_hospital_outlined,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 20.0,
                                                  ),
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                validator: _model
                                                    .textFieldClinicNameTextControllerValidator
                                                    .asValidator(context),
                                                inputFormatters: [
                                                  if (!isAndroid && !isiOS)
                                                    TextInputFormatter
                                                        .withFunction((oldValue,
                                                            newValue) {
                                                      return TextEditingValue(
                                                        selection:
                                                            newValue.selection,
                                                        text: newValue.text
                                                            .toCapitalization(
                                                                TextCapitalization
                                                                    .words),
                                                      );
                                                    }),
                                                ],
                                              ),
                                            ].divide(SizedBox(height: 6.0)),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Clinic Address',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                              TextFormField(
                                                controller: _model
                                                        .textFieldClinicLocTextController ??=
                                                    TextEditingController(
                                                  text: columnDentistRow
                                                      ?.clinicLocation,
                                                ),
                                                focusNode: _model
                                                    .textFieldClinicLocFocusNode,
                                                autofocus: false,
                                                enabled: true,
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                textInputAction:
                                                    TextInputAction.next,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Street, City, State, ZIP',
                                                  hintStyle: FlutterFlowTheme
                                                          .of(context)
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
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                      width: 1.5,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFF0077B6),
                                                      width: 1.5,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.5,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0x00000000),
                                                      width: 1.5,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                  prefixIcon: Icon(
                                                    Icons.location_on_outlined,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 20.0,
                                                  ),
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                maxLines: 2,
                                                keyboardType:
                                                    TextInputType.streetAddress,
                                                validator: _model
                                                    .textFieldClinicLocTextControllerValidator
                                                    .asValidator(context),
                                                inputFormatters: [
                                                  if (!isAndroid && !isiOS)
                                                    TextInputFormatter
                                                        .withFunction((oldValue,
                                                            newValue) {
                                                      return TextEditingValue(
                                                        selection:
                                                            newValue.selection,
                                                        text: newValue.text
                                                            .toCapitalization(
                                                                TextCapitalization
                                                                    .words),
                                                      );
                                                    }),
                                                ],
                                              ),
                                            ].divide(SizedBox(height: 6.0)),
                                          ),
                                        ].divide(SizedBox(height: 12.0)),
                                      ),
                                      Divider(
                                        height: 8.0,
                                        thickness: 1.0,
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                      ),
                                      Text(
                                        'CREDENTIALS',
                                        style: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .fontStyle,
                                              ),
                                              color: Color(0xFF0077B6),
                                              letterSpacing: 1.2,
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .fontStyle,
                                            ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 15.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Dental School / University',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                TextFormField(
                                                  controller: _model
                                                          .textFieldDentalSchoolTextController ??=
                                                      TextEditingController(
                                                    text: columnDentistRow
                                                        ?.dentalSchool,
                                                  ),
                                                  focusNode: _model
                                                      .textFieldDentalSchoolFocusNode,
                                                  autofocus: false,
                                                  enabled: true,
                                                  textCapitalization:
                                                      TextCapitalization.words,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'e.g. Harvard School of Dental Medicine',
                                                    hintStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .bodySmall
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
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
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        width: 1.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0xFF0077B6),
                                                        width: 1.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0x00000000),
                                                        width: 1.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0x00000000),
                                                        width: 1.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    filled: true,
                                                    fillColor: FlutterFlowTheme
                                                            .of(context)
                                                        .secondaryBackground,
                                                    prefixIcon: Icon(
                                                      Icons.school_outlined,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                  validator: _model
                                                      .textFieldDentalSchoolTextControllerValidator
                                                      .asValidator(context),
                                                  inputFormatters: [
                                                    if (!isAndroid && !isiOS)
                                                      TextInputFormatter
                                                          .withFunction(
                                                              (oldValue,
                                                                  newValue) {
                                                        return TextEditingValue(
                                                          selection: newValue
                                                              .selection,
                                                          text: newValue.text
                                                              .toCapitalization(
                                                                  TextCapitalization
                                                                      .words),
                                                        );
                                                      }),
                                                  ],
                                                ),
                                              ].divide(SizedBox(height: 6.0)),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Graduation Year',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                TextFormField(
                                                  controller: _model
                                                          .textFieldGradYearTextController ??=
                                                      TextEditingController(
                                                    text: columnDentistRow
                                                        ?.graduationYear,
                                                  ),
                                                  focusNode: _model
                                                      .textFieldGradYearFocusNode,
                                                  autofocus: false,
                                                  enabled: true,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    hintText: 'e.g. 2015',
                                                    hintStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .bodySmall
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
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
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        width: 1.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0xFF0077B6),
                                                        width: 1.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0x00000000),
                                                        width: 1.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0x00000000),
                                                        width: 1.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    filled: true,
                                                    fillColor: FlutterFlowTheme
                                                            .of(context)
                                                        .secondaryBackground,
                                                    prefixIcon: Icon(
                                                      Icons
                                                          .calendar_today_outlined,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  validator: _model
                                                      .textFieldGradYearTextControllerValidator
                                                      .asValidator(context),
                                                ),
                                              ].divide(SizedBox(height: 6.0)),
                                            ),
                                          ].divide(SizedBox(height: 12.0)),
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 5.0)),
                                  );
                                },
                              ),
                          ].divide(SizedBox(height: 20.0)),
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
