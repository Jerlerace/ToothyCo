import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'unified_nav_bar_model.dart';
export 'unified_nav_bar_model.dart';

class UnifiedNavBarWidget extends StatefulWidget {
  final int selectedIndex;
  final Function(int)? onTap;

  const UnifiedNavBarWidget({
    super.key,
    required this.selectedIndex,
    this.onTap,
  });

  @override
  State<UnifiedNavBarWidget> createState() => _UnifiedNavBarWidgetState();
}

class _UnifiedNavBarWidgetState extends State<UnifiedNavBarWidget> {
  late UnifiedNavBarModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UnifiedNavBarModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isActive = widget.selectedIndex == index;
    final Color color = isActive
        ? FlutterFlowTheme.of(context).primary
        : FlutterFlowTheme.of(context).secondaryText;

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        if (widget.onTap != null) {
          widget.onTap!(index);
        } else {
          // Navigate to the main HomepageUnified screen and set active index
          context.goNamed(
            'Homepage_Unified',
            queryParameters: {
              'initialTabIndex': index.toString(),
            }.withoutNulls,
          );
        }
      },
      child: Container(
        width: 80.0,
        height: 60.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 24.0,
            ),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: FlutterFlowTheme.of(context).labelSmall.override(
                    fontFamily: GoogleFonts.inter().fontFamily,
                    color: color,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    fontSize: 10.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: const Color(0x1A000000),
            offset: const Offset(0.0, -2.0),
            spreadRadius: 0.0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.home_rounded,
              label: 'Home',
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.dashboard_rounded,
              label: 'Workflow',
            ),
            _buildNavItem(
              index: 2,
              icon: Icons.notifications_rounded,
              label: 'Notifications',
            ),
            _buildNavItem(
              index: 3,
              icon: Icons.person_rounded,
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
