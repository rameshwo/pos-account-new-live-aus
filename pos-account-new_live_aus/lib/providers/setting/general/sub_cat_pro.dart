import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/category.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/home/product/product_cat_add.dart';
import 'package:pos_account/model/home/setting/general/category/pro_cat_image.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/model/home/setting/general/sub_cat/all_sub_cat.dart';
import 'package:pos_account/model/home/setting/general/sub_cat/subcat_add_req.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/repository/handler.dart';

import '../../../model/home/setting/general/upload_image_s3_res.dart';
import '../../../services/image/image_service.dart';

class SubCatPro extends ChangeNotifier {
  static List<String> get _headerList =>
      [LN.category, LN.subCategory, LN.sort, LN.status, LN.action];
  void get notify => notifyListeners();
  bool loading = true;

  int? catTypeIndex;
  int? filterTypeIndex;
  String? uploadImageUrl;

  PCatImages? addSection;
  String? imageId;
  String? defaultImageId;

  List<Category>? catList;

  var tableData = <TLModel>[];

  final searchCltr = TextEditingController();

  void init() {
    tableList.headerList = _headerList;
    tableData = <TLModel>[
      TLModel(title: LN.subCatName, tableCltr: TextEditingController()),
      TLModel(
        title: LN.sort,
        tableCltr: TextEditingController(),
        textInputType: TextInputType.number,
        isReq: true,
      ),
      TLModel(title: LN.description, tableCltr: TextEditingController()),
      TLModel(
        title: LN.icon,
        tableCltr: TextEditingController(),
      ),
      TLModel(
        title: LN.slug,
        tableCltr: TextEditingController(),
      ),
      TLModel(
        title: LN.identifier,
        tableCltr: TextEditingController(),
      )
    ];
  }

  Future<void> getAddSec() async {
    final _addSec = await Handler.getSubCatAddSec();
    catList = OrderUtils.getCatList(_addSec?.filterCategories);
    // loading = false;
    notify;
  }

  Future<void> getImageList() async {
    addSection = await Handler.getProdCatsAddSecList();
    if (addSection?.productCategoriesImages != null &&
        addSection!.productCategoriesImages!
            .any((e) => e.isDefaultImage != null && e.isDefaultImage!)) {
      imageId = addSection?.productCategoriesImages!
          .firstWhere((e) => e.isDefaultImage != null && e.isDefaultImage!)
          .id;
      defaultImageId = imageId;
    }
    if (!(addSection?.channels
            ?.any((e) => e.isSelected != null && !e.isSelected!) ??
        false)) {
      for (final e in addSection!.channels!) {
        e.isSelected = false;
      }
    } else {
      for (final e in addSection!.channels!) {
        e.isSelected = true;
      }
    }
    notify;
  }

  int pageIndex = 1;
  final tableList = RTableData(headerList: _headerList);
  AllSubCat? allSubCat;

  Future<void> getData({int page = 1}) async {
    pageIndex = page;
    allSubCat = await Handler.getSubCat(
        page: page, searchKey: searchCltr.text.toLowerCase());
    if (allSubCat?.data != null) {
      tableList.tableDataList = [];
      for (final e in allSubCat!.data!) {
        tableList.tableDataList.add(TableDataList(
          id: e.id ?? '',
          itemList: [
            e.categoryName ?? '',
            e.subCateogryName ?? '',
            "${e.sortOrder}"
          ],
          statusList: [
            (e.isActive ?? false) ? TableStatus.Active : TableStatus.Inactive
          ],
        ));
      }
    }
    loading = false;
    notify;
  }

  void clear() {
    itemId = "";
    isActive = true;
    selectedCatId = null;
    _editData = null;
    for (var e in tableData) {
      e.tableCltr.clear();
    }

    imageId = defaultImageId;
    uploadImageUrl = null;
    if (addSection?.productCategoriesImages != null)
      for (final e in addSection!.productCategoriesImages!) {
        if (e.id == defaultImageId)
          e.isDefaultImage = true;
        else
          e.isDefaultImage = false;
      }
    if (addSection?.filterTypes != null)
      for (final e in addSection!.filterTypes!) {
        e.isSelected = false;
      }
    if (addSection?.channels != null)
      for (final e in addSection!.channels!) {
        e.isSelected = false;
      }
    catTypeIndex = null;
    searchCltr.clear();
  }

  String itemId = '';
  bool isActive = true;

  String? selectedCatId;

  Future<void> addUpData() async {
    String? catTypeId;
    if (catTypeIndex != null &&
        addSection!.categoryTypes != null &&
        addSection!.categoryTypes!.isNotEmpty) {
      catTypeId = addSection!.categoryTypes![catTypeIndex!].id;
    }

    final data = SubCatAddReq(
        id: itemId,
        name: tableData[0].tableCltr.text,
        parentProductCategoryId: selectedCatId,
        sortOrder: int.tryParse(tableData[1].tableCltr.text),
        isActive: isActive,
        description: tableData[2].tableCltr.text,
        icon: tableData[3].tableCltr.text,
        slug: tableData[4].tableCltr.text,
        identifier: tableData[5].tableCltr.text,
        productCategoryImageId: imageId ?? '',
        categoryTypeId: catTypeId,
        imageLink: uploadImageUrl,
        isImageDeleted: uploadImageUrl == null,
        channels: addSection?.channels == null
            ? null
            : addSection!.channels!
                .where((e) => e.isSelected ?? false)
                .map((f) => Channel(
                    id: itemId.isEmpty ? "" : (f.additionalValue ?? ""),
                    channelId: f.id))
                .toList(),
        filterTypes: addSection?.filterTypes == null
            ? null
            : addSection!.filterTypes!
                .where((e) => e.isSelected ?? false)
                .map((f) => FilterType(
                    id: itemId.isEmpty ? "" : (f.additionalValue ?? ""),
                    filterTypeId: f.id,
                    name: f.value))
                .toList());
    loading = true;
    notify;

    if (uploadImageUrl?.isNotEmpty ?? false) {
      if (!(uploadImageUrl?.contains('https') ?? false)) {
        final _compressedFile =
            await ImageService.compressFileFors3(uploadImageUrl!);
        final _imageUploadStatus = await Handler.uploadImageOnUrl(
            contentType: uploadImageS3Res?.contentType,
            url: uploadImageS3Res?.uploadUrl,
            filepath: _compressedFile);

        if (_imageUploadStatus ?? false) {
          data.fileName = uploadImageS3Res?.fileName ?? '';
        }
      } else {
        data.fileName = _editData?.fileName ?? '';
      }
    } else {
      data.fileName = '';
    }

    final status = await Handler.addUpdateSubCat(
      subcat: data,
    );
    // print(_status);
    if ((status ?? false) && allSubCat?.total != null) {
      clear();
      await getData(page: pageIndex);
    }
    loading = false;
    notify;
  }

  Future<void> deleteData({required List<SRDatum> dataList}) async {
    loading = true;
    notify;
    final status = await Handler.deleteSubCat(subCatList: dataList);
    if (status ?? false) {
      for (final e in dataList) {
        if (tableList.tableDataList
            .any((f) => e.id?.toLowerCase() == f.id.toLowerCase()))
          tableList.tableDataList
              .removeWhere((f) => e.id?.toLowerCase() == f.id.toLowerCase());
      }
    }
    loading = false;
    notify;
  }

  int countSelected = 0;

  SubCatAddReq? _editData;

  Future<bool?> editData({String? id}) async {
    if (id == null) return null;
    loading = true;
    notify;

    final res = await Handler.editSubCat(id: id);
    if (res == null) return null;

    _editData = res;

    itemId = id;
    tableData[0].tableCltr.text = res.name ?? '';
    tableData[1].tableCltr.text = '${res.sortOrder ?? ''}';
    tableData[2].tableCltr.text = res.description ?? '';
    isActive = res.isActive ?? false;
    selectedCatId = res.parentProductCategoryId;
    imageId = res.productCategoryImageId;
    uploadImageUrl = res.imageLink;

    if (addSection!.categoryTypes!
        .any((e) => e.id?.toLowerCase() == res.categoryTypeId?.toLowerCase()))
      catTypeIndex = addSection!.categoryTypes!.indexWhere(
          (e) => e.id?.toLowerCase() == res.categoryTypeId?.toLowerCase());
    if (addSection != null && addSection!.productCategoriesImages != null)
      for (final e in addSection!.productCategoriesImages!) {
        if (e.id == imageId) {
          e.isDefaultImage = true;
        } else {
          e.isDefaultImage = false;
        }
      }
    if (addSection?.filterTypes != null && res.filterTypes != null)
      for (final e in res.filterTypes!) {
        if (addSection!.filterTypes!.any((a) => a.id == e.filterTypeId)) {
          addSection!.filterTypes!.firstWhere((a) => a.id == e.filterTypeId)
            ..isSelected = true
            ..additionalValue = e.id;
        }
      }
    if (addSection?.channels != null && res.channels != null)
      for (final e in res.channels!) {
        if (addSection!.channels!
            .any((a) => a.id?.toLowerCase() == e.channelId?.toLowerCase())) {
          addSection!.channels!.firstWhere((a) => a.id == e.channelId)
            ..isSelected = true
            ..additionalValue = e.id;
        }
      }

    loading = false;
    notify;

    return true;
  }

  // upload image

  UploadImageS3Res? uploadImageS3Res;

  Future<void> uploadImage() async {
    uploadImageS3Res = await Handler.uploadUrls3(
      fileName: "ProductCategoriesImages",
      identifier: "sub-category-image",
    );
  }
}
