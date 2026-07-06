import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';

class SData<T> {
  final List<T> data;

  SData({required this.data}) : assert(data.length == 9);

  T get(BuildContext context) {
    final type = Responsive.type(context);
    // log(_type.name);
    if (type == DeviceType.MobSmallProt)
      return data[0];
    else if (type == DeviceType.MobSmallLand)
      return data[1];
    else if (type == DeviceType.MobLargeProt)
      return data[2];
    else if (type == DeviceType.MobLargeLand)
      return data[3];
    else if (type == DeviceType.TabletSmallProt)
      return data[4];
    else if (type == DeviceType.TabletSmallLand)
      return data[5];
    else if (type == DeviceType.TabletLargeProt)
      return data[6];
    else if (type == DeviceType.TabletLargeLand)
      return data[7];
    else
      return data[8];
  }
}

class Responsive extends StatelessWidget {
  final Widget? mobile;
  final Widget? mobileLarge;
  final Widget tablet;
  final Widget? destop;
  const Responsive({
    super.key,
    this.mobile,
    this.mobileLarge,
    required this.tablet,
    this.destop,
  });

  static bool isMobile(BuildContext context) => Ssize(context).width <= 500;

  static bool isMobileLarge(BuildContext context) =>
      Ssize(context).width < 768 && Ssize(context).width >= 500;

  static bool isTablet(BuildContext context) =>
      Ssize(context).width <= 1024 && Ssize(context).width >= 768;

  static bool isTabletLarge(BuildContext context) =>
      Ssize(context).width <= 1366 && Ssize(context).width >= 1024;

  static bool isDesktop(BuildContext context) => Ssize(context).width >= 1366;

  static DeviceType type(BuildContext context) {
    final size = Ssize(context);
    if (Ssize(context).width <= 500 && size.isProt) {
      return DeviceType.MobSmallProt;
    } else if (Ssize(context).width < 768 && size.isProt) {
      return DeviceType.MobLargeProt;
    } else if (Ssize(context).width < 1024 && size.isProt) {
      return DeviceType.TabletSmallProt;
    } else if (Ssize(context).width < 1366 && size.isProt) {
      return DeviceType.TabletLargeProt;
    } else if (Ssize(context).width <= 500) {
      return DeviceType.MobSmallLand;
    } else if (Ssize(context).width <= 768) {
      return DeviceType.MobLargeLand;
    } else if (Ssize(context).width <= 1024) {
      return DeviceType.TabletSmallLand;
    } else if (Ssize(context).width <= 1366) {
      return DeviceType.TabletLargeLand;
    } else if (Ssize(context).width > 1366) {
      return DeviceType.Desktop;
    } else {
      return DeviceType.None;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    if (size.width >= 1024 && destop != null) {
      return destop!;
    } else if (size.width >= 700) {
      return tablet;
    } else if (size.width >= 450 && mobileLarge != null) {
      return mobileLarge!;
    } else if (mobile != null) {
      return mobile!;
    } else {
      return Container();
    }
  }
}

enum DeviceType {
  MobSmallLand,
  MobSmallProt,
  MobLargeLand,
  MobLargeProt,
  TabletSmallLand,
  TabletSmallProt,
  TabletLargeLand,
  TabletLargeProt,
  Desktop,
  None,
}
