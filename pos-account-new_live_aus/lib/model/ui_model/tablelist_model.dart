import 'package:flutter/material.dart';

class TLModel {
  //tablelist model
  final String title;
  final TextEditingController tableCltr;
  final TextInputType textInputType;
  final String hintText;
  final bool isReq;
  final Widget? suffixIcon;

  TLModel({
    required this.title,
    required this.tableCltr,
    this.textInputType = TextInputType.text,
    this.hintText = "",
    this.isReq = false,
    this.suffixIcon,
  });
}
