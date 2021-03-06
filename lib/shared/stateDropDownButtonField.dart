import 'package:flutter/material.dart';
import 'package:helbage/shared/color.dart';
import 'package:helbage/shared/styles.dart';
import 'package:helbage/constant/_constant.dart';

Widget getStateDropDownEnum({onChangeValue, dynamic? value, double? width}) {
  double size = 15;
  List<DropdownMenuItem> stateList = getStateList(size: size);
  return Container(
    height: 55.0,
    width: width ?? 400.0,
    child: DropdownButtonFormField(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(
          enabledBorder: inputFieldDefaultBorderStyle,
          focusedBorder: inputFieldFocusedBorderStyle,
        ),
        hint: Text(
          "State",
          style: TextStyle(fontSize: size),
        ),
        items: stateList,
        onChanged: onChangeValue),
  );
}

List<DropdownMenuItem> getStateList({size}) {
  List<DropdownMenuItem> stateList = new List.empty(growable: true);
  MalaysiaState.values.forEach((element) {
    stateList.add(
      DropdownMenuItem(
        child: Text(element.getString(), style: TextStyle(fontSize: size)),
        value: element.getString(),
      ),
    );
  });

  return stateList;
}
