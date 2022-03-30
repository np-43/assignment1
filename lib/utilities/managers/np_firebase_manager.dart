import 'package:assignment1/utilities/general_utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class NPFirebaseManager {

  static NPFirebaseManager? _instance;
  NPFirebaseManager._internal() {
    _instance = this;
  }

  static NPFirebaseManager get shared => _instance ?? NPFirebaseManager._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? verificationID;
  User? user;

  static initFirebase() async {
    await Firebase.initializeApp();
  }

}

extension ExtNPFirebaseManager on NPFirebaseManager {

  verifyPhoneNumber({required String countryCode, required String phoneNumber, required void Function() completion}) {
    String formattedNumber = countryCode + " " + phoneNumber;
    print(formattedNumber);
    _auth.verifyPhoneNumber(
        phoneNumber: formattedNumber,
        timeout: const Duration(seconds: 15),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential){
          print("verfiy completed");
          print(phoneAuthCredential.smsCode ?? "");
          completion();
        },
        verificationFailed: (FirebaseAuthException error) {
          print("verfiy failed");
          print(error.message ?? "");
          completion();
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          print("code sent");
          print(verificationId);
          verificationID = verificationId;
          completion();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("code auto retrieval timeout");
          print(verificationId);
          verificationID = verificationId;
          completion();
        }
    );
  }

  void signInWithPhoneNumber(String otp) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID ?? "",
        smsCode: otp,
      );
      user = (await _auth.signInWithCredential(credential)).user;
      print("UID: ${user?.uid ?? ""}");
    } catch (e) {
      GeneralUtility.shared.showSnackBar("Invalid OTP");
    }
  }

  void signOut() {
    _auth.signOut();
  }

}