import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nutrition_app/Notifications/notification.dart';
import 'package:nutrition_app/coverttime.dart'; // Import for TextInputFormatter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrition_app/reminder_page1_adddrug.dart';


final FirebaseFirestore _firestore = FirebaseFirestore.instance;

void saveDrugInformation(String name, String dose, String type, int interval, TimeOfDay time) async {
  final uid = FirebaseAuth.instance.currentUser!.uid; // Get the current user's ID

  // Create a reference to the user's patient document
  final patientRef = _firestore.collection('patients').doc(uid);

  // Create a new document within the drugs collection of the patient
  final docRef = patientRef.collection('drugs').doc();
  final formattedTime = Timestamp.fromDate(DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    time.hour,
    time.minute,
  ));

  await docRef.set({
    'name': name,
    'dose': dose,
    'type': type,
    'interval': interval,
    'time': formattedTime,
  });

  // Calculate the next notification time based on the selected time and interval
  DateTime nextNotificationTime = DateTime.now().add(Duration(hours: time.hour, minutes: time.minute));
  // for (int i = 1; i <= interval; i++) {
  //   nextNotificationTime = nextNotificationTime.add(Duration(hours: interval));
  //   LocalNotificationService.showRepeatedNotification(nextNotificationTime);
  // }
}


class DataEntry extends StatefulWidget {
  const DataEntry({Key? key}) : super(key: key);

  @override
  State<DataEntry> createState() => _DataEntryState();
}

class _DataEntryState extends State<DataEntry> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  String? _selectedType;
  var _selectedInterval = 0;
  TimeOfDay _time=const TimeOfDay(hour: 0, minute: 00);
  bool _clicked=false;

  Future<TimeOfDay>_selected_time() async{
    final TimeOfDay? picked= await showTimePicker(context: context, initialTime: _time);
    if(picked !=null && picked!=_time){
      setState(() {
        _time=picked;
        _clicked=true;
      });

    }
    return picked!;
  }

  // Validator function for the name TextField
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return

     SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter the name of the Drug!',
                      prefixIcon: Icon(Icons.drive_file_rename_outline),
                      labelText: 'Drug name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    // Validator added here
                    validator: _validateName,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: TextFormField(
                    controller: _doseController,
                    decoration: InputDecoration(
                      hintText: 'Enter the dose!',
                      prefixIcon: Icon(Icons.calculate_sharp),
                      labelText: 'Dosage in gm ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    // Input formatters added here to accept only numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Select Drug Type:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF223D60)),
                ),
                RadioListTile<String>(
                  title: Text('Bottle', style: TextStyle(fontSize: 15, color: Color(0xFF223D60))),
                  value: 'bottle',
                  groupValue: _selectedType,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Tablet', style: TextStyle(fontSize: 15, color: Color(0xFF223D60))),
                  value: 'tablet',
                  groupValue: _selectedType,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Syringe', style: TextStyle(fontSize: 15, color: Color(0xFF223D60))),
                  value: 'syringe',
                  groupValue: _selectedType,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Pill', style: TextStyle(fontSize: 15, color: Color(0xFF223D60))),
                  value: 'pill',
                  groupValue: _selectedType,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                Interval(
                  selected: _selectedInterval,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedInterval = newValue!;
                    });
                  },
                ),
SizedBox(
    width: 330,
    height: 40,
    child: Text("Select Time",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color:Color(0xFF223D60) ),)),
            SizedBox(
              width: 200,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF065A82) ,
                  shape: StadiumBorder(),
                ),
                onPressed: (){
                  _selected_time();
                },
                child: Text(
                  _clicked==false
                      ?
                  "\tSelect Time\t": "${convertTime(_time.hour.toString())}: ${convertTime(_time.minute.toString())}",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Form is valid, process data and schedule notification
                      saveDrugInformation(
                        _nameController.text,
                        _doseController.text,
                        _selectedType!,
                        _selectedInterval,
                        _time,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => drug_card()),
                      );
                    }
                  },
                  child: SizedBox(
                    width: 100,
                    child: Center(child: Text('Submit', style: TextStyle(color: Colors.white))),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF223D60)),
                  ),
                ),



              ],
            ),
          ),
        ),
      );

  }
}

class Interval extends StatelessWidget {
  final List<int> _interval = [0, 6, 8, 12, 24]; // Add 0 as a unique value
  final int selected;
  final ValueChanged<int?>? onChanged;

  Interval({Key? key, required this.selected, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text("Remind me every:", style: TextStyle(color: Color(0xFF223D60),fontWeight: FontWeight.bold)), // Set text color here
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: DropdownButton<int>(
              hint: selected == 0 ? Text("Select an interval", style: TextStyle(color: Color(0xFF223D60))) : null, // Set hint text color
              value: selected,
              items: _interval.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value == 0 ? "Select an interval" : value.toString(), style: TextStyle(color: Color(0xFF223D60))), // Set dropdown item text color
                );
              }).toList(),
              onChanged: onChanged,
              style: TextStyle(color: Color(0xFF223D60)), // Set dropdown button text color
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(selected == 1 ? "hour" : "hours", style: TextStyle(color: Color(0xFF223D60),fontWeight: FontWeight.bold)), // Set text color here
          ),
        ],
      ),
    );
  }

}





