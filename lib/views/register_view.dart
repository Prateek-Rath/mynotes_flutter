import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:pratnotes/firebase_options.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  late final TextEditingController _email, _password;


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
      appBar: AppBar(title: const Text('Register'),),
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
            child: const Text('register'),
            onPressed: () async {
              try{
                final email = _email.text;
                final password = _password.text;
                final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                devtools.log(userCredential.toString());
              }
              on FirebaseAuthException catch(e){
                if(e.code == 'weak-password'){
                  devtools.log('weak password');
                }
                else if(e.code == 'email-already-in-use'){
                  devtools.log('Email is already in use');
                }
                else if(e.code == 'invalid-email'){
                  devtools.log('invalid email');
                }
                else{
                  devtools.log('something else');
                  devtools.log(e.code);
                }
              }
              catch(e){
                devtools.log('error');
                devtools.log(e.runtimeType.toString());
              }
            },
          ),
          TextButton(
            onPressed: () async {
              try{
              Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
            }
            catch(e){
              devtools.log(e.runtimeType.toString());
            }
            }, 
            child: const Text('Already registered?, Login here!'),
          ),
        ],
      ),
    );
  }
}