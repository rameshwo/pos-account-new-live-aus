import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/profile/user_manage_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/table_data.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/user_manage/com/assign_service.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../../../../../../constant/constant.dart';
import '../../../../../../../../../model/home/setting/general/category/restro_table_model.dart';
import '../../../../../../../../../providers/cus_val_pro.dart';
import '../../general/common/common_header.dart';

class UserListDia extends StatefulWidget {
  final UserManagePro pro;
  final PageController pageController;
  final TabController tabController;
  final Function(int) paginate;

  final Function() onBack;
  const UserListDia({
    super.key,
    required this.pageController,
    required this.pro,
    required this.paginate,
    required this.tabController,
    required this.onBack,
  });

  @override
  State<UserListDia> createState() => _UserListDiaState();
}

class _UserListDiaState extends State<UserListDia> {
  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Processing(
      loading: widget.pro.userLoad,
      child: Column(
        children: [
          CommonHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      widget.pro.clear();
                      widget.onBack();
                    },
                    icon: Icon(Icons.arrow_back, size: size.getS(24))),
                SizedBox(width: size.getW(8)),
                Text(
                  LN.userManagement,
                  style: TextStyle(
                    fontSize: size.getS(18),
                    // fontFamily: ,ph
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.getH(8),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
            child: Row(
              children: [
                IntrinsicWidth(
                  child: SizedBox(
                    child: TabBar(
                      controller: widget.tabController,
                      physics: NeverScrollableScrollPhysics(),
                      labelPadding: EdgeInsets.symmetric(horizontal: 8),
                      labelColor: kSecondaryColor,
                      unselectedLabelColor: Colors.black,
                      indicatorColor: kSecondaryColor,
                      unselectedLabelStyle: TextStyle(
                        fontSize: size.getS(17),
                        // fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                        fontFamily: kFontFMedium,
                      ),
                      onTap: (index) {
                        widget.pro.userLoad = true;
                        widget.pro.searchCltr.clear();
                        widget.pro.notify;
                        widget.paginate(1);
                      },
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: TextStyle(
                        fontSize: size.getS(17),
                        fontFamily: kFontFMedium,
                        // fontWeight: FontWeight.bold,
                      ),
                      tabs: [
                        // Tab(
                        //   text: "Account Users",
                        // ),
                        Tab(
                          text: "Employees",
                        ),
                        Tab(
                          text: "Customers",
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Spacer(),
                        if (widget.tabController.index == 0)
                          Flexible(
                            child: LoadButton(
                              vPad: 8,
                              icon: Padding(
                                padding: EdgeInsets.only(right: size.getW(4)),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: size.getS(22),
                                ),
                              ),
                              hPad: 2,
                              fontSize: 16,
                              width: 200,
                              onsave: () async {
                                widget.pro.loading = true;
                                widget.pro.userLoad = true;
                                widget.pro.notify;
                                widget.pro.empId = "";
                                await widget.pro.getEmpAddSec();
                                widget.pro.empCodeCltr.text =
                                    widget.pro.empAddSec?.employeeCode ?? '';
                                widget.pro.userLoad = false;
                                widget.pageController.animateToPage(
                                  1,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                              btnText: "Add Employee",
                            ),
                          )
                        else if (widget.tabController.index == 1)
                          Flexible(
                            child: LoadButton(
                              vPad: 8,
                              icon: Padding(
                                padding: EdgeInsets.only(right: size.getW(4)),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: size.getS(22),
                                ),
                              ),
                              hPad: 2,
                              fontSize: 16,
                              width: 200,
                              onsave: () {
                                widget.pro.loading = true;
                                widget.pro.cusId = '';
                                widget.pro.notify;
                                widget.pageController.jumpToPage(3);
                              },
                              btnText: LN.addCus,
                            ),
                          ),
                        SizedBox(
                          width: size.getW(10),
                        ),
                        Flexible(
                          child: SizedBox(
                            width: size.getW(400),
                            child: TextFormWidget(
                              isReq: false,
                              prefixIcon: Icon(
                                Icons.search,
                                size: size.getS(25),
                              ),
                              vPad: 8,
                              // fillColor: Colors.grey.shade200,
                              borderColor: Colors.grey.shade200,
                              cltr: widget.pro.searchCltr,
                              onChanged: (val) {
                                Utils.handleSearch(callback: () async {
                                  widget.pro.userLoad = true;
                                  widget.pro.notify;
                                  widget.paginate(1);
                                });
                              },
                              hintText:
                                  //  widget.tabController.index == 0
                                  //     ? LN.searchUser
                                  //     :
                                  widget.tabController.index == 0
                                      ? "Search Employee"
                                      : LN.searchCus,
                              onSubmitted: (val) {
                                Utils.handleSearch(callback: () async {
                                  widget.pro.userLoad = true;
                                  widget.pro.notify;
                                  widget.paginate(1);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: _UserListDia(
            pro: widget.pro,
            // tableData: RTableData(headerList: [], tableDataList: []),
            tableData:
                //  widget.tabController.index == 0
                //     ? widget.pro.userTableList
                //     :
                widget.tabController.index == 0
                    ? widget.pro.employeeTableList
                    : widget.pro.customerTableList,
            page:
                // widget.tabController.index == 0
                //     ? widget.pro.pagiPage
                //     :
                widget.tabController.index == 0
                    ? widget.pro.empPage
                    : widget.pro.cusPage,
            total:
                //  widget.tabController.index == 0
                //     ? widget.pro.allUsers?.total ?? 0
                //     :
                widget.tabController.index == 0
                    ? widget.pro.allEmployees?.total ?? 0
                    : widget.pro.allCustomer?.total ?? 0,
            size: size,
            widget: widget,
          )),
        ],
      ),
    );
  }

  Widget _UserListDia({
    required UserManagePro pro,
    required RTableData tableData,
    required int page,
    required int total,
    required Ssize size,
    required UserListDia widget,
  }) {
    return SmartRefresher(
      controller: pro.refreshController,
      enablePullDown: true,
      onRefresh: () {
        widget.pro.userLoad = true;
        widget.pro.notify;
        widget.paginate(1);
        pro.refreshController.refreshCompleted();
      },
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
        children: [
          SizedBox(
            height: size.getH(12),
          ),
          tableData.tableDataList.isEmpty && !pro.userLoad
              ? NoItemsSec(
                  size: size,
                  title:
                      //  widget.tabController.index == 0
                      //     ? "No Users Found"
                      //     :
                      widget.tabController.index == 0
                          ? "No Employees Found"
                          : "No Customers Found",
                )
              : TableData(
                  tableData: tableData,
                  paginate: widget.paginate,
                  total: total,
                  page: page,
                  pageSize:
                      //  widget.tabController.index == 0
                      //     ? widget.pro.userPageSize
                      //     :
                      widget.pro.empPageSize,
                  sortColumnIndex: 1,
                  popUpMenuItems: (int _) =>
                      // widget.tabController.index == 0
                      //     ? [
                      //         LN.edit,
                      //       ]
                      //     :
                      widget.tabController.index == 0
                          ? GlobalCVP.isServiceStore
                              ? [
                                  LN.edit,
                                  "Assign Service",
                                  "Commission Setup",
                                ]
                              : [
                                  LN.edit,
                                ]
                          : [
                              LN.edit,
                            ],
                  onAction: (p0, p1) async {
                    if (widget.pro.userLoad) return;
                    // if (p1 == MoreFun.Edit && widget.tabController.index == 0) {
                    //   widget.pro.userId = p0.id ?? '';
                    //   widget.pro.loading = true;
                    //   widget.pro.notify;
                    //   widget.pageController.jumpToPage(1);
                    // } else
                    if (p1 == MoreFun.Edit && widget.tabController.index == 0) {
                      widget.pro.empId = p0.id ?? '';
                      widget.pro.loading = true;
                      widget.pro.userLoad = true;
                      widget.pro.notify;
                      final _status = await widget.pro.getEmpAddSec();
                      widget.pro.userLoad = false;
                      if (_status) widget.pageController.jumpToPage(1);
                    } else if (p1 == MoreFun.Edit &&
                        widget.tabController.index == 1) {
                      widget.pro.cusId = p0.id ?? '';
                      widget.pro.loading = true;
                      widget.pro.notify;
                      widget.pageController.jumpToPage(3);
                    } else if (p1 == MoreFun.Assign) {
                      widget.pro.userId = p0.id ?? '';
                      showDialog(
                          context: context,
                          builder: (builder) {
                            return SimpleDialog(
                              backgroundColor: Colors.white,
                              titlePadding: EdgeInsets.zero,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              children: [
                                AssignEmpService(data: p0),
                              ],
                            );
                          });
                      widget.pro.getAssignServiceAddSec(
                          employeeId: p0.id ?? "", employeeName: p0.name ?? "");
                    } else if (p1 == MoreFun.Commission) {
                      widget.pro.empId = p0.id ?? '';
                      widget.pro.loading = true;
                      widget.pro.notify;
                      // widget.pro.getCommDetails();
                      widget.pro.getCommAddSec();
                      widget.pageController.jumpToPage(2);
                    }
                  },
                ),
          SizedBox(
            height: size.getH(24),
          ),
        ],
      ),
    );
  }
}
