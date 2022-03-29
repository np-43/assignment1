import 'dart:convert';
import 'package:assignment1/base_classes/base_button.dart';
import 'package:assignment1/base_classes/base_text.dart';
import 'package:assignment1/base_classes/base_textfield.dart';
import 'package:assignment1/constants/color_constant.dart';
import 'package:assignment1/utilities/custom_controls/dropdown_textfield.dart';
import 'package:assignment1/utilities/extensions/common_extensions.dart';
import 'package:assignment1/utilities/general_utility.dart';
import 'package:assignment1/utilities/managers/font_enum.dart';
import 'package:assignment1/views/otp_verification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  List<DropdownOptionModel> countryCodeDropdownData = [];
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prepareCountryCodeDropdownData();
  }

  @override
  Widget build(BuildContext context) {
    double height = GeneralUtility.shared.getScreenSize(context).height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConst.primary,
      body: Container(
        // color: ColorConst.primary,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: (height * 0.2)),
            BaseText(text: "ENTER YOUR MOBILE NUMBER", myFont: MyFont.rcBold, color: ColorConst.white,),
            bodyView(),
            BaseMaterialButton("Continue", (){
              if(phoneNumberController.text.isSpaceEmpty()) {
                GeneralUtility.shared.showSnackBar("Please enter valid phone number.");
              } else {
                GeneralUtility.shared.pushAndRemove(context, OTPVerificationPage(phoneNumberController.text));
              }
            }),
            SizedBox(height: (height * 0.2)),
          ],
        ),
      ),
    );
  }
}

extension on _LoginPageState {

  bodyView() {
    return Expanded(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              mobileNumberView(),
              const SizedBox(height: 10),
              Expanded(child: BaseText(text: "We will send you an SMS with the verification code to this number", color: ColorConst.white, fontSize: 14, numberOfLines: 2,)),
              Expanded(child: Container())
            ],
          ),
        )
    );
  }

  mobileNumberView() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // BaseText(text: "+91"),
            SizedBox(
              width: 65,
              child: DropdownTextField(
                  myFont: MyFont.rcBold,
                  dataList: countryCodeDropdownData,
                  controller: countryCodeController,
                  hintText: "Select Country Code",
                  textColor: ColorConst.buttonBG,
                  onChange: (option){
                    countryCodeController.text = option.value ?? "";
                  }
              ),
            ),
            // const SizedBox(width: 5),
            Expanded(
                child: BaseTextField(
                  controller: phoneNumberController,
                  myFont: MyFont.rcBold,
                  fillColor: Colors.transparent,
                  hintText: "Enter phone number",
                  textInputType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  borderColor: Colors.transparent,
                  textColor: ColorConst.accent,
                  hintTextColor: ColorConst.accent,
                )
            ),
            IconButton(
              splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                iconSize: 20,
                alignment: Alignment.centerRight,
                onPressed: (){
                  phoneNumberController.clear();
                },
                icon: const Icon(Icons.cancel_outlined, color: ColorConst.accent,)
            )
          ],
        ),
        Container(height: 1, color: ColorConst.white),
      ],
    );
  }

}

extension on _LoginPageState {

  prepareCountryCodeDropdownData() async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/jsons/country_code.json");
    final List<dynamic> jsonResult = jsonDecode(data);
    countryCodeDropdownData = jsonResult.map((e) => DropdownOptionModel(id: 0, name: e["dial_code"], value: e["dial_code"])).toList();
    countryCodeDropdownData.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    countryCodeController.text = countryCodeDropdownData.first.value ?? "";
    setState(() {});
  }

}