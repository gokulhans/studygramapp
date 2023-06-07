import 'package:flutter/material.dart';

Widget addVerticalSpace(double height) {
  return SizedBox(height: height);
}

Widget addHorizontalSpace(double width) {
  return SizedBox(width: width);
}

double calculatePercentageDifference(double oldValue, double newValue) {
  double difference = newValue - oldValue;
  double percentageDifference = (difference / newValue) * 100;
  return percentageDifference;
}

String convertName(String Name) {
  List<String> words = Name.split(' ');
  String abbreviation = '';

  if (words.length > 1) {
    for (String word in words) {
      if (word.isNotEmpty) {
        abbreviation += word[0].toUpperCase();
      }
    }
  } else {
    abbreviation = Name; // Keep the single-word  name unchanged
  }

  return abbreviation;
}
