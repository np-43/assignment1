import 'package:image_picker/image_picker.dart';
import '../managers/font_enum.dart';
import 'package:flutter/material.dart';
import '../../constants/color_constant.dart';
import '../../constants/string_constant.dart';
import '../general_utility.dart';

enum ImagePickType {remove, camera, gallery}

extension ImagePickTypeExt on ImagePickType {

  String get displayText {
    switch (this){
      case ImagePickType.remove:  return StringConst.remove;
      case ImagePickType.camera:  return StringConst.takePhoto;
      case ImagePickType.gallery: return StringConst.chooseFromLibrary;
    }
  }

  TextStyle get textStyle {
    switch(this) {
      case ImagePickType.remove:
        return GeneralUtility.shared.getTextStyle(color: Colors.red, fontSize: 17, myFont: MyFont.rMedium);
      default:
        return GeneralUtility.shared.getTextStyle(color: ColorConst.black, fontSize: 17, myFont: MyFont.rMedium);
    }
  }

}

class NPImagePicker extends StatelessWidget {

  final bool showRemove;
  final void Function(ImagePickType, XFile?)? completion;

  const NPImagePicker({Key? key, this.showRemove = true, this.completion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ...((showRemove == true) ? (ImagePickType.values) : ([ImagePickType.camera, ImagePickType.gallery])).map((e) {
          return getItem(e, context);
        })
      ],
    );
  }

  getItem(ImagePickType imagePickType, BuildContext context) {
    return ListTile(
      title: Text(imagePickType.displayText, style: imagePickType.textStyle, textAlign: TextAlign.center,),
      onTap: () async {
        Navigator.pop(context);
        XFile? image;
        if (imagePickType == ImagePickType.camera) {
          image = await GeneralUtility.shared.imageFromCamera();
        } else if (imagePickType == ImagePickType.gallery) {
          image = await GeneralUtility.shared.imageFromGallery();
        }
        if (completion != null) {
          completion!(imagePickType, image);
        }
      },
    );
  }

}
