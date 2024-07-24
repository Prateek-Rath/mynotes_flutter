import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:pratnotes/constants/routers.dart';
// import 'package:pratnotes/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }


   @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'),),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(hintText: 'Enter email'),
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(hintText: 'Enter password'),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextButton(
            child: const Text('Login'),
            onPressed: () async {
              try{
                final email = _email.text;
                final password = _password.text;
                await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                Navigator.of(context).pushNamedAndRemoveUntil('/notes/', (_) => false,);
              }
              on FirebaseAuthException catch(e){
                if(e.code == 'user-not-found'){
                  devtools.log('user not found');
                }
                else if(e.code == 'invalid-credential'){
                  devtools.log('invalid credentials');
                }
                else if(e.code == 'wrong-password'){
                  devtools.log('incorrect password');
                }
                else{
                  devtools.log('something else');
                  devtools.log(e.code);
                }
              }
              catch(e){
                devtools.log(e.runtimeType.toString());
              }
            },
          ),
          TextButton(
            child: const Text('Not registered? Register here!'),
            onPressed: () async {
              try{
                devtools.log('hree');
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
              }
              catch(e){
                devtools.log(e.runtimeType.toString());
              }
            },
          )
        ],
      ),
    );
  }
}



