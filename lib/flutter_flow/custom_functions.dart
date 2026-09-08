import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

String? calculateTotalRevenue(List<dynamic>? jsonList) {
  if (jsonList == null || jsonList.isEmpty) return '0';
  final total = jsonList
      .map((e) => e['current_revenue'] as num? ?? 0)
      .reduce((a, b) => a + b);
  return total.toString();
}

String? getTargetRevenue(List<dynamic>? jsonList) {
  if (jsonList == null || jsonList.isEmpty) return '150000';
  // Pulls the target value from the first record in your database array
  return (jsonList.first['target_revenue'] ?? 150000).toString();
}

String? calculateTargetPercentage(List<dynamic>? jsonList) {
  if (jsonList == null || jsonList.isEmpty) return '0.0%';
  final current = jsonList
      .map((e) => e['current_revenue'] as num? ?? 0)
      .reduce((a, b) => a + b);
  final target = jsonList.first['target_revenue'] as num? ?? 150000;
  if (target == 0) return '0.0%';

  final percentage = (current / target) * 100;
  return '${percentage.toStringAsFixed(1)}% of target';
}
