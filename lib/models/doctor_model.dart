import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../utilities/extensions/common_extensions.dart';
import '../utilities/extensions/date_extension.dart';
import '../utilities/general_utility.dart';

class DoctorModel {
  int? id;
  String? firstName;
  String? lastName;
  String? profilePic;
  String? profilePicLocal;
  bool? favorite;
  String? primaryContactNo;
  String? rating;
  String? emailAddress;
  String? qualification;
  String? description;
  String? specialization;
  String? languagesKnown;

  DateTime? dob;
  String? bloodGroup;
  String? height;
  String? weight;
  bool isEdited = false;

  DoctorModel({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePic,
    this.profilePicLocal,
    this.favorite,
    this.primaryContactNo,
    this.rating,
    this.emailAddress,
    this.qualification,
    this.description,
    this.specialization,
    this.languagesKnown,
    this.dob,
    this.bloodGroup,
    this.height,
    this.weight,
    this.isEdited = false,
  });

  DoctorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePic = json['profile_pic'];
    profilePicLocal = json['profile_pic_local'];
    favorite = (((json['favorite'] ?? 0) == 1 || json['favorite'] == true) ? true : false);
    primaryContactNo = json['primary_contact_no'];
    rating = json['rating'];
    emailAddress = json['email_address'];
    qualification = json['qualification'];
    description = json['description'];
    specialization = json['specialization'];
    languagesKnown = json['languagesKnown'];
    dob = ExtDateTime.getDateTime(inputString: json['dob'], dateFormat: DateFormat.ddmmmmyyyyDash);
    bloodGroup = json['blood_group'];
    height = json['height'];
    weight = json['weight'];
    isEdited = ((json['is_edited'] ?? 0) == 1 ? true : false);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profile_pic'] = profilePic;
    data['profile_pic_local'] = profilePicLocal;
    data['favorite'] = (favorite == true) ? 1 : 0;
    data['primary_contact_no'] = primaryContactNo;
    data['rating'] = rating;
    data['email_address'] = emailAddress;
    data['qualification'] = qualification;
    data['description'] = description;
    data['specialization'] = specialization;
    data['languagesKnown'] = languagesKnown;
    data['dob'] = dob?.toFormattedString(DateFormat.ddmmmmyyyyDash);
    data['blood_group'] = bloodGroup;
    data['height'] = height;
    data['weight'] = weight;
    data['is_edited'] = (isEdited == true) ? 1 : 0;
    return data;
  }

  DoctorModel copy() {
    print(this.toJson());
    print("Before");
    DoctorModel model = DoctorModel(id: id, firstName: firstName, lastName: lastName, profilePic: profilePic, profilePicLocal: profilePicLocal, favorite: favorite, primaryContactNo: primaryContactNo, rating: rating, emailAddress: emailAddress, qualification: qualification, description: description, specialization: specialization, languagesKnown: languagesKnown, dob: dob, bloodGroup: bloodGroup, height: height, weight: weight, isEdited: isEdited);
    print(model.toJson());
    return model;
  }

}

extension ExtDoctorModel on DoctorModel {

  String get fullName {
    if(!(firstName?.isSpaceEmpty() ?? false) && !(lastName?.isSpaceEmpty() ?? false)) {
      return firstName! + " " + lastName!;
    }
    if(!(firstName?.isSpaceEmpty() ?? false)) {
      return firstName!;
    }
    if(!(lastName?.isSpaceEmpty() ?? false)) {
      return lastName!;
    }
    return "";
  }

  Tuple3<String, String, String>? getSeparatedDOB() {
    if (dob != null) {
      String? date = dob?.toFormattedString(DateFormat.ddmmmmyyyyDash);
      if(date != null) {
        List<String> list = date.split("-");
        return Tuple3<String, String, String>.fromList(list);
      }
    }
    return null;
  }

  Image getImage() {
    if (!(profilePicLocal?.isSpaceEmpty() ?? true)) {
      return GeneralUtility.shared.getBase64Image(base64String: profilePicLocal, fit: BoxFit.fill);
    } else {
      return GeneralUtility.shared.getNetworkImage(url: profilePic, fit: BoxFit.fill);
    }
  }

}