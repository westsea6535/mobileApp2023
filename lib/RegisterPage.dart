// import 'package:ass9/SuccessRegister.dart';
import 'SuccessRegister.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: const RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool saving = false;
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String userName = "";
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
                decoration: const InputDecoration(labelText: "Email"),
                onChanged: (value) {
                  email = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Password"),
                onChanged: (value) {
                  password = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "User Name"),
                onChanged: (value) {
                  userName = value;
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
                    print('where0');
                    final newUser = await _authentication.createUserWithEmailAndPassword(email: email, password: password);
                    // await FirebaseFirestore.instance.collection("user").doc(newUser.user!.uid).set(
                    //   {
                    //     "userName":userName,
                    //     "password":password,
                    //     "email":email,
                    //   });
                    print('where1');
                    if (newUser.user != null) {
                      _formKey.currentState!.reset();
                      print('where2');
                      if (!mounted) return;
                      print('where3');
                      Navigator.push(
                        context,
                        MaterialPageRoute( builder: (context) => const SuccessRegisterPage())
                      ); 
                      print('where4');
                      setState(() {
                        saving = false;
                      });
                    }
                  } catch(e){
                    print(e);
                  }
                },
                child: Text("Enter")
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("If you already registered,"),
                  TextButton(
                    child: Text("login in with your email."),
                    onPressed: () {
                      Navigator.pop(context);
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
