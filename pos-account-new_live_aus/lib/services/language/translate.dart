import 'dart:io';
import 'dart:ui';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/database/db_local_data.dart';
import '../../ln.dart';
import 'lang_model.dart';

class Translate {
  static Future<void> getAppLang() async {
    final lData = await DbLocalData.getLangData();
    LnPro.setLang = lData ?? DEFAULT_LANG_ENG;
    final loginRes = await DbLocalData.getLoginData();
    if (LN.ln == null && (loginRes?.token?.isNotEmpty ?? false)) {
      await translate(
          langCode: PlatformDispatcher.instance.locale.languageCode);
    }
  }

  static Future<bool?> translate({
    required String langCode,
  }) async {
    try {
      final Map<String, dynamic> langData = {};
      final translateLang = await Handler.getTranslatedLang();
      if (translateLang != null &&
          translateLang.any((e) => e.code == langCode)) {
        final langList = translateLang
            .firstWhere((e) => e.code == langCode)
            .languageTranslationList;

        if (langList != null) {
          for (final f in langList) {
            if (f.field != null) {
              langData[f.field!] = f.translated;
            }
          }
        }

        final langModel = LangModel.fromJson(langData);
        langModel.ln = langCode;
        // log(_langModel.ln.toString());
        // log(json.encode(_langModel.toJson()));
        await DbLocalData.localLangUpdate(appStrings: langModel);
        LnPro.setLang = langModel;
        return true;
      }
    } on FormatException catch (_) {
      showToast(LN.invalidResponseFormat);
    } on HttpException catch (_) {
      showToast(LN.somethingWentWrong);
    } catch (e) {
      // print(" language translation error ${e.toString()}");
    }
    return null;
  }
}
