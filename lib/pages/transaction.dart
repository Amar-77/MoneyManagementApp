import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key, required List<Map<String, String>> transactions}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<Map<String, String>> transactionHistory = [];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getString('transactions') ?? '[]';
    final transactionsList = jsonDecode(transactionsJson) as List<dynamic>;

    // Reverse the list to show the latest transaction at the top
    setState(() {
      transactionHistory = transactionsList
          .map((item) => Map<String, String>.from(item))
          .toList()
          .reversed
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0xff357472),
        title: Text(
          'Transaction History',
          style: GoogleFonts.russoOne(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff3c7e7a), Color(0xff043941)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: transactionHistory.length,
            itemBuilder: (context, index) {
              final transaction = transactionHistory[index];
              final amount = transaction['amount'] ?? '0';
              final category = transaction['category'] ?? 'N/A';
              final date = transaction['date'] ?? 'N/A';
              final time = transaction['time'] ?? 'N/A';
              final type = transaction['type'] ?? 'Unknown';

              // Determine color and icon based on type
              Color cardColor;
              IconData icon;
              Color iconColor;
              Color textColor;
              if (type == 'Income') {
                cardColor = Color(0xff00292f); // Dark color for income
                icon = Icons.keyboard_double_arrow_up_sharp; // Up arrow for income
                iconColor = Colors.green; // Green for income
                textColor = Color(0xff65aea9); // White text for income
              } else if (type == 'Expense') {
                cardColor = Color(0xff468a87); // Light color for expense
                icon = Icons.keyboard_double_arrow_down_sharp; // Down arrow for expense
                iconColor = Colors.red; // Red for expense
                textColor = Color(0xff00292f); // Black text for expense
              } else {
                cardColor = Color(0xff4a9591); // Default color
                icon = Icons.help; // Default icon
                iconColor = Colors.grey; // Default icon color
                textColor = Colors.black; // Default text color
              }

              return Card(
                color: cardColor,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(
                    icon,
                    color: iconColor, // Set icon color based on type
                  ),
                  title: Text(
                    category, // Show the category as the heading
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor, // Set text color based on type
                    ),
                  ),
                  subtitle: Text(
                    'Date: $date\nTime: $time',
                    style: GoogleFonts.nunito(
                      color: textColor, // Set subtitle text color based on type
                    ),
                  ),
                  trailing: Text(
                    amount,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor, // Set amount text color based on type
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
