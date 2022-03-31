import 'package:assignment1/base_classes/base_text.dart';
import 'package:assignment1/constants/color_constant.dart';
import 'package:assignment1/models/doctor_model.dart';
import 'package:assignment1/utilities/general_utility.dart';
import 'package:assignment1/utilities/managers/font_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../base_classes/base_button.dart';
import 'package:assignment1/utilities/extensions/common_extensions.dart';

import '../constants/string_constant.dart';

enum PersonalDetailEnum { firstName, lastName, specialization, contactNumber, rating }
extension on PersonalDetailEnum {
  String get displayText {
    switch(this) {
      case PersonalDetailEnum.firstName: return StringConst.firstName;
      case PersonalDetailEnum.lastName: return StringConst.lastName;
      case PersonalDetailEnum.specialization: return StringConst.specialization;
      case PersonalDetailEnum.contactNumber: return StringConst.contactNumber;
      case PersonalDetailEnum.rating: return StringConst.rating;
    }
  }
}

class DoctorDetailPage extends StatefulWidget {

  DoctorModel model;

  DoctorDetailPage(this.model, {Key? key}) : super(key: key);

  @override
  State<DoctorDetailPage> createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConst.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            headerView(),
            bodyView()
          ],
        ),
      ),
    );
  }
}

extension on _DoctorDetailPageState {

  headerView() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: (){
                        GeneralUtility.shared.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, color: ColorConst.accent, size: 28,)
                  ),
                ],
              ),
            ),
            Container(
              height: 110,
              decoration: const BoxDecoration(
                  color: ColorConst.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
              ),
            ),
          ],
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: ColorConst.white, width: 2),
                      borderRadius: BorderRadius.circular(40)
                  ),
                  height: 80,
                  width: 80,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: GeneralUtility.shared.getNetworkImage(url: widget.model.profilePic, fit: BoxFit.fill)
                  ),
                ),
                const SizedBox(height: 10),
                BaseText(text: widget.model.fullName, myFont: MyFont.rcBold, fontSize: 20,),
                const SizedBox(height: 10),
                SizedBox(
                  height: 30,
                  child: BaseMaterialButton(StringConst.editProfile, (){
                  }, buttonColor: ColorConst.buttonBG, verticalPadding: 0, horizontalPadding: 20, fontSize: 17,),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  bodyView() {
    return Expanded(
      child: Container(
        color: ColorConst.bgWhite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              BaseText(text: StringConst.personalDetail, myFont: MyFont.rcBold,),
              const SizedBox(height: 10),
              Column(
                children: PersonalDetailEnum.values.map((e) => personalDetailCellView(e)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

extension on _DoctorDetailPageState {

  Widget personalDetailCellView(PersonalDetailEnum personalDetailEnum) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorConst.white,
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BaseText(text: personalDetailEnum.displayText, color: ColorConst.grey, myFont: MyFont.rcBold, fontSize: 18, textAlignment: TextAlign.left,),
          (personalDetailEnum == PersonalDetailEnum.rating) ?
          RatingBarIndicator(
            rating: getPersonDetail(personalDetailEnum).toDouble() ?? 1,
            itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber,),
            itemCount: 5,
            direction: Axis.horizontal,
            itemSize: 25,
          ) :
          BaseText(text: getPersonDetail(personalDetailEnum), color: ColorConst.black, myFont: MyFont.rMedium, fontSize: 20, textAlignment: TextAlign.left,),
        ],
      ),
    );
  }

  String getPersonDetail(PersonalDetailEnum personalDetailEnum) {
    switch(personalDetailEnum) {
      case PersonalDetailEnum.firstName: return widget.model.firstName ?? "";
      case PersonalDetailEnum.lastName: return widget.model.lastName ?? "";
      case PersonalDetailEnum.specialization: return widget.model.specialization ?? "";
      case PersonalDetailEnum.contactNumber: return widget.model.primaryContactNo ?? "";
      case PersonalDetailEnum.rating: return widget.model.rating ?? "";
      default: return "";
    }
  }

}