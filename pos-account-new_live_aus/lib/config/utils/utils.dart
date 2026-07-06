import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imin_cash_drawer/imin_cash_drawer.dart';
import 'package:ntp/ntp.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/text_formatter.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:uuid/uuid.dart';
import '../../constant/constant.dart';

class Utils {
  static Timer? _debounce;

  static void handleSearch({
    required Future<void> Function() callback,
    int millisecond = 1000,
    Function()? dispose,
  }) {
    if (_debounce != null) {
      if (dispose != null) dispose();
      _debounce!.cancel();
    }
    _debounce = Timer(Duration(milliseconds: millisecond), () {
      callback().then((_) {
        if (dispose != null) dispose();
        _debounce!.cancel();
      });
    });
  }

  static void hideKeyBoard() {
    if (WidgetsBinding
            .instance.platformDispatcher.views.first.viewInsets.bottom >
        0.0) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  static String getRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      List.generate(
          length, (index) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  // static String decodeAndFormatData(String? encodedData) {
  //   if (encodedData == null) return "";

  //   try {
  //     // print("Error decoding Base64: $encodedData");
  //     final bytes = base64.decode(encodedData);
  //     return String.fromCharCodes(bytes);
  //   } catch (e) {
  //     // print("Error decoding Base64: $e");
  //     return "";
  //   }
  // }

  static String encodebase64(Object? object) {
    if (object == null) return "";

    try {
      final data = base64Encode(utf8.encode(json.encode(object)));

      return data;
    } catch (e) {
      // print("Error decoding Base64: $e");
      return "";
    }
  }

  static String formatNumber(double number) {
    if (number == number.truncateToDouble()) {
      // If the number is an integer, return it as an integer
      return number.truncate().toString();
    } else {
      // If the number has decimal places, return it with the decimal places
      return number.toStringAsFixed(
          2); // Change '2' to the desired number of decimal places
    }
  }

  static List<String> splitBySpace(
    final String sentence, {
    final int lineLength = 27,
    final String lineSpace = '   ',
  }) {
    final lineLength0 = lineLength;
    final lineSpace0 = lineSpace;

    final int preLineLength = (sentence.length / lineLength0).ceil();
    final int newTextLength =
        sentence.length + (preLineLength - 1) * lineSpace0.length;
    final int newLineLength = (newTextLength / lineLength0).ceil();

    final splitText = <String>[];
    String text = sentence;

    int startIndex = 0;

    do {
      // String _adder = "";

      if (text.length < lineLength0) {
        if (splitText.isNotEmpty) {
          text = lineSpace0 + text;
        }
        // _adder = _text;
        splitText.add(text);
        break;
      } else {
        int endIndex = text.lastIndexOf(' ', lineLength0);

        if (splitText.isNotEmpty) {
          text = lineSpace0 + text;
        } else if (endIndex < 4 &&
            text.split('').indexWhere((char) => char == ' ') < 3) {
          final trimLeft = text.trimLeft();
          if (trimLeft.contains(' ')) {
            final trimIndex = trimLeft.lastIndexOf(' ', lineLength0);
            if (trimIndex > endIndex) {
              endIndex = -1;
            }
          }
        }

        if (endIndex == -1) {
          if (text.length < lineLength0) {
            endIndex = text.length;
          } else {
            endIndex = lineLength0;
          }
        } else if (endIndex != lineLength0) {
          endIndex = text.lastIndexOf(' ', lineLength0);
        }

        startIndex = endIndex + 1;

        // _adder = _text.substring(0, _startIndex);
        splitText.add(text.substring(0, startIndex));

        if (endIndex != text.length) {
          text = text.substring(startIndex);
        }
      }
    } while (splitText.length <= newLineLength);

    final splitText2 = <String>[];
    for (final e in splitText) {
      if (e.trim().isNotEmpty) {
        splitText2.add(e);
      }
    }

    // print(
    //     "${_splitText.length} | $_newLineLength | ${sentence.length} | $_newTextLength");

    return splitText2;
  }

  static String uuid() {
    final uuid = Uuid();
    // Generate a v1 (time-based) id
    return uuid.v1();
  }

  static const platform = MethodChannel('com.example.cashbox');

  static Future<void> openIminDrawer() async {
    try {
      await platform.invokeMethod('openCashBox');
    } catch (_) {
      //
    }

    try {
      final data = await IminCashDrawer.drawerStatus;
      if (data != true) {
        await IminCashDrawer.openDrawer;
      }
    } catch (_) {
      //
    }
  }

  static Future<DateTime?> datePick(
    BuildContext context, {
    DateTime? initDate,
  }) async {
    return await showDatePicker(
        context: context,
        initialDate: initDate ?? DateTime.now(),
        currentDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2050));
  }

  static Future<TimeOfDay?> timePick(BuildContext context) async {
    return await showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  static Future<double> textQty(double quantity) async {
    final textCltr = TextEditingController(text: quantity.toString());
    final data = await showDialog(
        context: CUS_CTX!,
        builder: (context) {
          final size = Ssize(context);

          return SimpleDialog(
            contentPadding: EdgeInsets.symmetric(
                horizontal: size.getH(16), vertical: size.getH(28)),
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TitleTextForm(
                    title: "Quantity",
                    isReq: false,
                    hintText: "0",
                    textCltr: textCltr,
                    textInputType: TextInputType.number,
                    inputFormatters: [NonNegativeTextInputFormatter()],
                    suffix: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close)),
                  ),
                  SizedBox(
                    height: size.getH(12),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.getH(28)),
                    child: Row(
                      children: [
                        Expanded(
                          child: LoadButton(
                            btnColor: Colors.red,
                            btnText: LN.clear,
                            hPad: 12,
                            vPad: 8,
                            onsave: () {
                              textCltr.clear();
                            },
                          ),
                        ),
                        SizedBox(
                          width: size.getW(8),
                        ),
                        Expanded(
                          child: LoadButton(
                            btnText: "Confirm",
                            hPad: 12,
                            vPad: 8,
                            onsave: () {
                              Navigator.pop(context, textCltr.text);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          );
        });
    if (data != null && data is String) {
      return double.tryParse(data) ?? quantity;
    } else {
      return quantity;
    }
  }

  static Future<String> getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  }

  static String convertSeconds(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String result = "";
    if (hours > 0) {
      result += "$hours hour(s) ";
    }
    if (minutes > 0) {
      result += "$minutes minute(s) ";
    }
    if (seconds > 0 || result.isEmpty) {
      result += "$seconds second(s)";
    }

    return result.trim();
  }

  static String convertMinutesToHours(String? estTime, bool isModi) {
    final totalMinutes = int.tryParse(estTime ?? '') ?? 0;
    final hrText = isModi ? 'hr' : 'hour';
    final minText = isModi ? 'min' : 'minute';

    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    return "${hours > 0 ? "$hours $hrText${hours == 1 ? '' : 's'} " : ""}${minutes == 0 ? '' : '$minutes $minText${minutes == 1 ? '' : 's'}'}";
  }

  static String abbreviateNumber(String? data) {
    final value = data.inDouble;
    String format(double val, String suffix) {
      String result = val.roundToNString();
      result = result.endsWith(".00")
          ? result.substring(0, result.length - 3)
          : result;
      return "$result$suffix";
    }

    if (value >= 1e12) {
      return format(value / 1e12, "T");
    } else if (value >= 1e9) {
      return format(value / 1e9, "B");
    } else if (value >= 1e6) {
      return format(value / 1e6, "M");
    } else if (value >= 1e3) {
      return format(value / 1e3, "K");
    } else {
      return data ?? '';
    }
  }

  static String hexCode(Color color) =>
      '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

  static Color colorFromHex(String hexCode) {
    hexCode = hexCode.replaceFirst('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  /// Converts camelCase string into "Title Case" with spaces.
  static String formatCamelCaseKey(String input) {
    final words = input.split("");
    final output = words.map((e) {
      if (e == words[0])
        return e.toUpperCase();
      else if (e == e.toUpperCase())
        return " $e";
      else
        return e;
    }).join("");

    return output;
  }

  static final _player = AudioPlayer();

  // static Future<void> playSound() async {
  //   final _url = //"audio/Rameshor.mp3"; //
  //       "audio/notify.mp3";
  //   await _player.play(AssetSource(_url));
  // }

  static bool _isPlayingAlert = false;

  static Future<void> playAlert() async {
    if (_isPlayingAlert) return;

    _isPlayingAlert = true;

    await _player.setReleaseMode(ReleaseMode.loop);

    await _player.play(
      AssetSource("audio/delay.wav"),
    );
  }

  static Future<void> stopAlert() async {
    _isPlayingAlert = false;

    await _player.stop();
  }

  static Future<DateTime> getUtcTime() async {
    DateTime? _currentTime;
    try {
      final ntpTime = await NTP.now(lookUpAddress: 'time.google.com').timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          throw Exception('NTP timeout');
        },
      );

      _currentTime = ntpTime.toUtc();
    } catch (e) {
      // kPrint("NTP failed: $e");

      // fallback to device UTC time
      _currentTime = DateTime.now().toUtc();
    }

    return _currentTime;
  }

  static Future<void> checkInternetStrength() async {
    final stopwatch = Stopwatch()..start();

    try {
      final result = await InternetAddress.lookup('google.com');
      stopwatch.stop();

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        int ms = stopwatch.elapsedMilliseconds;

        if (ms > 1000) {
          kPrint("$ms ms Weak Internet ⚠️");
        } else {
          kPrint("$ms ms Good Internet ✅");
        }
      }
    } catch (e) {
      kPrint("No Internet ❌");
    }

// Logic:
// < 300 ms → Good
// 300–1000 ms → Moderate
// > 1000 ms → Weak 🚨
  }

  // static Timer? _timer;

  // static Future<void> testFunction({
  //   required Future<dynamic> function,
  //   required Function(dynamic res) setUp,
  // }) async {
  //   // final function = Handler.getAllNewOrdNoti();
  //   if (_timer != null) _timer!.cancel();
  //   final _res = await function.then((_) => _).catchError((e) async {
  //     if (e is String && e == "No Internet Connection") {
  //       // print("no internet");
  //       _timer = Timer.periodic(Duration(seconds: 3), (_) {
  //         print("calling function again...");
  //         testFunction(
  //           function: function,
  //           setUp: setUp,
  //         );
  //       });
  //     } else {
  //       print("done");
  //       if (_timer != null) _timer!.cancel();
  //     }
  //   });

  //   setUp(_res);
  // }
}
