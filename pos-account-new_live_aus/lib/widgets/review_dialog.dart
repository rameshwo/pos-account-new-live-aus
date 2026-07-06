import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/size_config.dart';
import '../constant/constant.dart';
import '../ln.dart';
import '../providers/common/review_pro.dart';
import 'input/text_form/text_form_widget.dart';
import 'rating_section.dart';

class ShowReviewDialog extends StatelessWidget {
  const ShowReviewDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<ReviewPro>(context);
    final size = Ssize(context);
    return SimpleDialog(
      titlePadding: EdgeInsets.symmetric(
          horizontal: size.getW(24), vertical: size.getH(8)),
      contentPadding: EdgeInsets.symmetric(
          horizontal: size.getW(48), vertical: size.getH(16)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      children: [
        Column(
          children: [
            SizedBox(height: size.getH(16)),
            Text(
              LN.giveUsRating,
              style: TextStyle(
                color: Colors.black,
                fontSize: size.getS(18),
                fontFamily: kFontFMedium,
              ),
            ),
            // Center(
            //     child: RatingSection(
            //   initialRating: _qrPro.reviewAddSec!
            //           .fold<double>(0, (pV, eV) => pV + eV.rating) /
            //       _qrPro.reviewAddSec!.length,
            //   ignoreGes: true,
            //   onRatingUpdate: (double val) {},
            // )),
            SizedBox(height: size.getS(24)),
            ...List.generate(pro.addReviewSec?.reviewQuestions?.length ?? 0,
                (i) {
              return _ratingSection(
                size: size,
                title: pro.addReviewSec?.reviewQuestions![i].question ?? "",
                rate: double.parse(
                    "${pro.addReviewSec?.reviewQuestions![i].ratings ?? 0.0}"),
                onUpdate: (double val) {
                  pro.addReviewSec?.reviewQuestions![i].ratings =
                      val.toString();
                  pro.notify;
                },
              );
            }),
            TextFormWidget(
              cltr: pro.detailsCltr,
              hintText: LN.shareDetails,
              maxLines: 5,
              borderColor: Colors.black45,
            ),
            SizedBox(height: size.getS(16)),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                onPressed: pro.pageLoading
                    ? null
                    : () {
                        pro.clear();
                        Navigator.pop(context);
                      },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                        horizontal: size.getW(36), vertical: size.getH(8))),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        side: BorderSide(
                          color: kPrimaryColor,
                        ),
                        borderRadius: BorderRadius.circular(5)))),
                child: Text(
                  LN.cancel,
                  style: TextStyle(
                    fontFamily: kFontFMedium,
                    fontSize: size.getS(16),
                  ),
                ),
              ),
              SizedBox(width: size.getW(12)),
              TextButton(
                  onPressed: pro.pageLoading
                      ? null
                      : () async {
                          await pro.makeReview();
                        },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          horizontal: size.getW(36), vertical: size.getH(8))),
                      backgroundColor:
                          MaterialStateProperty.all(kPrimaryColor)),
                  child: Text(
                    LN.confirm,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: kFontFMedium,
                      fontSize: size.getS(16),
                    ),
                  ))
            ]),
          ],
        ),
      ],
    );
  }

  Widget _ratingSection({
    required String title,
    required Ssize size,
    required Function(double) onUpdate,
    double rate = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.getH(12)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: size.getS(16),
                  fontFamily: kFontFMedium),
            ),
          ),
          SizedBox(width: size.getW(12)),
          RatingSection(
            initialRating: rate,
            onRatingUpdate: onUpdate,
          )
        ],
      ),
    );
  }
}
