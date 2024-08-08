import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotiPage extends StatefulWidget {
  @override
  _NotiPageState createState() => _NotiPageState();
}

class _NotiPageState extends State<NotiPage> {
  List<String> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notifications = prefs.getStringList('notifications') ?? [];
    });
  }

  void _clearNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications');
    setState(() {
      _notifications = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever, color: Colors.white),
            onPressed: () {
              _clearNotifications();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Notifications cleared')),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4a9591), Color(0xFF043941)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 100),
              Container(
                height: MediaQuery.of(context).size.height - 100,
                child: Stack(
                  children: _notifications.asMap().entries.map((entry) {
                    int index = entry.key;
                    String notification = entry.value;

                    return Positioned(
                      top: 10 + (index * 100),
                      left: 10,
                      right: 10,
                      child: Card(
                        color: Colors.black54,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          title: Text(
                            notification,
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: Icon(Icons.notifications, color: Colors.white),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
