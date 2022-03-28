import 'package:flutter/material.dart';
import 'package:assignment1/utilities/extensions/common_extensions.dart';
import 'package:assignment1/utilities/general_utility.dart';

class NPAlertDialog extends StatelessWidget {

  final String? title;
  final String? message;
  final List<AlertAction>? listActions;
  final void Function(AlertAction)? completion;

  const NPAlertDialog({Key? key, this.title, this.message, this.listActions, this.completion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getMainView();
  }

}

extension on NPAlertDialog {

  _getMainView() {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (title?.isSpaceEmpty() ?? true) ?
                  Container() :
                  Column(
                    children: [
                      Text(title!, style: GeneralUtility.shared.getTextStyle(color: Colors.black, fontSize: 17)),
                      const SizedBox(height: 10),
                    ],
                  ),
                  (message?.isSpaceEmpty() ?? true) ?
                  Container() :
                  Column(
                    children: [
                      Text(message!, style: GeneralUtility.shared.getTextStyle(color: Colors.black54)),
                      const SizedBox(height: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ...(listActions ?? [AlertAction.ok]).map((e) {
                        return TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                alignment: Alignment.bottomRight,
                                padding: MaterialStateProperty.all(EdgeInsets.zero)
                            ),
                            onPressed: (){
                              if(completion != null) {
                                completion!(e);
                              }
                            },
                            child: Text(e.displayText, style: e.textStyle)
                        );
                      })
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