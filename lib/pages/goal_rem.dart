import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ict_project/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalRem extends StatefulWidget {
  const GoalRem({Key? key}) : super(key: key);

  @override
  _GoalRemState createState() => _GoalRemState();
}

class _GoalRemState extends State<GoalRem> {
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _expenseController = TextEditingController();

  double _incomeGoal = 0;
  double _expenseLimit = 0;

  double _totalIncome = 0;
  double _totalExpense = 0;

  bool _goalsSet = false;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _loadGoals();
    _loadTotalIncomeAndExpense();

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _loadGoals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _incomeGoal = prefs.getDouble('incomeGoal') ?? 0;
      _expenseLimit = prefs.getDouble('expenseLimit') ?? 0;
      _goalsSet = _incomeGoal > 0 || _expenseLimit > 0;
      _incomeController.text = _incomeGoal.toStringAsFixed(2);
      _expenseController.text = _expenseLimit.toStringAsFixed(2);
    });
  }

  void _loadTotalIncomeAndExpense() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double totalIncome = prefs.getDouble('totalIncome') ?? 0;
    double totalExpense = prefs.getDouble('totalExpense') ?? 0;

    setState(() {
      _totalIncome = totalIncome;
      _totalExpense = totalExpense;
    });

    _checkGoals();
  }

  Future<void> _saveGoals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('incomeGoal', _incomeGoal);
    await prefs.setDouble('expenseLimit', _expenseLimit);
    setState(() {
      _goalsSet = true;
    });
    _checkGoals();
  }


   ///removes old value and it resets;)
  Future<void> _updateGoals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('incomeGoal');
    await prefs.remove('expenseLimit');
    setState(() {
      _goalsSet = false;
    });
  }

  void _showNotification(String title, String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList('notifications') ?? [];
    notifications.add('$title: $message');
    await prefs.setStringList('notifications', notifications);
  }

  void _checkGoals() {
    if (_totalIncome >= _incomeGoal && _incomeGoal > 0) {
      _showNotification('Congratulations!', 'You have reached your income goal!');
    }
    if (_totalExpense >= _expenseLimit && _expenseLimit > 0) {
      _showNotification('Warning!', 'You have reached your expense limit!');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff4a9591), Color(0xff032a30)],
            ),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 62, right: 20.0, top: 30),
                child: Text(
                  'Goal & Limits',
                  style: GoogleFonts.grandHotel(
                      color: Colors.white,
                      fontSize: 70,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Image.asset("assets/images/goal.png", height: 250),
              SizedBox(height: 20),
              _buildHorizontalProgressIndicator('Income Progress', _incomeGoal, _totalIncome, Color(
                  0xff052123)),
              SizedBox(height: 20),
              _buildHorizontalProgressIndicator('Expense Progress', _expenseLimit, _totalExpense, Color(
                  0xff65aea9)),
              SizedBox(height: 50),
              if (!_goalsSet) ...[
                _buildGlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        controller: _incomeController,
                        label: 'Income Goal',
                        onChanged: (value) {
                          setState(() {
                            _incomeGoal = double.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: _expenseController,
                        label: 'Expense Limit',
                        onChanged: (value) {
                          setState(() {
                            _expenseLimit = double.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff122f31),
                          foregroundColor: Color(0xfffdfdfd),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _saveGoals,
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ),
              ] else ...[

                _buildGlassContainer(
                  child: Column(
                    children: [
                      Column(
                        children: [

                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xff054952),
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [Color(0xff053a41), Color(0xff054952)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  offset: Offset(4, 4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(-2, -2),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xff054952),
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [Color(0xff053a41), Color(0xff134045)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
                                          offset: Offset(4, 4),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.2),
                                          offset: Offset(-1, -1),
                                          blurRadius: 2,
                                          spreadRadius: 0.5,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Income Goal',
                                            style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            '\$${_incomeGoal.toStringAsFixed(2)}',
                                            style: GoogleFonts.roboto(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xff054952),
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [Color(0xff053a41), Color(0xff134045)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
                                          offset: Offset(4, 4),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.2),
                                          offset: Offset(-1, -1),
                                          blurRadius: 4,
                                          spreadRadius: 0.5,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Expense Limit',
                                            style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            '\$${_expenseLimit.toStringAsFixed(2)}',
                                            style: GoogleFonts.roboto(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          ,


                          SizedBox(height: 30),

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16), // Rounded corners
                              color: Color(0xff054952), // Base color
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  offset: Offset(4, 4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  offset: Offset(-1, -1),
                                  blurRadius: 2,
                                  spreadRadius: 0.5,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(16),


                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12), // Rounded corners
                                    color: Color(0xff054952), // Base color
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.4),
                                        offset: Offset(4, 4),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.2),
                                        offset: Offset(-4, -4),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Income',
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '\$${_totalIncome.toStringAsFixed(2)}',
                                        style: GoogleFonts.roboto(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 25),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12), // Rounded corners
                                    color: Color(0xff054952), // Base color
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.4),
                                        offset: Offset(4, 4),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.2),
                                        offset: Offset(-4, -4),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Expense',
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '\$${_totalExpense.toStringAsFixed(2)}',
                                        style: GoogleFonts.roboto(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                            ,
                          ),


                          SizedBox(height: 20),
                          Container(
                            width: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12), // Rounded corners
                              color: Color(0xff042924), // Base color
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  offset: Offset(4, 4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  offset: Offset(-2, -2),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff042924),
                                foregroundColor: Color(0xfff3f3f3),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: _updateGoals,
                              child: Text('Update Goals'),
                            ),
                          )

                        ],
                      ),
                    ],
                  ),
                ),

              ],
              SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
        ),
        style: TextStyle(color: Colors.white),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildGoalInfo(String label, double value) {
    return Text(
      '$label: ${value.toStringAsFixed(2)}',
      style: TextStyle(color: Colors.white, fontSize: 18),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildHorizontalProgressIndicator(String label, double goal, double current, Color color) {
    double progress;
    String progressText;

    if (label == 'Expense Progress') {
      // For expense progress, we calculate how much of the limit has been used
      progress = goal > 0 ? current / goal : 0;
      progress = progress > 1 ? 1 : progress; // Cap progress at 1.0
      progressText = progress >= 1
          ? 'Limit Reached'
          : '${(progress * 100).toStringAsFixed(1)}% of Limit Used';
    } else {
      // For income progress, normal calculation
      progress = goal > 0 ? current / goal : 0;
      progress = progress > 1 ? 1 : progress; // Cap progress at 1.0
      progressText = progress >= 1
          ? 'Goal Reached'
          : '${(progress * 100).toStringAsFixed(1)}% of Goal Attained';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white.withOpacity(0.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white.withOpacity(0.2),
                ),
                child: FractionallySizedBox(
                  widthFactor: progress,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [color.withOpacity(0.8), color],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  progressText,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


}
