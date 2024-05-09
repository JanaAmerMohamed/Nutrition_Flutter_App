import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';

class MainScreen2 extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen2> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  int _notificationInterval = 15; // Default interval

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reminder Notification"),
        backgroundColor: Color(0xFF223D60),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        child: Center(
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter the name of the Drug!',
                  prefixIcon: Icon(Icons.drive_file_rename_outline),
                  labelText: 'Drug name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                validator: _validateName,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _doseController,
                decoration: InputDecoration(
                  hintText: 'Enter the interval in minutes!',
                  prefixIcon: Icon(Icons.calculate_sharp),
                  labelText: 'Interval to send notification (minutes)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  setState(() {
                    _notificationInterval = int.tryParse(value) ?? 15;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(
                  hintText: 'Enter the notification body!',
                  prefixIcon: Icon(Icons.message),
                  labelText: 'Notification Body',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF223D60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                onPressed: () {
                  Workmanager().registerPeriodicTask(
                    "1",
                    "periodic Notification",
                    inputData: {
                      'body': _bodyController.text,
                    },
                    frequency: Duration(minutes: _notificationInterval),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Notification added successfully')),
                  );
                  Navigator.of(context).pop(); // Navigate back to the previous screen (dashboard page)
                },
                child: Text(
                  'Set Notification Interval',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
