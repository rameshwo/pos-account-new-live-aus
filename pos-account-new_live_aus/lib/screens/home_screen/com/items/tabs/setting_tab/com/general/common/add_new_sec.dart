import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/switch_adap.dart';

class StatusClass {
  final String activeText;
  final String inActiveText;
  final bool getStatus;
  final Function(bool)? setStatus;
  final bool changeColor;

  StatusClass({
    required this.activeText,
    required this.inActiveText,
    required this.getStatus,
    this.setStatus,
    this.changeColor = true,
  });
}

class AddNewSection extends StatelessWidget {
  final String tableTitle;
  final List<TLModel> tableList;
  final List<StatusClass>? statusClass;
  final Function()? onAdd;
  final Function()? onCancel;
  final Widget? newWidget;
  final Widget? bottomWidget;
  final bool isNew;
  final bool showSaveBtn;
  final String? saveText;
  final double saveBtnWidth;
  final bool showCloseBtn;
  final double? elevation;
  final double newWidHeight;
  final String? statusText;
  const AddNewSection({
    super.key,
    required this.tableTitle,
    required this.tableList,
    this.onAdd,
    this.newWidget,
    this.isNew = true,
    this.statusClass,
    this.onCancel,
    this.showSaveBtn = true,
    this.saveText,
    this.saveBtnWidth = 240,
    this.showCloseBtn = true,
    this.elevation,
    this.newWidHeight = 12,
    this.statusText,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Card(
      elevation: elevation,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.getH(8.0), horizontal: size.getW(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       tableTitle,
              //       style: TextStyle(
              //         fontSize: size.getS(18),
              //         // fontFamily: ,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.black,
              //       ),
              //     ),
              //     if (showCloseBtn)
              //       IconButton(
              //           onPressed: () {
              //             Navigator.pop(context);
              //           },
              //           icon: Icon(Icons.close))
              //   ],
              // ),
              SizedBox(
                height: size.getH(newWidHeight),
              ),

              Wrap(
                spacing: size.getW(size.isProt ? 24 : 24),
                runSpacing: size.getH(16),
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  if (newWidget != null) newWidget!,
                  ...List.generate(
                      tableList.length,
                      (index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.getW(300),
                                child: Row(
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                          text: tableList[index].title,
                                          style: TextStyle(
                                            fontSize: size.getS(16),
                                            color: Colors.black,
                                            fontFamily: kFontFMedium,
                                          ),
                                          children: tableList[index].isReq
                                              ? [
                                                  TextSpan(
                                                    text: " *",
                                                    style: TextStyle(
                                                      fontSize: size.getS(16),
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                ]
                                              : null),
                                    ),
                                    if (tableList[index].suffixIcon !=
                                        null) ...[
                                      Spacer(),
                                      tableList[index].suffixIcon!
                                    ]
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.getH(6),
                              ),
                              SizedBox(
                                width: size.getW(300),
                                child: TextFormWidget(
                                  borderColor: Colors.black54,
                                  borderRadius: 5,
                                  cltr: tableList[index].tableCltr,
                                  hintText: tableList[index].hintText,
                                  textInputType: tableList[index].textInputType,
                                  isReq: tableList[index].isReq,
                                  vPad: 10,
                                ),
                              )
                            ],
                          )),
                  if (statusClass != null && statusClass!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusText ?? LN.status,
                          style: TextStyle(
                            fontSize: size.getS(16),
                            fontFamily: kFontFMedium,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                              statusClass!.length,
                              (index) => Padding(
                                    padding:
                                        EdgeInsets.only(right: size.getW(24)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SwitchAdap(
                                          size: size,
                                          value: statusClass![index].getStatus,
                                          onChanged:
                                              statusClass![index].setStatus,
                                        ),
                                        SizedBox(
                                          width: size.getW(12),
                                        ),
                                        Text(
                                          statusClass![index].getStatus
                                              ? statusClass![index].activeText
                                              : statusClass![index]
                                                  .inActiveText,
                                          style: TextStyle(
                                            fontSize: size.getS(16),
                                            color: !statusClass![index]
                                                        .changeColor ||
                                                    statusClass![index]
                                                        .getStatus
                                                ? kSecondaryColor
                                                : Colors.red.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                        ),
                      ],
                    )
                ],
              ),
              bottomWidget != null ? bottomWidget! : SizedBox.shrink(),
              SizedBox(
                height: size.getH(18),
              ),
              Row(
                children: [
                  LoadButton(
                    onsave: onAdd,
                    loading: onAdd == null,
                    btnText:
                        isNew ? (saveText ?? LN.saveNAddAnother) : LN.update,
                    width: saveBtnWidth,
                  ),
                  // ElevatedButton(
                  //     style: ButtonStyle(
                  //         backgroundColor: WidgetStateProperty.all(
                  //             onAdd == null ? Colors.grey : kSecondaryColor),
                  //         padding: WidgetStateProperty.all(
                  //             EdgeInsets.symmetric(
                  //                 horizontal: size.getW(12),
                  //                 vertical: size.getH(8)))),
                  //     onPressed: onAdd,
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Icon(
                  //           Icons.add,
                  //           color: Colors.white,
                  //           size: size.getS(24),
                  //         ),
                  //         SizedBox(
                  //           width: size.getW(6),
                  //         ),
                  //         Text(
                  //           isNew ? LN.saveNAddAnother : LN.update,
                  //           style: TextStyle(
                  //             fontSize: size.getS(16),
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ],
                  //     )),
                  SizedBox(
                    width: size.getW(12),
                  ),
                  if (!isNew)
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.red.shade700),
                            padding: WidgetStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: size.getW(12),
                                    vertical: size.getH(8)))),
                        onPressed: onCancel,
                        child: Text(
                          LN.cancel,
                          style: TextStyle(
                            fontSize: size.getS(16),
                            color: Colors.white,
                          ),
                        ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
