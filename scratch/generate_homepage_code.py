import os

filepath = 'lib/homepage_unified/homepage_unified_widget.dart'

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Imports
target_imports = "import 'dart:ui';"
replacement_imports = """import 'dart:ui';
import 'dart:math' as math;
import '/custom_code/actions/index.dart' as actions;"""

# 2. Main Admin Workflow Tab Replacement
# Let's find lines 290 to 2132.
# We will locate the block using:
# Start: "if (homepageUnifiedUserRow?.userType == 'Admin')\n                      Column(\n                        mainAxisSize: MainAxisSize.max,\n                        children: [\n                          Padding(\n                            padding: EdgeInsetsDirectional.fromSTEB("
# End: "                            .divide(SizedBox(height: 20.0))\n                            .addToStart(SizedBox(height: 16.0))\n                            .addToEnd(SizedBox(height: 32.0)),\n                      ),"
# Let's write a python script that locates this block and replaces it.

start_marker = "if (homepageUnifiedUserRow?.userType == 'Admin')\n                      Column(\n                        mainAxisSize: MainAxisSize.max,"
end_marker = ".divide(SizedBox(height: 20.0))\n                            .addToStart(SizedBox(height: 16.0))\n                            .addToEnd(SizedBox(height: 32.0)),\n                      ),"

start_idx = content.find(start_marker)
if start_idx == -1:
    print("Could not find start marker!")
    exit(1)

end_idx = content.find(end_marker, start_idx)
if end_idx == -1:
    print("Could not find end marker!")
    exit(1)
end_idx += len(end_marker)

print(f"Found admin tab block from index {start_idx} to {end_idx}")

# Let's design the replacement block.
replacement_admin_tab = """if (homepageUnifiedUserRow?.userType == 'Admin')
                      FutureBuilder<List<dynamic>>(
                        future: Future.wait([
                          LeaveRequestTable().queryRows(queryFn: (q) => q.order('created_at', ascending: false)),
                          UserTable().queryRows(queryFn: (q) => q),
                          DentistTable().queryRows(queryFn: (q) => q),
                          PatientTable().queryRows(queryFn: (q) => q),
                          ProcedureTable().queryRows(queryFn: (q) => q),
                          actions.getMonthlyRevenueMetrics(filterType: '6M'),
                          AppointmentTable().queryRows(queryFn: (q) => q),
                          PaymentsTable().queryRows(queryFn: (q) => q.eq('status', 'Paid')),
                        ]),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ),
                            );
                          }
                          final leaves = snapshot.data![0] as List<LeaveRequestRow>;
                          final users = snapshot.data![1] as List<UserRow>;
                          final dentists = snapshot.data![2] as List<DentistRow>;
                          final patients = snapshot.data![3] as List<PatientRow>;
                          final procedures = snapshot.data![4] as List<ProcedureRow>;
                          final revenue6M = snapshot.data![5] as List<dynamic>;
                          final appointments = snapshot.data![6] as List<AppointmentRow>;
                          final payments = snapshot.data![7] as List<PaymentsRow>;

                          final userMap = {for (var u in users) u.userId: u};
                          final pendingLeaves = leaves.where((l) => l.status == 'Pending').toList();
                          final otherLeaves = leaves.where((l) => l.status != 'Pending').toList();
                          final pendingDentistApps = dentists.where((d) => d.status == 'Pending').length;

                          final now = DateTime.now();
                          final currentMonthPayments = payments.where((p) => p.createdAt != null && p.createdAt!.year == now.year && p.createdAt!.month == now.month);
                          final monthlyRevenue = currentMonthPayments.fold<int>(0, (sum, p) => sum + (p.amount ?? 0));
                          final totalAppointmentsCount = appointments.length;
                          final completedAppointmentsCount = appointments.where((a) => a.status == 'Completed').length;
                          final fulfillmentRate = appointments.isEmpty ? 0.0 : (completedAppointmentsCount / totalAppointmentsCount) * 100.0;

                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // 1. Metric Cards Row 1 (Total Appointments & Monthly Revenue)
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: InkWell(
                                          onTap: () async {
                                            context.pushNamed(AdminTotalPatientHistoryFocusWidget.routeName);
                                          },
                                          child: Container(
                                            width: 100.0,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 12.0,
                                                  color: const Color(0x334F46E5),
                                                  offset: const Offset(0.0, 4.0),
                                                )
                                              ],
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                                                stops: [0.0, 1.0],
                                                begin: AlignmentDirectional(1.0, 1.0),
                                                end: AlignmentDirectional(-1.0, -1.0),
                                              ),
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 36.0,
                                                        height: 36.0,
                                                        decoration: BoxDecoration(
                                                          color: const Color(0x33FFFFFF),
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        child: const Align(
                                                          alignment: AlignmentDirectional(0.0, 0.0),
                                                          child: Icon(
                                                            Icons.calendar_today_rounded,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: const AlignmentDirectional(1.0, -1.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: const Color(0x33FFFFFF),
                                                            borderRadius: BorderRadius.circular(12.0),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                const Icon(
                                                                  Icons.arrow_upward_rounded,
                                                                  color: Colors.white,
                                                                  size: 14.0,
                                                                ),
                                                                Text(
                                                                  '+12%',
                                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                        fontFamily: GoogleFonts.inter().fontFamily,
                                                                        color: Colors.white,
                                                                        fontSize: 11.0,
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
                                                  Text(
                                                    formatNumber(
                                                      totalAppointmentsCount,
                                                      formatType: FormatType.compact,
                                                    ),
                                                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                          fontFamily: GoogleFonts.interTight().fontFamily,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                  Text(
                                                    'Total Appointments',
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          fontFamily: GoogleFonts.inter().fontFamily,
                                                          color: const Color(0xCCFFFFFF),
                                                          fontSize: 11.0,
                                                        ),
                                                  ),
                                                ].divide(const SizedBox(height: 8.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: InkWell(
                                          onTap: () async {
                                            context.pushNamed(PRevenueViewWidget.routeName);
                                          },
                                          child: Container(
                                            width: 100.0,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 12.0,
                                                  color: const Color(0x3310B981),
                                                  offset: const Offset(0.0, 4.0),
                                                )
                                              ],
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFF10B981), Color(0xFF059669)],
                                                stops: [0.0, 1.0],
                                                begin: AlignmentDirectional(1.0, 1.0),
                                                end: AlignmentDirectional(-1.0, -1.0),
                                              ),
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 36.0,
                                                        height: 36.0,
                                                        decoration: BoxDecoration(
                                                          color: const Color(0x33FFFFFF),
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        child: const Align(
                                                          alignment: AlignmentDirectional(0.0, 0.0),
                                                          child: Icon(
                                                            Icons.attach_money_rounded,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: const AlignmentDirectional(1.0, -1.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: const Color(0x33FFFFFF),
                                                            borderRadius: BorderRadius.circular(12.0),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                const Icon(
                                                                  Icons.arrow_upward_rounded,
                                                                  color: Colors.white,
                                                                  size: 14.0,
                                                                ),
                                                                Text(
                                                                  '+8%',
                                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                        fontFamily: GoogleFonts.inter().fontFamily,
                                                                        color: Colors.white,
                                                                        fontSize: 11.0,
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
                                                  Text(
                                                    monthlyRevenue < 1000
                                                        ? '\\$$monthlyRevenue'
                                                        : '\\$${(monthlyRevenue / 1000.0).toStringAsFixed(1)}K',
                                                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                          fontFamily: GoogleFonts.interTight().fontFamily,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                  Text(
                                                    'Monthly Revenue',
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          fontFamily: GoogleFonts.inter().fontFamily,
                                                          color: const Color(0xCCFFFFFF),
                                                          fontSize: 11.0,
                                                        ),
                                                  ),
                                                ].divide(const SizedBox(height: 8.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ].divide(const SizedBox(width: 12.0)),
                                ),
                              ),
                              // 2. Metric Cards Row 2 (Patients & Fulfillment Rate)
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: InkWell(
                                          onTap: () async {
                                            context.pushNamed(PPatientManagementWidget.routeName);
                                          },
                                          child: Container(
                                            width: 100.0,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 12.0,
                                                  color: const Color(0x33F59E0B),
                                                  offset: const Offset(0.0, 4.0),
                                                )
                                              ],
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                                                stops: [0.0, 1.0],
                                                begin: AlignmentDirectional(1.0, 1.0),
                                                end: AlignmentDirectional(-1.0, -1.0),
                                              ),
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 36.0,
                                                        height: 36.0,
                                                        decoration: BoxDecoration(
                                                          color: const Color(0x33FFFFFF),
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        child: const Align(
                                                          alignment: AlignmentDirectional(0.0, 0.0),
                                                          child: Icon(
                                                            Icons.people_alt_rounded,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: const AlignmentDirectional(1.0, -1.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: const Color(0x33FFFFFF),
                                                            borderRadius: BorderRadius.circular(12.0),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                const Icon(
                                                                  Icons.arrow_upward_rounded,
                                                                  color: Colors.white,
                                                                  size: 14.0,
                                                                ),
                                                                Text(
                                                                  '+24%',
                                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                        fontFamily: GoogleFonts.inter().fontFamily,
                                                                        color: Colors.white,
                                                                        fontSize: 11.0,
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
                                                  Text(
                                                    formatNumber(
                                                      patients.length,
                                                      formatType: FormatType.compact,
                                                    ),
                                                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                          fontFamily: GoogleFonts.interTight().fontFamily,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                  Text(
                                                    'Patients',
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          fontFamily: GoogleFonts.inter().fontFamily,
                                                          color: const Color(0xCCFFFFFF),
                                                          fontSize: 11.0,
                                                        ),
                                                  ),
                                                ].divide(const SizedBox(height: 8.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: InkWell(
                                          onTap: () async {},
                                          child: Container(
                                            width: 100.0,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 12.0,
                                                  color: const Color(0x33EF4444),
                                                  offset: const Offset(0.0, 4.0),
                                                )
                                              ],
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                                                stops: [0.0, 1.0],
                                                begin: AlignmentDirectional(1.0, 1.0),
                                                end: AlignmentDirectional(-1.0, -1.0),
                                              ),
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 36.0,
                                                        height: 36.0,
                                                        decoration: BoxDecoration(
                                                          color: const Color(0x33FFFFFF),
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        child: const Align(
                                                          alignment: AlignmentDirectional(0.0, 0.0),
                                                          child: Icon(
                                                            Icons.trending_up_rounded,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: const AlignmentDirectional(1.0, -1.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: const Color(0x33FFFFFF),
                                                            borderRadius: BorderRadius.circular(12.0),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                const Icon(
                                                                  Icons.arrow_upward_rounded,
                                                                  color: Colors.white,
                                                                  size: 14.0,
                                                                ),
                                                                Text(
                                                                  '+3%',
                                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                        fontFamily: GoogleFonts.inter().fontFamily,
                                                                        color: Colors.white,
                                                                        fontSize: 11.0,
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
                                                  Text(
                                                    '${fulfillmentRate.toStringAsFixed(1)}%',
                                                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                                                          fontFamily: GoogleFonts.interTight().fontFamily,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                  Text(
                                                    'Fulfillment Rate',
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          fontFamily: GoogleFonts.inter().fontFamily,
                                                          color: const Color(0xCCFFFFFF),
                                                          fontSize: 11.0,
                                                        ),
                                                  ),
                                                ].divide(const SizedBox(height: 8.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ].divide(const SizedBox(width: 12.0)),
                                ),
                              ),
                              // 3. Revenue Overview Chart Section
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).alternate,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Revenue Overview',
                                                  style: FlutterFlowTheme.of(context).titleMedium.override(
                                                        fontFamily: GoogleFonts.interTight().fontFamily,
                                                        fontWeight: FontWeight.bold,
                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                      ),
                                                ),
                                                Text(
                                                  'Last 6 months performance',
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: GoogleFonts.inter().fontFamily,
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                        fontSize: 11.0,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: 30.0,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF0F2F5),
                                                borderRadius: BorderRadius.circular(20.0),
                                              ),
                                              child: Align(
                                                alignment: const AlignmentDirectional(0.0, 0.0),
                                                child: Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                                  child: Text(
                                                    now.year.toString(),
                                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                                          fontFamily: GoogleFonts.inter().fontFamily,
                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                          fontSize: 12.0,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Builder(
                                          builder: (context) {
                                            final maxRevVal = revenue6M.isEmpty
                                                ? 150000.0
                                                : revenue6M.map<double>((e) => math.max((e['current_revenue'] as num).toDouble(), (e['target_revenue'] as num).toDouble())).reduce(math.max);
                                            final double capHeight = 120.0;
                                            return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: revenue6M.map<Widget>((item) {
                                                final month = item['month'] as String? ?? '';
                                                final currentRevenue = (item['current_revenue'] as num? ?? 0).toDouble();
                                                final targetRevenue = (item['target_revenue'] as num? ?? 0).toDouble();
                                                
                                                final currentHeight = maxRevVal > 0 ? (currentRevenue / maxRevVal) * capHeight : 0.0;
                                                final targetHeight = maxRevVal > 0 ? (targetRevenue / maxRevVal) * capHeight : 0.0;
                                                
                                                return Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      month,
                                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: GoogleFonts.inter().fontFamily,
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                        fontSize: 11.0,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        Container(
                                                          width: 28.0,
                                                          height: math.max(currentHeight, 4.0),
                                                          decoration: BoxDecoration(
                                                            gradient: const LinearGradient(
                                                              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                                                              stops: [0.0, 1.0],
                                                              begin: AlignmentDirectional(0.0, -1.0),
                                                              end: AlignmentDirectional(0, 1.0),
                                                            ),
                                                            borderRadius: BorderRadius.circular(6.0),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 28.0,
                                                          height: math.max(targetHeight, 4.0),
                                                          decoration: BoxDecoration(
                                                            color: const Color(0xFFF0F2F5),
                                                            borderRadius: BorderRadius.circular(6.0),
                                                          ),
                                                        ),
                                                      ].divide(const SizedBox(width: 4.0)),
                                                    ),
                                                  ].divide(const SizedBox(height: 4.0)),
                                                );
                                              }).toList().divide(const SizedBox(width: 8.0)),
                                            );
                                          },
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 10.0,
                                                  height: 10.0,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF4F46E5),
                                                    borderRadius: BorderRadius.circular(2.0),
                                                  ),
                                                ),
                                                Text(
                                                  'Revenue',
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: GoogleFonts.inter().fontFamily,
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                      ),
                                                ),
                                              ].divide(const SizedBox(width: 4.0)),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 10.0,
                                                  height: 10.0,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFF0F2F5),
                                                    borderRadius: BorderRadius.circular(2.0),
                                                  ),
                                                ),
                                                Text(
                                                  'Target',
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: GoogleFonts.inter().fontFamily,
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                      ),
                                                ),
                                              ].divide(const SizedBox(width: 4.0)),
                                            ),
                                          ].divide(const SizedBox(width: 16.0)),
                                        ),
                                      ].divide(const SizedBox(height: 20.0)),
                                    ),
                                  ),
                                ),
                              ),
                              // 4. Workflow Control GridView
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Workflow Control',
                                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                                            fontFamily: GoogleFonts.interTight().fontFamily,
                                            fontWeight: FontWeight.bold,
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            fontSize: 20.0,
                                          ),
                                    ),
                                    Text(
                                      'Quick shortcuts to manage clinic data and users',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: GoogleFonts.inter().fontFamily,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                    ),
                                    const SizedBox(height: 12.0),
                                    GridView(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12.0,
                                        mainAxisSpacing: 12.0,
                                        childAspectRatio: 1.5,
                                      ),
                                      children: [
                                        _buildWorkflowCard(
                                          title: 'Dentist Requests',
                                          count: pendingDentistApps,
                                          icon: Icons.assignment_ind_rounded,
                                          color: const Color(0xFFF97316),
                                          bgColor: const Color(0xFFFFF7ED),
                                          onTap: () => context.pushNamed(PAdminDentistRequestsWidget.routeName),
                                        ),
                                        _buildWorkflowCard(
                                          title: 'User Roles',
                                          count: users.length,
                                          icon: Icons.people_alt_rounded,
                                          color: const Color(0xFF3B82F6),
                                          bgColor: const Color(0xFFEFF6FF),
                                          onTap: () => context.pushNamed(PUserManagementWidget.routeName),
                                        ),
                                        _buildWorkflowCard(
                                          title: 'Patients Directory',
                                          count: patients.length,
                                          icon: Icons.folder_shared_rounded,
                                          color: const Color(0xFF10B981),
                                          bgColor: const Color(0xFFECFDF5),
                                          onTap: () => context.pushNamed(PPatientManagementWidget.routeName),
                                        ),
                                        _buildWorkflowCard(
                                          title: 'Dentist Directory',
                                          count: dentists.length,
                                          icon: Icons.supervised_user_circle_rounded,
                                          color: const Color(0xFF0F766E),
                                          bgColor: const Color(0xFFF0FDFA),
                                          onTap: () => context.pushNamed(PDentistManagementWidget.routeName),
                                        ),
                                        _buildWorkflowCard(
                                          title: 'Procedures',
                                          count: procedures.length,
                                          icon: Icons.medical_services_rounded,
                                          color: const Color(0xFF8B5CF6),
                                          bgColor: const Color(0xFFF5F3FF),
                                          onTap: () => context.pushNamed(PProceduresViewAdminWidget.routeName),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // 5. Dentist Leave Approvals Section
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dentist Leave Approvals',
                                      style: FlutterFlowTheme.of(context).titleLarge.override(
                                            fontFamily: GoogleFonts.interTight().fontFamily,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 12.0),
                                    if (pendingLeaves.isEmpty && otherLeaves.isEmpty)
                                      Card(
                                        elevation: 0,
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Center(
                                            child: Text(
                                              'No leave requests found.',
                                              style: FlutterFlowTheme.of(context).bodyMedium,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ...pendingLeaves.map((l) => _buildLeaveCard(l, userMap[l.dentistId], true)),
                                    ...otherLeaves.map((l) => _buildLeaveCard(l, userMap[l.dentistId], false)),
                                  ],
                                ),
                              ),
                            ].divide(const SizedBox(height: 24.0)),
                          );
                        },
                      )"""

# Perform replacements
content = content.replace(target_imports, replacement_imports, 1)

# Revert previous chart row replacement (if any) and replace the main block
content = content[:start_idx] + replacement_admin_tab + content[end_idx:]

# Also, delete the unused _buildAdminWorkflow method at the end of the file to prevent warnings/errors.
# Let's search for the unused method:
unused_method_start = "  Widget _buildAdminWorkflow(UserRow? adminRow) {"
unused_method_idx = content.find(unused_method_start)
if unused_method_idx != -1:
    # Let's find where this method ends.
    # It ends before "  Widget _buildDentistWorkflow("
    unused_method_end_idx = content.find("  Widget _buildDentistWorkflow(", unused_method_idx)
    if unused_method_end_idx != -1:
        print(f"Removing unused _buildAdminWorkflow method at end of file")
        content = content[:unused_method_idx] + content[unused_method_end_idx:]

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Replacement complete successfully!")
