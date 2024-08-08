import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({Key? key, required List<Map<String, String>> transactions}) : super(key: key);

  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  Map<String, double> _categoryData = {};

  // Define colors for bar chart
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff438884), Color(0xff367775)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          title: Text(
            'Income History',
            style: GoogleFonts.russoOne(),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff438884), Color(0xff043941)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Bar Chart
              Expanded(
                child: _categoryData.isNotEmpty
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
                            width: 40,
                          )
                        ],
                      );
                    }).toList(),
                    gridData: FlGridData(show: false), // Remove background dotted lines
                    borderData: FlBorderData(show: false), // Remove border lines
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
                          return _categoryData.keys.elementAt(index);
                        },
                      ),
                      leftTitles: SideTitles(showTitles: false),
                    ),
                  ),
                )
                    : Center(child: Text('No incomes recorded.')),
              ),
              const SizedBox(height: 20),
              // Income Categories
              Text(
                'Income Categories',
                style: TextStyle(
                  color: Color(0xff001e22),
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Expanded(
                child: _categoryData.isNotEmpty
                    ? GlassContainer(
                  child: ListView.builder(
                    itemCount: _categoryData.keys.length,
                    itemBuilder: (context, index) {
                      final category = _categoryData.keys.elementAt(index);
                      final amount = _categoryData[category] ?? 0;
                      return Card(
                        color: const Color(0xff00292f),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            category,
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff559f9c),
                            ),
                          ),
                          trailing: Text(
                            '\$${amount.toStringAsFixed(2)}',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff559e9b),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
                    : Center(child: Text('No income recorded.')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;

  const GlassContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
