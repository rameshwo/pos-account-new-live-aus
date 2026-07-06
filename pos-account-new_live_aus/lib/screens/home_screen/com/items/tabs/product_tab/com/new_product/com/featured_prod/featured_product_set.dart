import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/product/featured_product_pro.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'add_new_featured_prod.dart';
import 'featured_prod_list.dart';

class FeaturedProductSet extends StatefulWidget {
  const FeaturedProductSet({super.key});

  @override
  State<FeaturedProductSet> createState() => _FeaturedProductSetState();
}

class _FeaturedProductSetState extends State<FeaturedProductSet> {
  final refreshCltr = RefreshController(initialRefresh: false);
  final _pageCltr = PageController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    setData();
  }

  FeaturedProductPro? _featuredProdPro;

  setData() {
    _featuredProdPro = Provider.of<FeaturedProductPro>(context, listen: false);
    _featuredProdPro?.getData();
  }

  Future<void> paginate(int page) async {
    if (_featuredProdPro != null) {
      _featuredProdPro!.getData(page: page);
    }
    refreshCltr.loadComplete();
    refreshCltr.refreshCompleted();
  }

  @override
  void dispose() {
    _featuredProdPro?.screenLoad = true;
    _featuredProdPro?.featuredList.clear();
    _featuredProdPro?.searchCltr.clear();
    _featuredProdPro?.selectedIds.clear();
    _featuredProdPro?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final featuredProd = Provider.of<FeaturedProductPro>(context);
    final isNewAdding = _pageCltr.hasClients && _pageCltr.page == 1;
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 1.15,
        minHeight: size.height / 5,
      ),
      width: size.width / 1.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: size.getH(24),
          ),
          Row(
            children: [
              if (isNewAdding)
                IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      _pageCltr
                          .animateToPage(0,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut)
                          .then((value) => featuredProd.notify);
                    },
                    icon: Icon(Icons.arrow_back)),
              Text(
                LN.frequentlySellingProducts,
                style: TextStyle(
                  fontSize: size.getS(18),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (!isNewAdding)
                IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      _pageCltr
                          .animateToPage(1,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut)
                          .then((value) => featuredProd.notify);
                    },
                    icon: Icon(
                      Icons.add_circle,
                      size: size.getS(28),
                      color: Colors.green,
                    )),
              Spacer(),
              IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close))
            ],
          ),
          Flexible(
            child: Card(
              margin: EdgeInsets.zero,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                width: double.infinity,
                height: isNewAdding ? size.getH(300) : size.height / 1.3,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: size.getH(8.0), horizontal: size.getW(16)),
                  child: PageView(
                    controller: _pageCltr,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      FeaturedProdList(
                        refreshController: refreshCltr,
                        onRefresh: (val) {
                          if (val) {
                            paginate(featuredProd.pageIndex + 1);
                          } else {
                            paginate(1);
                          }
                        },
                      ),
                      AddNewFeaturedProdSection(
                        focusNode: focusNode,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.getH(12),
          ),
        ],
      ),
    );
  }
}
