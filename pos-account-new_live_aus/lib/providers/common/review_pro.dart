import 'package:flutter/material.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/repository/handler.dart';
import '../../model/home/menu/payment/make_pay_res.dart';

class ReviewPro extends ChangeNotifier {
  void get notify => notifyListeners();

  ReviewQuestionUserViewModel? addReviewSec;

  bool pageLoading = false;

  makeReview() async {
    try {
      pageLoading = true;
      addReviewSec?.description = detailsCltr.text;
      final res = await Handler.addReview(
        req: addReviewSec,
      );
      if (res == true) {
        clear();
        pageLoading = false;
      }
      pageLoading = false;
      notify;
    } catch (e) {
      return false;
    }
  }

  final detailsCltr = TextEditingController();

  void clear() {
    GlobalCVP.showReview = false;
    GlobalCVP.reviewQuestionUserViewModel = null;
    addReviewSec = null;
    detailsCltr.clear();
  }
}
