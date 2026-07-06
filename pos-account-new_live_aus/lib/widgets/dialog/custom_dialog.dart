import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:provider/provider.dart';

import '../../config/size_config.dart';
import '../../constant/constant.dart';
import '../../ln.dart';
import '../../screens/initialize/screen_saver/pin_lock/pin_lock.dart';
import '../input/text_form/text_form_widget.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final double titleSize;
  final Widget content;
  final List<Widget> actions;
  final Color? backgroundColor;
  final ShapeBorder? shape;

  const CustomDialog({
    super.key,
    required this.title,
    this.titleSize = 32,
    required this.content,
    required this.actions,
    this.backgroundColor,
    this.shape,
  });

  static showPermissionErrorDialog({
    required BuildContext context,
    String? title,
    String? message,
    String? okText,
  }) async {
    return showCupertinoDialog(
      barrierLabel: title,
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CustomDialog(
          title: "Permission Denied",
          titleSize: Ssize(context).getS(30),
          content: SizedBox(
            width: Ssize(context).getW(500),
            child: Padding(
              padding: EdgeInsets.all(Ssize(context).getW(16)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: Ssize(context).getS(40),
                  ),
                  SizedBox(width: Ssize(context).getH(16)),
                  Flexible(
                    child: Text(
                      "You do not have permission to delete this item. To delete this item, please switch the User.",
                      style: TextStyle(
                        fontSize: Ssize(context).getS(19),
                        fontFamily: kFontFMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  onPressed: () {
                    Navigator.pop(context);
                    PinLockScreen.show();
                  },
                  child: Text(
                    "Switch User",
                    style: TextStyle(
                      fontSize: Ssize(context).getS(16),
                      color: kSecondaryColor,
                      fontFamily: kFontFMedium,
                    ),
                  ),
                ),
                SizedBox(width: Ssize(context).getW(16)),
                CupertinoButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: Ssize(context).getS(16),
                      color: Colors.red,
                      fontFamily: kFontFMedium,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static Future<void> showNotesDialog({
    required BuildContext context,
    required TextEditingController descCltr,
    required void Function(String) onChangedDesc,
    void Function()? onTapDes,
    String? title,
    String? hintText,
  }) async {
    return showCupertinoDialog(
      barrierLabel: title,
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CustomDialog(
          title: title ?? "",
          content: _buildNotesContent(
            title: title,
            context: context,
            descCltr: descCltr,
            onChangedDesc: onChangedDesc,
            onTapDes: onTapDes,
            hintText: hintText,
          ),
          actions: _buildDefaultActions(
            context: context,
            onOk: () {
              onChangedDesc(descCltr.text);
              Navigator.pop(context);
            },
            onCancel: () {
              descCltr.clear();
              onChangedDesc('');

              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  static Future<void> alert({
    required BuildContext context,
    required String title,
    required String message,
    String? okText,
    void Function()? onOk,
  }) async {
    return showCupertinoDialog(
      barrierLabel: title,
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: Ssize(context).getS(20),
              fontFamily: kFontFMedium,
            ),
          ),
          content: Padding(
            padding: EdgeInsets.all(Ssize(context).getW(16)),
            child: Text(
              message,
              style: TextStyle(
                fontSize: Ssize(context).getS(16),
                fontFamily: kFontFRegular,
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (onOk != null) onOk();
                  },
                  child: Text(
                    okText ?? LN.ok,
                    style: TextStyle(
                      fontSize: Ssize(context).getS(16),
                      color: kSecondaryColor,
                      fontFamily: kFontFMedium,
                    ),
                  ),
                ),
                SizedBox(width: Ssize(context).getW(16)),
              ],
            ),
          ],
        );
      },
    );
  }

  static Future showCustomDialog({
    required BuildContext context,
    required String title,
    final double titleSize = 32,
    required Widget content,
    List<Widget>? actions,
    Color? backgroundColor,
    ShapeBorder? shape,
    Function()? onOk,
    Function()? onCancel,
    bool? setCustomAction = false,
  }) async {
    return showCupertinoDialog(
      barrierLabel: title,
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CustomDialog(
          titleSize: titleSize,
          title: title,
          content: content,
          actions: actions ??
              ((setCustomAction == false)
                  ? []
                  : _buildDefaultActions(
                      context: context,
                      onOk: () {
                        if (onOk != null) {
                          onOk();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      onCancel: () {
                        if (onCancel != null) {
                          onCancel();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    )),
          backgroundColor: backgroundColor,
          shape: shape,
        );
      },
    );
  }

  static Widget _buildNotesContent({
    String? title,
    String? hintText,
    required BuildContext context,
    required TextEditingController descCltr,
    required void Function(String) onChangedDesc,
    void Function()? onTapDes,
  }) {
    final size = Ssize(context);
    final _placeOrder = Provider.of<PlaceOrderPro>(context);

    String _removeItem(String data, String? itemToRemove) {
      if (itemToRemove == null) return data;

      String result = data.replaceAll(itemToRemove.trim(), '');

      // Remove double commas if created
      result = result.replaceAll(RegExp(r',\s*,'), ',');

      // Remove leading comma
      result = result.replaceAll(RegExp(r'^,\s*'), '');

      // Remove trailing comma
      result = result.replaceAll(RegExp(r',\s*$'), '');

      return result.trim();
    }

    return IntrinsicHeight(
      child: SizedBox(
        width: size.getW(500),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              size.getW(16), size.getW(4), size.getW(16), size.getW(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_placeOrder.orderNoteList != null)
                Wrap(
                  children:
                      List.generate(_placeOrder.orderNoteList!.length, (index) {
                    final _isSelected = descCltr.text
                        .contains(_placeOrder.orderNoteList?[index].name ?? '');
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getW(4), vertical: size.getH(4)),
                      child: InkWell(
                        onTap: () {
                          if (_isSelected) {
                            descCltr.text = _removeItem(descCltr.text,
                                _placeOrder.orderNoteList?[index].name);
                          } else {
                            descCltr.text +=
                                "${descCltr.text.isEmpty ? '' : ', '}${_placeOrder.orderNoteList?[index].name}";
                          }

                          _placeOrder.notify;
                          onChangedDesc(descCltr.text);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.getW(18),
                              vertical: size.getH(4)),
                          decoration: BoxDecoration(
                            color: _isSelected ? kUserColor : Colors.white,
                            border: Border.all(
                                color:
                                    _isSelected ? kUserColor : Colors.black54),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _placeOrder.orderNoteList?[index].name ?? '',
                            style: TextStyle(
                              color: _isSelected ? Colors.white : kPrimaryColor,
                              fontSize: size.getH(16),
                              fontFamily: kFontFMedium,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              SizedBox(height: size.getH(8)),
              TextFormWidget(
                maxLines: 5,
                borderRadius: 5,
                hintStyle: TextStyle(
                  fontSize: size.getS(16),
                  color: Colors.black45,
                  fontFamily: kFontFMedium,
                ),
                cltr: descCltr,
                borderColor: Colors.black12,
                hintText: hintText ?? "Enter Note on Item",
                onChanged: (value) {
                  // _placeOrder.notify;
                  // onChangedDesc(value ?? '');
                },
                onTap: onTapDes,
              ),
              SizedBox(height: size.getH(16)),
            ],
          ),
        ),
      ),
    );
  }

  static _buildDefaultActions({
    required BuildContext context,
    required final Function() onOk,
    required final Function() onCancel,
  }) {
    final size = Ssize(context);
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: CupertinoButton(
              onPressed: () {
                onCancel();
              },
              child: Text(
                LN.clear,
                style: TextStyle(
                  fontSize: size.getS(16),
                  color: Colors.red,
                  fontFamily: kFontFMedium,
                ),
              ),
            ),
          ),
          SizedBox(width: size.getW(16)),
          Flexible(
            child: CupertinoButton(
              // sizeStyle: CupertinoButtonSize.medium,
              borderRadius: BorderRadius.circular(5),
              onPressed: () {
                onOk();
              },
              child: Text(
                LN.save,
                style: TextStyle(
                  fontSize: size.getS(16),
                  color: kSecondaryColor,
                  fontFamily: kFontFMedium,
                ),
              ),
            ),
          ),
          SizedBox(width: size.getW(16)),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);

    return SimpleDialog(
      backgroundColor: backgroundColor ?? CupertinoColors.systemBackground,
      shape: shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      titlePadding: EdgeInsets.zero,
      title: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: size.getW(16), vertical: size.getH(10)),
        decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: size.getS(titleSize),
                fontFamily: kFontFMedium,
                color: Colors.white,
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(size.getW(8)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: size.getS(26),
                  color: Colors.red.shade700,
                ),
              ),
            )
          ],
        ),
      ),
      children: [
        content,
        ...actions,
      ],
    );
  }
}
