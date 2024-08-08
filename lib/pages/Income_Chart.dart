import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class IncomeChart extends StatefulWidget {
  const IncomeChart({Key? key}) : super(key: key);

  @override
  _IncomeChartState createState() => _IncomeChartState();
}

class _IncomeChartState extends State<IncomeChart> {
  Map<String, double> _categoryData = {};
  final List<Color> _colors = [
    Color(0xff00292f),
    Color(0xff093c40),
    Color(0xff65aea9),
    Color(0xffb1c2c2),
  ];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getString('transactions') ?? '[]';
    final transactionsList = jsonDecode(transactionsJson) as List<dynamic>;

    final categoryData = <String, double>{};
    for (var item in transactionsList) {
      if (item['type'] == 'Income') {
        final category = item['category'] ?? 'Unknown';
        final amount = double.tryParse(item['amount']?.replaceAll('\$', '') ?? '0') ?? 0;
        categoryData[category] = (categoryData[category] ?? 0) + amount;
      }
    }

    setState(() {
      _categoryData = categoryData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _categoryData.isNotEmpty
        ? BarChart(
      BarChartData(
        barGroups: _categoryData.entries.map((entry) {
          final index = _categoryData.keys.toList().indexOf(entry.key);
          final color = _colors[index % _colors.length];
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                y: entry.value,
                colors: [color],
                width: 20,
              ),
            ],
          );
        }).toList(),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) => GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            margin: 16,
            getTitles: (double value) {
              final index = value.toInt();
              final category = _categoryData.keys.elementAt(index);
              // Use the first letter of each category
              return category.isNotEmpty ? category[0] : '';
            },
          ),
          leftTitles: SideTitles(showTitles: false),
        ),
      ),
    )
        : Center(child: Text('No incomes recorded.'));
  }
}
