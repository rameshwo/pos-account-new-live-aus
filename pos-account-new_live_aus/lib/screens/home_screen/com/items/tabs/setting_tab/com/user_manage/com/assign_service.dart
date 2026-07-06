import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/providers/profile/user_manage_pro.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../model/home/setting/pos_device/printer_product/printer_prod_detail_res.dart';
import 'custom_select_view.dart';

class AssignEmpService extends StatefulWidget {
  final SRDatum data;
  const AssignEmpService({
    super.key,
    required this.data,
  });

  @override
  State<AssignEmpService> createState() => _PrinterProductSetState();
}

class _PrinterProductSetState extends State<AssignEmpService> {
  late UserManagePro pro;

  @override
  void initState() {
    pro = Provider.of<UserManagePro>(context, listen: false);
    pro.getAssignServiceAddSec(
        employeeId: widget.data.id ?? "", employeeName: widget.data.name ?? "");
    super.initState();
  }

  @override
  void dispose() {
    pro.clearAssignService();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final pro = Provider.of<UserManagePro>(context);
    final catVars = (pro.assignedServiceList?.serviceCategoryVariationList?.any(
                (e) =>
                    e.categoryId?.toLowerCase() ==
                    pro.serviceList?.categoryId?.toLowerCase()) ??
            false)
        ? pro.assignedServiceList?.serviceCategoryVariationList?.firstWhere(
            (e) =>
                e.categoryId?.toLowerCase() ==
                pro.serviceList?.categoryId?.toLowerCase())
        : null;

    return CustomSelectView(
      title: "Assign Service",
      type: "Service",
      topWidget:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Card(
          child: IntrinsicWidth(
            child: SizedBox(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.getW(12), vertical: size.getH(8)),
                child: Row(
                  children: [
                    Text(
                      "Assign the service to the employee ",
                      style: TextStyle(
                        fontSize: size.getS(15),
                        color: Colors.black,
                        fontFamily: kFontFMedium,
                      ),
                    ),
                    Text(
                      "${widget.data.name}",
                      style: TextStyle(
                        fontSize: size.getS(15),
                        color: Colors.black,
                        fontFamily: kFontFBold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
      catServList: pro.serviceList,
      onChangeFilter: () {
        pro.notify;
      },
      onChangeSearch: () {
        pro.notify;
      },
      onTapSubCategory: (index) {
        pro.onTapSubCategory(index);
      },
      loading: pro.loading,
      selectAll: (val) {
        if (catVars != null) {
          if (val == true) {
            for (var product in pro.subCatServList!.productVariations!) {
              if (!catVars.productVariationIds!.contains(product.id)) {
                catVars.productVariationIds!.add(product.id!);
              }
            }
          } else {
            for (var product in pro.subCatServList!.productVariations!) {
              catVars.productVariationIds!.removeWhere(
                  (e) => e.toLowerCase() == product.id?.toLowerCase());
            }
          }
        } else {
          pro.assignedServiceList?.serviceCategoryVariationList ??= [];
          if (val == true) {
            pro.assignedServiceList?.serviceCategoryVariationList!.add(
              ProductCategoryVariationList(
                categoryId: pro.subCatServList!.categoryId,
                productVariationIds: pro.subCatServList?.productVariations
                    ?.map((e) => e.id!)
                    .toList(),
              ),
            );
          } else {
            pro.assignedServiceList?.serviceCategoryVariationList!.clear();
          }
        }
        pro.notify;
      },
      servicesTypesList: pro.servicesTypesList,
      onSave: () {
        pro.addUpdate();
      },
      searchCltr: pro.searchCltr,
      filterCltr: pro.filterCltr,
      selectedCatId: pro.selectedCatId,
      selectedSubCatIndex: pro.selectedSubCatIndex,
      subCatServList: pro.subCatServList,
      selectedList: pro.assignedServiceList?.serviceCategoryVariationList ?? [],
      catVars: catVars,
      onTapCategory: (id) {
        pro.searchCltr.clear();
        pro.selectedSubCatIndex = 0;
        pro.selectedCatId = id;
        pro.getAllServices();
      },
      onTapProduct: (id, isSelected) {
        if (catVars != null) {
          if (isSelected) {
            catVars.productVariationIds?.add(id);
          } else {
            catVars.productVariationIds
                ?.removeWhere((e) => e.toLowerCase() == id.toLowerCase());
          }
        } else {
          pro.assignedServiceList?.serviceCategoryVariationList ??= [];
          pro.assignedServiceList?.serviceCategoryVariationList
              ?.add(ProductCategoryVariationList(
            categoryId: pro.subCatServList!.categoryId,
            productVariationIds: [id],
          ));
        }
        pro.notify;
      },
    );
  }
}
