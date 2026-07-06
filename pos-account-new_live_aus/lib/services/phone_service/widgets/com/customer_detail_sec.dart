import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/payment/cus_loyal_res.dart';
import 'package:pos_account/providers/menu/cus_history_pro.dart';
import 'package:pos_account/screens/home_screen/com/dialogs/customer/customer_order_history.dart';
import 'package:pos_account/services/phone_service/phone_service.dart';
import 'package:provider/provider.dart';
import 'phone_dia_sec.dart';

class CustomerDetailSection extends StatefulWidget {
  final CusForLoyalityRes? cusData;
  const CustomerDetailSection({super.key, this.cusData});

  static bool _isDiaOpen = false;

  static Future showDia({
    final CusForLoyalityRes? cusData,
  }) async {
    if (_isDiaOpen) return;

    _isDiaOpen = true;
    await showDialog(
        context: CUS_CTX!,
        barrierColor: Colors.black12,
        builder: (_) {
          return CustomerDetailSection(cusData: cusData);
        });
    _isDiaOpen = false;
  }

  @override
  State<CustomerDetailSection> createState() => _CustomerDetailSectionState();
}

class _CustomerDetailSectionState extends State<CustomerDetailSection> {
  @override
  void initState() {
    _getCustomerOrder();
    super.initState();
  }

  late CusHistoryPro _cusHisPro;

  void _getCustomerOrder() {
    _cusHisPro = Provider.of<CusHistoryPro>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cusHisPro.getCusSym();
      _cusHisPro.getOrderData(cusId: widget.cusData?.id);
    });
  }

  @override
  void dispose() async {
    _cusHisPro.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cusPro = Provider.of<CusHistoryPro>(context);
    return SimpleDialog(
      alignment: Alignment.topCenter,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      children: [
        PhoneDiaSection(
          cusData: widget.cusData,
          onPop: () async {
            Navigator.pop(context);
          },
        ),
        // if (widget.cusData?.id != null) ...[
        SizedBox(
          height: 24,
          child: Divider(color: Colors.black54),
        ),
        if (cusPro.customerHistory != null)
          CusOrderHistorySection(
            customerId: widget.cusData!.id,
          ),
        CusOrderHistorySection.newOrderButton(
          context,
          cusData: OrderUtils.convertCusForLoyaltyResToCusData(widget.cusData),
          buttonText: cusPro.isOrderCopied && cusPro.selectedOrderId != null
              ? LN.langModelContinue
              : LN.newOrder,
          pageCltr: PhoneService.pageController,
        ),
        // ]
      ],
    );
  }
}
