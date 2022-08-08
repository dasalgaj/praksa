// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key ? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterStatePage();
}

class _RegisterStatePage extends State<RegisterPage> {
  final _formEmail = GlobalKey<FormState>();
  final _formPassword = GlobalKey<FormState>();
  final _formConfirmPass = GlobalKey<FormState>();
  bool _isValidEmail = false;
  bool _isValidPassword = false;
  bool _isValidConfirmPass = false;

  // text controller
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  void _saveForm() {
    setState(() {
      _isValidEmail = _formEmail.currentState!.validate();
      _isValidPassword = _formPassword.currentState!.validate();
      _isValidConfirmPass= _formConfirmPass.currentState!.validate();

      if (_isValidEmail && _isValidPassword && _isValidConfirmPass) {
        register();
      }
    });
  }

  Future register() async {
    var url = Uri.parse("http://192.168.5.15/registracija.php");
    var response = await http.post(url, body: {
      "email" : emailController.text.trim(),
      "password" : passController.text.trim(),
    });

    var data = json.decode(response.body);
    
    if (data == "Error") {
      Fluttertoast.showToast(
        msg: "Ovaj Email je zauzet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
    else {
      Fluttertoast.showToast(
        msg: "Registracija uspješna",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );

      emailController.clear();
      passController.clear();
      confirmPassController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
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
                'Hello there',
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
              )
              ),
              SizedBox(height: 10),
              Text(
                'Register below with your details',
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
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return 'Ovo polje je obavezno';
                      }
                
                      if (!EmailValidator.validate(email)) {
                        return "Unesi valjani email";
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
                    controller: passController,
                    validator: (password) {
                      RegExp regex = 
                        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

                        if (password == null || password.isEmpty) {
                          return 'Ovo polje je obavezno';
                        }

                        if (!regex.hasMatch(password)) {
                          return 'Unesite valjanu lozinku\nJedno veliko slovo\nJedno malo slovo\nMinimalno 8 znakova\nJedan specijalni znak';
                        }
                  
                        return null;
                      },
                    obscureText: true,
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
          
              //confirm password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Form(
                  key: _formConfirmPass,
                  child: TextFormField(
                    controller: confirmPassController,
                    validator: (confirmPassword) {
                        if (confirmPassword == null || confirmPassword.isEmpty) {
                          return 'Ovo polje je obavezno';
                        }

                        if (confirmPassController.text.trim() != passController.text.trim()){
                          return 'Lozinke se ne podudaraju';
                        }
                  
                        return null;
                      },
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                      hintText: 'Potvrdi Lozinku',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),  
                  ),
                ),
              ),
          
              SizedBox(height: 10),

              // sign up button
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
                        'Registriraj se',
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
                
              // I am a member! login now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Imate račun? ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                  ),
                  GestureDetector(
                    onTap: () {
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
                    child: Text(
                        'Prijavite se',
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