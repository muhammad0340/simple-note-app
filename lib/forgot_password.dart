import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_notes_app/login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password Screen"),
      ),
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'email',
            ),
          ),
          InkWell(
            onTap: ()async{
              try{
                FirebaseAuth auth = FirebaseAuth.instance;
                await auth.sendPasswordResetEmail(email: emailController.text);
                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return LoginScreen();
                }));
              }
                  catch(e){
                print(e.toString(),);
                  }
            },
            child: Container(
              height: 50,
             width: 150,
             child: Center(
               child: Text("send"),
             ),
            ),
          )
        ],
      ),
    );
  }
}
