import 'package:flutter/material.dart';

InputDecoration textFormFieldDecoration({String? labelText, String? hintText}) {
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    labelStyle: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic),
    hintStyle: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
  );
}
