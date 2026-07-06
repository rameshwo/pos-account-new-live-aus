import 'package:flutter/material.dart';
import 'package:pos_account/model/home/product/modifier/prod_with_variation_res.dart';
import 'package:pos_account/providers/product/assign_modi_pro.dart';
import 'package:pos_account/providers/product/edit_modifier_pro.dart';
import 'package:provider/provider.dart';
import 'assign_modifier_screen.dart';
import 'edit_modi_screen.dart';
import 'tag_modifier_screen.dart';

class ModifierScreen extends StatefulWidget {
  final Function() onBack;
  const ModifierScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<ModifierScreen> createState() => _ModifierScreenState();
}

class _ModifierScreenState extends State<ModifierScreen> {
  final _pageCltr = PageController();

  @override
  void dispose() {
    _pageCltr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assignPro = Provider.of<AssignModiPro>(context);
    final editModiPro = Provider.of<EditModiPro>(context);
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageCltr,
      children: [
        TagModifierScreen(
          onBackMain: widget.onBack,
          assignModifier: (val) {
            editModiPro.isEdit = val.fold<int>(
                    0,
                    (iV, e) =>
                        iV +
                        (e.productVariations?.fold<int>(
                                0, (pV, e) => pV + (e.modifierCount ?? 0)) ??
                            0)) >
                0;

            if (editModiPro.isEdit) {
              editModiPro.prodVarDataList =
                  val.map((a) => ProdWithVarData.fromJson(a.toJson())).toList();
            } else {
              assignPro.prodVarDataList =
                  val.map((a) => ProdWithVarData.fromJson(a.toJson())).toList();
            }

            editModiPro.notify;

            _pageCltr.animateToPage(1,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
        ),
        if (editModiPro.isEdit)
          EditModiferSec(
            onBack: () {
              _pageCltr.animateToPage(0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
          )
        else
          AssignModiferSec(
            onBack: () {
              _pageCltr.animateToPage(0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
          ),
      ],
    );
  }
}
