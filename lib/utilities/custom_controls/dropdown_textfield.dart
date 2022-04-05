import 'package:assignment1/utilities/general_utility.dart';
import 'package:flutter/material.dart';
import '../../base_classes/base_text.dart';
import '../../base_classes/base_textfield.dart';
import '../../constants/color_constant.dart';
import '../managers/font_enum.dart';

class DropdownOptionModel {

  late int id;
  late String? value;
  late String name;

  DropdownOptionModel({required this.id, this.value, required this.name});

}

class DropdownTextField extends StatefulWidget {
  final List<DropdownOptionModel>? dataList;
  final TextEditingController controller;
  final double? customWidth;
  final String? Function(String?)? validator;
  final bool isValid;
  final bool? isDense;
  final EdgeInsetsGeometry? contentPadding;
  final MyFont myFont;
  final Color textColor;
  final String hintText;
  final void Function(DropdownOptionModel) onChange;
  final void Function()? onClear;

  const DropdownTextField(
      {Key? key, required this.dataList,
        required this.controller,
        this.customWidth,
        this.validator,
        this.isValid = true,
        this.isDense,
        this.contentPadding,
        this.myFont = MyFont.rRegular,
        this.textColor = ColorConst.black,
        required this.hintText,
        required this.onChange,
        this.onClear}) : super(key: key);

  @override
  _DropdownTextFieldState createState() => _DropdownTextFieldState();
}

class _DropdownTextFieldState extends State<DropdownTextField> {

  bool isDropdownVisible = false;

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  ///__Returns UI for dropdown options.__
  OverlayEntry _createOverlayEntry() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    var size = renderBox!.size;
    return OverlayEntry(
        builder: (context) => Positioned(
          width: widget.customWidth ?? size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 5.0),
            child: Material(
              child: ((widget.dataList?.length ?? 0) > 0) ? Container(
                color: ColorConst.white,
                height: (widget.dataList?.length ?? 0) <= 5 ? ((widget.dataList?.length ?? 0) * 40) : (40 * 5),
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  // color: ColorConst.grey,
                  margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  elevation: 5,
                  child: Scrollbar(
                    // isAlwaysShown: true,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      shrinkWrap: true,
                      children: widget.dataList!.map((element) {
                        return InkResponse(
                          onTap: (){
                            setIsDropdownVisible(false);
                            if (element.id > 0 || element.value != null) {
                              widget.controller.text = element.name;
                              widget.onChange(element);
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                padding: const EdgeInsets.only(left: 0.0, bottom: 5),
                                child: BaseText(text: element.name, color: ColorConst.primary, fontSize: 18, myFont: MyFont.rRegular, letterSpacing: 0, textAlignment: TextAlign.left,),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
            ) : GeneralUtility.shared.getNoDataView()
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child:  BaseTextField(
        myFont: widget.myFont,
        textColor: widget.textColor,
        borderColor: Colors.transparent,
        controller: widget.controller,
        validator: widget.validator,
        isDense: widget.isDense,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        fillColor: Colors.transparent,
        suffixIcon: InkWell(
          child: const Icon(Icons.keyboard_arrow_down_sharp, color: ColorConst.grey, size: 20),
          onTap: (){
            if (widget.controller.text.isEmpty || widget.onClear == null) {
              setIsDropdownVisible(!isDropdownVisible);
            } else {
              widget.controller.text = "";
              widget.onClear!();
            }
          },
        ),
        hintText: widget.hintText,
        readOnly: true,
        onTap: (){
          setIsDropdownVisible(!isDropdownVisible);
        },
      ),
    );
  }

  ///__To change visibility of dropdown.__
  setIsDropdownVisible(bool visible) {
    isDropdownVisible = visible;
    if (isDropdownVisible) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)!.insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
    }
  }

}