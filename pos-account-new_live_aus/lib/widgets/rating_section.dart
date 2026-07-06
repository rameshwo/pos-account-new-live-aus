import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../config/size_config.dart';

class RatingSection extends StatelessWidget {
  final double initialRating;
  final Function(double) onRatingUpdate;
  final bool ignoreGes;
  const RatingSection({
    super.key,
    required this.onRatingUpdate,
    this.initialRating = 0.0,
    this.ignoreGes = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              5,
              (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.getW(6)),
                    child: Icon(Icons.star_outline,
                        color: Colors.grey.shade500, size: size.getS(32)),
                  )),
        ),
        RatingBar.builder(
          unratedColor: Colors.transparent,
          initialRating: initialRating,
          minRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: false,
          ignoreGestures: ignoreGes,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: size.getW(6)),
          itemSize: size.getS(32),
          itemBuilder: (context, val) {
            return Icon(
              Icons.star,
              color: Colors.amber.shade400,
            );
          },
          onRatingUpdate: onRatingUpdate,
        ),
      ],
    );
  }
}
