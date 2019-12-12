import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color buttonTextColor;
  final double buttonRadius;
  final double buttonHeight;
  final Widget buttonIcon;
  final VoidCallback onPressed;
  final FontWeight buttonFontWeight;
  final double buttonFontSize;
  final double buttonPaddingsize;

  const SocialLoginButton(
      {Key key,
      this.buttonText: "",
      this.buttonColor: Colors.purple,
      this.buttonTextColor: Colors.white,
      this.buttonRadius: 16,
      this.buttonHeight: 40,
      this.buttonIcon,
      this.onPressed,
      this.buttonFontWeight: FontWeight.w500,
      this.buttonFontSize: 15,
      this.buttonPaddingsize: 10, String butonText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (buttonIcon != null) ...[
              buttonIcon,
              Text(
                buttonText ,
                style: TextStyle(
                    color: buttonTextColor,
                    fontWeight: buttonFontWeight,
                    fontSize: buttonFontSize),
              ),
              Opacity(
                child: buttonIcon,
                opacity: 0,
              )
            ],
             if (buttonIcon == null) ...[
             Container(),
              Text(
                buttonText,
                style: TextStyle(
                    color: buttonTextColor,
                    fontWeight: buttonFontWeight,
                    fontSize: buttonFontSize),
              ),
             Container()
            ]
          ],
        ),
        color: buttonColor,
        padding: EdgeInsets.all(buttonPaddingsize),
        onPressed: onPressed,
      ),
    );
  }
  /**eski Yöntem
   * 
   *   buttonIcon != null ? buttonIcon : Container(),
            Text(
             buttonText !=null ? buttonText : "",
              style: TextStyle(
                  color: buttonTextColor,
                  fontWeight: buttonFontWeight,
                  fontSize: buttonFontSize),
            ),
           buttonIcon != null ?  Opacity(
              child: buttonIcon,
              opacity: 0,
            ):Container(),
   */
}
