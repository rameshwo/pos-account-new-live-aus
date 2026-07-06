import 'package:flutter/material.dart';

import '../../../../../../../../config/size_config.dart';
import '../../../../../../../../constant/constant.dart';
import '../../../../../../../../ln.dart';
import '../../../../../../../../model/home/menu/place_order/order_tab/order_tab_req.dart';
import '../../../../../../../../providers/menu/order_tab/order_tab_pro.dart';
import '../../../../../../../../providers/menu/place_order_pro.dart';

class OrderTabItem extends StatelessWidget {
  final OrderTabReq ticket;
  final OrderTabPro tabPro;
  final Ssize size;
  final PlaceOrderPro? placeOrderPro;
  final String? curSym;
  final Function(OrderTabReq)? onTap;
  final Function(OrderTabReq, bool?)? onCheckboxChanged;
  final Function(String?)? onPayPressed;
  final Function(String, OrderTabPro, Ssize)? onEditPressed;

  const OrderTabItem({
    super.key,
    required this.ticket,
    required this.tabPro,
    required this.size,
    this.placeOrderPro,
    required this.onTap,
    this.onCheckboxChanged,
    this.onPayPressed,
    this.onEditPressed,
    this.curSym,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!(ticket);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: placeOrderPro?.orderTabId?.toLowerCase() ==
                  ticket.id?.toLowerCase()
              ? kSecondaryColor.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.getW(16.0), vertical: size.getH(12.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (tabPro.actionTapped) _buildCheckbox(),
              if (tabPro.actionTapped) SizedBox(width: size.getW(12)),
              _buildTicketInfo(),
              _buildTotalItems(),
              _buildCustomerCount(),
              _buildTabLimit(),
              if (!tabPro.actionTapped && !tabPro.isClosedTab)
                _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Checkbox(
          activeColor: kSecondaryColor,
          value: tabPro.selectedTabs?.contains(ticket) ?? false,
          onChanged: (value) {
            if (onCheckboxChanged != null) {
              onCheckboxChanged!(ticket, value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildTicketInfo() {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ticket.tabIdentification ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: size.getS(16))),
          SizedBox(height: size.getH(4)),
          Text('(Tab Limit : ${curSym ?? ""}${ticket.tabLimit})',
              style: TextStyle(color: Colors.black87, fontSize: size.getS(16))),
        ],
      ),
    );
  }

  Widget _buildTotalItems() {
    return Expanded(
      flex: 1,
      child: Text(
        ticket.totalOrderItems?.isNotEmpty ?? false
            ? ticket.totalOrderItems ?? "0"
            : "0",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.getS(16)),
      ),
    );
  }

  Widget _buildCustomerCount() {
    return Expanded(
      flex: 1,
      child: Text(
        ticket.noOfCustomer?.isNotEmpty ?? false
            ? ticket.noOfCustomer ?? "0"
            : "0",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.getS(16)),
      ),
    );
  }

  Widget _buildTabLimit() {
    return Expanded(
      child: Text(
        '${curSym ?? ""}${ticket.totalAmount ?? '0.00'}',
        textAlign: TextAlign.right,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.getS(16)),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Expanded(
      flex: 2,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (ticket.orderId?.isNotEmpty ?? false)
            _buildOrderActionButton(
              LN.pay,
              Colors.green,
              () {
                if (onPayPressed != null) {
                  onPayPressed!(ticket.orderId);
                }
              },
            ),
          const SizedBox(width: 8),
          _buildOrderActionButton(
            LN.edit,
            kSecondaryColor,
            () {
              if (onEditPressed != null) {
                onEditPressed!(ticket.id ?? "", tabPro, size);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderActionButton(String text, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size.getW(80),
        padding: EdgeInsets.symmetric(
            horizontal: size.getW(4), vertical: size.getH(6)),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(text,
            style: TextStyle(color: Colors.white, fontSize: size.getS(16))),
      ),
    );
  }
}
