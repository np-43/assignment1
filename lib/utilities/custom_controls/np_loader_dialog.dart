import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:assignment1/utilities/extensions/common_extensions.dart';
import 'package:assignment1/utilities/general_utility.dart';

class NPLoaderDialog extends StatelessWidget {

  final String? message;

  const NPLoaderDialog({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getMainView();
  }

}

extension on NPLoaderDialog {

  _getMainView() {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8)
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SpinKitFadingCircle(color: Colors.black54, size: 40),
                  (message?.isSpaceEmpty() ?? true) ? Container() :
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 10),
                      Text(message ?? "", style: GeneralUtility.shared.getTextStyle(color: Colors.black45, fontSize: 17)),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}