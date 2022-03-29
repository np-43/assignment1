import 'package:assignment1/constants/color_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../base_classes/base_button.dart';
import '../base_classes/base_text.dart';
import '../base_classes/base_textfield.dart';
import '../utilities/general_utility.dart';
import '../utilities/managers/font_enum.dart';

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
            BaseText(text: "ENTER VERIFICATION CODE", myFont: MyFont.rcBold, color: ColorConst.white,),
            bodyView(),
            BaseMaterialButton("Login", (){
              if(isAgree != true) {
                GeneralUtility.shared.showSnackBar("Please agree to the Terms Of Use and Privacy Policy.");
                return;
              }
            }),
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
                          BaseText(text: "I agree to the ", fontSize: 15, color: ColorConst.white),
                          BaseText(text: "Terms Of Use ", fontSize: 15, color: ColorConst.accent),
                          BaseText(text: "and ", fontSize: 15, color: ColorConst.white),
                          BaseText(text: "Privacy Policy ", fontSize: 15, color: ColorConst.accent),
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
            const SizedBox(height: 10),
            otpInputView(),
            const SizedBox(height: 10),
            Expanded(child: BaseText(text: "Please enter the verification code that was sent to ${widget.phone}", color: ColorConst.white, fontSize: 14, numberOfLines: 2,)),
            Expanded(child: Container())
          ],
        )
    );
  }

  otpInputView() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container()
          ],
        ),
        Container(height: 1, color: ColorConst.white),
      ],
    );
  }

}
