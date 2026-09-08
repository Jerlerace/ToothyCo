import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'p_procedures_npricing_patient_model.dart';
import '/patient/p_book_appointment_patient/p_book_appointment_patient_widget.dart';
export 'p_procedures_npricing_patient_model.dart';

/// 8.
///
/// Procedures & Pricing Page
///
/// Design service cards for cleaning, extraction, x-ray, filling, crowns,
/// checkup. Each card includes service name, price, short description, clean
/// card layout.
class PProceduresNpricingPatientWidget extends StatefulWidget {
  const PProceduresNpricingPatientWidget({super.key});

  static String routeName = 'P_ProceduresNpricing_patient';
  static String routePath = '/pProceduresNpricingPatient';

  @override
  State<PProceduresNpricingPatientWidget> createState() =>
      _PProceduresNpricingPatientWidgetState();
}

class _PProceduresNpricingPatientWidgetState
    extends State<PProceduresNpricingPatientWidget> {
  late PProceduresNpricingPatientModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<ProcedureRow> allProcedures = [];
  List<ProcedureRow> filteredProcedures = [];
  bool isLoading = true;
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PProceduresNpricingPatientModel());
    _model.searchFocusNode = FocusNode();
    _model.searchController = TextEditingController();
    _model.searchController!.addListener(_onSearchChanged);
    _loadProcedures();
  }

  @override
  void dispose() {
    _model.searchController?.removeListener(_onSearchChanged);
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadProcedures() async {
    try {
      final data = await ProcedureTable().queryRows(
        queryFn: (q) => q.eq('status', 'Active'),
      );
      setState(() {
        allProcedures = data;
        filteredProcedures = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading procedures: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    final query = _model.searchController?.text.toLowerCase() ?? '';
    setState(() {
      filteredProcedures = allProcedures.where((p) {
        final matchesQuery = p.procedureName.toLowerCase().contains(query) ||
            (p.procedureDescription?.toLowerCase().contains(query) ?? false);
        final matchesCategory = selectedCategory == 'All' || p.category == selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
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
            'Procedures & Pricing',
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
                        'Dental Services & Pricing',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily: GoogleFonts.interTight().fontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      content: Text(
                        'Browse the clinic\'s list of dental procedures and estimated pricing. Select services to see cost ranges, procedure descriptions, and duration details.',
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
        body: isLoading
            ? Center(
                child: SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextFormField(
                      controller: _model.searchController,
                      focusNode: _model.searchFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Search procedures...',
                        hintStyle: FlutterFlowTheme.of(context).labelMedium,
                        prefixIcon: Icon(Icons.search, color: FlutterFlowTheme.of(context).secondaryText, size: 20),
                        suffixIcon: _model.searchController!.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _model.searchController!.clear();
                                },
                              )
                            : null,
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
                        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      ),
                      onChanged: (_) => _applyFilters(),
                    ),
                  ),

                  // Category Filter Chips
                  if (allProcedures.isNotEmpty)
                    Container(
                      height: 44,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        children: [
                          'All',
                          ...allProcedures
                              .map((p) => p.category)
                              .where((cat) => cat != null && cat!.isNotEmpty)
                              .cast<String>()
                              .toSet()
                        ].map((cat) {
                          final isSelected = selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(cat),
                              selected: isSelected,
                              selectedColor: FlutterFlowTheme.of(context).primary,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  selectedCategory = cat;
                                  _applyFilters();
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Services List',
                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily: GoogleFonts.interTight().fontFamily,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).accent1,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(12.0, 6.0, 12.0, 6.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.local_offer_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 14.0,
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  '${filteredProcedures.length} Services',
                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                        fontFamily: GoogleFonts.inter().fontFamily,
                                        color: FlutterFlowTheme.of(context).primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: filteredProcedures.isEmpty
                        ? Center(
                            child: Text(
                              'No procedures match your search.',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(0, 12.0, 0, 32.0),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: filteredProcedures.length,
                            itemBuilder: (context, listViewIndex) {
                              final listViewProcedureRow = filteredProcedures[listViewIndex];
                              return Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 5.0, 16.0, 5.0),
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
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 48.0,
                                                    height: 48.0,
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFFE8F4FF),
                                                      borderRadius: BorderRadius.circular(14.0),
                                                    ),
                                                    child: const Align(
                                                      alignment: AlignmentDirectional(0.0, 0.0),
                                                      child: Icon(
                                                        Icons.cleaning_services_rounded,
                                                        color: Colors.blue,
                                                        size: 24.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        listViewProcedureRow.procedureName,
                                                        style: FlutterFlowTheme.of(context).titleMedium.override(
                                                              fontFamily: GoogleFonts.interTight().fontFamily,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                      ),
                                                      Text(
                                                        valueOrDefault<String>(
                                                          listViewProcedureRow.category,
                                                          'category',
                                                        ),
                                                        style: FlutterFlowTheme.of(context).labelSmall.override(
                                                              fontFamily: GoogleFonts.inter().fontFamily,
                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(const SizedBox(width: 12.0)),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    formatNumber(
                                                      listViewProcedureRow.pricing!,
                                                      formatType: FormatType.compact,
                                                    ),
                                                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                          fontFamily: GoogleFonts.interTight().fontFamily,
                                                          color: FlutterFlowTheme.of(context).primary,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                  Text(
                                                    'per session',
                                                    style: FlutterFlowTheme.of(context).labelSmall.override(
                                                          fontFamily: GoogleFonts.inter().fontFamily,
                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          height: 1.0,
                                          thickness: 1.0,
                                          color: FlutterFlowTheme.of(context).alternate,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            valueOrDefault<String>(
                                              listViewProcedureRow.procedureDescription,
                                              'procedure_description',
                                            ),
                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                  fontFamily: GoogleFonts.inter().fontFamily,
                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                  lineHeight: 1.5,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Icon(
                                                        Icons.schedule_rounded,
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                        size: 14.0,
                                                      ),
                                                      Text(
                                                        valueOrDefault<String>(
                                                          listViewProcedureRow.timeDuration,
                                                          'timeDuration',
                                                        ),
                                                        style: FlutterFlowTheme.of(context).labelSmall.override(
                                                              fontFamily: GoogleFonts.inter().fontFamily,
                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                            ),
                                                      ),
                                                    ].divide(const SizedBox(width: 4.0)),
                                                  ),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Icon(
                                                        Icons.repeat_rounded,
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                        size: 14.0,
                                                      ),
                                                      Text(
                                                        'Every 6 months',
                                                        style: FlutterFlowTheme.of(context).labelSmall.override(
                                                              fontFamily: GoogleFonts.inter().fontFamily,
                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                            ),
                                                      ),
                                                    ].divide(const SizedBox(width: 4.0)),
                                                  ),
                                                ].divide(const SizedBox(width: 16.0)),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  context.pushNamed(
                                                    PBookAppointmentPatientWidget.routeName,
                                                    queryParameters: {
                                                      'initialProcedureId': serializeParam(
                                                        listViewProcedureRow.procedureId,
                                                        ParamType.String,
                                                      ),
                                                    }.withoutNulls,
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFE8F4FF),
                                                    borderRadius: BorderRadius.circular(8.0),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(12.0, 6.0, 12.0, 6.0),
                                                    child: Text(
                                                      'Book Now',
                                                      style: FlutterFlowTheme.of(context).labelSmall.override(
                                                            fontFamily: GoogleFonts.inter().fontFamily,
                                                            color: Colors.blue,
                                                            fontWeight: FontWeight.bold,
                                                          ),
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
                          ),
                  ),
                ],
              )
    ),
  );
}
}
