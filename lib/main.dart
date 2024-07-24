import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pratnotes/constants/routers.dart';
import 'package:pratnotes/firebase_options.dart';
import 'package:pratnotes/views/register_view.dart';
import 'package:pratnotes/views/verify_email_view.dart';
import 'views//login_view.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const RegisterView(),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
      }
    )
  );
}



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if(user != null){
              if(user.emailVerified){
                return const NotesView();
              }
              else{
                return const VerifyEmailView();
              }
            }
            else{
              return const LoginView();
            }
            
          default:
            return const Text('Loading');
            
        }
      },
    );
  }
}




enum MenuAction {logout, settings}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
                switch (value){
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialogue(context);
                    if(shouldLogout){
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                    }
                    devtools.log(shouldLogout.toString());
                    break;
                  case MenuAction.settings:
                    devtools.log('settings');
                    break;
                  default:
                    devtools.log('default');
                    break;
                }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,  
                  child: Text('Logout'),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.settings,  
                  child: Text('Settings'),
                ),
              ];
          },)
        ],
        ),
      body: const Text('hello world')
    );
  }
}


Future<bool> showLogOutDialogue(BuildContext context){
  return showDialog(
    context: context, 
    builder: (context){
      return AlertDialog(
        title: const Text('SignOut'),
        content: const Text('Are you sure you want to sign out'),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(true);
            },
            child: const Text('Logout'),
          ),
        ]
      );
    }
  ).then((value) => value ?? false);
}