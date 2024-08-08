import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pie_chart/pie_chart.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({Key? key, required List<Map<String, String>> transactions}) : super(key: key);

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  Map<String, double> _categoryData = {};

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getString('transactions') ?? '[]';
    final transactionsList = jsonDecode(transactionsJson) as List<dynamic>;

    final categoryData = <String, double>{};
    for (var item in transactionsList) {
      if (item['type'] == 'Expense') {
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
      // extendBodyBehindAppBar: true,
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
            'Expense History',
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
              const SizedBox(height: 10),
              // Pie Chart
              _categoryData.isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: PieChart(
                  dataMap: _categoryData,
                  chartType: ChartType.ring,
                  colorList: const [
                    Color(0xff001e22), // Deep Blue
                    Color(0xff09353a), // Dark Slate Blue
                    Color(0xff166571), // Medium Teal Blue
                    Color(0xff3faab5), // Muted Blue
                    Color(0xff0b8aa6), // Light Teal
                    Color(0xff789e9e), // Soft Gray Blue
                    Color(0xffaee7ed), // Pure White
                  ],
                  legendOptions: const LegendOptions(
                    legendPosition: LegendPosition.left,
                  ),
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValues: true,
                    showChartValuesInPercentage: true,
                  ),
                  ringStrokeWidth: 60, // Add stroke width here
                ),
              )
                  : const Center(child: Text('No expenses recorded.')),
              const SizedBox(height: 50),
              // Expense Categories
              const Text(
                'Expense Categories',
                style: TextStyle(
                  color: Color(0xff001e22),
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: _categoryData.isNotEmpty
                    ? GlassContainer(
                  child: ListView.builder(
                    itemCount: _categoryData.keys.length,
                    itemBuilder: (context, index) {
                      final category = _categoryData.keys.elementAt(index);
                      final amount = _categoryData[category] ?? 0;
                      return Card(
                        color: const Color(0xff468986),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            category,
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff00292f),
                            ),
                          ),
                          trailing: Text(
                            '\$${amount.toStringAsFixed(2)}',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff00292f),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
                    : const Center(child: Text('No expenses recorded.')),
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
