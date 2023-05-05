import 'package:crud_app/pages/signup.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../components/square_tile.dart';
import '../services/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    bool? isSigning = false;
    final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  // text editing controllers
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  Future signInWithEmailAndPassword() async {
    setState(() {
      isSigning = true;
    });
    try {
      await Auth().signInWithEmailAndPassword(email: usernameController.text, password: passwordController.text).then((value) {
        setState(() {
          isSigning = false;
        });
        Navigator.pushReplacementNamed(context, '/login');
      });
    } on FirebaseAuthException catch(e) {
      print('some error $e');
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
                  'Welcome back you\'ve been missed!',
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
                                      // username textfield
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false, icon: Icons.person, textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (!EmailValidator.validate(value!)) {
                      return 'Please enter a valid email address';
                    }
                  },
                ),

                const SizedBox(height: 20),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true, icon: Icons.lock, textInputType: TextInputType.text,
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'Please enter at least 6 characters';
                    }
                  },
                ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(onTap: () { 
                  if (_formKey.currentState!.validate()) {
                    signInWithEmailAndPassword();
                  }
                }, label: 'Login',
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

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // google button
                    SquareTile(imagePath: 'assets/google.png'),

                    SizedBox(width: 25),

                    // apple button
                    SquareTile(imagePath: 'assets/apple.png')
                  ],
                ),

                const SizedBox(height: 30),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () { Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );   },
                      child: const Text(
                        'Register now',
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