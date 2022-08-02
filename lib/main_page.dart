// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'otp_page.dart';
import 'changePass_page.dart';

class MainPage extends StatelessWidget {
  final String email;
  final String password;
  const MainPage({Key? key, required this.email, required this.password}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 88.0),
                      child: Text(
                        'Hello',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                      ),
                    ),
                  ),
                  
                  // sign out button
                  RawMaterialButton(
                    onPressed:() {
                      Navigator.pushAndRemoveUntil<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (
                                (context) => LoginPage()
                                ),
                            ),
                            (route) => false,
                          );
                    },
                    elevation: 2.0,
                    fillColor: Colors.deepPurple,
                    child: Icon(
                      Icons.logout,
                      size: 30.0,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(12.0),
                    shape: CircleBorder(),
                    ),
                ],
              ),

              Text(
                    email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),

              SizedBox(height: 40),

              // change password button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                child: GestureDetector(
                  onTap:() {
                    Navigator.push(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (
                                (context) => ChangePassPage(changeEmail: email, changePass: password)
                                ),
                            ),
                          );
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Text(
                        'Promjeni lozinku',
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