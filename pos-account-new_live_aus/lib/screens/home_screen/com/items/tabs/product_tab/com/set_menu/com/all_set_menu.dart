import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/product/set_menu_pro.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllSetMenu extends StatefulWidget {
  final Function()? onEdit;
  const AllSetMenu({super.key, this.onEdit});

  @override
  State<AllSetMenu> createState() => _AllSetMenuState();
}

class _AllSetMenuState extends State<AllSetMenu> {
  SetMenuPro? _setMenu;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    _setMenu = Provider.of<SetMenuPro>(context, listen: false);
    if (_setMenu != null) _setMenu!.getAllSetMenu(page: 1);
  }

  paginate(int page) {
    if (_setMenu != null) {
      _setMenu!.getAllSetMenu(page: page);
    }
  }

  @override
  void dispose() {
    _setMenu?.setMenuScreenLoad = true;
    _setMenu?.setMenuList.clear();
    _setMenu?.searchCltr.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final setMenu = Provider.of<SetMenuPro>(context);
    return Processing(
      loading: setMenu.setMenuScreenLoad,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height / 1.14,
          minHeight: size.height / 5,
        ),
        width: size.width / 1.2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.getH(12),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LN.setMenuCombo,
                  style: TextStyle(
                    fontSize: size.getS(24),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: SizedBox(
                width: size.width / 3,
                child: TextFormWidget(
                  isReq: false,
                  prefixIcon: Icon(
                    Icons.search,
                    size: size.getS(32),
                  ),
                  borderRadius: 5,
                  borderColor: Colors.black12,
                  cltr: setMenu.searchCltr,
                  hintText: LN.searchSetMenu,
                  onChanged: (String? val) {
                    Utils.handleSearch(
                        callback: () async {
                          setMenu.setMenuScreenLoad = true;
                          setMenu.notify();
                          setMenu.getAllSetMenu(page: 1);
                        },
                        millisecond: 2000);
                  },
                  suffixIcon: InkWell(
                      onTap: () {
                        if (setMenu.searchCltr.text.isEmpty) return;
                        setMenu.searchCltr.clear();
                        setMenu.setMenuScreenLoad = true;
                        setMenu.notify();
                        setMenu.getAllSetMenu(page: 1);
                      },
                      child: Icon(Icons.close)),
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: setMenu.selectedIds.length > 1 ? 48 : 0,
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.red.shade700),
                      padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                          horizontal: size.getW(24), vertical: size.getH(8)))),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (builder) => ConfirmDialog(
                              title:
                                  "${setMenu.selectedIds.length} ${LN.setMenuSmall}",
                              onDelete: () async {
                                setMenu.deleteData(
                                    dataList: setMenu.selectedIds);
                                return null;
                              },
                            ));
                  },
                  child: Text(
                    LN.delete,
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
            Flexible(
              child: SmartRefresher(
                controller: setMenu.refreshCltr,
                enablePullUp: true,
                onLoading: () {
                  paginate(setMenu.getPage + 1);
                },
                onRefresh: () {
                  paginate(1);
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!setMenu.setMenuScreenLoad &&
                          setMenu.setMenuList.isNotEmpty)
                        Wrap(
                          children: [
                            ...List.generate(setMenu.setMenuList.length,
                                (index) {
                              final item = setMenu.setMenuList[index];
                              final isSelected = setMenu.selectedIds
                                  .map((e) => e.id)
                                  .contains(item.id);
                              return Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.red.shade700
                                          : Colors.grey.shade400,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                margin: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                child: InkWell(
                                  onTap: () {
                                    if (item.id == null) return;

                                    if (setMenu.selectedIds
                                        .map((e) => e.id)
                                        .contains(item.id))
                                      setMenu.selectedIds
                                          .removeWhere((f) => f.id == item.id);
                                    else
                                      setMenu.selectedIds.add(SRDatum(
                                        id: item.id,
                                        name: item.name,
                                      ));
                                    setMenu.notify();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: (item.imagePath != null &&
                                                  item.imagePath!.isNotEmpty)
                                              ? CachedNetworkImage(
                                                  imageUrl: item.imagePath!,
                                                  fit: BoxFit.cover,
                                                  height: size.getH(140),
                                                  width: size.getH(148),
                                                  placeholder: ImageError.load,
                                                  errorWidget: ImageError.text)
                                              : SizedBox(
                                                  height: size.getH(140),
                                                  width: size.getH(148),
                                                  child: Center(
                                                    child: Text(
                                                      LN.noImage,
                                                      style: TextStyle(
                                                          fontSize:
                                                              size.getS(18),
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color:
                                                              Colors.black45),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        Text(
                                          item.name ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: size.getS(16),
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: size.getW(12),
                                            ),
                                            if (GlobalCVP.viewWidget
                                                .viewEditSetMenuButton)
                                              ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStateProperty.all(
                                                            kSecondaryColor),
                                                  ),
                                                  onPressed: () async {
                                                    if (item.id == null) return;
                                                    Navigator.pop(context);
                                                    setMenu.loading = true;
                                                    setMenu.clear();
                                                    setMenu.notify();
                                                    await setMenu
                                                        .editSetMenuData(
                                                            id: item.id!);
                                                    if (widget.onEdit != null)
                                                      widget.onEdit!();
                                                  },
                                                  child: Text(
                                                    LN.edit,
                                                    style: TextStyle(
                                                      fontSize: size.getS(16),
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )),
                                            if (GlobalCVP.viewWidget
                                                .viewDeleteSetMenueButton)
                                              IconButton(
                                                  onPressed: () {
                                                    final deletedData = SRDatum(
                                                      id: item.id,
                                                      name: item.name,
                                                    );
                                                    showDialog(
                                                        context: context,
                                                        builder: (builder) =>
                                                            ConfirmDialog(
                                                              title: deletedData
                                                                      .name ??
                                                                  '',
                                                              onDelete:
                                                                  () async {
                                                                setMenu.deleteData(
                                                                    dataList: [
                                                                      deletedData
                                                                    ]);
                                                                return null;
                                                              },
                                                            ));
                                                  },
                                                  icon: Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.red,
                                                    size: size.getS(32),
                                                  ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                          ],
                        )
                      else if (!setMenu.setMenuScreenLoad)
                        NoItemsSec(
                          size: size,
                          title: LN.noSetMenuFound,
                        ),
                      // if (setMenu.allSetMenuRes != null)
                      //   PaginateButton(
                      //     total: setMenu.allSetMenuRes!.total ?? 0,
                      //     pageIndex: setMenu.getPage,
                      //     next: () => paginate(setMenu.getPage + 1),
                      //     prev: () => paginate(setMenu.getPage - 1),
                      //   ),
                      SizedBox(
                        height: size.getH(24),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
