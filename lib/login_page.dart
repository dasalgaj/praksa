// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:praksa_zadatak/main_page.dart';
import 'dart:convert';
import 'register_page.dart';
import 'otp_page.dart';
import 'forgotPass_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key ? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formEmail = GlobalKey<FormState>();
  final _formPassword = GlobalKey<FormState>();
  bool _isValidEmail = false;
  bool _isValidPassword = false;

  // text controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _saveForm() {
    setState(() {
      _isValidEmail = _formEmail.currentState!.validate();
      _isValidPassword = _formPassword.currentState!.validate();

      if (_isValidEmail && _isValidPassword) {
        login();
      }
    });
  }

  Future<String> getMobitel() async {
    var url = Uri.parse("http://192.168.5.14/get_data.php");
    var response = await http.post(url, body: {
      "email" : emailController.text,
      "password" : passwordController.text,
    });

    var data = json.decode(response.body);

    return data['Mobitel'];
  }

  Future login() async {
    var url = Uri.parse("http://192.168.5.14/prijava.php");
    var response = await http.post(url, body: {
      "email" : emailController.text,
      "password" : passwordController.text,
    });

    var data = json.decode(response.body);
    
    if (data == "Success") {

      Fluttertoast.showToast(
        msg: "Uspješna prijava",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );

      String brojMob = await getMobitel();

      FocusManager.instance.primaryFocus?.unfocus();

      Navigator.push(context, MaterialPageRoute(builder: ((context) => MainPage(email: emailController.text.trim(), password: passwordController.text.trim()))));
    }
    else if (data == "Error") {
      Fluttertoast.showToast(
        msg: "Netočni email ili lozinka",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(
                'Hello Again!',
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
              )
              ),
              SizedBox(height: 10),
              Text(
                'Welcome back!',
                style: TextStyle(
                fontSize: 20,
              )
              ),
              SizedBox(height: 50),
                
              // email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Form(
                  key: _formEmail,
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator:(email) {
                      if (email == null || email.isEmpty) {
                        return 'Ovo polje je obavezno';
                      }
                
                      return null;
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Email',
                    fillColor: Colors.grey[200],
                    filled: true,
                    ),  
                  ),
                ),
              ),
                
              SizedBox(height: 10),
          
              // password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Form(
                  key: _formPassword,
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    validator:(password) {
                      if (password == null || password.isEmpty) {
                        return 'Ovo polje je obavezno';
                      }
                
                      return null;
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Lozinka',
                    fillColor: Colors.grey[200],
                    filled: true,
                    ),  
                  ),
                ),
              ),

              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap:() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return ForgotPasswordPage();
                          })
                        );
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          
              SizedBox(height: 10),
          
              // prijavi se button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap:() => _saveForm(),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Text(
                        'Prijavi se',
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
              SizedBox(height: 25),
                
              // nemate račun? registrirajte se
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Nemate račun? ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (
                            (context) => RegisterPage()
                            ),
                        ),
                      );
                    },
                    child: Text(
                        'Registrirajte se',
                        style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
          
            ]),
          ),
        ),
      ),
    );
  }
}