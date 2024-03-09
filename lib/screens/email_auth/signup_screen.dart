import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demo/screens/email_auth/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController location = TextEditingController();
  String? gender;
  bool hidePassword = true; // Initially, hide the password

  String? errorMessage;

  void showSnackBar(String message) {
    setState(() {
      errorMessage = message;
    });
  }

  void togglePasswordVisibility() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  void createAccount() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();
    String fullName = fullNameController.text.trim();

    if (email == "" || password == "" || cPassword == "" || fullName == "") {
      showSnackBar("Please fill all the details!");
    } else if (password != cPassword) {
      showSnackBar("Passwords do not match!");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (ex) {
        showSnackBar(ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Create an account",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: SafeArea(
          child: ListView(
            children: [
              if (errorMessage != null)
                Container(
                  color: Colors.red,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    TextField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email Address",
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      obscureText: hidePassword, // Obscure text if hidePassword is true
                      decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: IconButton(
                          onPressed: togglePasswordVisibility,
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: cPasswordController,
                      obscureText: hidePassword, // Obscure text if hidePassword is true
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: gender,
                      decoration: InputDecoration(
                        labelText: "Gender",
                      ),
                      items: ["Male", "Female", "Other"]
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          gender = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: location,
                      onTap: () {
                        // Implement location functionality here
                        // Example: use geolocator package to get current location
                      },
                      decoration: InputDecoration(
                        labelText: "",
                      ),
                    ),
                    SizedBox(height: 20),
                    CupertinoButton(
                      onPressed: () {
                        createAccount();
                      },
                      color: Colors.blue,
                      child: Text("Create Account"),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text("Login"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
