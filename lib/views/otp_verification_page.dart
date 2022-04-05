import 'package:assignment1/constants/color_constant.dart';
import 'package:assignment1/constants/string_constant.dart';
import 'package:assignment1/views/doctors_listing_page.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../base_classes/base_button.dart';
import '../base_classes/base_text.dart';
import '../utilities/general_utility.dart';
import '../utilities/managers/font_enum.dart';
import '../utilities/managers/np_firebase_manager.dart';

class OTPVerificationPage extends StatefulWidget {

  String phone;
  OTPVerificationPage(this.phone, {Key? key}) : super(key: key);

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {

  bool _isAgree = false;

  bool get isAgree => _isAgree;
  set isAgree(bool value) {
    setState(() {
      _isAgree = value;
    });
  }
  String otp = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = GeneralUtility.shared.getScreenSize(context).height;
    return Scaffold(
      backgroundColor: ColorConst.primary,
      resizeToAvoidBottomInset: false,
      body: Container(
        // color: ColorConst.primary,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: (height * 0.2)),
            BaseText(text: StringConst.otpPageTitle, myFont: MyFont.rcBold, color: ColorConst.white,),
            bodyView(),
            BaseMaterialButton("Login", isAgree ? (){
              if(otp.length != 6) {
                GeneralUtility.shared.showSnackBar(StringConst.otpInputValidationMsg);
                return;
              }
              GeneralUtility.shared.showProcessing(isFromInitState: false);
              NPFirebaseManager.shared.signInWithPhoneNumber(otp, (status){
                GeneralUtility.shared.hideProcessing(isFromInitState: false);
                if(status) {
                  GeneralUtility.shared.pushAndRemove(context, const DoctorsListingPage());
                }
              });
            } : null,
            buttonColor: ColorConst.buttonBG,),
            SizedBox(
              height: (height * 0.2),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        isAgree = !isAgree;
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.scale(
                            scale: 1,
                            child: Container(
                              margin: const EdgeInsets.only(right: 5),
                              height: 14,
                              width: 14,
                              child: Checkbox(
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                value: isAgree,
                                onChanged: (value){
                                  isAgree = !isAgree;
                                },
                                activeColor: ColorConst.buttonBG,
                                fillColor: MaterialStateProperty.all(ColorConst.buttonBG),
                                overlayColor: MaterialStateProperty.all(ColorConst.buttonBG),
                              ),
                            ),
                          ),
                          BaseText(text: "${StringConst.agreeTo} ", fontSize: 15, color: ColorConst.white),
                          BaseText(text: "${StringConst.termsOfUse} ", fontSize: 15, color: ColorConst.accent),
                          BaseText(text: "${StringConst.and} ", fontSize: 15, color: ColorConst.white),
                          BaseText(text: StringConst.privacyPolicy, fontSize: 15, color: ColorConst.accent),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on _OTPVerificationPageState {

  bodyView() {
    return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            otpInputView(),
            const SizedBox(height: 20),
            Expanded(child: BaseText(text: "${StringConst.otpDesc} ${widget.phone}", color: ColorConst.white, fontSize: 14, numberOfLines: 2,)),
          ],
        )
    );
  }

  otpInputView() {

    double fieldWidth = ((MediaQuery.of(context).size.width - 40 - 50)/6);

    return Pinput(
      length: 6,
      defaultPinTheme: PinTheme(
        width: fieldWidth,
        height: fieldWidth,
        textStyle: GeneralUtility.shared.getTextStyle(myFont: MyFont.rcBold, fontSize: 30, color: ColorConst.accent),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorConst.primaryDark
        ),
      ),
      validator: (NPFirebaseManager.shared.code == null) ? null : (s) {
        return s == NPFirebaseManager.shared.code! ? null : StringConst.invalidOTP;
      },
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      onCompleted: (pin) => otp = pin,
      androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
    );

  }

}
