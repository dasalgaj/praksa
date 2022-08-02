// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:convert';
import 'dart:developer';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formEmail = GlobalKey<FormState>();
  bool _isValidEmail = false;
  

  //text controllers
  final emailController = TextEditingController();

  void _saveForm() {
    setState(() {
      _isValidEmail = _formEmail.currentState!.validate();

      if (_isValidEmail) {
          checkUser();
      }
    });
  }

  String? verifyLink;

  Future checkUser() async {
    var url = Uri.parse("http://192.168.5.12/check_email.php");
    var response = await http.post(url, body: {
      "email" : emailController.text.trim()
    }
    );

    var link = json.decode(response.body);

    if (link == 'INVALIDUSER') {
      Fluttertoast.showToast(
        msg: "Ovaj korisnik ne postoji",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
    else {

      setState(() {
        verifyLink = link;
      });

      sendEmail();

      Fluttertoast.showToast(
        msg: "Link je poslan na vaš mail račun",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );
      
      emailController.clear();

      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  int newPass = 0;

  Future resetPassword() async {
    var url = Uri.parse(verifyLink!);
    var response = await http.post(url);
    var link = json.decode(response.body);
    setState(() {
      newPass = link;
    });
    log(link);
  }

  sendEmail() async {
  // Note that using a username and password for gmail only works if
  // you have two-factor authentication enabled and created an App password.
  // Search for "gmail app password 2fa"
  // The alternative is to use oauth.
  String username = 'salgaj.dario@gmail.com';
  String password = 'eqtxtrfwofxwsqbb';

  final smtpServer = gmail(username, password);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.  

  // Create our message.
  final message = Message()
    ..from = Address(username)
    ..recipients.add(emailController.text.trim())
    //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    //..bccRecipients.add(Address('bccAddress@example.com'))
    ..subject = 'Password recover link from app : ${DateTime.now()}'
    //..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "<h3>Please click this link to reset your password</h3>\n<p><a href='$verifyLink'>Click me to reset</a></p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent. \n' +
        e.toString());
  }
}

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Enter Your Email and we will send you a password reset link',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),

          SizedBox(height: 10),

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

              // reset password button
              MaterialButton(
                onPressed:() => _saveForm(),
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    color: Colors.white,
                    )
                  ),
                color: Colors.deepPurple
              ),
        ],
      ),
    );
  }
}