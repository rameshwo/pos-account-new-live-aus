import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../providers/product/new_product_pro.dart';
import '../add_new_p.dart';
import 'recent_add_product/recent_add_p.dart';

class ProductListPage extends StatefulWidget {
  final Function() onBack;
  const ProductListPage({super.key, required this.onBack});

  @override
  ProductListPageState createState() => ProductListPageState();
}

class ProductListPageState extends State<ProductListPage> {
  final _pageCltr = PageController();
  late NewProductPro _newProdPro;

  @override
  void initState() {
    super.initState();
    _newProdPro = Provider.of<NewProductPro>(context, listen: false);
  }

  @override
  void dispose() {
    _newProdPro.productList.clear();
    _pageCltr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageCltr,
      children: [
        RecentAddedProducts(
          addNewProduct: () {
            // _tabCltr.animateTo(1);
            _pageCltr.animateToPage(1,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
          onBack: widget.onBack,
        ),
        AddNewProduct(
          onBack: () {
            _pageCltr.animateToPage(0,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
        ),
      ],
    );
  }
}
