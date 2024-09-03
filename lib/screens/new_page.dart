

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'device_info.dart';

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'IN');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Number Validation'),
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),
        backgroundColor: Color(0xFF4DB6AC),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  _phoneNumber = number;
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.DIALOG,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                selectorTextStyle: TextStyle(color: Colors.black),
                initialValue: _phoneNumber,
                textFieldController: TextEditingController(),
                inputDecoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                formatInput: false,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    print('Form is valid');
                    print('Phone number: ${_phoneNumber.phoneNumber}');
                    print('ISO code: ${_phoneNumber.isoCode}');
                  } else {
                    print('Form is invalid');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background color
                  foregroundColor: Colors.white, // Text color
                  disabledForegroundColor: Colors.grey, // Disabled text color
                  disabledBackgroundColor: Colors.grey.shade400, // Disabled background color
                ),
                child: Text('Submit'),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeviceInfo()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent, // Background color
                  foregroundColor: Colors.white, // Text color
                  disabledForegroundColor: Colors.grey, // Disabled text color
                  disabledBackgroundColor: Colors.grey.shade400, // Disabled background color
                ),
                child: Text('Device Info'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




