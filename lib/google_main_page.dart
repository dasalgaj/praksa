// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:praksa_zadatak/api/google_signin_api.dart';
import 'login_page.dart';

class GoogleMainPage extends StatelessWidget {
  final GoogleSignInAccount user;

  const GoogleMainPage({Key? key, required this.user}) : super(key: key);

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
                    onPressed:() async {
                      await GoogleSignInApi.logout();

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
                    user.email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}