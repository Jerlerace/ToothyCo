import os

filepath = 'lib/admin/a_d_m_i_n_lastpages/p_revenue_view/p_revenue_view_widget.dart'

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Imports
target_imports = "import '/custom_code/actions/index.dart' as actions;"
replacement_imports = """import '/custom_code/actions/index.dart' as actions;
import 'dart:math' as math;
import 'package:intl/intl.dart';"""

# 2. Build start
target_build = """  @override
  Widget build(BuildContext context) {
    return GestureDetector("""
replacement_build = """  @override
  Widget build(BuildContext context) {
    final currentPeriodSum = _model.localRevenueList.fold<double>(0.0, (sum, item) => sum + (item['current_revenue'] as num? ?? 0).toDouble());
    final previousPeriodSum = _model.localRevenueList.fold<double>(0.0, (sum, item) => sum + (item['previous_revenue'] as num? ?? 0).toDouble());
    final targetPeriodSum = _model.localRevenueList.fold<double>(0.0, (sum, item) => sum + (item['target_revenue'] as num? ?? 0).toDouble());
    final progressPercent = targetPeriodSum > 0 ? math.min(1.0, math.max(0.0, currentPeriodSum / targetPeriodSum)) : 0.0;
    final previousProgressPercent = targetPeriodSum > 0 ? math.min(1.0, math.max(0.0, previousPeriodSum / targetPeriodSum)) : 0.0;
    final growthRate = previousPeriodSum > 0 ? ((currentPeriodSum - previousPeriodSum) / previousPeriodSum) * 100 : 0.0;
    return GestureDetector("""

# 3. Top growth rate
target_top_growth = """                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0x33FFFFFF),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          8.0, 4.0, 8.0, 4.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.arrow_upward_rounded,
                                            color: Color(0xFF4ADE80),
                                            size: 14.0,
                                          ),
                                          Text(
                                            '+12.4%',
                                            style: FlutterFlowTheme.of(context)
                                                .labelSmall
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelSmall
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFF4ADE80),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelSmall
                                                          .fontStyle,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),"""
replacement_top_growth = """                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0x33FFFFFF),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          8.0, 4.0, 8.0, 4.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            growthRate >= 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                                            color: growthRate >= 0 ? const Color(0xFF4ADE80) : const Color(0xFFF87171),
                                            size: 14.0,
                                          ),
                                          Text(
                                            '${growthRate >= 0 ? '+' : ''}${growthRate.toStringAsFixed(1)}%',
                                            style: FlutterFlowTheme.of(context)
                                                .labelSmall
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelSmall
                                                            .fontStyle,
                                                  ),
                                                  color: growthRate >= 0 ? const Color(0xFF4ADE80) : const Color(0xFFF87171),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelSmall
                                                          .fontStyle,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),"""

# 4. Top progress indicator
target_top_progress = """                              LinearPercentIndicator(
                                percent: 0.856,
                                width: 120.0,
                                lineHeight: 6.0,
                                animation: true,
                                animateFromLastPercent: true,
                                progressColor: Color(0xFF4ADE80),
                                backgroundColor: Color(0x33FFFFFF),
                                barRadius: Radius.circular(4.0),
                                padding: EdgeInsets.zero,
                              ),"""
replacement_top_progress = """                              LinearPercentIndicator(
                                percent: progressPercent,
                                width: 120.0,
                                lineHeight: 6.0,
                                animation: true,
                                animateFromLastPercent: true,
                                progressColor: const Color(0xFF4ADE80),
                                backgroundColor: const Color(0x33FFFFFF),
                                barRadius: Radius.circular(4.0),
                                padding: EdgeInsets.zero,
                              ),"""

# 5. Chart row (Jan to Jun)
start_pattern = "Expanded(\n                                              child: Row(\n                                                mainAxisSize: MainAxisSize.max,\n                                                mainAxisAlignment:\n                                                    MainAxisAlignment\n                                                        .spaceAround,\n                                                crossAxisAlignment:\n                                                    CrossAxisAlignment.end,\n                                                children: [\n                                                  Column(\n                                                    mainAxisSize:"
end_pattern = "].divide(\n                                                        SizedBox(height: 4.0)),\n                                                  ),\n                                                ],\n                                              ),\n                                            ),"

start_idx = content.find("Expanded(\n                                              child: Row(\n                                                mainAxisSize: MainAxisSize.max,\n                                                mainAxisAlignment:\n                                                    MainAxisAlignment\n                                                        .spaceAround,\n                                                crossAxisAlignment:\n                                                    CrossAxisAlignment.end,\n                                                children: [\n                                                  Column(\n                                                    mainAxisSize:")
end_idx = content.find("].divide(\n                                                        SizedBox(height: 4.0)),\n                                                  ),\n                                                ],\n                                              ),\n                                            ),", start_idx) + len("].divide(\n                                                        SizedBox(height: 4.0)),\n                                                  ),\n                                                ],\n                                              ),\n                                            ),")

chart_row_target = content[start_idx:end_idx]

replacement_chart_row = """Expanded(
                                              child: Builder(
                                                builder: (context) {
                                                  final maxRevVal = _model.localRevenueList.isEmpty
                                                      ? 150000.0
                                                      : _model.localRevenueList.map<double>((e) => math.max(
                                                          (e['current_revenue'] as num).toDouble(),
                                                          math.max(
                                                            (e['previous_revenue'] as num).toDouble(),
                                                            (e['target_revenue'] as num).toDouble()
                                                          )
                                                        )).reduce(math.max);
                                                  final double capHeight = 130.0;
                                                  return Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: _model.localRevenueList.map<Widget>((item) {
                                                      final month = item['month'] as String? ?? '';
                                                      final currentRevenue = (item['current_revenue'] as num? ?? 0).toDouble();
                                                      final previousRevenue = (item['previous_revenue'] as num? ?? 0).toDouble();
                                                      final targetRevenue = (item['target_revenue'] as num? ?? 0).toDouble();
                                                      
                                                      final currentHeight = maxRevVal > 0 ? (currentRevenue / maxRevVal) * capHeight : 0.0;
                                                      final previousHeight = maxRevVal > 0 ? (previousRevenue / maxRevVal) * capHeight : 0.0;
                                                      final targetHeight = maxRevVal > 0 ? (targetRevenue / maxRevVal) * capHeight : 0.0;
                                                      
                                                      return Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Stack(
                                                            alignment: const AlignmentDirectional(0.0, 1.0),
                                                            children: [
                                                              Container(
                                                                width: 18.0,
                                                                height: math.max(previousHeight, 4.0),
                                                                decoration: BoxDecoration(
                                                                  color: const Color(0x33FA8231),
                                                                  borderRadius: BorderRadius.circular(6.0),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 18.0,
                                                                height: math.max(currentHeight, 4.0),
                                                                decoration: BoxDecoration(
                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                  borderRadius: BorderRadius.circular(6.0),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment: const AlignmentDirectional(0.0, -1.0),
                                                                child: Container(
                                                                  width: 4.0,
                                                                  height: math.max(targetHeight, 4.0),
                                                                  decoration: BoxDecoration(
                                                                    color: const Color(0xFF4ADE80),
                                                                    borderRadius: BorderRadius.circular(2.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            month,
                                                            style: FlutterFlowTheme.of(context).labelSmall.override(
                                                              fontFamily: GoogleFonts.inter().fontFamily,
                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                              fontSize: 10.0,
                                                            ),
                                                          ),
                                                        ].divide(const SizedBox(height: 4.0)),
                                                      );
                                                    }).toList(),
                                                  );
                                                },
                                              ),
                                            )"""

# 6. Period comparison container
comp_start = """                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20.0),"""
comp_start_idx = content.find(comp_start)
comp_end_pattern = """                                              child: Text(
                                                'vs last period',"""
comp_end_idx = content.find(comp_end_pattern, comp_start_idx)
final_close_idx = content.find("                          ),", comp_end_idx) + len("                          ),")

comp_container_target = content[comp_start_idx:final_close_idx]

replacement_comp_container = """Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 16.0),
                                    child: Text(
                                      'Period Comparison',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.interTight(
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Current Period',
                                              style: FlutterFlowTheme.of(context)
                                                  .labelSmall.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(context)
                                                              .labelSmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(context)
                                                              .labelSmall
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(context)
                                                            .labelSmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(context)
                                                            .labelSmall
                                                            .fontStyle,
                                                  ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 4.0, 0.0, 0.0),
                                              child: Text(
                                                '\$${NumberFormat('#,##0').format(currentPeriodSum)}',
                                                style: FlutterFlowTheme.of(context)
                                                    .titleMedium.override(
                                                      font: GoogleFonts.interTight(
                                                        fontWeight: FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(context)
                                                                .titleMedium
                                                                .fontStyle,
                                                      ),
                                                      color: FlutterFlowTheme.of(context)
                                                          .primaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(context)
                                                              .titleMedium
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ),
                                            LinearPercentIndicator(
                                              percent: progressPercent,
                                              lineHeight: 6.0,
                                              animation: true,
                                              animateFromLastPercent: true,
                                              progressColor: FlutterFlowTheme.of(context).primary,
                                              backgroundColor: FlutterFlowTheme.of(context).alternate,
                                              barRadius: const Radius.circular(4.0),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        child: Container(
                                          width: 1.0,
                                          height: 60.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Previous Period',
                                              style: FlutterFlowTheme.of(context)
                                                  .labelSmall.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(context)
                                                              .labelSmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(context)
                                                              .labelSmall
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(context)
                                                            .labelSmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(context)
                                                            .labelSmall
                                                            .fontStyle,
                                                  ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 4.0, 0.0, 0.0),
                                              child: Text(
                                                '\$${NumberFormat('#,##0').format(previousPeriodSum)}',
                                                style: FlutterFlowTheme.of(context)
                                                    .titleMedium.override(
                                                      font: GoogleFonts.interTight(
                                                        fontWeight: FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(context)
                                                                .titleMedium
                                                                .fontStyle,
                                                      ),
                                                      color: FlutterFlowTheme.of(context)
                                                          .primaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(context)
                                                              .titleMedium
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ),
                                            LinearPercentIndicator(
                                              percent: previousProgressPercent,
                                              lineHeight: 6.0,
                                              animation: true,
                                              animateFromLastPercent: true,
                                              progressColor: const Color(0xFFFA8231),
                                              backgroundColor: FlutterFlowTheme.of(context).alternate,
                                              barRadius: const Radius.circular(4.0),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 24.0,
                                    thickness: 1.0,
                                    color: FlutterFlowTheme.of(context).alternate,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Target',
                                              style: FlutterFlowTheme.of(context)
                                                  .labelSmall.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(context)
                                                              .labelSmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(context)
                                                              .labelSmall
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(context)
                                                            .labelSmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(context)
                                                            .labelSmall
                                                            .fontStyle,
                                                  ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 4.0, 0.0, 0.0),
                                              child: Text(
                                                '\$${NumberFormat('#,##0').format(targetPeriodSum)}',
                                                style: FlutterFlowTheme.of(context)
                                                    .titleMedium.override(
                                                      font: GoogleFonts.interTight(
                                                        fontWeight: FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(context)
                                                                .titleMedium
                                                                .fontStyle,
                                                      ),
                                                      color: FlutterFlowTheme.of(context)
                                                          .primaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(context)
                                                              .titleMedium
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ),
                                            LinearPercentIndicator(
                                              percent: 1.0,
                                              lineHeight: 6.0,
                                              animation: true,
                                              animateFromLastPercent: true,
                                              progressColor: const Color(0xFF4ADE80),
                                              backgroundColor: FlutterFlowTheme.of(context).alternate,
                                              barRadius: const Radius.circular(4.0),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        child: Container(
                                          width: 1.0,
                                          height: 60.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Growth Rate',
                                              style: FlutterFlowTheme.of(context)
                                                  .labelSmall.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(context)
                                                              .labelSmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(context)
                                                              .labelSmall
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(context)
                                                            .labelSmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(context)
                                                            .labelSmall
                                                            .fontStyle,
                                                  ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 4.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Icon(
                                                    growthRate >= 0
                                                        ? Icons.trending_up_rounded
                                                        : Icons.trending_down_rounded,
                                                    color: growthRate >= 0
                                                        ? const Color(0xFF4ADE80)
                                                        : const Color(0xFFF87171),
                                                    size: 18.0,
                                                  ),
                                                  Text(
                                                    '${growthRate >= 0 ? '+' : ''}${growthRate.toStringAsFixed(1)}%',
                                                    style: FlutterFlowTheme.of(context)
                                                        .titleMedium.override(
                                                          font: GoogleFonts.interTight(
                                                            fontWeight: FontWeight.bold,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: growthRate >= 0
                                                              ? const Color(0xFF4ADE80)
                                                              : const Color(0xFFF87171),
                                                          letterSpacing: 0.0,
                                                          fontWeight: FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(context)
                                                                  .titleMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ].divide(const SizedBox(width: 4.0)),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 4.0, 0.0, 0.0),
                                              child: Text(
                                                'vs last period',
                                                style: FlutterFlowTheme.of(context)
                                                    .labelSmall.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(context)
                                                                .labelSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(context)
                                                                .labelSmall
                                                                .fontStyle,
                                                      ),
                                                      color: FlutterFlowTheme.of(context)
                                                          .secondaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(context)
                                                              .labelSmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(context)
                                                              .labelSmall
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )"""

# Perform string replacement
content = content.replace(target_imports, replacement_imports, 1)
content = content.replace(target_build, replacement_build, 1)
content = content.replace(target_top_growth, replacement_top_growth, 1)
content = content.replace(target_top_progress, replacement_top_progress, 1)
content = content.replace(chart_row_target, replacement_chart_row, 1)
content = content.replace(comp_container_target, replacement_comp_container, 1)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Replacement complete successfully!")
