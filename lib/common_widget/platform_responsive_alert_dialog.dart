import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/common_widget/platform_responsive_widget.dart';

class PlatformResponsiveAlertDialog extends PlatformResponsiveWidget {
  final String title;
  final String content;
  final String mainButtonText;
  final String cancelButtonText;
  final double buttonTextSize;
  final FontWeight buttonTextBold;
  final Color buttonTextColor;

  PlatformResponsiveAlertDialog(
      {@required this.title,
      @required this.content,
      @required this.mainButtonText,
      this.cancelButtonText,
      this.buttonTextSize,
      this.buttonTextBold,
      this.buttonTextColor});

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog(
            context: context, builder: (BuildContext context) => this)
        : await showDialog(
            context: context,
            builder: (BuildContext context) => this,
            barrierDismissible: false);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.green.shade50,
        ),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 1 / 12,
        width: MediaQuery.of(context).size.width,
        child: Text(
          title,
          style: TextStyle(
              color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      content: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 1 / 12,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.green.shade50,
        ),
        child: Text(
          content,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
        ),
      ),
      actions: _settingTheDialogButtons(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _settingTheDialogButtons(context),
    );
  }

  List<Widget> _settingTheDialogButtons(BuildContext context) {
    final allButtons = <Widget>[];
    if (Platform.isIOS) {
      allButtons.add(
        CupertinoButton(
          child: Text(
            mainButtonText,
            style: TextStyle(
                fontWeight: buttonTextBold,
                fontSize: 18,
                color: buttonTextColor),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );

      if (cancelButtonText != null) {
        allButtons.add(
          CupertinoButton(
            child: Text(
              cancelButtonText,
              style: TextStyle(
                  fontWeight: buttonTextBold,
                  fontSize: 18,
                  color: buttonTextColor),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }
    } else {
      allButtons.add(
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(
            mainButtonText,
            style: TextStyle(
                fontWeight: buttonTextBold,
                fontSize: 18,
                color: buttonTextColor),
          ),
        ),
      );
      if (cancelButtonText != null) {
        allButtons.add(FlatButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            cancelButtonText,
            style: TextStyle(
                fontWeight: buttonTextBold,
                fontSize: 18,
                color: buttonTextColor),
          ),
        ));
      }
    }
    return allButtons;
  }
}
