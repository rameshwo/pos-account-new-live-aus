import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/product_tab/com/raw_ingre/raw_ingre_add_sec.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/common_header.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../constant/constant.dart';
import '../../../../../../../../ln.dart';
import '../../../../../../../../providers/product/new_product_pro.dart';
import 'all_raw_ingre_list.dart';

class RawIngreSection extends StatefulWidget {
  final Function()? onBack;
  const RawIngreSection({
    super.key,
    this.onBack,
  });

  @override
  State<RawIngreSection> createState() => _RawIngreSectionState();
}

class _RawIngreSectionState extends State<RawIngreSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final newProdPro = Provider.of<NewProductPro>(context);
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          CommonHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      widget.onBack?.call();
                    },
                    icon: Icon(Icons.arrow_back)),
                IntrinsicWidth(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      // tabAlignment: TabAlignment.center,
                      labelStyle: TextStyle(
                        fontSize: Ssize(context).getS(18),
                        fontFamily: kFontFMedium,
                      ),
                      labelColor: Colors.black,
                      tabs: [
                        Tab(text: 'All Raw Ingredients'),
                        Tab(text: '${LN.add} ${LN.rawIngre}'),
                      ],
                      onTap: (index) {
                        newProdPro.clearIngreSec();
                        newProdPro.notify;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Expanded(
              child: TabBarView(
            controller: _tabController,
            children: [
              AllRawIngredients(tabController: _tabController),
              RawIngreAddSection(),
            ],
          )),
        ],
      ),
    );
  }
}
