  import 'dart:developer';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:demo/screens/email_auth/signup_screen.dart';
  import 'package:demo/screens/home_screen.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';

  class LoginScreen extends StatefulWidget {
    const LoginScreen({ Key? key }) : super(key: key);

    @override
    State<LoginScreen> createState() => _LoginScreenState();
  }

  class _LoginScreenState extends State<LoginScreen> {

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    void login() async {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if(email == "" || password == "") {
        log("Please fill all the fields!");
      }
      else {

        try {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
          if(userCredential.user != null) {

            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(context, CupertinoPageRoute(
                builder: (context) => HomeScreen()
            ));

          }
        } on FirebaseAuthException catch(ex) {
          log(ex.code.toString());
        }
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Login",
            style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blueGrey,
        ),

        body: SafeArea(
          child: Center( // Center the content vertically and horizontally
            child: ListView(
              children: [

                Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            labelText: "Email Address"
                        ),
                      ),

                      SizedBox(height: 10,),

                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            labelText: "Password"
                        ),
                      ),

                      SizedBox(height: 20,),

                      CupertinoButton(
                        onPressed: () {
                          login();
                        },
                        color: Colors.blue,
                        child: Text("Log In"),
                      ),

                      SizedBox(height: 10,),

                      CupertinoButton(
                        onPressed: () {
                          Navigator.push(context, CupertinoPageRoute(
                              builder: (context) => SignUpScreen()
                          ));
                        },
                        child: Text("Create an Account"),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      );
    }
  }
