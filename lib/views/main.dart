import 'package:assignment1/utilities/general_utility.dart';
import 'package:assignment1/utilities/managers/database_manager.dart';
import 'package:assignment1/utilities/managers/np_firebase_manager.dart';
import 'package:assignment1/utilities/managers/shared_preference_manager.dart';
import 'package:assignment1/views/doctors_listing_page.dart';
import 'package:assignment1/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:assignment1/utilities/extensions/common_extensions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsManager.initSharedPreference();
  await NPFirebaseManager.initFirebase();
  await DatabaseManager.initDB();
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
      home: ((SharedPrefsManager.shared.getString(spKey: SPKey.uid)?.isSpaceEmpty() ?? true) == true) ? const LoginPage() : const DoctorsListingPage(),
    );
  }
}
