// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/providers/cus_val_pro.dart';
// import 'package:pos_account/providers/setting/general/cat_type_pro.dart';
// import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/add_new_sec.dart';
// import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/table_data.dart';
// import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
// import 'package:pos_account/widgets/loading.dart';
// import 'package:provider/provider.dart';

// import '../../general_set.dart';

// class CatTypeSet extends StatefulWidget {
//   final PageController pageController;
//   const CatTypeSet({Key? key, required this.pageController}) : super(key: key);

//   @override
//   State<CatTypeSet> createState() => _CatTypeSetState();
// }

// class _CatTypeSetState extends State<CatTypeSet>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();

//   CatTypePro? _pro;

//   late TabController _tabController;

//   @override
//   void initState() {
//     _tabController = TabController(length: 2, vsync: this);
//     setData();
//     super.initState();
//   }

//   setData() async {
//     _pro = Provider.of<CatTypePro>(context, listen: false);
//     if (_pro != null) {
//       _pro!.init();
//       await _pro!.getData(page: 1);
//     }
//   }

//   paginate(int page) {
//     if (_pro != null) {
//       _pro!.loading = true;
//       _pro!.notify;
//       _pro!.getData(page: page);
//     }
//   }

//   @override
//   void dispose() {
//     _pro?.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pro = Provider.of<CatTypePro>(context);
//     final size = Ssize(context);
//     return Processing(
//       loading: pro.loading,
//       child: DefaultTabController(
//         length: 2,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SettingsTabRow(
//               addTitle: "Add Category Types",
//               viewTitle: "Category Types List",
//               tabController: _tabController,
//               pageController: widget.pageController,
//             ),
//             SizedBox(
//               height: size.getH(12),
//             ),
//             Expanded(
//                 child: TabBarView(controller: _tabController, children: [
//               SingleChildScrollView(
//                 child: TableData(
//                   tableData: pro.tableList,
//                   popUpMenuItems: (int i) => [
//                     if (GlobalCVP.viewWidget.viewCategoryTypeEdit &&
//                         (pro.getAllCatTypes?.data?[i].isEditEnabled ?? false))
//                       LN.edit,
//                     if (GlobalCVP.viewWidget.viewCategoryTypeDelete &&
//                         (pro.getAllCatTypes?.data?[i].isDeleteEnabled ?? false))
//                       LN.delete,
//                   ],
//                   showDeleteBtn:
//                       GlobalCVP.viewWidget.viewCategoryTypeBulkDelete,
//                   deleteItem: (items) {
//                     showDialog(
//                         context: context,
//                         builder: (builder) => ConfirmDialog(
//                               title: items.length > 1
//                                   ? "${items.length} ${LN.catType.toLowerCase()}"
//                                   : "${items[0].name}",
//                               onDelete: () async {
//                                 pro.deleteData(dataList: items);
//                                 return null;
//                               },
//                             ));
//                   },
//                   selectItem: (count) {
//                     pro.countMultipleCatTypes = count;
//                     pro.notify;
//                   },
//                   paginate: paginate,
//                   total: pro.getAllCatTypes?.total,
//                   page: pro.pageNum,
//                   onAction: (p0, moreFun) {
//                     final data = pro.getAllCatTypes!.data!
//                         .firstWhere((e) => e.id == p0.id);
//                     pro.tableData[0].tableCltr.text = data.name ?? '';
//                     pro.tableData[1].tableCltr.text =
//                         data.sortOrder?.toString() ?? '0';
//                     pro.catTypeId = data.id ?? "";
//                     pro.isActiveStatus = data.isActive ?? false;
//                     pro.notify;
//                     _tabController.animateTo(1);
//                     Future.delayed(Duration(milliseconds: 500), () {
//                       pro.notify;
//                     });
//                   },
//                 ),
//               ),
//               SingleChildScrollView(
//                 child: Form(
//                   key: _formKey,
//                   child: AddNewSection(
//                     showSaveBtn:
//                         GlobalCVP.viewWidget.viewCategoryTypeSaveButton,
//                     tableTitle: LN.catType,
//                     tableList: pro.tableData,
//                     statusClass: [
//                       StatusClass(
//                           activeText: LN.active,
//                           getStatus: pro.isActiveStatus,
//                           inActiveText: LN.inActive,
//                           setStatus: (val) {
//                             pro.isActiveStatus = val;
//                             pro.notify;
//                           })
//                     ],
//                     onAdd: pro.loading
//                         ? null
//                         : () async {
//                             if (_formKey.currentState!.validate()) {
//                               await pro.addUpData();
//                             }
//                           },
//                     isNew: pro.catTypeId.isEmpty ? true : false,
//                     onCancel: () {
//                       pro.clear();
//                       pro.notify;
//                     },
//                   ),
//                 ),
//               ),
//             ])),
//           ],
//         ),
//       ),
//     );
//   }
// }
