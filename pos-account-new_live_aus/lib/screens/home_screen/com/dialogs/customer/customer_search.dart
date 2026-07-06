import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/common/cus_list_pro.dart';
import 'package:pos_account/providers/menu/cus_history_pro.dart';
import 'package:pos_account/screens/home_screen/com/dialogs/cus_list_dia.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/paginate_sec.dart';
import 'package:provider/provider.dart';
import 'customer_order_history.dart';

class CustomerSearchDia extends StatefulWidget {
  const CustomerSearchDia({super.key});

  @override
  State<CustomerSearchDia> createState() => _CustomerSearchDiaState();
}

class _CustomerSearchDiaState extends State<CustomerSearchDia> {
  @override
  void dispose() {
    cusHisPro.clear();
    super.dispose();
  }

  late CusHistoryPro cusHisPro;

  Future<void> pagination(int page, {required CusListPro cusListPro}) async {
    cusHisPro.pageLoad = true;
    await cusListPro.getCustomers(
        key: cusListPro.searchCusCltr.text, page: page);
    cusHisPro.pageLoad = false;
    cusHisPro.notify;
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    cusHisPro = Provider.of<CusHistoryPro>(context);
    final cusListPro = Provider.of<CusListPro>(context);
    return Processing(
      loading: cusHisPro.pageLoad,
      child: SizedBox(
        // constraints: BoxConstraints(
        //   maxHeight: size.height / 1.1,
        //   minHeight: size.height / 4,
        // ),
        width: size.width / 1.15,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LN.cusSearch,
                  style: TextStyle(
                    fontSize: size.getS(20),
                    color: Colors.black,
                    fontFamily: kFontFMedium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      cusHisPro.clear();
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      size: size.getS(25),
                    ))
              ],
            ),
            Divider(
              height: 1,
              color: Colors.black87,
              thickness: 0.6,
            ),
            SizedBox(
              height: size.getH(12),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LN.cusName,
                          style: TextStyle(
                            fontSize: size.getS(18),
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: size.getH(4),
                        ),
                        SizedBox(
                          width: size.getW(500),
                          child: TextFormWidget(
                            isReq: false,
                            hPad: 24,
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
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
                                  )
                                else
                                  Icon(
                                    Icons.search,
                                    size: size.getS(32),
                                  ),
                                SizedBox(
                                  width: size.getW(8),
                                ),
                              ],
                            ),
                            borderRadius: 5,
                            cltr: cusListPro.searchCusCltr,
                            hintText: LN.searchCus,
                            onChanged: (p0) {
                              Utils.handleSearch(callback: () async {
                                cusListPro.getCustomers(
                                    key: cusListPro.searchCusCltr.text,
                                    page: 1);
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: size.getH(16),
                        ),
                        CusListTable(
                          cusListPro: cusListPro,
                          selectedCusId: cusListPro.selectedCusId,
                          onTap: (data) {
                            cusListPro.selectedCusId = data.id;
                            cusListPro.notify;
                            cusHisPro.getCusSym().then(
                                (_) => cusHisPro.getOrderData(cusId: data.id));
                          },
                        ),
                        SizedBox(
                          height: size.getH(16),
                        ),
                        Row(
                          children: [
                            PaginateButton(
                              total: cusListPro.cusTotalPage,
                              pageSize: cusListPro.cusPageSize,
                              pageIndex: cusListPro.cusPageIndex,
                              next: () => pagination(
                                  cusListPro.cusPageIndex + 1,
                                  cusListPro: cusListPro),
                              prev: () => pagination(
                                  cusListPro.cusPageIndex - 1,
                                  cusListPro: cusListPro),
                            ),
                            Spacer(),
                            if (cusListPro.selectedCusId != null &&
                                cusListPro.cusDataList.any((e) =>
                                    e.id?.toLowerCase() ==
                                    cusListPro.selectedCusId?.toLowerCase()))
                              CusOrderHistorySection.newOrderButton(
                                context,
                                cusData: cusListPro.cusDataList.firstWhere(
                                    (e) =>
                                        e.id?.toLowerCase() ==
                                        cusListPro.selectedCusId
                                            ?.toLowerCase()),
                                buttonText: "Select Customer",
                                align: Alignment.bottomLeft,
                              ),
                          ],
                        ),
                      ],
                    )),
                SizedBox(
                  width: size.getW(16),
                ),
                Expanded(
                  flex: 9,
                  child: CusOrderHistorySection(
                    customerId: cusListPro.selectedCusId ?? '',
                    cusData: cusListPro.cusDataList.any((e) =>
                            e.id?.toLowerCase() ==
                            cusListPro.selectedCusId?.toLowerCase())
                        ? cusListPro.cusDataList.firstWhere((e) =>
                            e.id?.toLowerCase() ==
                            cusListPro.selectedCusId?.toLowerCase())
                        : null,
                  ),
                )
              ],
            ),
            SizedBox(
              height: size.getH(48),
            ),
          ],
        ),
      ),
    );
  }
}
