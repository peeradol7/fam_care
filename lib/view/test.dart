import 'package:flutter/material.dart';

class BirthDateForm extends StatefulWidget {
  @override
  _BirthDateFormState createState() => _BirthDateFormState();
}

class _BirthDateFormState extends State<BirthDateForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime _birthDate = DateTime.now();
  DateTime _periodDate = DateTime.now();

  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _periodDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _birthDateController.text =
        "${_birthDate.toLocal()}".split(' ')[0]; // Format initial date
    _periodDateController.text = "${_periodDate.toLocal()}".split(' ')[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Your Birth Date and Period Date')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _birthDateController,
                decoration: InputDecoration(labelText: 'Birth Date'),
                readOnly: true,
                onTap: () async {
                  DateTime pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _birthDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      ) ??
                      _birthDate;

                  setState(() {
                    _birthDate = pickedDate;
                    _birthDateController.text =
                        "${_birthDate.toLocal()}".split(' ')[0];
                  });
                },
              ),
              TextFormField(
                controller: _periodDateController,
                decoration: InputDecoration(labelText: 'Period Date'),
                readOnly: true,
                onTap: () async {
                  DateTime pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _periodDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      ) ??
                      _periodDate;

                  setState(() {
                    _periodDate = pickedDate;
                    _periodDateController.text =
                        "${_periodDate.toLocal()}".split(' ')[0];
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Call AuthService to save data to Firestore
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
