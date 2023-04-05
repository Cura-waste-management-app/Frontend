import 'package:flutter/material.dart';

class LoadErrorScreen extends StatefulWidget {
  const LoadErrorScreen({Key? key}) : super(key: key);

  @override
  State<LoadErrorScreen> createState() => _LoadErrorScreenState();
}

class _LoadErrorScreenState extends State<LoadErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Unable to Load Data"));
  }
}
