import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ict_project/pages/goal_rem.dart';
import 'package:ict_project/pages/progress_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Income_Chart.dart';
import 'add_expense.dart';
import 'add_income.dart';
import 'package:fl_chart/fl_chart.dart';
import 'expense.dart';
import 'expense_chart.dart';
import 'income.dart';
import 'transaction.dart';

class Content extends StatefulWidget {
  const Content({super.key});
  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
 int _selectedIndex = 0;
  List<Map<String, String>> transactions = [];
  double _balance = 0.0;
  final List<String> _options = ["Daily", "Bills", "History"];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadParameters();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();


      setState(() {
        _balance = prefs.getDouble('balance') ?? 0.0;
      });

      final transactionsJson = prefs.getString('transactions') ?? '[]';
      final transactionsList = jsonDecode(transactionsJson) as List<dynamic>;
      setState(() {
        transactions = transactionsList.map((item) => Map<String, String>.from(item)).toList();
      });
    } catch (e) {
      print('Error loading preferences: $e');
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();


      await prefs.setDouble('balance', _balance);


      final transactionsJson = jsonEncode(transactions);
      await prefs.setString('transactions', transactionsJson);
    } catch (e) {
      print('Error saving preferences: $e');
    }
  }



 double _incomeGoal = 0;
 double _expenseLimit = 0;
 double _totalIncome = 0;
 double _totalExpense = 0;
 void _loadParameters() async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   setState(() {
     _incomeGoal = prefs.getDouble('incomeGoal') ?? 0;
     _expenseLimit = prefs.getDouble('expenseLimit') ?? 0;
     _totalIncome = prefs.getDouble('totalIncome') ?? 0;
     _totalExpense = prefs.getDouble('totalExpense') ?? 0;
   });
 }



  void _addTransaction(Map<String, String> transaction) {
    setState(() {
      transactions.add(transaction);
      double amount = double.tryParse(transaction['amount']?.substring(1) ?? '0') ?? 0.0;
      if (transaction['type'] == 'Income') {
        _balance += amount;
      } else if (transaction['type'] == 'Expense') {
        _balance -= amount;
      }
    });
    _savePreferences();
  }



  Widget _buildScrollableWidgets() {
    return Container(
      height: 450,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        children: [
          Container(
            width: 300,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Color(0xff00292f),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  spreadRadius: 2,
                  blurRadius: 9,
                  offset: Offset(1, 15),
                ),
              ],
            ),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Container(
                      //color: Colors.white.withOpacity(0.1), // Slightly opaque background for text readability
                      padding: EdgeInsets.only(bottom: 70,left: 10,right: 0),
                      child: Text(
                        'Total \nBalance \n\                       \$ ${_balance.toStringAsFixed(2)}'.toUpperCase(),
                        style: TextStyle(
                          color: Color(0xff65aea9),
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                    ),
                  ),
                ),
              ),

            ),
          ),
          Container(
            width: 300,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Color(0xff054952),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  spreadRadius: 2,
                  blurRadius: 9,
                  offset: Offset(1, 15),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 40.0,right: 40),
                child: Container(
                  height: 400,
                  child: PieChart(
                    PieChartData(
                      sections: _getSections(),

                      sectionsSpace: 15,
                      centerSpaceRadius: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 300,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Color(0xff016c72),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  spreadRadius: 2,
                  blurRadius: 9,
                  offset: Offset(1, 15),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IncomeChart(),
            ),
          ),
          Container(
            width: 300,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Color(0xff418790),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  spreadRadius: 2,
                  blurRadius: 9,
                  offset: Offset(1, 15),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ExpenseChart(),
            )
          ),
          Container(
            width: 300,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Color(0xff428493),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  spreadRadius: 2,
                  blurRadius: 9,
                  offset: Offset(1, 15),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child:Row(
                  children: [
                    SizedBox(width: 50,),
                    VerticalProgressIndicator(
                      label: 'Income Progress',
                      goal: _incomeGoal,
                      current: _totalIncome,
                      color: Color(0xff013339),
                    ),
                    SizedBox(height: 0,width: 40,),
                    VerticalProgressIndicator(
                      label: 'Expense Progress',
                      goal: _expenseLimit,
                      current: _totalExpense,
                      color: Color(0xd27ac6c2),
                    ),
                  ],
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTogglePressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildToggleSwitch() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      child: Container(
        width: 385,
        height: 60,
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xff337676),
          boxShadow: [                               //3d effect so 2 shadow;)
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: Offset(-3, -3),
              blurRadius: 6,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              offset: Offset(3, 3),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_options.length, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTogglePressed(index),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        _options[index],
                        style: TextStyle(
                            color: Colors.teal[100],
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                );
              }),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: _selectedIndex * (380 / _options.length),
              child: Container(
                width: 370 / _options.length,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.teal[100],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(2, 4),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      spreadRadius: -2,
                      blurRadius: 10,
                      offset: Offset(-2, -2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  _options[_selectedIndex],
                  style: TextStyle(
                      color: Color(0xff0c2d3d),
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return Column(
          children: [
            _buildScrollableWidgets(),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Space around each button
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddIncomePage(transactions: transactions),
                        ),
                      );
                      if (result != null && result is Map<String, String>) {
                        _addTransaction(result);
                      }
                    },
                    icon: const Icon(Icons.keyboard_double_arrow_up_outlined, size: 30),
                    label: Text(
                      'Add Income',
                      style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xff65ada8), backgroundColor: Color(
                        0xff00292f), minimumSize: Size(400, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8, // Add shadow for 3D effect
                      shadowColor: Colors.black.withOpacity(0.4),
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Space around each button
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  AddExpensePage(transactions: transactions,),
                        ),
                      );
                      if (result != null && result is Map<String, String>) {
                        _addTransaction(result);
                      }
                    },
                    icon: const Icon(Icons.keyboard_double_arrow_down_outlined, size: 30),
                    label: Text(
                      'Add Expense',
                      style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xff052123), backgroundColor: Color(
                        0xff468c89), minimumSize: Size(400, 100), // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8,
                      shadowColor: Colors.black.withOpacity(0.4), // Shadow color
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

           //pie chart designing
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffb1c2c2).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all( 5.0),
                      child: Container(
                        height: 400,
                        child: PieChart(
                          PieChartData(
                            sections: _getSections(),

                            sectionsSpace: 15,
                            centerSpaceRadius: 50,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Legend for Pie Chart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 25,
                              height: 12,
                              color: Color(0xff052123), // Color for Income
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Income',
                              style: GoogleFonts.nunito(fontSize: 25),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              width: 25,
                              height: 12,
                              color: Color(0xff468c89), // Color for Expense
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Expense',
                              style: GoogleFonts.nunito(fontSize: 25),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Space around each button
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  GoalRem(),
                    ),
                  );
                },
                //icon: const Icon(Icons.bulb, size: 30),
                label: Text(
                  'GOALS & REMAINDERS',
                  style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xff052123), backgroundColor: Color(
                    0xff347781), minimumSize: Size(400, 100), // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  elevation: 10, // Add shadow for 3D effect
                  shadowColor: Colors.black.withOpacity(0.6), // Shadow color
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 100,),// Navigation Buttons
          ],
        );
      case 1:
        return BillsSection();
      case 2:
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.black.withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 10,
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExpensePage(transactions: transactions),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff052123),
                            Color(0xff830a16),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 4,
                            blurRadius: 10,
                            offset: const Offset(2, 4),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            spreadRadius: -2,
                            blurRadius: 10,
                            offset: const Offset(-2, -2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text('E X P E N S E S', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IncomePage(transactions: transactions),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff052123),
                            Color(0xff00713a),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 4,
                            blurRadius: 10,
                            offset: const Offset(2, 4),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            spreadRadius: -2,
                            blurRadius: 10,
                            offset: const Offset(-2, -2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text('I n c o m e'.toUpperCase(), style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionPage(transactions: transactions),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff134045),
                            Color(0xff408785),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 4,
                            blurRadius: 10,
                            offset: const Offset(2, 4),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            spreadRadius: -2,
                            blurRadius: 10,
                            offset: const Offset(-2, -2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text('T r a n s a c t i o n s'.toUpperCase(), style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff4a9591), Color(0xff043941)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 140.0, top: 60),
                      child: Text(
                        'SpendWise',
                        style: GoogleFonts.grandHotel(
                            color: Colors.white,
                            fontSize: 70,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _buildToggleSwitch(),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Center(
                        child: Text(
                          'Think | Plan | Invest | Execute'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.grey[400],
                            letterSpacing: 2,
                            height: 2,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    _buildContent(),          //we defined 3 cases above
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 List<PieChartSectionData> _getSections() {

   double income = transactions
       .where((t) => t['type'] == 'Income')
       .fold(0.0, (sum, t) => sum + double.parse(t['amount']!.substring(1)));

   double expense = transactions
       .where((t) => t['type'] == 'Expense')
       .fold(0.0, (sum, t) => sum + double.parse(t['amount']!.substring(1)));

   // Update SharedPreferences with total income and expense
   _updateTotalValues(income, expense);

   return [
     PieChartSectionData(
       color: Color(0xff052123),
       value: income,
       title: '${income.toStringAsFixed(0)}',
       radius: 100,
       titleStyle: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xbd77cfca)),
     ),
     PieChartSectionData(
       color: Color(0xff468d8a),
       value: expense,
       title: '${expense.toStringAsFixed(0)}',
       radius: 100,
       titleStyle: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xb60a3f43)),
     ),
   ];
 }

 Future<void> _updateTotalValues(double income, double expense) async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.setDouble('totalIncome', income);
   await prefs.setDouble('totalExpense', expense);
 }

}
class BillsSection extends StatefulWidget {
  @override
  _BillsSectionState createState() => _BillsSectionState();
}

class _BillsSectionState extends State<BillsSection> {

  List<String> undoneBills = [];
  List<String> doneBills = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  Future<void> _loadBills() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      undoneBills = prefs.getStringList('undoneBills') ?? [];
      doneBills = prefs.getStringList('doneBills') ?? [];
    });
  }

  Future<void> _saveBills() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('undoneBills', undoneBills);
    await prefs.setStringList('doneBills', doneBills);
  }

  void _toggleBill(String bill) {
    setState(() {
      if (undoneBills.contains(bill)) {
        undoneBills.remove(bill);
        doneBills.add(bill);
      } else {
        doneBills.remove(bill);
        undoneBills.add(bill);
      }
      _saveBills();
    });
  }

  void _addBill(String bill) {
    if (bill.isNotEmpty) {
      setState(() {
        undoneBills.add(bill);
      });
      _saveBills();
    }
  }

  void _removeBill(String bill) {
    setState(() {
      if (undoneBills.contains(bill)) {
        undoneBills.remove(bill);
      } else if (doneBills.contains(bill)) {
        doneBills.remove(bill);
      }
      _saveBills();
    });
  }

  Widget _buildBillItem(String bill, bool isDone) {
    return ListTile(
      title: Text(
        bill,
        style: TextStyle(
            decoration: isDone ? TextDecoration.lineThrough : null,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white.withOpacity(0.7)
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Checkbox(
            value: isDone,
            checkColor: Colors.white,
            activeColor: Color(0xff65aea9),
            onChanged: (value) {
              _toggleBill(bill);

            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Color(0xffb1c2c2)),
            onPressed: () => _removeBill(bill),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddBillDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 16,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Add New Bill',
                  style: TextStyle(
                    color: Colors.teal[100],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    labelText: 'Bill Name',
                    labelStyle: TextStyle(color: Colors.teal[100]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.teal[100]),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _controller.clear();
                      },
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      child: Text('Add',style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        _addBill(_controller.text);
                        Navigator.of(context).pop();
                        _controller.clear();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            //color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xff002429),Color(0xff063b43)],
                ),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text(
                      'Undone Bills'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Color(0xff84bfba),
                      ),
                    ),
                    SizedBox(height: 8),
                    ...undoneBills.map((bill) => _buildBillItem(bill, false)).toList(),
                    SizedBox(height: 16),
                    Text(
                      'Done Bills'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: Color(0xff65ada8),
                      ),
                    ),
                    SizedBox(height: 40),
                    ...doneBills.map((bill) => _buildBillItem(bill, true)).toList(),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(), // Placeholder to align the button
                        ),
                        GestureDetector(
                          onTap: _showAddBillDialog,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
