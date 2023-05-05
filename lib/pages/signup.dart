import 'package:crud_app/pages/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

    bool? isSigning = false;
    final _formKey = GlobalKey<FormState>();
    final passwordRegExp = 
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>');

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
  }

  // text editing controllers
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final fullNameController = TextEditingController();

  final phoneNumberController = TextEditingController();


  Future createUserWithEmailAndPassword() async {
    setState(() {
      isSigning = true;
    });
    try {
      await Auth().createUserWithEmailAndPassword(email: usernameController.text, password: passwordController.text).then((value) {
        setState(() {
          isSigning = false;
        });
        Navigator.pushReplacementNamed(context, '/register');
      } );
    } on FirebaseAuthException catch(e) {
      print('error accured $e');
      setState(() {
        isSigning = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff110b1f),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // logo
                const Image(image: AssetImage('assets/logo.png'), height: 200,),

                const SizedBox(height: 20),

                // welcome back, you've been missed!
                Text(
                  'Register now to join us!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                    MyTextField(
                  controller: fullNameController,
                  hintText: 'Full Name',
                  obscureText: false, icon: Icons.person_pin_sharp, textInputType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your full name';
                    }
                  },
                ),

                const SizedBox(height: 20),

                // password textfield
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false, icon: Icons.person, textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (!EmailValidator.validate(value!)) {
                      return 'Please enter a valid email adress';
                    }
                  },
                ),

                const SizedBox(height: 20),

                MyTextField(
                  controller: phoneNumberController,
                  hintText: 'Phone Number',
                  obscureText: false, icon: Icons.phone, textInputType: TextInputType.phone,
                  validator: (value) {
                    if (value!.length != 9) {
                      return 'Please enter a correct phone number';
                    }
                  },
                ),

                const SizedBox(height: 20),

                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true, icon: Icons.lock, textInputType: TextInputType.text,
                  validator: (value) {
                    if (!passwordRegExp.hasMatch(value!) && value.length < 6) {
                      return 'Please enter at least 6 characters';
                    }
                  },
                ),

                const SizedBox(height: 20),

                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true, icon: Icons.lock, textInputType: TextInputType.text,
                  validator: (value) {
                    if (value != passwordController.text) {
                      return 'Please enter the same password';
                    }
                  },
                ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(onTap: () { 
                  if (_formKey.currentState!.validate()) {
                    createUserWithEmailAndPassword();
                  }
                }, label: 'Sign Up',

                ),

                const SizedBox(height: 15,),

                isSigning == true ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Please wait...", style: TextStyle(color: Colors.white),),
                    SizedBox(
                      width: 10,
                    ),
                    SpinKitPianoWave(
              color: Colors.white,
              size: 50,
            )
                  ],
                ) : Container(),

                const SizedBox(height: 50),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () { Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );    },
                      child: const Text(
                        'Log in now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}