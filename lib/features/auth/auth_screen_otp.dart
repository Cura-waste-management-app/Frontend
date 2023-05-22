import 'package:cura_frontend/features/auth/auth_screen_phone.dart';
import 'package:cura_frontend/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

import '../community/widgets/progress_dialog.dart';

class AuthScreenOtp extends ConsumerStatefulWidget {
  final String verificationId;
  const AuthScreenOtp({Key? key, required this.verificationId})
      : super(key: key);
  static const routeName = 'auth-screen-otp';

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<AuthScreenOtp> createState() => _AuthScreenOtpState();
}

class _AuthScreenOtpState extends ConsumerState<AuthScreenOtp> {
  late ProgressDialog progressDialog;

  void verifyOtp(WidgetRef ref, BuildContext context, String userOTP) {
    ref
        .read(authControllerProvider)
        .verifyOTP(showProgress, context, widget.verificationId, userOTP, ref);

    // Navigator.pushNamed(context,  UserDetails.routeName);
  }

  void showProgress() {
    progressDialog.show();
  }

  @override
  void dispose() {
    progressDialog.dismiss();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    progressDialog = ProgressDialog(context);
  }

  // final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    var code = "";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            color: const Color.fromARGB(255, 78, 85, 79),
            onPressed: () {
              Navigator.pushNamed(context, AuthScreenOtp.routeName);
            },
            icon: const Icon(Icons.arrow_back_sharp)),
      ),
      // ignore: avoid_unnecessary_containers, prefer_const_constructors
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/otp.png',
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
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onChanged: (value) {
                  if (value.length == 6) {
                    code = value;
                  }
                },
                onCompleted: (ctx) {},
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
                    verifyOtp(ref, context, code);
                  }, // () async {
                  //   try {
                  //     PhoneAuthCredential credential =
                  //         PhoneAuthProvider.credential(
                  //             verificationId: AuthScreenPhone.verify,
                  //             smsCode: code);

                  //     // Sign the user in (or link) with the credential
                  //     await auth.signInWithCredential(credential);
                  //     auth.authStateChanges().listen((User? user) {
                  //       if (user != null) {
                  //         prints(user.uid);
                  //       }
                  //     });
                  //     // ignore: use_build_context_synchronously
                  //     Navigator.pushNamedAndRemoveUntil(
                  //         context, Location.routeName, (route) => false);
                  //   } catch (e) {
                  //     // ignore: avoid_print
                  //     prints("wrong otp");
                  //   }
                  // },
                  child: const Text('Verify OTP'),
                ),
              ),
              Row(
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AuthScreenPhone.routeName);
                    },
                    child: const Text(
                      'Edit Phone Number?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
