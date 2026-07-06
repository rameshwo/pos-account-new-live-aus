import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/setting/notification/notify_pro.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key});

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  NotifyPro? _notifyPro;

  Future<void> getData() async {
    _notifyPro = Provider.of<NotifyPro>(context, listen: false);
    await _notifyPro?.getData();
  }

  bool _isDisable({String? value}) {
    if (value == null)
      return true;
    else if (value.contains("Email") &&
        GlobalCVP.viewWidget.enableEmailNotification)
      return false;
    else if (value.contains("Push") &&
        GlobalCVP.viewWidget.enablePushNotification)
      return false;
    else if (value.contains("Bell") &&
        GlobalCVP.viewWidget.enableBellNotification)
      return false;
    else
      return true;
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final notifyPro = Provider.of<NotifyPro>(context);
    if (notifyPro.generalLoad && notifyPro.notificationType == null)
      return Loading();
    return Processing(
      loading: notifyPro.generalLoad,
      align: Alignment.topLeft,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.getH(24),
            ),
            if (notifyPro.notificationType?.data != null &&
                notifyPro.notificationType!.data!.isNotEmpty)
              Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: SizedBox(
                    width: size.width / 2.7,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: size.getH(12.0), horizontal: size.getW(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...List.generate(
                              notifyPro.notificationType!.data!.length,
                              (index) => ListTile(
                                    leading: Text(
                                      "${index + 1}.",
                                      style: TextStyle(
                                        fontSize: size.getS(24),
                                        fontFamily: kFontFMedium,
                                        color: Colors.black,
                                      ),
                                    ),
                                    title: Text(
                                      notifyPro.notificationType!.data![index]
                                              .name ??
                                          '',
                                      style: TextStyle(
                                        fontSize: size.getS(24),
                                        fontFamily: kFontFMedium,
                                        color: Colors.black,
                                      ),
                                    ),
                                    trailing: SwitchAdap(
                                      size: size,
                                      value: notifyPro.notificationType!
                                              .data![index].isActive ??
                                          false,
                                      onChanged: _isDisable(
                                              value: notifyPro.notificationType!
                                                  .data![index].name)
                                          ? null
                                          : (val) {
                                              notifyPro.notificationType!
                                                  .data![index].isActive = val;
                                              notifyPro.notify;
                                              notifyPro.addUpdate(
                                                  notifyData: notifyPro
                                                      .notificationType!
                                                      .data![index]);
                                            },
                                    ),
                                  ))
                        ],
                      ),
                    ),
                  ))
            else
              NoItemsSec(
                title: LN.noItemFound,
                size: size,
              )
          ],
        ),
      ),
    );
  }
}
