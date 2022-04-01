import 'package:assignment1/base_classes/base_text.dart';
import 'package:assignment1/base_classes/base_textfield.dart';
import 'package:assignment1/constants/color_constant.dart';
import 'package:assignment1/constants/image_constant.dart';
import 'package:assignment1/models/doctor_model.dart';
import 'package:assignment1/utilities/general_utility.dart';
import 'package:assignment1/utilities/managers/font_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../base_classes/base_button.dart';
import 'package:assignment1/utilities/extensions/common_extensions.dart';
import 'package:assignment1/utilities/extensions/date_extension.dart';
import '../constants/string_constant.dart';

enum _PersonalDetailEnum { firstName, lastName, specialization, contactNumber, rating }
extension on _PersonalDetailEnum {
  int get value {
    switch(this) {
      case _PersonalDetailEnum.firstName: return 1;
      case _PersonalDetailEnum.lastName: return 2;
      case _PersonalDetailEnum.specialization: return 3;
      case _PersonalDetailEnum.contactNumber: return 4;
      case _PersonalDetailEnum.rating: return 5;
    }
  }
  String get displayText {
    switch(this) {
      case _PersonalDetailEnum.firstName: return StringConst.firstName;
      case _PersonalDetailEnum.lastName: return StringConst.lastName;
      case _PersonalDetailEnum.specialization: return StringConst.specialization;
      case _PersonalDetailEnum.contactNumber: return StringConst.contactNumber;
      case _PersonalDetailEnum.rating: return StringConst.rating;
    }
  }
  bool get isEditable {
    switch(this) {
      case _PersonalDetailEnum.contactNumber: return false;
      default: return true;
    }
  }
}

enum _OtherDetailEnum { day, month, year, bloodGroup, height, weight }
extension on _OtherDetailEnum {
  String get displayText {
    switch(this) {
      case _OtherDetailEnum.day: return StringConst.day;
      case _OtherDetailEnum.month: return StringConst.month;
      case _OtherDetailEnum.year: return StringConst.year;
      case _OtherDetailEnum.bloodGroup: return StringConst.bloodGroup;
      case _OtherDetailEnum.height: return StringConst.height;
      case _OtherDetailEnum.weight: return StringConst.weight;
    }
  }
  String get iconName {
    switch(this) {
      case _OtherDetailEnum.bloodGroup: return ImageConst.icBloodGroup;
      case _OtherDetailEnum.height: return ImageConst.icHeight;
      case _OtherDetailEnum.weight: return ImageConst.icWeight;
      default: return ImageConst.icCalender;
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
  
  bool _isEdit = false;
  bool get isEdit => _isEdit;
  set isEdit(bool value) {
    setState(() {
      _isEdit = value;
    });
  }

  Map<int, TextEditingController> mapController = {};

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _PersonalDetailEnum.values.where((element) => element != _PersonalDetailEnum.rating).forEach((element) {
      mapController[element.value] = TextEditingController(text: getPersonDetail(element));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConst.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            headerView(),
            bodyView(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                color: ColorConst.bgWhite,
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 4/3, mainAxisSpacing: 10, crossAxisSpacing: 10),
                    itemCount: _OtherDetailEnum.values.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (buildContext, index){
                      return otherDetailGridView(_OtherDetailEnum.values[index]);
                    }
                ),
              ),
            )
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
                    isEdit = !isEdit;
                    print(mapController.entries.toList());
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
                children: _PersonalDetailEnum.values.map((e) => personalDetailCellView(e)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

extension on _DoctorDetailPageState {

  Widget personalDetailCellView(_PersonalDetailEnum personalDetailEnum) {
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
          SizedBox(height: 5),
          (personalDetailEnum == _PersonalDetailEnum.rating) ?
          ((isEdit) ? RatingBar.builder(
            itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber,),
            onRatingUpdate: (rating) {
              widget.model.rating = "$rating";
            },
            allowHalfRating: true,
            initialRating: getPersonDetail(personalDetailEnum).toDouble() ?? 1,
            itemCount: 5,
            direction: Axis.horizontal,
            itemSize: 25,
          ) : RatingBarIndicator(
            rating: getPersonDetail(personalDetailEnum).toDouble() ?? 1,
            itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber,),
            itemCount: 5,
            direction: Axis.horizontal,
            itemSize: 25,
          )
          ) :
          ((isEdit) ? SizedBox(
              height: 25,
              child: BaseTextField(
                controller: mapController[personalDetailEnum.value],
                textColor: ColorConst.black,
                borderColor: Colors.transparent,
                myFont: MyFont.rMedium,
                fontSize: 16,
                contentPadding: const EdgeInsets.symmetric(horizontal: 5),
              )
          ) :
          BaseText(text: getPersonDetail(personalDetailEnum), color: ColorConst.black, myFont: MyFont.rMedium, fontSize: 20, textAlignment: TextAlign.left,)),
        ],
      ),
    );
  }

  String getPersonDetail(_PersonalDetailEnum personalDetailEnum) {
    switch(personalDetailEnum) {
      case _PersonalDetailEnum.firstName: return widget.model.firstName ?? "";
      case _PersonalDetailEnum.lastName: return widget.model.lastName ?? "";
      case _PersonalDetailEnum.specialization: return widget.model.specialization ?? "";
      case _PersonalDetailEnum.contactNumber: return widget.model.primaryContactNo ?? "";
      case _PersonalDetailEnum.rating: return widget.model.rating ?? "";
      default: return "";
    }
  }

  Widget otherDetailGridView(_OtherDetailEnum otherDetailEnum) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: handleTapEventForOtherDetailView(otherDetailEnum),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: ColorConst.grey),
            borderRadius: BorderRadius.circular(5),
            color: ColorConst.white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GeneralUtility.shared.getAssetImage(name: otherDetailEnum.iconName, height: 15, fit: BoxFit.fitHeight),
                  const SizedBox(width: 2),
                  BaseText(text: otherDetailEnum.displayText, myFont: MyFont.rcRegular, fontSize: 17)
                ],
              ),
            ),
            const SizedBox(width: 5),
            Expanded(child: BaseText(text: "-", myFont: MyFont.rcBold, fontSize: 15)),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  void Function()? handleTapEventForOtherDetailView(_OtherDetailEnum otherDetailEnum) {
    if(isEdit) {
      if (otherDetailEnum == _OtherDetailEnum.day || otherDetailEnum == _OtherDetailEnum.month || otherDetailEnum == _OtherDetailEnum.year) {
        return (){
          GeneralUtility.shared.showDatePicker(completion: (DateTime? date){
            print(date?.toFormattedString(DateFormat.ddmmyyyyDash));
          });
        };
      }
    }
    return null;
  }

}