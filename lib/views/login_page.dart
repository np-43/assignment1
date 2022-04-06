import 'package:assignment1/base_classes/base_button.dart';
import 'package:assignment1/base_classes/base_text.dart';
import 'package:assignment1/base_classes/base_textfield.dart';
import 'package:assignment1/constants/color_constant.dart';
import 'package:assignment1/constants/string_constant.dart';
import 'package:assignment1/utilities/custom_controls/dropdown_textfield.dart';
import 'package:assignment1/utilities/extensions/common_extensions.dart';
import 'package:assignment1/utilities/general_utility.dart';
import 'package:assignment1/utilities/managers/font_enum.dart';
import 'package:assignment1/views/otp_verification_page.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:assignment1/utilities/managers/np_firebase_manager.dart';

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
            BaseText(text: StringConst.loginTitle, myFont: MyFont.rcBold, color: ColorConst.white,),
            bodyView(),
            BaseMaterialButton(StringConst.continueText, () async {
              if(phoneNumberController.text.isSpaceEmpty()) {
                GeneralUtility.shared.showSnackBar(StringConst.mobileValidationMsg);
              } else {
                GeneralUtility.shared.showProcessing(isFromInitState: false);
                NPFirebaseManager.shared.verifyPhoneNumber(countryCode: countryCodeController.text, phoneNumber: phoneNumberController.text, completion: (status){
                  GeneralUtility.shared.hideProcessing(isFromInitState: false);
                  if(status) {
                    GeneralUtility.shared.pushAndRemove(context, OTPVerificationPage(phoneNumberController.text));
                  }
                });
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            mobileNumberView(),
            const SizedBox(height: 10),
            Expanded(child: BaseText(text: StringConst.numberDesc, color: ColorConst.white, fontSize: 14, numberOfLines: 2,)),
          ],
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
                  customWidth: (GeneralUtility.shared.getScreenSize(context).width * 0.75),
                  hintText: StringConst.countryCodePlaceHolder,
                  textColor: ColorConst.buttonBG,
                  fillColor: Colors.transparent,
                  onChange: (option){
                    countryCodeController.text = option.value ?? "";
                  }
              ),
            ),
            // const SizedBox(width: 5),
            Expanded(
                child: BaseTextField(
                  // maxLength: 10,
                  controller: phoneNumberController,
                  myFont: MyFont.rcBold,
                  fillColor: Colors.transparent,
                  hintText: StringConst.phoneNumberPlaceHolder,
                  textInputType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
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
    await CountryCodes.init();
    List<CountryDetails> list = CountryCodes.countryCodes().where((element) => element != null).map((e) => e!).toList();
    final Locale? deviceLocale = CountryCodes.getDeviceLocale();
    list.sort((a, b) {
      return (a.dialCode ?? "").toLowerCase().compareTo((b.dialCode ?? "").toLowerCase());
    });
    countryCodeDropdownData = list.map((e) => DropdownOptionModel(id: 0, name: ("(${e.dialCode ?? ""}) " + (e.localizedName ?? e.name ?? "")), value: e.dialCode)).toList();
    if(list.where((element) => element.alpha2Code == deviceLocale?.countryCode).toList().isNotEmpty) {
      CountryDetails deviceCountryDetails = list.firstWhere((element) => element.alpha2Code == deviceLocale?.countryCode);
      countryCodeController.text = countryCodeDropdownData.firstWhere((element) => element.name.contains(deviceCountryDetails.name ?? "")).value ?? "";
    } else {
      countryCodeController.text = countryCodeDropdownData.first.value ?? "";
    }
    setState(() {});
  }

}