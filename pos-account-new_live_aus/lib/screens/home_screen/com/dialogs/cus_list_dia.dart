import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/booking/all_customer.dart';
import 'package:pos_account/providers/common/cus_list_pro.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:pos_account/widgets/paginate_sec.dart';
import 'package:provider/provider.dart';

class CustomerList {
  static Future<dynamic> show(BuildContext context) {
    return showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
            backgroundColor: kBackgroundColor,
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            children: [CusListDia()]));
  }
}

class CusListDia extends StatefulWidget {
  final bool isSingleWidget;
  final Function(CusData)? onTap;
  const CusListDia({
    super.key,
    this.isSingleWidget = true,
    this.onTap,
  });

  @override
  State<CusListDia> createState() => _CusListDiaState();

  static String? selectedId;
}

class _CusListDiaState extends State<CusListDia> {
  void pagination(int page, {required CusListPro cusListPro}) {
    cusListPro.getCustomers(key: cusListPro.searchCusCltr.text, page: page);
  }

  @override
  void dispose() {
    CusListDia.selectedId = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);

    return ChangeNotifierProvider<CusListPro>(
      create: (BuildContext context) => CusListPro(),
      child: Consumer<CusListPro>(
        builder: (context, cusListPro, child) {
          return Processing(
              loading: cusListPro.loadingCus,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: size.height / 1.14,
                  minHeight: size.height / 5,
                ),
                width: size.width * 0.7,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.isSingleWidget)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LN.cusList,
                              style: TextStyle(
                                fontSize: size.getS(18),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.close))
                          ],
                        ),
                      SizedBox(
                        height: size.getH(6),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            // width: size.getW(500),
                            child: TextFormWidget(
                              isReq: false,
                              hPad: 24,
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      cusListPro.getCustomers(
                                          key: cusListPro.searchCusCltr.text,
                                          page: 1);
                                    },
                                    child: Icon(
                                      Icons.search,
                                      size: size.getS(32),
                                    ),
                                  ),
                                  if (cusListPro.searchCusCltr.text.isNotEmpty)
                                    InkWell(
                                      onTap: () {
                                        cusListPro.searchCusCltr.clear();
                                        cusListPro.getCustomers(
                                            key: cusListPro.searchCusCltr.text,
                                            page: cusListPro.cusPageIndex);
                                      },
                                      child: Icon(
                                        Icons.close,
                                        size: size.getS(32),
                                      ),
                                    ),
                                  SizedBox(
                                    width: size.getW(8),
                                  ),
                                ],
                              ),
                              borderRadius: 5,
                              borderColor: Colors.black12,
                              cltr: cusListPro.searchCusCltr,
                              hintText: LN.search,
                              onChanged: (p0) {
                                if (cusListPro.searchCusCltr.text.isNotEmpty) {
                                  Utils.handleSearch(callback: () async {
                                    cusListPro.getCustomers(
                                        key: cusListPro.searchCusCltr.text,
                                        page: 1);
                                  });
                                }
                              },
                              onSubmitted: (p0) {
                                cusListPro.getCustomers(
                                    key: cusListPro.searchCusCltr.text,
                                    page: 1);
                              },
                            ),
                          ),
                          SizedBox(
                            width: size.getW(24),
                          ),
                          PaginateButton(
                            total: cusListPro.cusTotalPage,
                            pageSize: cusListPro.cusPageSize,
                            pageIndex: cusListPro.cusPageIndex,
                            next: () => pagination(cusListPro.cusPageIndex + 1,
                                cusListPro: cusListPro),
                            prev: () => pagination(cusListPro.cusPageIndex - 1,
                                cusListPro: cusListPro),
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: size.getH(12),
                      // ),
                      if (cusListPro.cusDataList.isEmpty &&
                          !cusListPro.loadingCus)
                        NoItemsSec(size: size, title: "No Customer Found")
                      else
                        CusListTable(
                          cusListPro: cusListPro,
                          onTap: widget.onTap != null
                              ? (data) {
                                  // if (CusListDia.selectedId == null)
                                  CusListDia.selectedId = data.id;
                                  // else
                                  // CusListDia.selectedId = null;
                                  widget.onTap!(data);
                                }
                              : (data) {
                                  Navigator.of(context).pop(data);
                                },
                          selectedCusId: CusListDia.selectedId,
                        ),
                      SizedBox(
                        height: size.getH(24),
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}

class CusListTable extends StatelessWidget {
  final CusListPro cusListPro;
  final Function(CusData)? onTap;
  final String? selectedCusId;

  const CusListTable(
      {required this.cusListPro, this.onTap, this.selectedCusId, super.key});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Table(
                columnWidths: {
                  0: FlexColumnWidth(2.5),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(1.7),
                },
                border: TableBorder.all(
                  width: 0.7,
                  color: Colors.black12,
                ),
                children: [
                  TableRow(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                            color: Colors.black12,
                          ),
                          color: Colors.grey[200]),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.getH(18),
                              horizontal: size.getW(8)),
                          child: Text(
                            LN.name,
                            style: TextStyle(
                              fontSize: size.getS(16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.getH(18),
                              horizontal: size.getW(8)),
                          child: Text(
                            LN.email,
                            style: TextStyle(
                              fontSize: size.getS(16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.getH(18),
                              horizontal: size.getW(8)),
                          child: Text(
                            "Phone No.",
                            style: TextStyle(
                              fontSize: size.getS(16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ]),
                ],
              ),
              Table(
                columnWidths: {
                  0: FlexColumnWidth(2.5),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(1.7),
                },
                border: TableBorder.all(
                  width: 0.7,
                  color: Colors.black12,
                ),
                children: [
                  if (cusListPro.cusDataList.isNotEmpty)
                    ...List.generate(cusListPro.cusDataList.length, (index) {
                      bool isSelected =
                          cusListPro.cusDataList[index].id == selectedCusId;
                      return TableRow(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: isSelected ? Colors.white : Colors.black12,
                            ),
                            color: isSelected ? kSecondaryColor : null,
                          ),
                          children: [
                            TableRowInkWell(
                              onTap: onTap == null
                                  ? null
                                  : () => onTap!(cusListPro.cusDataList[index]),
                              child: Padding(
                                padding: EdgeInsets.all(size.getW(10)),
                                child: Text(
                                  cusListPro.cusDataList[index].name ?? '',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: size.getS(16),
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            TableRowInkWell(
                              onTap: onTap == null
                                  ? null
                                  : () => onTap!(cusListPro.cusDataList[index]),
                              child: Padding(
                                padding: EdgeInsets.all(size.getW(10)),
                                child: Text(
                                  cusListPro.cusDataList[index].email ?? '',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: size.getS(16),
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            TableRowInkWell(
                              onTap: onTap == null
                                  ? null
                                  : () => onTap!(cusListPro.cusDataList[index]),
                              child: Padding(
                                padding: EdgeInsets.all(size.getW(10)),
                                child: Text(
                                  cusListPro.cusDataList[index].phoneNumber ??
                                      '',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: size.getS(16),
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            )
                          ]);
                    }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
