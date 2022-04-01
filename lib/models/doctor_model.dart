import 'package:tuple/tuple.dart';
import '../utilities/extensions/common_extensions.dart';
import '../utilities/extensions/date_extension.dart';

class DoctorModel {
  int? id;
  String? firstName;
  String? lastName;
  String? profilePic;
  bool? favorite;
  String? primaryContactNo;
  String? rating;
  String? emailAddress;
  String? qualification;
  String? description;
  String? specialization;
  String? languagesKnown;

  DateTime? dob;

  DoctorModel({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePic,
    this.favorite,
    this.primaryContactNo,
    this.rating,
    this.emailAddress,
    this.qualification,
    this.description,
    this.specialization,
    this.languagesKnown,
    this.dob
  });

  DoctorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePic = json['profile_pic'];
    favorite = json['favorite'];
    primaryContactNo = json['primary_contact_no'];
    rating = json['rating'];
    emailAddress = json['email_address'];
    qualification = json['qualification'];
    description = json['description'];
    specialization = json['specialization'];
    languagesKnown = json['languagesKnown'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profile_pic'] = profilePic;
    data['favorite'] = favorite;
    data['primary_contact_no'] = primaryContactNo;
    data['rating'] = rating;
    data['email_address'] = emailAddress;
    data['qualification'] = qualification;
    data['description'] = description;
    data['specialization'] = specialization;
    data['languagesKnown'] = languagesKnown;
    return data;
  }

  DoctorModel copy() {
    DoctorModel model = DoctorModel(id: id, firstName: firstName, lastName: lastName, profilePic: profilePic, favorite: favorite, primaryContactNo: primaryContactNo, rating: rating, emailAddress: emailAddress, qualification: qualification, description: description, specialization: specialization, languagesKnown: languagesKnown, dob: dob);
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

}