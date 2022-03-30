import 'package:assignment1/utilities/general_utility.dart';
import 'package:assignment1/utilities/managers/shared_preference_manager.dart';
import 'package:assignment1/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsManager.initSharedPreference();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_){
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navKey,
      home: const LoginPage(),
    );
  }
}
