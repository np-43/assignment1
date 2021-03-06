import 'package:assignment1/utilities/general_utility.dart';
import 'package:assignment1/utilities/managers/shared_preference_manager.dart';
import 'package:assignment1/views/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../constants/string_constant.dart';

class NPFirebaseManager {

  static NPFirebaseManager? _instance;
  NPFirebaseManager._internal() {
    _instance = this;
  }

  static NPFirebaseManager get shared => _instance ?? NPFirebaseManager._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? verificationID;
  String? code;
  User? user;

  static initFirebase() async {
    await Firebase.initializeApp();
  }

}

extension ExtNPFirebaseManager on NPFirebaseManager {

  verifyPhoneNumber({required String countryCode, required String phoneNumber, required void Function(bool) completion}) {
    String formattedNumber = countryCode + " " + phoneNumber;
    print(formattedNumber);
    _auth.verifyPhoneNumber(
        phoneNumber: formattedNumber,
        timeout: const Duration(seconds: 15),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential){
          print("verfiy completed");
          print(phoneAuthCredential.smsCode ?? "");
          code = phoneAuthCredential.smsCode;
          // completion(true);
        },
        verificationFailed: (FirebaseAuthException error) {
          print("verfiy failed");
          print(error.message ?? "");
          GeneralUtility.shared.showSnackBar(StringConst.mobileValidationMsg);
          completion(false);
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          print("code sent");
          print(verificationId);
          verificationID = verificationId;
          completion(true);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("code auto retrieval timeout");
          print(verificationId);
          verificationID = verificationId;
          // completion(true);
        }
    );
  }

  void signInWithPhoneNumber(String otp, void Function(bool) completion) {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID ?? "",
        smsCode: otp,
      );
      _auth.signInWithCredential(credential).then((value) {
        user = value.user;
        print("UID: ${user?.uid ?? ""}");
        SharedPrefsManager.shared.setString(value: user?.uid ?? "", spKey: SPKey.uid);
        completion(true);
      }).catchError((error){
        GeneralUtility.shared.showSnackBar(StringConst.invalidOTP);
        completion(false);
      });
    } catch (e) {
      GeneralUtility.shared.showSnackBar(StringConst.invalidOTP);
      completion(false);
    }
  }

  void signOut() {
    _auth.signOut();
    SharedPrefsManager.shared.clearAll();
    GeneralUtility.shared.pushAndRemove(navKey.currentContext!, const LoginPage());
  }

}