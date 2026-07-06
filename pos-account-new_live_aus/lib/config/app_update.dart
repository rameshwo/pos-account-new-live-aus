import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_in_store_app_version_checker/flutter_in_store_app_version_checker.dart';
// import 'package:in_app_update/in_app_update.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:pos_account/ln.dart';
import 'package:url_launcher/url_launcher.dart';
import 'size_config.dart';

class AppUpdate {
  static void checkUpdate({bool isSandBox = false}) {
    if (!isSandBox) _checkVersion();
    // if (Platform.isAndroid) {
    //   _androidUpdate();
    // } else if (Platform.isIOS) {
    //   _iosUpdate();
    // }
  }

  // static void _androidUpdate() {
  //   InAppUpdate.checkForUpdate().then((info) async {
  //     if (info.updateAvailability == UpdateAvailability.updateAvailable) {
  //       if (info.immediateUpdateAllowed) {
  //         InAppUpdate.performImmediateUpdate().then((_val) {
  //           if (_val == AppUpdateResult.success) {
  //             showToast("${Strings.APP_NAME} is updated successfully");
  //           } else if (_val == AppUpdateResult.userDeniedUpdate) {
  //             // _androidUpdate();
  //           }
  //         }).catchError((e) {
  //           showToast("Failed to update an app");
  //         });
  //       } else {
  //         InAppUpdate.startFlexibleUpdate().then((_val) {
  //           if (_val == AppUpdateResult.success) {
  //             InAppUpdate.completeFlexibleUpdate();
  //           } else if (_val == AppUpdateResult.userDeniedUpdate) {
  //             // _androidUpdate();
  //           }
  //         }).catchError((e) {
  //           // log("Flexible update error: $e");
  //           showToast("Failed to update an app");
  //         });
  //       }
  //     }
  //   }).catchError((e) {
  //     // log("In app update error: $e");
  //     showToast("Failed to check updates");
  //   });
  // }

  // static void _iosUpdate() {}

  // static Future<bool> isImmediateUpdateOnPlayStore(String appId) async {
  //   final url =
  //       'https://play.google.com/store/apps/details?id=$appId&hl=en_US&gl=US';
  //   final response = await http.get(Uri.parse(url));

  //   if (response.statusCode == 200) {
  //     final html = response.body;
  //     const pattern =
  //         '<div class="lXlx5">Updated on</div><div class="xg1aie">(.+?)</div>';

  //     final regex = RegExp(pattern);
  //     final match = regex.firstMatch(html);
  //     if (match != null) {
  //       final dateString = match.group(1);
  //       if (dateString != null) {
  //         final date = DateFormat("MMM dd, yyyy").parse(dateString);
  //         if (DateTime.now().difference(date).inDays.abs() >= 7) {
  //           return true;
  //         }
  //       }
  //     }
  //   }
  //   return false;
  // }

  // static NewVersionPlus get newVersion =>
  //     NewVersionPlus(androidId: Strings.appIdPlayStore);

  static final _checker =
      InStoreAppVersionChecker(appId: Strings.appIdPlayStore);

  static _checkVersion() async {
    try {
      final status = await _checker.checkUpdate();
      // kPrint(
      //     "status: ${status.canUpdate} ${status.appURL} ${status.currentVersion} ${status.newVersion}");
      // double _localV =
      //     double.parse('0.' + status.localVersion.replaceAll('.', ''));
      // double _storeV =
      //     double.parse('0.' + status.storeVersion.replaceAll('.', ''));
      // print(
      //     "------------------local: $_localV store: $_storeV -----------------");
      // isUptoDate(x, y);
      if (status.canUpdate &&
          // _localV < _storeV &&
          CUS_CTX != null) {
        // Provider.of<AuthProvider>(CUS_CTX!, listen: false).logOut();
        showDialog(
            context: CUS_CTX!,
            barrierColor: Color(0xFFE3EAFD),
            barrierDismissible: false,
            builder: (_) {
              return AppUpdateUI(onUpdate: () async {
                launchUrl(
                  Uri.parse(
                      "https://play.google.com/store/apps/details?id=${Strings.appIdPlayStore}"),
                  mode: LaunchMode.externalApplication,
                ).catchError((error, stackTrace) {
                  showToast(
                      "Please update ${Strings.APP_NAME} app from Play store");
                  return false;
                });
              });
            });
      }
    } on SocketException catch (_) {
      showToast("No Internet Connection");
    } catch (e) {
      // print("----------app update error: $e");
      // showToast("Please update ${Strings.APP_NAME} app from Play store");
    }
  }
}

class AppUpdateUI extends StatelessWidget {
  final Function()? onUpdate;
  const AppUpdateUI({
    super.key,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                kPrimaryColor.withAlpha(50),
                kSecondaryColor.withAlpha(50),
              ],
            ),
          ),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(size.getS(20)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              width: size.getW(500),
              height: size.getH(500),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/png/splash_logo.png', // replace with your rocket image asset
                      height: size.getH(100),
                    ),
                    SizedBox(height: size.getH(40)),
                    Text(
                      'App Update Required!',
                      style: TextStyle(
                        fontSize: size.getS(30),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: size.getH(20)),
                    Text(
                      'We regularly update our app and add new features to give you a better point of sale system experience.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: size.getS(19),
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: size.getH(48)),
                    ElevatedButton(
                      onPressed: onUpdate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSecondaryColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: size.getW(80), vertical: size.getH(20)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Update App',
                        style: TextStyle(
                          fontSize: size.getS(22),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
