import 'package:flutter/material.dart';
import 'package:helbage/shared/color.dart';
import 'package:helbage/shared/styles.dart';

Container fryoTextInput(String hintText,
    {onTap, onChanged, onEditingComplete, onSubmitted, controller, validator}) {
  return Container(
    margin: EdgeInsets.only(top: 13),
    child: TextFormField(
      validator: validator,
      controller: controller,
      onTap: onTap,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      cursorColor: primaryColor,
      style: inputFieldTextStyle,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: inputFieldHintTextStyle,
          focusedBorder: inputFieldFocusedBorderStyle,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: inputFieldDefaultBorderStyle),
    ),
  );
}

Container fryoEmailInput(String hintText,
    {onTap, onChanged, onEditingComplete, onSubmitted, controller, validator}) {
  return Container(
    margin: EdgeInsets.only(top: 13),
    child: TextFormField(
      validator: validator,
      controller: controller,
      onTap: onTap,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      keyboardType: TextInputType.emailAddress,
      cursorColor: primaryColor,
      style: inputFieldTextStyle,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: inputFieldHintTextStyle,
          focusedBorder: inputFieldFocusedBorderStyle,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: inputFieldDefaultBorderStyle),
    ),
  );
}

Container fryoPasswordInput(String hintText,
    {onTap, onChanged, onEditingComplete, onSubmitted, controller, validator}) {
  return Container(
    margin: EdgeInsets.only(top: 13),
    child: TextFormField(
      validator: validator,
      controller: controller,
      onTap: onTap,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      obscureText: true,
      cursorColor: primaryColor,
      style: inputFieldHintPaswordTextStyle,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: inputFieldHintPaswordTextStyle,
          focusedBorder: inputFieldFocusedBorderStyle,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: inputFieldDefaultBorderStyle),
    ),
  );
}
