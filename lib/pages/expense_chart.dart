import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pie_chart/pie_chart.dart'; // Import pie_chart package

class ExpenseChart extends StatefulWidget {
  const ExpenseChart({Key? key}) : super(key: key);

  @override
  _ExpenseChartState createState() => _ExpenseChartState();
}

class _ExpenseChartState extends State<ExpenseChart> {
  Map<String, double> _categoryData = {};
  Map<String, String> _legendLabels = {}; // Map to store category initials and full names

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
    final legendLabels = <String, String>{};
    for (var item in transactionsList) {
      if (item['type'] == 'Expense') {
        final category = item['category'] ?? 'Unknown';
        final amount = double.tryParse(item['amount']?.replaceAll('\$', '') ?? '0') ?? 0;
        categoryData[category] = (categoryData[category] ?? 0) + amount;

        final initial = category.isNotEmpty ? category[0] : '?';
        legendLabels[initial] = category; // Map initials to full category names
      }
    }

    setState(() {
      _categoryData = categoryData;
      _legendLabels = legendLabels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _categoryData.isNotEmpty
        ? Column(
      children: [
        Container(
          width: 300, // Adjust the width as needed
          height: 300, // Adjust the height as needed
          child: PieChart(
            dataMap: _categoryData,
            chartType: ChartType.disc,
            colorList: const [
              Color(0xff001e22), // Deep Blue
              Color(0xff09353a), // Dark Slate Blue
              Color(0xff0b535e), // Medium Teal Blue
              Color(0xff2d7880), // Muted Blue
              Color(0xff4a8c88), // Light Teal
              Color(0xff75a5a5), // Soft Gray Blue
              Color(0xffaee7ed), // Pure White
            ],
            legendOptions: LegendOptions(
              legendPosition: LegendPosition.left,
              legendTextStyle: TextStyle(
                fontSize: 10, // Smaller legend text
                color: Colors.black, // Change text color to black or desired color
              ),
              showLegends: false, // Hide default legend
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValues: false, // Hide the chart values
              showChartValuesInPercentage: false, // Hide the percentage values
            ),
            ringStrokeWidth: 80, // Adjust the stroke width as needed
            //centerText: 'Expenses', // Optional: Add center text
            centerTextStyle: GoogleFonts.nunito(
              fontSize: 16, // Adjust center text size as needed
              color: Colors.black, // Center text color
            ),
          ),
        ),
        SizedBox(height: 10), // Spacing between chart and legend
        _buildLegend(),
      ],
    )
        : Center(child: Text('No expenses recorded.'));
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _legendLabels.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                color: _getColorForCategory(entry.value),
              ),
              SizedBox(width: 4),
              Text(
                entry.key,
                style: TextStyle(
                  fontSize: 12, // Adjust the font size for legend
                  color: Colors.black, // Change text color to black or desired color
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getColorForCategory(String category) {
    final colors = [
      Color(0xff00292f),
      Color(0xff054952),
      Color(0xff016c72),
      Color(0xff2c7880),
      Color(0xff65aea9),
      Color(0xffb1c2c2),
      Color(0xffffffff),
    ];
    final index = _categoryData.keys.toList().indexOf(category);
    return colors[index % colors.length];
  }
}
