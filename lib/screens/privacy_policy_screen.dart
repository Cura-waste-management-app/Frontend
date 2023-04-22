import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});
  static const routeName = '/privacy-policy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              overflow: TextOverflow.ellipsis),
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Center(
                child: Icon(
                  Icons.privacy_tip_outlined,
                  size: 70,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "It is important that you understand what information Cura collects, uses and how you can control it. We explain it in detail our Cura's Privacy Policy and you can review the key points below.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Why does Cura collect your data?",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Text(
                "To give you a customized experience, improved services and understand how users use Cura.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Text(
                "Your information and content",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Text(
                "This may include any information you share with us, for example: your saved location or address, your email ID or phone number, and the photos you upload to the Cura App.\nSharing data with others is subject to follow up of the policy associated.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Text(
                "Changes to this policy",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 3),
            const Padding(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Text(
                "We might make changes to this policy.\nWhen we do so, we'll provide you with prominent notice as appropriate under the circumstances.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
