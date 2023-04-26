import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CheckInternetConnection extends StatefulWidget {
  final Widget child;

  CheckInternetConnection({Key? key, required this.child}) : super(key: key);

  @override
  _CheckInternetConnectionState createState() =>
      _CheckInternetConnectionState();
}

class _CheckInternetConnectionState extends State<CheckInternetConnection> {
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = (result != ConnectivityResult.none);
      });
    });
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _isConnected = (connectivityResult != ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isConnected ? widget.child : _buildNoInternetConnectionWidget();
  }

  Widget _buildNoInternetConnectionWidget() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.signal_wifi_off, size: 80.0),
              const Text(
                'No internet connection',
                style: TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                child: const Text('Try again'),
                onPressed: () async {
                  await checkConnectivity();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
