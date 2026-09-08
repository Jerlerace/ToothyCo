import os

filepath = 'lib/homepage_unified/homepage_unified_widget.dart'

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Revert imports
target_imports = """import 'dart:ui';
import 'dart:math' as math;"""
replacement_imports = "import 'dart:ui';"
content = content.replace(target_imports, replacement_imports, 1)

# 2. Revert GridView
target_gridview = """              GridView(
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
              ),"""

replacement_gridview = """              GridView(
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
                    title: 'Procedures',
                    count: procedures.length,
                    icon: Icons.medical_services_rounded,
                    color: const Color(0xFF8B5CF6),
                    bgColor: const Color(0xFFF5F3FF),
                    onTap: () => context.pushNamed(PProceduresViewAdminWidget.routeName),
                  ),
                ],
              ),"""

content = content.replace(target_gridview, replacement_gridview, 1)

# 3. Revert chart row
# We will read the original chart row from our target content list
# Since we know the builder pattern we wrote, let's write it down:
target_builder = """                                      Builder(
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
                                                            colors: [
                                                              Color(0xFF4F46E5),
                                                              Color(0xFF7C3AED)
                                                            ],
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
                                      ),"""

# Let's get the original static Row content.
# We can read the first part, middle parts, and ending parts to match it.
# Wait! Instead of hardcoding all 480 lines in this script, we can just replace the builder with a mock Row with the correct months or download/read it.
# Wait! Let's check: since we know the original file was not modified elsewhere, can we check if there's any file copy in app data? No.
# Wait! Let's write the static Row content back using the exact string from the history:
original_static_row = """                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Aug',
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
                                                      fontSize: 11.0,
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
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 28.0,
                                                    height: 60.0,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFF4F46E5),
                                                          Color(0xFF7C3AED)
                                                        ],
                                                        stops: [0.0, 1.0],
                                                        begin:
                                                            AlignmentDirectional(
                                                                0.0, -1.0),
                                                        end:
                                                            AlignmentDirectional(
                                                                0, 1.0),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 28.0,
                                                    height: 60.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF0F2F5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(width: 4.0)),
                                              ),
                                            ].divide(SizedBox(height: 4.0)),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Sep',
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
                                                      fontSize: 11.0,
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
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 28.0,
                                                    height: 80.0,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFF4F46E5),
                                                          Color(0xFF7C3AED)
                                                        ],
                                                        stops: [0.0, 1.0],
                                                        begin:
                                                            AlignmentDirectional(
                                                                0.0, -1.0),
                                                        end:
                                                            AlignmentDirectional(
                                                                0, 1.0),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 28.0,
                                                    height: 80.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF0F2F5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(width: 4.0)),
                                              ),
                                            ].divide(SizedBox(height: 4.0)),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Oct',
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
                                                      fontSize: 11.0,
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
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 28.0,
                                                    height: 100.0,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFF4F46E5),
                                                          Color(0xFF7C3AED)
                                                        ],
                                                        stops: [0.0, 1.0],
                                                        begin:
                                                            AlignmentDirectional(
                                                                0.0, -1.0),
                                                        end:
                                                            AlignmentDirectional(
                                                                0, 1.0),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 28.0,
                                                    height: 100.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF0F2F5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(width: 4.0)),
                                              ),
                                            ].divide(SizedBox(height: 4.0)),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Nov',
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
                                                      fontSize: 11.0,
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
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 28.0,
                                                    height: 75.0,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFF4F46E5),
                                                          Color(0xFF7C3AED)
                                                        ],
                                                        stops: [0.0, 1.0],
                                                        begin:
                                                            AlignmentDirectional(
                                                                0.0, -1.0),
                                                        end:
                                                            AlignmentDirectional(
                                                                0, 1.0),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 28.0,
                                                    height: 75.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF0F2F5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(width: 4.0)),
                                              ),
                                            ].divide(SizedBox(height: 4.0)),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Dec',
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
                                                      fontSize: 11.0,
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
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 28.0,
                                                    height: 120.0,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFF4F46E5),
                                                          Color(0xFF7C3AED)
                                                        ],
                                                        stops: [0.0, 1.0],
                                                        begin:
                                                            AlignmentDirectional(
                                                                0.0, -1.0),
                                                        end:
                                                            AlignmentDirectional(
                                                                0, 1.0),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 28.0,
                                                    height: 120.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF0F2F5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(width: 4.0)),
                                              ),
                                            ].divide(SizedBox(height: 4.0)),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Jan',
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
                                                      fontSize: 11.0,
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
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 28.0,
                                                    height: 90.0,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFF4F46E5),
                                                          Color(0xFF7C3AED)
                                                        ],
                                                        stops: [0.0, 1.0],
                                                        begin:
                                                            AlignmentDirectional(
                                                                0.0, -1.0),
                                                        end:
                                                            AlignmentDirectional(
                                                                0, 1.0),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 28.0,
                                                    height: 90.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF0F2F5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(width: 4.0)),
                                              ),
                                            ].divide(SizedBox(height: 4.0)),
                                          ),
                                        ].divide(SizedBox(width: 8.0)),
                                      )"""

content = content.replace(target_builder, original_static_row, 1)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Revert complete successfully!")
