import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../pdf_generate/display.dart';

class InputForm extends StatefulWidget {
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();
  String _orgName = '';
  String _orderNumber = '';
  String _startDate = '';
  String _endDate = '';
  String _currency = '';
  String _days = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Input Form')),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assest/img'), // Ensure you have the image in your assets folder
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 150), // Adjust this value to position correctly
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Org Name', filled: true, fillColor: Colors.white),
                    onSaved: (value) {
                      _orgName = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Order Number', filled: true, fillColor: Colors.white),
                    onSaved: (value) {
                      _orderNumber = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Start Date', filled: true, fillColor: Colors.white),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _startDate = DateFormat('d MMMM yyyy').format(pickedDate);
                        });
                      }
                    },
                    controller: TextEditingController(text: _startDate),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'End Date', filled: true, fillColor: Colors.white),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _endDate = DateFormat('d MMMM yyyy').format(pickedDate);
                        });
                      }
                    },
                    controller: TextEditingController(text: _endDate),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'pay ammount', filled: true, fillColor: Colors.white),
                    onSaved: (value) {
                      _currency = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'how many days ', filled: true, fillColor: Colors.white),
                    onSaved: (value) {
                      _days = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplayPage(
                              orgName: _orgName,
                              orderNumber: _orderNumber,
                              startDate: _startDate,
                              endDate: _endDate,
                              currency: _currency,
                              days: _days,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
