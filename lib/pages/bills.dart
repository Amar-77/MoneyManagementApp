import 'package:flutter/material.dart';

class Bills extends StatefulWidget {
  const Bills({super.key});

  @override
  _BillsState createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  String? _expandedImagePath; // To store the path of the expanded image

  void _showImage(String imagePath) {
    setState(() {
      _expandedImagePath = imagePath;
    });
  }

  void _hideImage() {
    setState(() {
      _expandedImagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Color(0xff00292f)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xff4a9591), Color(0xff043941)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 70.0,right: 20),
                      child: Text(
                        "Uploaded Bills",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff00292f),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView(
                      children: [
                        // Example bill items
                        BillItem(
                          imagePath: "assets/images/bill1.jpg",
                          description: "Electricity Bill",
                          onTap: () => _showImage("assets/images/bill1.jpg"),
                        ),
                        BillItem(
                          imagePath: "assets/images/bill2.jpg",
                          description: "Air-Conditioner",
                          onTap: () => _showImage("assets/images/bill2.jpg"),
                        ),
                        // Add more bill items as needed
                      ],
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      // Handle upload action
                    },
                    child: const Text('Upload New Bill'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xff468b88),
                      backgroundColor: Color(0xff00292f),
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Show full-screen image if _expandedImagePath is not null
          if (_expandedImagePath != null)
            GestureDetector(
              onTap: _hideImage,
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: Image.asset(
                    _expandedImagePath!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class BillItem extends StatelessWidget {
  final String imagePath;
  final String description;
  final VoidCallback onTap; // Callback to handle tap event

  const BillItem({
    required this.imagePath,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Color(0xffb1c2c2), // Set the color of the card to a green shade
      child: ListTile(
        contentPadding: EdgeInsets.all(10.0),
        leading: GestureDetector(
          onTap: onTap,
          child: Image.asset(
            imagePath,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(description),
      ),
    );
  }
}
