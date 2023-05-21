import 'package:cura_frontend/constants.dart';
import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});
  static const routeName = '/help-support';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          "Help and Support",
          style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              overflow: TextOverflow.ellipsis),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Center(
              child: Icon(
                Icons.live_help_outlined,
                size: 70,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Contact Information',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'For any inquiries or support, please contact at:',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Email: $supportEmailId',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Phone: $supportPhoneNumber',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Q: How do I update my profile information?',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'A: You can update your profile information by navigating to the "My Profile" tab in the side drawer, click Edit Profile, and make the desired changes.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
