import 'package:cura_frontend/features/auth/auth_screen_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreenPhone extends StatefulWidget {
  const AuthScreenPhone({super.key});
  static const routeName = 'auth-screen-phone';
  static String verify = "";
  @override
  State<AuthScreenPhone> createState() => _AuthScreenPhoneState();
}

class _AuthScreenPhoneState extends State<AuthScreenPhone> {
  TextEditingController countryCode = TextEditingController();

  var phone = "";

  @override
  void initState() {
    // TODO: implement initState
    countryCode.text = "+91";
    super.initState();
  }

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
                width: 200,
                height: 200,
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
                'We will send you one time password on this phone number',
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
                  children: <Widget>[
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryCode,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "+91"),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          phone = value;
                        },
                        decoration: const InputDecoration(
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
                  onPressed: () async {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      // ignore: unnecessary_string_interpolations
                      phoneNumber: '${countryCode.text + phone}',
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {
                        AuthScreenPhone.verify = verificationId;
                        Navigator.pushNamed(context, AuthScreenOtp.routeName);
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                      //Navigator.pushNamed(context, Location.routeName);
                    );
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
