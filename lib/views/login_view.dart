import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
                final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                print(userCredential);
              }
              on FirebaseAuthException catch(e){
                if(e.code == 'user-not-found'){
                  print('user not found');
                }
                else if(e.code == 'invalid-credential'){
                  print('invalid credentials');
                }
                else if(e.code == 'wrong-password'){
                  print('incorrect password');
                }
                else{
                  print('something else');
                  print(e.code);
                }
              }
              catch(e){
                print(e.runtimeType);
              }
            },
          ),
          TextButton(
            child: const Text('Not registered? Register here!'),
            onPressed: () async {
              try{
                print('hree');
                Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false);
              }
              catch(e){
                print(e.runtimeType);
              }
            },
          )
        ],
      ),
    );
  }
}



