import 'package:flutter/material.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/ui_model/print_invoice.dart';
import 'package:pos_account/services/printer/com/barcode_qr_print.dart';
import 'package:pos_account/widgets/dashline_widget.dart';
import 'package:screenshot/screenshot.dart';

class Stk {
  static const double _c = 1.4; // 0.8887029288702929;
  static const _iS = 1.6;

  static final screenshotController = ScreenshotController();

  static Future<ImagePrintModel> captureAny({
    required Widget child,
  }) async {
    double _width = 0.0;
    double _height = 0.0;

    final _widget = LayoutBuilder(builder: (context, constr) {
      _width = constr.maxWidth;
      _height = constr.maxHeight;

      // print("${constr.maxHeight} ${constr.maxWidth}");
      return child;
    });

    final _bytes = await screenshotController.captureFromLongWidget(
      _widget,
      pixelRatio: 2,
      delay: Duration(milliseconds: 50),
    );

    return ImagePrintModel(
      // filePath: '',
      staticByte: _bytes,
      width: _width.floor(),
      height: _height.floor(),
    );
  }

  static Future<ImagePrintModel> capture({required PrintInvoice pI}) async {
    double _width = 0.0;
    double _height = 0.0;

    final _widget = LayoutBuilder(builder: (context, constr) {
      _width = constr.maxWidth;
      _height = constr.maxHeight;

      // print("${constr.maxHeight} ${constr.maxWidth}");
      return captureWidget(pI);
    });

    final _bytes = await screenshotController.captureFromLongWidget(
      _widget,
      pixelRatio: 1.5,
      delay: Duration(milliseconds: 500),
    );

    return ImagePrintModel(
      // filePath: '',
      staticByte: _bytes,
      width: _width.floor(),
      height: _height.floor(),
    );
  }

  static Widget captureWidget(PrintInvoice pI) {
    final hasPrice =
        pI.body!.item?.any((e) => e.itemHeader?.body3?.isNotEmpty ?? false) ??
            false;
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      // width: double.infinity,
      width: 560, //384
      child: Column(
        children: [
          if (pI.title != null)
            Text(
              pI.title!,
              style: TextStyle(
                fontSize: 40 * _c,
                color: Colors.black,
                fontFamily: kFontFMedium,
              ),
              textAlign: TextAlign.center,
            ),
          if (pI.subtitle != null)
            Text(
              pI.subtitle!,
              style: TextStyle(
                fontSize: 18 * _c,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          if (pI.subtitleList != null)
            for (final e in pI.subtitleList!)
              Text(
                e.text,
                style: TextStyle(
                  fontSize: _c * (14 + 4 * e.size),
                  color: Colors.black,
                  fontWeight:
                      e.style == PrinterTextStyle.Bold ? FontWeight.bold : null,
                ),
                textAlign: TextAlign.center,
              ),
          SizedBox(
            height: _c * (24),
          ),
          if (pI.body?.header != null)
            for (final e in pI.body!.header!)
              if (e.body1 != null && e.body1!.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        e.title ?? '',
                        style: TextStyle(
                            fontSize: _c * (14 + 4 * e.size),
                            color: Colors.black,
                            fontWeight: e.bold ? FontWeight.bold : null),
                      ),
                    ),
                    if (e.body1 != null)
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            e.body1!,
                            style: TextStyle(
                              fontSize: _c * (18),
                              color: Colors.black,
                              fontWeight:
                                  e.style == StkViewFontStyle.Bold.name ||
                                          e.bold
                                      ? FontWeight.bold
                                      : null,
                              // e.bold ? FontWeight.bold : null,
                              fontStyle: e.style == StkViewFontStyle.Italic.name
                                  ? FontStyle.italic
                                  : null,
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              else
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    e.title ?? '',
                    style: TextStyle(
                      fontSize: _c * (14 + 4 * e.size),
                      color: Colors.black,
                      fontWeight:
                          e.style == StkViewFontStyle.Bold.name || e.bold
                              ? FontWeight.bold
                              : null,
                      // e.bold ? FontWeight.bold : null,
                      fontStyle: e.style == StkViewFontStyle.Italic.name
                          ? FontStyle.italic
                          : null,
                    ),
                  ),
                ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: _c * (8.0)),
            child: HDashDivider(
              dashWidth: 6,
              strokeWidth: 3,
            ),
          ),

          //
          if (pI.body?.item != null)
            for (final a in pI.body!.item!) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "", //  a.itemHeader?.body2 ?? '',
                        style: TextStyle(
                          fontSize: _iS * (22),
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: hasPrice ? 9 : 14,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        a.itemHeader?.title ?? '',
                        style: TextStyle(
                          fontSize: _iS * (22),
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  if (hasPrice)
                    Expanded(
                      flex: 5,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          a.itemHeader?.body3 ?? '',
                          style: TextStyle(
                            fontSize: _iS * (22),
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              // group item
              if (a.groupItem?.isNotEmpty ?? false) ...[
                Text(
                  '===============================================================================',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                for (final c in a.groupItem!) ...[
                  if (c.itemHeader?.title?.isNotEmpty ?? false)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              c.itemHeader?.body2 ?? '',
                              style: TextStyle(
                                fontSize: _iS * (32),
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: hasPrice ? 9 : 14,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              c.itemHeader?.title ?? '',
                              style: TextStyle(
                                fontSize: _iS * (32),
                                color: Colors.black,
                                fontFamily: kFontFMedium,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        if (hasPrice)
                          Expanded(
                            flex: 5,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                c.itemHeader?.body3 ?? '',
                                style: TextStyle(
                                  fontSize: _iS * (32),
                                  color: Colors.black,
                                  fontFamily: kFontFMedium,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  for (final ac in _getBodyData(item: c, hasPrice: hasPrice))
                    ac,
                  Text(
                    '===============================================================================',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
                SizedBox(height: 32)
              ],

              // item body
              if (a.itemBody != null) ...[
                ..._getBodyData(item: a, hasPrice: hasPrice),
                Text(
                  '===============================================================================',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                )
              ],
            ],
          if (pI.body?.itemFooter != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 8,
                  child: Text(
                    pI.body?.itemFooter?.title ?? '',
                    style: TextStyle(
                      fontSize: _c * (24),
                      color: Colors.black,
                      fontFamily: kFontFMedium,
                    ),
                  ),
                ),
                if (pI.body?.itemFooter?.body2?.isNotEmpty ?? false)
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        pI.body?.itemFooter?.body2 ?? '',
                        style: TextStyle(
                          fontSize: _c * (24),
                          color: Colors.black,
                          fontFamily: kFontFMedium,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: _c * (8.0)),
              child: HDashDivider(
                dashWidth: 6,
                strokeWidth: 3,
              ),
            ),
          ],
          if (pI.body?.footer != null)
            for (final e in pI.body!.footer!)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 8,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        e.title ?? '',
                        style: TextStyle(
                          fontSize: _c * (26),
                          fontWeight:
                              e.title == LN.total ? FontWeight.bold : null,
                          color: Colors.black,
                          fontFamily: kFontFMedium,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        e.body1 ?? '',
                        style: TextStyle(
                          fontSize: _c * (26),
                          color: Colors.black,
                          fontWeight:
                              e.title == LN.total ? FontWeight.bold : null,
                          fontFamily: kFontFMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          SizedBox(
            height: _c * (24),
          ),
          if (pI.footerList != null)
            for (final e in pI.footerList!)
              if (e != null)
                Text(
                  e,
                  style: TextStyle(
                    fontSize: e.contains('#') ? 40 * _c : _c * (18),
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }

  static List<Widget> _getBodyData({
    required Item item,
    bool hasPrice = true,
  }) {
    final posColList = <Widget>[];

    for (final b in item.itemBody!) {
      if (b.doubleUpDivider)
        posColList.add(Text(
          '===============================================================================',
          maxLines: 1,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ));

      if (b.itemSpace != null) {
        posColList.add(SizedBox(height: b.itemSpace));
      } else if (b.title?.isNotEmpty ?? false) {
        final double? height = b.size == 1 ? 1.5 : null;
        posColList.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  (b.body2?.trim().isNotEmpty ?? false) ? "${b.body2} X " : "",
                  style: TextStyle(
                    fontSize: _iS *
                        (b.size == 3
                            ? 26
                            : b.size == 2
                                ? 23
                                : 20),
                    color: Colors.black,
                    // fontFamily: kFontFMedium,
                    fontWeight: b.bold ? FontWeight.bold : null,
                    height: height,
                    overflow: TextOverflow.visible,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            Expanded(
              flex: hasPrice ? 9 : 14,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  color:
                      (b.isReverseText ?? false) ? Colors.black : Colors.white,
                  child: Text(
                    (b.title ?? ''),
                    style: TextStyle(
                      fontSize: _iS *
                          (b.size == 6
                              ? 32
                              : b.size == 3
                                  ? 26
                                  : b.size == 2
                                      ? 23
                                      : 20),
                      color: (b.isReverseText ?? false)
                          ? Colors.white
                          : Colors.black,
                      fontWeight: b.bold ? FontWeight.bold : null,
                      decoration: b.underline ? TextDecoration.underline : null,
                      height: height,
                    ),
                  ),
                ),
              ),
            ),
            if (hasPrice)
              Expanded(
                flex: 5,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    b.body3 ?? '',
                    style: TextStyle(
                      fontSize: _iS *
                          (b.size == 3
                              ? 27
                              : b.size == 2
                                  ? 24
                                  : 21),
                      color: Colors.black,
                      fontFamily: kFontFMedium,
                      height: height,
                    ),
                  ),
                ),
              ),
          ],
        ));
      }
    }

    return posColList;
  }
}
