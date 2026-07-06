import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/gift_card/image/gift_card_img_data.dart';
import 'package:pos_account/providers/menu/gift_card/gift_card_image_pro.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'add_gift_card_image_dia.dart';

class GiftCardCusImageTab extends StatefulWidget {
  const GiftCardCusImageTab({super.key});

  @override
  State<GiftCardCusImageTab> createState() => _GiftCardCusImageTabState();
}

class _GiftCardCusImageTabState extends State<GiftCardCusImageTab>
    with TickerProviderStateMixin {
  GiftCardImagePro? _giftCardImagePro;
  String? curSym;
  TabController? _tabCltr;
  List<String> _groupNames = [];
  final Map<String, RefreshController> _refreshControllers = {};
  final _scrollCltr2 = ScrollController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    _refreshControllers.values.forEach((controller) => controller.dispose());
    _tabCltr?.dispose();
    super.dispose();
  }

  void getData() async {
    curSym = await SharedPrefs.curSym;
    setState(() {});
    _giftCardImagePro = Provider.of<GiftCardImagePro>(context, listen: false);
    _giftCardImagePro?.getAdSec().then((value) => _giftCardImagePro
        ?.getGiftCardAll()
        .then((value) => _updateGroupNames()));
  }

  void _updateGroupNames({bool isReload = false}) {
    if (mounted) {
      setState(() {
        _giftCardImagePro?.pageLoad = true;
      });

      final allGroups = _giftCardImagePro?.cardImageList
          .map((card) => card.giftCardTemplateGroupName.toString())
          .toSet()
          .toList();

      if (allGroups != null && allGroups.isNotEmpty) {
        setState(() {
          _groupNames = allGroups;

          // Dispose old TabController if exists
          if (_tabCltr != null) {
            _tabCltr!.dispose();
          }

          // Reinitialize TabController
          _tabCltr = TabController(length: allGroups.length, vsync: this);

          // Create a separate RefreshController for each group
          for (final group in _groupNames) {
            _refreshControllers[group] =
                _refreshControllers[group] ?? RefreshController();
          }
        });
      }
      setState(() {
        _giftCardImagePro?.pageLoad = false;
      });
    }
  }

  void reload(int page) {
    _giftCardImagePro
        ?.getGiftCardAll(page: page)
        .then((value) => _updateGroupNames(isReload: true));
  }

  void showDia({required Ssize size}) {
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (builder) => SimpleDialog(
        backgroundColor: kBackgroundColor,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        children: [
          AddGiftCardImageDia(
            callBack: () {
              _giftCardImagePro
                  ?.getGiftCardAll()
                  .then((value) => _updateGroupNames(isReload: true));
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final pro = Provider.of<GiftCardImagePro>(context);
    if (_groupNames.isNotEmpty && _tabCltr == null) {
      _tabCltr = TabController(length: _groupNames.length, vsync: this);
    }

    return Processing(
      loading: pro.pageLoad,
      align: Alignment.topLeft,
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.getW(12),
            vertical: size.getH(0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                        padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                            horizontal: size.getW(16),
                            vertical: size.getH(size.isDesktop ? 16 : 8)))),
                    onPressed: () => showDia(size: size),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          size: size.getS(25),
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: size.getW(8),
                        ),
                        Text(
                          LN.createNew,
                          style: TextStyle(
                            fontSize: size.getS(16),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )),
              ),
              SizedBox(height: size.getH(12)),
              if (_groupNames.isNotEmpty && _tabCltr != null)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: size.getH(40),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                        ),
                        child: TabBar(
                          tabAlignment: TabAlignment.start,
                          indicatorColor: Colors.transparent,
                          labelColor: Colors.white,
                          controller: _tabCltr,
                          isScrollable: true,
                          indicator: BoxDecoration(
                            color: kPrimaryColor,
                          ),
                          labelStyle: TextStyle(
                            fontSize: size.getS(16),
                            fontFamily: kFontFMedium,
                          ),
                          labelPadding: EdgeInsets.zero,
                          indicatorPadding: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          unselectedLabelColor: Colors.black,
                          tabs: _groupNames
                              .map((group) => _tabWidget(size, title: group))
                              .toList(),
                          onTap: (index) {
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.getW(8),
                    ),
                    PopupMenuButton(
                      tooltip: LN.showGiftCard,
                      itemBuilder: (_) {
                        final list = _groupNames;
                        return [
                          PopupMenuItem(
                            padding: EdgeInsets.zero,
                            height: 0,
                            enabled: false,
                            child: SizedBox(
                              height: list.length > 10
                                  ? 400.0
                                  : (40.0 * list.length),
                              width: double.infinity,
                              child: Scrollbar(
                                controller: _scrollCltr2,
                                thumbVisibility: true,
                                trackVisibility: true,
                                thickness: 4,
                                child: SingleChildScrollView(
                                  controller: _scrollCltr2,
                                  child: Column(
                                    children: List.generate(list.length, (i) {
                                      return Container(
                                        width: double.infinity,
                                        color: _tabCltr?.index == i
                                            ? kPrimaryColor
                                            : null,
                                        child: InkWell(
                                          onTap: () {
                                            _tabCltr!.animateTo(i);

                                            final val = list
                                                .getRange(0, i)
                                                .fold<int>(0, (prev, element) {
                                              return prev + element.length;
                                            });

                                            _scrollCltr2.animateTo(
                                                (i * 12) + val * 8.4,
                                                duration:
                                                    Duration(milliseconds: 500),
                                                curve: Curves.easeInOut);
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: size.getH(8),
                                                horizontal: size.getW(12)),
                                            child: Text(
                                              list[i],
                                              style: TextStyle(
                                                fontSize: size.getS(18),
                                                color: _tabCltr?.index == i
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontFamily: kFontFMedium,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ];
                      },
                      child: Icon(Icons.more_vert),
                    )
                  ],
                ),
              if (_groupNames.isEmpty)
                Expanded(child: NoItemsSec(size: size, title: LN.noImgFound)),
              SizedBox(height: size.getH(12)),
              if (_groupNames.isNotEmpty && _tabCltr != null)
                Expanded(
                  child: TabBarView(
                    controller: _tabCltr,
                    children: _groupNames.map((group) {
                      final filteredCards = pro.cardImageList.where((card) {
                        return card.giftCardTemplateGroupName == group;
                      }).toList();

                      final controller =
                          _refreshControllers[group] ?? RefreshController();

                      return SmartRefresher(
                        controller: controller,
                        enablePullUp: true,
                        onLoading: () {
                          // paginate(_pro.pageIndex + 1, group);
                          controller.loadComplete();
                        },
                        onRefresh: () {
                          // paginate(1, group);
                          _giftCardImagePro?.getGiftCardAll().then(
                              (value) => _updateGroupNames(isReload: true));
                          controller.refreshCompleted();
                        },
                        child: filteredCards.isEmpty
                            ? NoItemsSec(size: size, title: LN.noImgFound)
                            : Wrap(
                                spacing: size.getW(4),
                                runSpacing: size.getH(4),
                                children: List.generate(filteredCards.length,
                                    (index) {
                                  final cardImage = filteredCards[index];
                                  return buildCard(size, cardImage, pro);
                                }),
                              ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabWidget(Ssize size, {String? title}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          vertical: BorderSide(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: size.getW(16),
      ),
      child: Tab(
        iconMargin: EdgeInsets.zero,
        child: Text(
          title ?? '',
        ),
      ),
    );
  }

  Widget buildCard(
      Ssize size, GiftCardImageData cardImage, GiftCardImagePro pro) {
    return SizedBox(
      height: size.getH(328),
      width: size.getW(220),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            margin: EdgeInsets.symmetric(
              vertical: size.getH(12),
              horizontal: size.getW(12),
            ),
            padding: EdgeInsets.symmetric(
              vertical: size.getH(12),
              horizontal: size.getW(12),
            ),
            child: Column(
              children: [
                if (cardImage.imagePath != null &&
                    cardImage.imagePath!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: cardImage.imagePath!,
                      height: size.getH(160),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: ImageError.load,
                      errorWidget: ImageError.icon,
                    ),
                  )
                else
                  Card(
                    margin: EdgeInsets.zero,
                    child: SizedBox(
                      height: size.getH(160),
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          LN.noImage,
                          style: TextStyle(
                            fontSize: size.getS(18),
                            fontStyle: FontStyle.italic,
                            color: Colors.black45,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: size.getH(4)),
                Expanded(
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        text: cardImage.name ?? LN.na,
                        style: TextStyle(
                          fontSize: size.getS(16),
                          color: Colors.black,
                          fontFamily: kFontFMedium,
                        ),
                        children: [
                          if (cardImage.amount != null &&
                              cardImage.amount!.isNotEmpty)
                            TextSpan(
                              text:
                                  "\n${curSym ?? ''}${cardImage.amount ?? ''}",
                            )
                        ],
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: pro.pageLoad
                      ? null
                      : () => pro.editImage(cardImage.id).then((value) {
                            if (value ?? false) showDia(size: size);
                            pro.notify;
                          }),
                  style: ButtonStyle(
                    side: WidgetStateProperty.all(
                      BorderSide(color: Colors.red),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(horizontal: size.getW(32)),
                    ),
                  ),
                  child: Text(
                    LN.edit,
                    style: TextStyle(
                      fontSize: size.getS(18),
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: size.getW(2),
            top: size.getH(2),
            child: (cardImage.isActive ?? false)
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(255),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: size.getW(8),
                      vertical: size.getH(4),
                    ),
                    child: Text(
                      LN.active,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: size.getS(14),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(50),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: size.getW(8),
                      vertical: size.getH(4),
                    ),
                    child: Text(
                      LN.inActive,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: size.getS(14),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
