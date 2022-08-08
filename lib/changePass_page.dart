// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'main_page.dart';

class ChangePassPage extends StatefulWidget {
  final String changeEmail;
  final String changePass;
  const ChangePassPage({Key ? key, required this.changeEmail, required this.changePass}) : super(key: key);

  @override
  State<ChangePassPage> createState() => _ChangePassPage();
}

class _ChangePassPage extends State<ChangePassPage> {
  final _formOldPassword = GlobalKey<FormState>();
  final _formNewPassword = GlobalKey<FormState>();
  final _formConfirmNewPassword = GlobalKey<FormState>();
  bool _isValidOldPassword = false;
  bool _isValidNewPassword = false;
  bool _isValidConfirmNewPassword = false;

  // text controller
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  void _saveForm() {
    setState(() {
      _isValidOldPassword = _formOldPassword.currentState!.validate();
      _isValidNewPassword = _formNewPassword.currentState!.validate();
      _isValidConfirmNewPassword = _formConfirmNewPassword.currentState!.validate();

      if (_isValidOldPassword && _isValidNewPassword && _isValidConfirmNewPassword) {
        promjeniLozinku();
      }
    });
  }

  Future promjeniLozinku() async {
    var url = Uri.parse("http://192.168.5.15/promjena_lozinke.php");
    var response = await http.post(url, body: {
      "email" : widget.changeEmail,
      "newPassword" : newPasswordController.text.trim(),
    });

    var data = json.decode(response.body);
    
    if (data == "Success") {
      Fluttertoast.showToast(
        msg: "Lozinka uspješno promijenjena",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );

      oldPasswordController.clear();
      newPasswordController.clear();
      confirmNewPasswordController.clear();
      FocusManager.instance.primaryFocus?.unfocus();

      Navigator.pushAndRemoveUntil<dynamic>(context, MaterialPageRoute<dynamic>(builder: ((context) => MainPage(email: widget.changeEmail, password:  widget.changePass,))), (route) => false,);
    }
    else if (data == "Error") {
      Fluttertoast.showToast(
        msg: "Pogreška",
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
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(
                'Promjena lozinke',
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
              )
              ),
              SizedBox(height: 50),
                
              // old password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Form(
                  key: _formOldPassword,
                  child: TextFormField(
                    controller: oldPasswordController,
                    obscureText: true,
                    validator:(oldPassword) {

                      if (oldPassword == null || oldPassword.isEmpty) {
                        return 'Ovo polje je obavezno';
                      }

                      if (oldPasswordController.text.trim() != widget.changePass) {
                        return 'Pogrešna stara lozinka';
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
                    hintText: 'Stara lozinka',
                    fillColor: Colors.grey[200],
                    filled: true,
                    ),  
                  ),
                ),
              ),
                
              SizedBox(height: 10),
          
              // new password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Form(
                  key: _formNewPassword,
                  child: TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    validator:(newPassword) {
                      RegExp regex = 
                        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

                      if (newPassword == null || newPassword.isEmpty) {
                        return 'Ovo polje je obavezno';
                      }

                      if (!regex.hasMatch(newPassword)) {
                          return 'Unesite valjanu lozinku\nJedno veliko slovo\nJedno malo slovo\nMinimalno 8 znakova\nJedan specijalni znak';
                      }

                      if (newPassword == widget.changePass) {
                        return 'Ne može biti stara lozinka';
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
                    hintText: 'Nova lozinka',
                    fillColor: Colors.grey[200],
                    filled: true,
                    ),  
                  ),
                ),
              ),
          
              SizedBox(height: 10),

              // confirm new password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Form(
                  key: _formConfirmNewPassword,
                  child: TextFormField(
                    controller: confirmNewPasswordController,
                    obscureText: true,
                    validator:(confirmNewPassword) {
                      if (confirmNewPassword == null || confirmNewPassword.isEmpty) {
                        return 'Ovo polje je obavezno';
                      }
                
                      if (confirmNewPasswordController.text.trim() != newPasswordController.text.trim()){
                          return 'Lozinke se ne podudaraju';
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
                    hintText: 'Potvrdi novu lozinku',
                    fillColor: Colors.grey[200],
                    filled: true,
                    ),  
                  ),
                ),
              ),
          
              SizedBox(height: 10),
          
              // promjeni lozinku button
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
          
            ]),
          ),
        ),
      ),
    );
  }
}