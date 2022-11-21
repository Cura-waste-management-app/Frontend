import 'package:cura_frontend/features/auth/auth_screen_phone.dart';
import 'package:flutter/material.dart';

class AuthScreenOtp extends StatefulWidget {
  const AuthScreenOtp({super.key});
  static const routeName = 'auth-screen-otp';

  @override
  // ignore: library_private_types_in_public_api
  _AuthScreenOtpState createState() => _AuthScreenOtpState();
}

class _AuthScreenOtpState extends State<AuthScreenOtp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // ignore: avoid_unnecessary_containers, prefer_const_constructors
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/auth-screen.png',
                width: 300,
                height: 300,
              ),
              const SizedBox(
                height: 25,
              ),

              // ignore: avoid_unnecessary_containers

              const SizedBox(
                height: 10,
              ),
              // ignore: prefer_const_constructors
              Text(
                'Phone Verification',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'We need to register your phone before you could contribute :)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "+91"),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Phone Number"),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AuthScreenPhone.routeName);
                  },
                  child: const Text('Send Code'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
