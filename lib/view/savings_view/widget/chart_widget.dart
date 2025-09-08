import 'package:fanmint/models/savings_account_model.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SavingsChartWidget extends StatelessWidget {
  const SavingsChartWidget({
    super.key,
    required this.account,
  });

  final SavingsAccountModel account;

  @override
  Widget build(BuildContext context) {
    double runningBalance = 0;
    List<FlSpot> spots = [];

    for (int i = 0; i < account.transactions.length; i++) {
      final tx = account.transactions[i];
      runningBalance += tx.isDeposit ? tx.amount : -tx.amount;

      spots.add(
        FlSpot(
          i.toDouble(),
          runningBalance,
        ),
      );
    }
    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index < account.transactions.length) {
                    final date = account.transactions[index].date;
                    return Text(
                      "${date.day}/${date.month}",
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: HelperFunctions.isDarkMode(context)
                  ? UniColors.secondary
                  : UniColors.primary,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: HelperFunctions.isDarkMode(context)
                    ? UniColors.secondary.withOpacity(0.1)
                    : UniColors.primary.withOpacity(0.1),
              ),
              spots: spots,
            ),
          ],
        ),
      ),
    );
  }
}
