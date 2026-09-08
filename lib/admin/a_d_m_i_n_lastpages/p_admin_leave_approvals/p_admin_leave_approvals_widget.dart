import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'p_admin_leave_approvals_model.dart';
export 'p_admin_leave_approvals_model.dart';

class PAdminLeaveApprovalsWidget extends StatefulWidget {
  const PAdminLeaveApprovalsWidget({super.key});

  static String routeName = 'PAdminLeaveApprovals';
  static String routePath = '/pAdminLeaveApprovals';

  @override
  State<PAdminLeaveApprovalsWidget> createState() =>
      _PAdminLeaveApprovalsWidgetState();
}

class _PAdminLeaveApprovalsWidgetState extends State<PAdminLeaveApprovalsWidget> {
  late PAdminLeaveApprovalsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String generateUUID() {
    final r = DateTime.now().microsecondsSinceEpoch;
    String hex(int val, int len) => val.toRadixString(16).padLeft(len, '0');
    return '${hex(r & 0xFFFFFFFF, 8)}-${hex((r >> 32) & 0xFFFF, 4)}-4${hex((r >> 48) & 0xFFF, 3)}-8${hex((r >> 56) & 0xFFF, 3)}-${hex(r & 0xFFFFFFFFFFFF, 12)}';
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PAdminLeaveApprovalsModel());
    _model.initState(context);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildLeaveCard(LeaveRequestRow leave, UserRow? dentistUser) {
    final String dentistName = dentistUser?.fullname ?? 'Dentist';
    final nameParts = dentistName.trim().split(RegExp(r'\s+'));
    final initials = nameParts.length >= 2
        ? '${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}'.toUpperCase()
        : nameParts.isNotEmpty && nameParts[0].isNotEmpty
            ? nameParts[0][0].toUpperCase()
            : 'DR';

    Color statusColor = const Color(0xFFF59E0B);
    Color statusBgColor = const Color(0xFFFFF7ED);
    String statusText = 'PENDING';
    if (leave.status == 'Approved') {
      statusColor = const Color(0xFF10B981);
      statusBgColor = const Color(0xFFECFDF5);
      statusText = 'APPROVED';
    } else if (leave.status == 'Rejected') {
      statusColor = const Color(0xFFEF4444);
      statusBgColor = const Color(0xFFFEF2F2);
      statusText = 'REJECTED';
    }

    final isPending = leave.status == 'Pending';

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 0,
      color: FlutterFlowTheme.of(context).secondaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundColor: FlutterFlowTheme.of(context).accent1,
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dentistName,
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${dateTimeFormat("yMMMd", leave.startDate)} - ${dateTimeFormat("yMMMd", leave.endDate)}',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              'Reason: ${leave.reason ?? "No reason specified"}',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: GoogleFonts.inter().fontFamily,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            if (isPending) ...[
              const Divider(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await LeaveRequestTable().update(
                        data: {
                          'status': 'Rejected',
                          'reviewed_by': currentUserUid,
                          'updated_at': DateTime.now().toIso8601String(),
                        },
                        matchingRows: (q) => q.eq('request_id', leave.requestId!),
                      );
                      await NotificationTable().insert({
                        'notification_id': generateUUID(),
                        'user_id': leave.dentistId,
                        'title': 'Leave Request Rejected',
                        'body': 'Your leave request for ${dateTimeFormat("yMMMd", leave.startDate)} to ${dateTimeFormat("yMMMd", leave.endDate)} has been rejected.',
                        'type': 'leave_rejected',
                        'reference_id': leave.requestId,
                        'is_read': false,
                        'created_at': DateTime.now().toIso8601String(),
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Leave request rejected.')),
                      );
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEF2F2),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                    child: const Text('Reject', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12.0),
                  ElevatedButton(
                    onPressed: () async {
                      await LeaveRequestTable().update(
                        data: {
                          'status': 'Approved',
                          'reviewed_by': currentUserUid,
                          'updated_at': DateTime.now().toIso8601String(),
                        },
                        matchingRows: (q) => q.eq('request_id', leave.requestId!),
                      );
                      await NotificationTable().insert({
                        'notification_id': generateUUID(),
                        'user_id': leave.dentistId,
                        'title': 'Leave Request Approved',
                        'body': 'Your leave request for ${dateTimeFormat("yMMMd", leave.startDate)} to ${dateTimeFormat("yMMMd", leave.endDate)} has been approved.',
                        'type': 'leave_approved',
                        'reference_id': leave.requestId,
                        'is_read': false,
                        'created_at': DateTime.now().toIso8601String(),
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Leave request approved.')),
                      );
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFECFDF5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                    child: const Text('Approve', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
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
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
            'Leave Approvals',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: GoogleFonts.interTight().fontFamily,
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
          elevation: 0.5,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Search & Filter Header Section
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 8.0),
                child: TextFormField(
                  controller: _model.searchController,
                  focusNode: _model.searchFocusNode,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: 'Search dentist leaves...',
                    labelStyle: FlutterFlowTheme.of(context).labelMedium,
                    hintText: 'Enter dentist name...',
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
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding: const EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    suffixIcon: _model.searchController!.text.isNotEmpty
                        ? InkWell(
                            onTap: () async {
                              _model.searchController!.clear();
                              setState(() {});
                            },
                            child: Icon(
                              Icons.clear,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 22.0,
                            ),
                          )
                        : null,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ),
              // Status Filters Section
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: FlutterFlowChoiceChips(
                        options: const [
                          ChipData('Pending'),
                          ChipData('Approved'),
                          ChipData('Rejected'),
                          ChipData('All'),
                        ],
                        onChanged: (val) {
                          setState(() {
                            _model.choiceChipsValue = val?.firstOrNull;
                          });
                        },
                        selectedChipStyle: ChipStyle(
                          backgroundColor: FlutterFlowTheme.of(context).primary,
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: GoogleFonts.interTight().fontFamily,
                                color: Colors.white,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                          iconColor: Colors.white,
                          iconSize: 18.0,
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        unselectedChipStyle: ChipStyle(
                          backgroundColor: FlutterFlowTheme.of(context).alternate,
                          textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: GoogleFonts.inter().fontFamily,
                                color: FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 13.0,
                              ),
                          iconColor: FlutterFlowTheme.of(context).secondaryText,
                          iconSize: 18.0,
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        controller: _model.choiceChipsValueController ??=
                            FormFieldController<List<String>>(
                          ['Pending'],
                        ),
                        wrapped: false,
                        chipSpacing: 8.0,
                        multiselect: false,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 12.0, thickness: 1.0),
              // List Content Section
              Expanded(
                child: FutureBuilder<List<UserRow>>(
                  future: UserTable().queryRows(queryFn: (q) => q.eq('user_type', 'Dentist')),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final dentists = userSnapshot.data ?? [];
                    final dentistMap = {for (var d in dentists) d.userId: d};

                    return StreamBuilder<List<LeaveRequestRow>>(
                      stream: SupaFlow.client
                          .from("Leave_Request")
                          .stream(primaryKey: ['request_id'])
                          .order('created_at', ascending: false)
                          .map((list) => list.map((item) => LeaveRequestRow(item)).toList()),
                      builder: (context, leaveSnapshot) {
                        if (leaveSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!leaveSnapshot.hasData || leaveSnapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              'No leave requests found.',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          );
                        }

                        final filterStatus = _model.choiceChipsValue ?? 'Pending';
                        final query = _model.searchController?.text.toLowerCase() ?? '';

                        final filteredLeaves = leaveSnapshot.data!.where((leave) {
                          // 1. Status Filter
                          if (filterStatus != 'All' && leave.status != filterStatus) {
                            return false;
                          }
                          // 2. Search Query Filter (by Dentist Name)
                          if (query.isNotEmpty) {
                            final dentistUser = dentistMap[leave.dentistId];
                            final dentistName = (dentistUser?.fullname ?? '').toLowerCase();
                            if (!dentistName.contains(query)) {
                              return false;
                            }
                          }
                          return true;
                        }).toList();

                        if (filteredLeaves.isEmpty) {
                          return Center(
                            child: Text(
                              'No leave requests match your criteria.',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          itemCount: filteredLeaves.length,
                          itemBuilder: (context, index) {
                            final leave = filteredLeaves[index];
                            return _buildLeaveCard(leave, dentistMap[leave.dentistId]);
                          },
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
