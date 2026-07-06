import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/home/product/product_cat_add.dart';
import 'package:pos_account/model/home/setting/general/category/pro_cat_image.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/repository/handler.dart';

import '../../../model/home/setting/general/upload_image_s3_res.dart';
import '../../../services/image/image_service.dart';

class ProductCatPro extends ChangeNotifier {
  static List<String> get _headerList =>
      [LN.name, LN.catType, LN.sortOrder, LN.status, LN.action];
  //product category
  AllProductCat? _getAllData;
  final _tableList = RTableData(headerList: _headerList);
  bool loading = true;
  int _page = 1;
  int? catTypeIndex;

  var tableData = <TLModel>[];

  void init() {
    _tableList.headerList = _headerList;
    tableData = <TLModel>[
      TLModel(
        title: LN.categoryName,
        tableCltr: TextEditingController(),
      ),
      TLModel(
        title: LN.description,
        tableCltr: TextEditingController(),
      ),
      TLModel(
        title: LN.sort,
        tableCltr: TextEditingController(),
        textInputType: TextInputType.number,
        isReq: true,
      ),
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

  int get getPage => _page;

  set setPage(int val) {
    _page = val;
  }

  void clear() {
    // itemId = "";
    editData = null;
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
    _statusCat = true;
    catTypeIndex = null;
    for (var e in tableData) {
      e.tableCltr.clear();
    }
    defaultBackgroundColorCltr.text = Utils.hexCode(kPrimaryColor);
    deBackcolor = kPrimaryColor;

    defaultTextColorCltr.text = Utils.hexCode(Colors.white);
    deTextcolor = Colors.white;

    onFocusBackgroundColorCltr.text = Utils.hexCode(kSecondaryColor);
    foBackcolor = kSecondaryColor;

    onFocusTextsColorCltr.text = Utils.hexCode(Colors.white);
    foTextcolor = Colors.white;
    searchCltr.clear();
  }

  final searchCltr = TextEditingController();

  Future<void> getData({int page = 1}) async {
    setPage = page;
    _getAllData = await Handler.getProductCats(
        page: page, searchKey: searchCltr.text.toLowerCase());
    if (_getAllData?.data != null) {
      _tableList.tableDataList = [];
      for (var e in _getAllData!.data!) {
        _tableList.tableDataList.add(TableDataList(
          id: e.id ?? '',
          itemList: [
            e.name ?? '',
            e.categoryType ?? '',
            e.sortOrder?.toString() ?? '',
          ],
          statusList: [e.isActive ? TableStatus.Active : TableStatus.Inactive],
        ));
      }
    }
    loading = false;
    notifyListeners();
  }

  AllProductCat? get getPCats => _getAllData;

  RTableData get getTableList => _tableList;

  // String itemId = "";

  Future<void> addUpData() async {
    loading = true;
    notify();
    String? catTypeId;
    if (catTypeIndex != null &&
        addSection!.categoryTypes != null &&
        addSection!.categoryTypes!.isNotEmpty) {
      catTypeId = addSection!.categoryTypes![catTypeIndex!].id;
    }

    final catData = CatAddReq(
      id: editData?.id ?? "",
      name: tableData[0].tableCltr.text,
      description: tableData[1].tableCltr.text,
      sortOrder: int.tryParse(tableData[2].tableCltr.text),
      icon: tableData[3].tableCltr.text,
      slug: tableData[4].tableCltr.text,
      identifier: tableData[5].tableCltr.text,
      productCategoryImageId: imageId ?? '',
      isActive: getStatusCat,
      categoryTypeId: catTypeId,
      isImageDeleted: uploadImageUrl == null,
      channels: addSection?.channels == null
          ? null
          : addSection!.channels!
              .where((e) => e.isSelected ?? false)
              .map((f) => Channel(
                    id: "",
                    channelId: f.id,
                  ))
              .toList(),
      filterTypes: addSection?.filterTypes == null
          ? null
          : addSection!.filterTypes!
              .where((e) => e.isSelected ?? false)
              .map((f) => FilterType(id: "", filterTypeId: f.id, name: f.value))
              .toList(),
      posDevices: addSection?.posDevices == null
          ? null
          : addSection!.posDevices!
              .where((e) => e.isSelected ?? false)
              .map((f) => PosDevice(
                    id: f.additionalValue?.toString() ?? "",
                    posDeviceId: f.id,
                  ))
              .toList(),
      productCategoryBackgroundColorViewModel:
          ProductCategoryBackgroundColorViewModel(
        defaultBackGroundColor: defaultBackgroundColorCltr.text,
        defaultTextColor: defaultTextColorCltr.text,
        onFocusBackGroundColor: onFocusBackgroundColorCltr.text,
        onFocusTextColor: onFocusTextsColorCltr.text,
      ),
      fileName: '', // uploadImageS3Res?.fileName,
    );

    if (editData != null) {
      catData.isHalfCategory = editData?.isHalfCategory;
      catData.parentProductCategoryId = editData?.parentProductCategoryId;
      catData.aspectRatio = editData?.aspectRatio;
      catData.linkText = editData?.linkText;
      catData.link = editData?.link;
      catData.imageLink = editData?.imageLink;
    }

    if (uploadImageUrl?.isNotEmpty ?? false) {
      if (!(uploadImageUrl?.contains('https') ?? false)) {
        final _compressedFile =
            await ImageService.compressFileFors3(uploadImageUrl!);

        final _imageUploadStatus = await Handler.uploadImageOnUrl(
          contentType: uploadImageS3Res?.contentType,
          url: uploadImageS3Res?.uploadUrl,
          filepath: _compressedFile,
        );

        if (_imageUploadStatus ?? false) {
          catData.fileName = uploadImageS3Res?.fileName ?? '';
        }
      } else {
        catData.fileName = editData?.fileName ?? '';
      }
    } else {
      catData.fileName = '';
    }

    final isAddSuccess = await Handler.addProductCat(
      catData: catData,
    );

    if (isAddSuccess != null && isAddSuccess && _getAllData?.total != null) {
      clear();
      if (_getAllData!.total! - (getPage * 10) < 10) {
        await getData(page: getPage);
      }
      getData(page: _page);
    }
    loading = false;
    notify();
  }

  Future<void> deleteData({required List<SRDatum> prodCats}) async {
    final status = await Handler.deleteProductCats(productCatsList: prodCats);
    if (status != null && status) {
      for (var e in prodCats) {
        getTableList.tableDataList.removeWhere((f) => e.id == f.id);
      }
      notifyListeners();
    }
  }

  CatAddReq? editData;

  Future<bool?> editProdCat({String? id}) async {
    if (id == null) return null;
    loading = true;
    notify();

    editData = await Handler.editProdCats(id: id);
    if (editData != null) {
      tableData[0].tableCltr.text = editData?.name ?? '';
      tableData[1].tableCltr.text = editData?.description ?? '';
      tableData[2].tableCltr.text = editData?.sortOrder?.toString() ?? '';
      // itemId = editData?.id ?? '';
      setStatusCat = editData!.isActive;
      imageId = editData!.productCategoryImageId;
      uploadImageUrl = editData?.imageUrl;
      if (addSection!.categoryTypes!.any((e) =>
          e.id?.toLowerCase() == editData!.categoryTypeId?.toLowerCase()))
        catTypeIndex = addSection!.categoryTypes!.indexWhere((e) =>
            e.id?.toLowerCase() == editData!.categoryTypeId?.toLowerCase());
      if (addSection != null && addSection!.productCategoriesImages != null)
        for (final e in addSection!.productCategoriesImages!) {
          if (e.id == imageId) {
            e.isDefaultImage = true;
          } else {
            e.isDefaultImage = false;
          }
        }

      if (addSection?.filterTypes != null && editData!.filterTypes != null)
        for (final e in editData!.filterTypes!) {
          if (addSection!.filterTypes!.any((a) => a.id == e.filterTypeId)) {
            addSection!.filterTypes!.firstWhere((a) => a.id == e.filterTypeId)
              ..isSelected = true
              ..additionalValue = e.id;
          }
        }
      if (addSection?.channels != null && editData!.channels != null)
        for (final e in editData!.channels!) {
          if (addSection!.channels!
              .any((a) => a.id?.toLowerCase() == e.channelId?.toLowerCase())) {
            addSection!.channels!.firstWhere((a) => a.id == e.channelId)
              ..isSelected = true
              ..additionalValue = e.id;
          }
        }

      if (addSection?.posDevices != null && editData!.posDevices != null)
        for (final e in editData!.posDevices!) {
          if (addSection!.posDevices!.any((a) => a.id == e.posDeviceId)) {
            addSection!.posDevices!.firstWhere((a) => a.id == e.posDeviceId)
              ..isSelected = true
              ..additionalValue = e.id;
          }
        }
      defaultBackgroundColorCltr.text = editData
              ?.productCategoryBackgroundColorViewModel
              ?.defaultBackGroundColor ??
          Utils.hexCode(kPrimaryColor);
      if (defaultBackgroundColorCltr.text.isNotEmpty)
        deBackcolor = Utils.colorFromHex(defaultBackgroundColorCltr.text);

      defaultTextColorCltr.text =
          editData?.productCategoryBackgroundColorViewModel?.defaultTextColor ??
              Utils.hexCode(Colors.white);
      if (defaultTextColorCltr.text.isNotEmpty)
        deTextcolor = Utils.colorFromHex(defaultTextColorCltr.text);

      onFocusBackgroundColorCltr.text = editData
              ?.productCategoryBackgroundColorViewModel
              ?.onFocusBackGroundColor ??
          Utils.hexCode(kSecondaryColor);
      if (onFocusBackgroundColorCltr.text.isNotEmpty)
        foBackcolor = Utils.colorFromHex(onFocusBackgroundColorCltr.text);

      onFocusTextsColorCltr.text =
          editData?.productCategoryBackgroundColorViewModel?.onFocusTextColor ??
              Utils.hexCode(Colors.white);
      if (onFocusTextsColorCltr.text.isNotEmpty)
        foTextcolor = Utils.colorFromHex(onFocusTextsColorCltr.text);
    }
    loading = false;
    notify();
    return editData != null;
  }

  PCatImages? addSection;

  String? imageId;
  String? defaultImageId;

  String? uploadImageUrl;

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

    notify();
  }

  int _countSelectedCats = 0;

  int get getCountSCatI => _countSelectedCats;

  set setCountSCatI(int val) {
    _countSelectedCats = val;
    notify();
  }

  bool _statusCat = true;

  bool get getStatusCat => _statusCat;

  set setStatusCat(bool val) {
    _statusCat = val;
    notify();
  }

  void notify() {
    notifyListeners();
  }

  /// [Drawer category sorting] product category sorting from menu screen

  Future<void> sortCategory({required List<String> catIdList}) async {
    final allcatList = <CatAddReq>[];

    for (int i = 0; i <= (catIdList.length / 10).round(); i++) {
      final res = await Handler.getProductCats(page: i + 1);
      if (res != null && res.data != null) allcatList.addAll(res.data!);
    }

    final sortedCatList = <CatAddReq>[];
    for (int i = 0; i < catIdList.length; i++) {
      if (allcatList
          .any((e) => e.id?.toLowerCase() == catIdList[i].toLowerCase())) {
        sortedCatList.add(
          allcatList.firstWhere(
              (e) => e.id?.toLowerCase() == catIdList[i].toLowerCase())
            ..sortOrder = i + 1,
        );
      }
    }
    //TODO: for sorting category by dragging on drawer
    // await Handler.addProductCat(
    //   catList: _sortedCatList,
    //   showToast: false,
    // );
  }

  // color
  final defaultBackgroundColorCltr =
      TextEditingController(text: Utils.hexCode(kPrimaryColor));
  Color deBackcolor = kPrimaryColor;

  final defaultTextColorCltr =
      TextEditingController(text: Utils.hexCode(Colors.white));
  Color deTextcolor = Colors.white;

  final onFocusBackgroundColorCltr =
      TextEditingController(text: Utils.hexCode(kSecondaryColor));
  Color foBackcolor = kSecondaryColor;

  final onFocusTextsColorCltr =
      TextEditingController(text: Utils.hexCode(Colors.white));
  Color foTextcolor = Colors.white;

  // upload image

  UploadImageS3Res? uploadImageS3Res;

  Future<void> uploadImage() async {
    uploadImageS3Res = await Handler.uploadUrls3(
      fileName: "ProductCategoriesImages",
      identifier: "category-image",
    );
  }
}
