import 'package:flutter/material.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/user_manage/com/employee_add_page.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../providers/profile/user_manage_pro.dart';
import 'com/commission_setup.dart';
import 'com/customer_add_page.dart';
import 'com/userlist_dia.dart';

class UserManagement extends StatefulWidget {
  final Function()? onBack;
  const UserManagement({super.key, this.onBack});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement>
    with SingleTickerProviderStateMixin {
  final pageController = PageController();
  late TabController _tabController;
  late UserManagePro? _pro;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getData();
    super.initState();
  }

  getData() async {
    _pro = Provider.of<UserManagePro>(context, listen: false);
    if (_pro != null) {
      _pro!.searchCltr.clear();
      _pro!.userTableList.tableDataList = [];
      _pro!.employeeTableList.tableDataList = [];
      _pro!.customerTableList.tableDataList = [];
      _pro!.userLoad = true;
      // _pro!.getAllUsers(page: 1);
      _pro?.getAllEmployees(page: 1);
    }
  }

  loadData([page]) {
    if (_tabController.index == 0) {
      // _pro?.getAllUsers(page: page);
      _pro?.getAllEmployees(page: page);
    } else if (_tabController.index == 1) {
      // _pro?.getAllEmployees(page: page);
      _pro?.getAllCustomers(page: page);
    } else {
      // _pro?.getAllCustomers(page: page);
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<UserManagePro>(context);
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: pageController,
      children: [
        UserListDia(
          paginate: loadData,
          tabController: _tabController,
          pageController: pageController,
          pro: pro,
          onBack: widget.onBack ?? () {},
        ),
        // UserAddPage(
        //   pageController: pageController,
        //   pro: pro,
        // ),
        EmployeeAddPage(
          pageController: pageController,
          userManagePro: pro,
        ),
        CommissionSetupPage(
          pageController: pageController,
          pro: pro,
        ),
        CustomerAddPage(
          pro: pro,
          pageController: pageController,
        ),
      ],
    );
  }
}
