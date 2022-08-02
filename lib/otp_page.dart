// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'login_page.dart';

class OtpPage extends StatelessWidget {
  final String email;
  final String mobitel;
  final String password;
  const OtpPage({Key? key, required this.email, required this.mobitel, required this.password}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 2.0),
                child: Row(
                  children: [
                    Text(
                      'Verification code',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 8),
                child: Row(
                  children: [
                    Text(
                      'We have sent the code verification to',
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 8),
                child: Row(
                  children: [
                    Text(
                      '+99******1233',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  onChanged: (value) {
                    print(value);
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    inactiveColor: Colors.deepPurple
                  ),
                ),
              ),

              SizedBox(height: 30),

              // confirm login
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 110.0),
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                          ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
