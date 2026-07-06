import 'package:flutter/material.dart';

class ToFromData {
  final String id;
  final TextEditingController fromCltr;
  final TextEditingController toCltr;
  final TextEditingController dataCltr;

  ToFromData({
    this.id = "",
    required this.fromCltr,
    required this.toCltr,
    required this.dataCltr,
  });
}

class WeekendModel {
  final String id;
  final TextEditingController titleCltr;
  final TextEditingController valueCltr;
  final String weekDayId;
  bool isEnable;

  WeekendModel({
    this.id = "",
    this.weekDayId = "",
    required this.titleCltr,
    required this.valueCltr,
    this.isEnable = false,
  });
}

class HolidayModel {
  final String id;
  final TextEditingController titleCltr;
  String date;
  final TextEditingController valueCltr;
  bool isEnable;

  HolidayModel({
    this.id = "",
    required this.titleCltr,
    this.date = "",
    required this.valueCltr,
    this.isEnable = false,
  });
}

class OpenWeekModel {
  String weekId;
  String weekName;
  List<OpenHoursModel> openHourList;

  OpenWeekModel({
    required this.weekName,
    required this.weekId,
    required this.openHourList,
  });
}

class OpenHoursModel {
  String id;
  String openTime;
  String closeTime;
  bool isOpen;

  OpenHoursModel({
    this.id = "",
    required this.openTime,
    required this.closeTime,
    this.isOpen = true,
  });
}

class SecondaryEmailModel {
  final String id;
  final TextEditingController emailCltr;
  bool isActive;

  SecondaryEmailModel({
    this.id = "",
    required this.emailCltr,
    this.isActive = true,
  });
}

class StoreChannelModel {
  final String id;
  final String channelId;
  final TextEditingController noteCltr;
  final String name;

  StoreChannelModel({
    this.id = "",
    required this.channelId,
    required this.noteCltr,
    this.name = "",
  });
}

class SocialMediaModel {
  final String id;
  final String socialId;
  final TextEditingController linkCltr;
  final String name;
  bool isActive;

  SocialMediaModel({
    this.id = "",
    required this.socialId,
    required this.linkCltr,
    this.name = "",
    this.isActive = true,
  });
}
