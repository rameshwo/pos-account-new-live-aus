import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import '../general/common/common_header.dart';
import 'com/email_setting.dart';
import 'com/general_settings.dart';
import 'com/sms_setting.dart';

class NotificationSetting extends StatefulWidget {
  final Function()? onBack;
  const NotificationSetting({super.key, this.onBack});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting>
    with SingleTickerProviderStateMixin {
  final _tabList = [LN.generalSettings, LN.emailSetting, LN.smsSetting];

  TabController? _tabCltr;

  @override
  void initState() {
    _tabCltr = TabController(length: _tabList.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    if (_tabCltr != null) _tabCltr!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonHeader(
          child: Row(
            children: [
              IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: widget.onBack,
                  icon: Icon(Icons.arrow_back)),
              SizedBox(width: size.getW(8)),
              Text(
                LN.notifiSet,
                style: TextStyle(
                  fontSize: size.getS(18),
                  // fontFamily: ,ph
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.getH(8),
        ),
        Expanded(
            child: DefaultTabController(
          length: _tabList.length,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: size.getH(40),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                ),
                child: TabBar(
                  tabAlignment: TabAlignment.start,
                  indicatorWeight: 0,
                  tabs: List.generate(_tabList.length,
                      (index) => _tabWidget(size, title: _tabList[index])),
                  indicatorColor: Colors.transparent,
                  labelColor: Colors.white,
                  controller: _tabCltr,
                  isScrollable: true,
                  indicator: BoxDecoration(
                    color: kPrimaryColor,
                  ),
                  labelStyle: TextStyle(
                    fontSize: size.getS(16),
                    fontFamily: kFontFMedium,
                  ),
                  labelPadding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  unselectedLabelColor: Colors.black,
                ),
              ),
              if (_tabCltr != null)
                Flexible(
                    child: TabBarView(
                        controller: _tabCltr,
                        physics: BouncingScrollPhysics(),
                        children: [
                      GeneralSettings(),
                      EmailSettings(),
                      SMSSetting(),
                    ])),
            ],
          ),
        ))
      ],
    );
  }

  Widget _tabWidget(Ssize size, {String? title}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          vertical: BorderSide(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: size.getW(16),
      ),
      child: Tab(
        iconMargin: EdgeInsets.zero,
        child: Text(
          title ?? '',
        ),
      ),
    );
  }
}
