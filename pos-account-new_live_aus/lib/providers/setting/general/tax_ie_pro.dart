import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/model/home/setting/general/tax_in_ex/setting_res_2.dart';
import 'package:pos_account/model/home/setting/general/tax_in_ex/tax_in_ex_add_sec.dart';
import 'package:pos_account/model/home/setting/general/tax_in_ex/tax_in_ex_req.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/repository/handler.dart';

class TaxIEPro extends ChangeNotifier {
  static List<String> get _headerList => [
        LN.taxName,
        LN.value,
        LN.taxTypeU,
        "Product Count",
        LN.status,
        LN.defaultText,
        LN.action
      ];
  //tax type

  TaxInExAddSec? taxInExAddSec;
  int? taxTypeIndex;

  SettingResTyp2? _getAllData;
  final _tableList = RTableData(headerList: _headerList);
  bool loading = true;

  TaxInExReq? editData;

  int _page = 1;

  int get getPage => _page;

  set setPage(int val) {
    _page = val;
  }

  var tableData = <TLModel>[];

  void init() {
    _tableList.headerList = _headerList;
    tableData = <TLModel>[
      TLModel(title: LN.taxName, tableCltr: TextEditingController()),
      // TLModel(title: LN.description, tableCltr: TextEditingController()),
      TLModel(
          title: LN.value,
          tableCltr: TextEditingController(),
          textInputType: TextInputType.number)
    ];
  }

  void clear() {
    itemId = "";
    taxTypeIndex = null;
    for (var e in tableData) {
      e.tableCltr.clear();
    }
    searchCltr.clear();
    taxRuleList.clear();
  }

  String itemId = "";

  Future<void> getAddSec() async {
    taxInExAddSec = await Handler.getTaxAddSec();
    notify();
  }

  final searchCltr = TextEditingController();

  Future<void> getData({int page = 1}) async {
    setPage = page;
    _getAllData = await Handler.getAllTaxIE(
        page: page, searchKey: searchCltr.text.toLowerCase());
    if (_getAllData?.data != null) {
      _tableList.tableDataList = [];
      for (var e in _getAllData!.data!) {
        _tableList.tableDataList.add(TableDataList(
          id: e.id!,
          itemList: [
            e.name ?? '',
            e.value ?? '',
            e.taxType ?? '',
            e.productCount?.toString() ?? ''
          ],
          statusList: [
            (e.isActive != null && e.isActive!)
                ? TableStatus.Active
                : TableStatus.Inactive,
            (e.isDefault != null && e.isDefault!)
                ? TableStatus.Active
                : TableStatus.Inactive
          ],
        ));
      }
    }
    loading = false;
    notify();
  }

  SettingResTyp2? get getAllTaxIE => _getAllData;

  RTableData get getTableList => _tableList;

  Future<void> addUpData() async {
    loading = true;
    notify();

    final _data = TaxInExReq(
      id: itemId,
      name: tableData[0].tableCltr.text,
      value: tableData[1].tableCltr.text,
      isActive: getStatus,
      isDefault: getDefault,
    );

    if ((taxInExAddSec?.taxTypes?.isNotEmpty ?? false) &&
        taxTypeIndex != null) {
      _data.taxTypeId = taxInExAddSec!.taxTypes![taxTypeIndex!].id;
    }

    _data.taxRules = [];

    for (final a in taxRuleList) {
      final _ruleData = TaxRule(
        id: a.id,
        name: a.ruleNameCltr.text,
        taxRuleConditions: [],
      );
      for (final b in a.taxConditionSection) {
        _ruleData.taxRuleConditions!.add(TaxRuleCondition(
          id: b.id,
          orderTypeId: b.orderTypeId,
          value: b.value.text,
        ));
      }

      _data.taxRules!.add(_ruleData);
    }

    final isAddSuccess = await Handler.addUpTaxIE(data: _data);

    loading = false;
    notify();

    if (isAddSuccess != null && isAddSuccess && _getAllData!.total != null) {
      clear();
      // if (_getAllData!.total! - (getPage * 10) < 10) {
      //   await getData(page: getPage);
      // }
    }
  }

  Future<void> deleteData({required List<SRDatum> dataList}) async {
    final status = await Handler.deleteTaxIE(dataList: dataList);
    if (status != null && status) {
      for (var e in dataList) {
        getTableList.tableDataList.removeWhere((f) => e.id == f.id);
      }
      notify();
    }
  }

  Future<bool?> getEditData({required String id}) async {
    loading = true;
    notify();

    editData = await Handler.editTaxIE(id: id);
    if (editData == null) return null;

    tableData[0].tableCltr.text = editData?.name ?? '';
    tableData[1].tableCltr.text = editData?.value ?? '';
    itemId = editData!.id ?? "";
    setStatus = editData!.isActive ?? false;
    setDefault = editData!.isDefault ?? false;
    if (taxInExAddSec != null &&
        taxInExAddSec!.taxTypes != null &&
        taxInExAddSec!.taxTypes!.any(
            (e) => e.id?.toLowerCase() == editData!.taxTypeId?.toLowerCase())) {
      taxTypeIndex = taxInExAddSec!.taxTypes!.indexWhere(
          (e) => e.id?.toLowerCase() == editData!.taxTypeId?.toLowerCase());
    } else {
      taxTypeIndex = null;
    }

    if (editData?.taxRules?.isNotEmpty ?? false) {
      taxRuleList.clear();

      for (final a in editData!.taxRules!) {
        addTaxRule(taxRule: a);
      }
    }

    loading = false;
    notify();
    return true;
  }

  int _countSelected = 0;

  int get getSelectedCount => _countSelected;

  set setCount(int val) {
    _countSelected = val;
    notify();
  }

  bool _status = true;

  bool get getStatus => _status;

  set setStatus(bool val) {
    _status = val;
    notify();
  }

  bool _isDefault = true;

  bool get getDefault => _isDefault;

  set setDefault(bool val) {
    _isDefault = val;
    notify();
  }

  final taxRuleList = <TaxRuleSectionModel>[];

  void addTaxRule({TaxRule? taxRule}) {
    taxRuleList.add(TaxRuleSectionModel(
      id: taxRule?.id ?? '',
      ruleNameCltr: TextEditingController(text: taxRule?.name ?? ''),
      taxConditionSection: taxInExAddSec?.orderTypes?.map((e) {
            final _taxRuleCond = (taxRule?.taxRuleConditions?.any((f) =>
                        f.orderTypeId?.toLowerCase() == e.id?.toLowerCase()) ??
                    false)
                ? taxRule?.taxRuleConditions?.firstWhere(
                    (f) => f.orderTypeId?.toLowerCase() == e.id?.toLowerCase())
                : null;
            return TaxConditionSection(
              id: _taxRuleCond?.id ?? "",
              orderTypeId: e.id ?? '',
              orderTypeName: e.name ?? "",
              value: TextEditingController(text: _taxRuleCond?.value),
            );
          }).toList() ??
          [],
    ));
    notify();
  }

  void removeTaxRule(int index) {
    if (taxRuleList.isNotEmpty) {
      taxRuleList.removeAt(index);
      notify();
    }
  }

  void notify() {
    notifyListeners();
  }
}

class TaxRuleSectionModel {
  String id;
  final TextEditingController ruleNameCltr;
  final List<TaxConditionSection> taxConditionSection;

  TaxRuleSectionModel({
    this.id = "",
    required this.ruleNameCltr,
    required this.taxConditionSection,
  });
}

class TaxConditionSection {
  String id;
  final String orderTypeId;
  final String orderTypeName;
  final TextEditingController value;

  TaxConditionSection({
    this.id = "",
    required this.orderTypeName,
    required this.orderTypeId,
    required this.value,
  });
}
