// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:intl/intl.dart';

Future<List<dynamic>> getMonthlyRevenueMetrics({String? filterType}) async {
  try {
    final supabase = SupaFlow.client;

    // Fetch all paid payments from the Payments table
    final response = await supabase
        .from('Payments')
        .select('*')
        .eq('status', 'Paid');

    final List<dynamic> paymentsList = response as List<dynamic>;

    final now = DateTime.now();

    if (paymentsList.isEmpty) {
      if (filterType == '7D') {
        return [
          {'month': 'Mon', 'current_revenue': 1500, 'previous_revenue': 1200, 'target_revenue': 5000},
          {'month': 'Tue', 'current_revenue': 2500, 'previous_revenue': 2200, 'target_revenue': 5000},
          {'month': 'Wed', 'current_revenue': 1800, 'previous_revenue': 1600, 'target_revenue': 5000},
          {'month': 'Thu', 'current_revenue': 3000, 'previous_revenue': 2800, 'target_revenue': 5000},
          {'month': 'Fri', 'current_revenue': 4500, 'previous_revenue': 4000, 'target_revenue': 5000},
          {'month': 'Sat', 'current_revenue': 1200, 'previous_revenue': 1000, 'target_revenue': 5000},
          {'month': 'Sun', 'current_revenue': 2000, 'previous_revenue': 1800, 'target_revenue': 5000},
        ];
      } else if (filterType == '1M') {
        return [
          {'month': 'W1', 'current_revenue': 15000, 'previous_revenue': 12000, 'target_revenue': 30000},
          {'month': 'W2', 'current_revenue': 25000, 'previous_revenue': 23000, 'target_revenue': 30000},
          {'month': 'W3', 'current_revenue': 18000, 'previous_revenue': 17000, 'target_revenue': 30000},
          {'month': 'W4', 'current_revenue': 22000, 'previous_revenue': 20000, 'target_revenue': 30000},
        ];
      } else if (filterType == '3M') {
        return [
          {'month': 'Apr', 'current_revenue': 120000, 'previous_revenue': 110000, 'target_revenue': 150000},
          {'month': 'May', 'current_revenue': 135000, 'previous_revenue': 125000, 'target_revenue': 150000},
          {'month': 'Jun', 'current_revenue': 145000, 'previous_revenue': 130000, 'target_revenue': 150000},
        ];
      } else if (filterType == '6M') {
        return [
          {'month': 'Jan', 'current_revenue': 85000, 'previous_revenue': 80000, 'target_revenue': 150000},
          {'month': 'Feb', 'current_revenue': 95000, 'previous_revenue': 90000, 'target_revenue': 150000},
          {'month': 'Mar', 'current_revenue': 110000, 'previous_revenue': 100000, 'target_revenue': 150000},
          {'month': 'Apr', 'current_revenue': 120000, 'previous_revenue': 110000, 'target_revenue': 150000},
          {'month': 'May', 'current_revenue': 135000, 'previous_revenue': 125000, 'target_revenue': 150000},
          {'month': 'Jun', 'current_revenue': 145000, 'previous_revenue': 130000, 'target_revenue': 150000},
        ];
      } else {
        return [
          {'month': 'Jan', 'current_revenue': 85000, 'previous_revenue': 80000, 'target_revenue': 150000},
          {'month': 'Feb', 'current_revenue': 95000, 'previous_revenue': 90000, 'target_revenue': 150000},
          {'month': 'Mar', 'current_revenue': 110000, 'previous_revenue': 100000, 'target_revenue': 150000},
          {'month': 'Apr', 'current_revenue': 120000, 'previous_revenue': 110000, 'target_revenue': 150000},
          {'month': 'May', 'current_revenue': 135000, 'previous_revenue': 125000, 'target_revenue': 150000},
          {'month': 'Jun', 'current_revenue': 145000, 'previous_revenue': 130000, 'target_revenue': 150000},
        ];
      }
    }

    final Map<String, int> groupedSum = {};
    final Map<String, int> groupedSumPrev = {};
    int targetRevenue = 150000;

    if (filterType == '7D') {
      targetRevenue = 5000;
      for (int i = 6; i >= 0; i--) {
        final dayStr = DateFormat('E').format(now.subtract(Duration(days: i)));
        groupedSum[dayStr] = 0;
        groupedSumPrev[dayStr] = 0;
      }
      final sevenDaysAgo = now.subtract(Duration(days: 7));
      final fourteenDaysAgo = now.subtract(Duration(days: 14));
      for (var payment in paymentsList) {
        final createdAtStr = payment['created_at'] as String?;
        if (createdAtStr != null) {
          final date = DateTime.parse(createdAtStr);
          if (date.isAfter(sevenDaysAgo)) {
            final dayStr = DateFormat('E').format(date);
            groupedSum[dayStr] = (groupedSum[dayStr] ?? 0) + (payment['amount'] as int? ?? 0);
          } else if (date.isAfter(fourteenDaysAgo)) {
            final dayStr = DateFormat('E').format(date);
            groupedSumPrev[dayStr] = (groupedSumPrev[dayStr] ?? 0) + (payment['amount'] as int? ?? 0);
          }
        }
      }
    } else if (filterType == '1M') {
      targetRevenue = 30000;
      groupedSum['W1'] = 0;
      groupedSum['W2'] = 0;
      groupedSum['W3'] = 0;
      groupedSum['W4'] = 0;
      groupedSumPrev['W1'] = 0;
      groupedSumPrev['W2'] = 0;
      groupedSumPrev['W3'] = 0;
      groupedSumPrev['W4'] = 0;
      final thirtyDaysAgo = now.subtract(Duration(days: 30));
      final sixtyDaysAgo = now.subtract(Duration(days: 60));
      for (var payment in paymentsList) {
        final createdAtStr = payment['created_at'] as String?;
        if (createdAtStr != null) {
          final date = DateTime.parse(createdAtStr);
          if (date.isAfter(thirtyDaysAgo)) {
            final differenceDays = date.difference(thirtyDaysAgo).inDays;
            String weekStr = 'W4';
            if (differenceDays < 7) {
              weekStr = 'W1';
            } else if (differenceDays < 14) {
              weekStr = 'W2';
            } else if (differenceDays < 21) {
              weekStr = 'W3';
            }
            groupedSum[weekStr] = (groupedSum[weekStr] ?? 0) + (payment['amount'] as int? ?? 0);
          } else if (date.isAfter(sixtyDaysAgo)) {
            final differenceDays = date.difference(sixtyDaysAgo).inDays;
            String weekStr = 'W4';
            if (differenceDays < 7) {
              weekStr = 'W1';
            } else if (differenceDays < 14) {
              weekStr = 'W2';
            } else if (differenceDays < 21) {
              weekStr = 'W3';
            }
            groupedSumPrev[weekStr] = (groupedSumPrev[weekStr] ?? 0) + (payment['amount'] as int? ?? 0);
          }
        }
      }
    } else if (filterType == '3M') {
      targetRevenue = 150000;
      for (int i = 2; i >= 0; i--) {
        final monthStr = DateFormat('MMM').format(DateTime(now.year, now.month - i, 1));
        groupedSum[monthStr] = 0;
        groupedSumPrev[monthStr] = 0;
      }
      final ninetyDaysAgo = now.subtract(Duration(days: 90));
      final oneEightyDaysAgo = now.subtract(Duration(days: 180));
      for (var payment in paymentsList) {
        final createdAtStr = payment['created_at'] as String?;
        if (createdAtStr != null) {
          final date = DateTime.parse(createdAtStr);
          if (date.isAfter(ninetyDaysAgo)) {
            final monthStr = DateFormat('MMM').format(date);
            groupedSum[monthStr] = (groupedSum[monthStr] ?? 0) + (payment['amount'] as int? ?? 0);
          } else if (date.isAfter(oneEightyDaysAgo)) {
            final currentMonthCorresp = DateFormat('MMM').format(DateTime(date.year, date.month + 3, 1));
            if (groupedSumPrev.containsKey(currentMonthCorresp)) {
              groupedSumPrev[currentMonthCorresp] = (groupedSumPrev[currentMonthCorresp] ?? 0) + (payment['amount'] as int? ?? 0);
            }
          }
        }
      }
    } else if (filterType == '6M') {
      targetRevenue = 150000;
      for (int i = 5; i >= 0; i--) {
        final monthStr = DateFormat('MMM').format(DateTime(now.year, now.month - i, 1));
        groupedSum[monthStr] = 0;
        groupedSumPrev[monthStr] = 0;
      }
      final oneEightyDaysAgo = now.subtract(Duration(days: 180));
      final threeSixtyDaysAgo = now.subtract(Duration(days: 360));
      for (var payment in paymentsList) {
        final createdAtStr = payment['created_at'] as String?;
        if (createdAtStr != null) {
          final date = DateTime.parse(createdAtStr);
          if (date.isAfter(oneEightyDaysAgo)) {
            final monthStr = DateFormat('MMM').format(date);
            groupedSum[monthStr] = (groupedSum[monthStr] ?? 0) + (payment['amount'] as int? ?? 0);
          } else if (date.isAfter(threeSixtyDaysAgo)) {
            final currentMonthCorresp = DateFormat('MMM').format(DateTime(date.year, date.month + 6, 1));
            if (groupedSumPrev.containsKey(currentMonthCorresp)) {
              groupedSumPrev[currentMonthCorresp] = (groupedSumPrev[currentMonthCorresp] ?? 0) + (payment['amount'] as int? ?? 0);
            }
          }
        }
      }
    } else {
      targetRevenue = 150000;
      for (var payment in paymentsList) {
        final createdAtStr = payment['created_at'] as String?;
        if (createdAtStr != null) {
          final date = DateTime.parse(createdAtStr);
          final monthStr = DateFormat('MMM').format(date);
          groupedSum[monthStr] = (groupedSum[monthStr] ?? 0) + (payment['amount'] as int? ?? 0);
          groupedSumPrev[monthStr] = 0;
        }
      }
    }

    final List<dynamic> result = [];
    groupedSum.forEach((timePeriod, amount) {
      result.add({
        'month': timePeriod,
        'current_revenue': amount,
        'previous_revenue': groupedSumPrev[timePeriod] ?? 0,
        'target_revenue': targetRevenue,
      });
    });

    return result;
  } catch (e) {
    print('Error fetching revenue metrics: $e');
    return [
      {'month': 'Jan', 'current_revenue': 0, 'previous_revenue': 0, 'target_revenue': 150000},
      {'month': 'Feb', 'current_revenue': 0, 'previous_revenue': 0, 'target_revenue': 150000},
      {'month': 'Mar', 'current_revenue': 0, 'previous_revenue': 0, 'target_revenue': 150000},
      {'month': 'Apr', 'current_revenue': 0, 'previous_revenue': 0, 'target_revenue': 150000},
      {'month': 'May', 'current_revenue': 0, 'previous_revenue': 0, 'target_revenue': 150000},
      {'month': 'Jun', 'current_revenue': 0, 'previous_revenue': 0, 'target_revenue': 150000},
    ];
  }
}
