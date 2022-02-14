import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_shadow.dart';

Widget txtField(
  BuildContext context,
  String title,
  TextEditingController _controller, {
  TextInputType keyboardType = TextInputType.text,
  bool isPassword = false,
  bool hasCustomShadow = true,
  Color bgColor = Colors.white,
  bool hasLabel = false,
  bool hasEye = false,
  LengthLimitingTextInputFormatter? textFieldLimit,
  Function? changeEyeColor,
  bool hasOnTap = false,
  Function? onTap,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(
      vertical: 10.0,
    ),
    width: MediaQuery.of(context).size.width * .9,
    decoration: BoxDecoration(
      boxShadow: (hasCustomShadow == true) ? customShadow : null,
    ),
    child: TextField(
      keyboardType: keyboardType,
      controller: _controller,
      obscureText: !isPassword,
      onTap: hasOnTap ? () => onTap!() : null,
      style: Theme.of(context).textTheme.headline5,
      inputFormatters: [
        (textFieldLimit != null)
            ? textFieldLimit
            : LengthLimitingTextInputFormatter(500),
      ],
      decoration: InputDecoration(
        suffixIcon: hasEye
            ? IconButton(
                onPressed: () => changeEyeColor!(),
                icon: const Icon(Icons.remove_red_eye),
                color: isPassword ? Colors.red : Colors.grey,
              )
            : null,
        floatingLabelBehavior: (hasLabel == true)
            ? FloatingLabelBehavior.auto
            : FloatingLabelBehavior.never,
        labelText: title,
        labelStyle: TextStyle(
            fontSize: 13,
            color: Colors.black.withOpacity(0.3),
            fontWeight: FontWeight.bold),
        hintText: (hasLabel == false) ? title : "",
        hintStyle: TextStyle(
            fontSize: 13,
            color: Colors.black.withOpacity(0.3),
            fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        fillColor: bgColor,
        filled: true,
      ),
    ),
  );
}

Widget smallEntryField(
    BuildContext context, String title, TextEditingController _controller,
    {bool isPassword = false,
    TextInputType keyboardType = TextInputType.phone,
    FocusNode? focusNode,
    FocusNode? nextFocus}) {
  return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width * .15,
      decoration: BoxDecoration(
        boxShadow: customShadow,
      ),
      child: TextField(
        controller: _controller,
        keyboardType: keyboardType,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
        textInputAction: TextInputAction.next,
        focusNode: focusNode,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
      ));
}
