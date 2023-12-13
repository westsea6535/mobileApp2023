import 'package:flutter/material.dart';
import 'RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'mainPage.dart';
// import 'DataStorage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body:const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool saving = false;
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: saving,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Email"
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: "Password"
                ),
                onChanged: (value) {
                  password = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    setState(() {
                      saving = true;
                    });

                    final currentUser = await _authentication.signInWithEmailAndPassword(
                      email: email,
                      password: password
                    );

                    if (currentUser.user != null) {
                      _formKey.currentState!.reset();
                      if (!mounted) return;
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }

                    setState(() { 
                      saving = false;
                    });
                  } catch (e) {
                    print('Login error');}
                  }, 
                child: Text("Enter")
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("If you did not register,"),
                  TextButton(child: Text("Register your email"),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => RegisterPage()));
                    },
                  )
                ],
              ),
            ],
          ),

        ),
      ),
    );
  }
}