import 'package:cura_frontend/common/error_screen.dart';
import 'package:cura_frontend/features/auth/auth_screen_otp.dart';
import 'package:cura_frontend/features/auth/controllers/auth_controller.dart';
import 'package:cura_frontend/features/auth/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:country_picker/country_picker.dart';

class AuthScreenPhone extends ConsumerStatefulWidget {
  const AuthScreenPhone({Key? key}) : super(key: key);
  static const routeName = 'auth-screen-phone';
  static String verify = "";
  @override
  ConsumerState<AuthScreenPhone> createState() => _AuthScreenPhoneState();
}

class _AuthScreenPhoneState extends ConsumerState<AuthScreenPhone> {
  final TextEditingController phoneController = TextEditingController();
  String countryCode = "91";
  Country? country;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country c) {
          setState(() {
            country = c;
            countryCode = c.phoneCode;
          });
        });
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+$countryCode$phoneNumber');
    } else {
      showSnackBar(context: context, content: "Please enter your phone number");
    }
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

              ElevatedButton(
                  onPressed: pickCountry, child: const Text("Pick Country")),

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
                      child: Text('+$countryCode'), //TextField(
                      //   controller: countryCode,
                      //   decoration: const InputDecoration(
                      //       border: InputBorder.none, hintText: "+91"),
                      // ),
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
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
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
                  onPressed: sendPhoneNumber,
                  //() async {
                  //   await FirebaseAuth.instance.verifyPhoneNumber(
                  //     // ignore: unnecessary_string_interpolations
                  //     phoneNumber: '${countryCode.text + phone}',
                  //     verificationCompleted:
                  //         (PhoneAuthCredential credential) {},
                  //     verificationFailed: (FirebaseAuthException e) {},
                  //     codeSent: (String verificationId, int? resendToken) {
                  //       AuthScreenPhone.verify = verificationId;
                  //       Navigator.pushNamed(context, AuthScreenOtp.routeName);
                  //     },
                  //     codeAutoRetrievalTimeout: (String verificationId) {},
                  //     //Navigator.pushNamed(context, Location.routeName);
                  //   );
                  // },
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
