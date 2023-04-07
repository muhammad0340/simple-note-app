import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController contectController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("SignUp Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 28.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              //................................................
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  right: 28,
                  left: 28,
                  bottom: 15,
                ),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Enter Username',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  right: 28,
                  left: 28,
                  bottom: 15,
                ),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: TextField(
                    controller: contectController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.phone),
                      hintText: 'Enter Contect',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  right: 28,
                  left: 28,
                  bottom: 15,
                ),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Enter Email',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  right: 28,
                  left: 28,
                  bottom: 15,
                ),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),
              InkWell(
                onTap: () async {
                  try {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    await auth.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(auth.currentUser!.uid)
                        .set({
                      'uid': auth.currentUser!.uid,
                      'username': usernameController.text,
                      'contect': contectController.text,
                      'email': emailController.text,
                    });

                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return LoginScreen();
                    }));
                  } catch (e) {
                    print(
                      e.toString(),
                    );
                  }
                },
                child: Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      "SignUp",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
