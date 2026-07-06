import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/widgets/loading.dart';

class KitchenView extends StatelessWidget {
  const KitchenView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Processing(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height / 1.2,
          minHeight: size.height / 5,
        ),
        width: size.width / 1.17,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Laxman Sharma',
                      style: TextStyle(
                        fontSize: size.getS(20),
                        color: kPrimaryColor,
                        fontFamily: kFontFMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text.rich(TextSpan(
                      text: '04:42 PM | Order No : #5435324332',
                      style: TextStyle(
                        fontSize: size.getS(16),
                        fontFamily: kFontFMedium,
                        color: Colors.black,
                      ),
                    )),
                  ],
                ),
                SizedBox(width: size.getW(48)),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.blue.withAlpha(60),
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(
                      vertical: size.getH(4), horizontal: size.getW(12)),
                  child: Text(
                    'New Order',
                    style: TextStyle(
                      fontSize: size.getS(14),
                      fontFamily: kFontFMedium,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close))
              ],
            ),
            Divider(
              color: Colors.black87,
              thickness: 0.6,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "item list",
                    style: TextStyle(
                      fontSize: size.getS(18),
                      color: kPrimaryColor,
                      fontFamily: kFontFMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1 X Momo with Sausage',
                              style: TextStyle(
                                fontSize: size.getS(16),
                                fontFamily: kFontFMedium,
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: size.getW(12)),
                              child: Column(
                                children: List.generate(
                                  3,
                                  (j) => Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "1 X ",
                                        style: TextStyle(
                                          fontSize: size.getS(14),
                                          fontFamily: kFontFMedium,
                                          color: Colors.black54,
                                          height: 1.15,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          'Spicy Mayo',
                                          style: TextStyle(
                                            fontSize: size.getS(14),
                                            fontFamily: kFontFMedium,
                                            color: Colors.black54,
                                            height: 1.15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  // border: Border.all(),
                                  borderRadius: BorderRadius.circular(5)),
                              // padding: EdgeInsets.symmetric(
                              //     vertical: size.getH(2), horizontal: size.getW(12)),
                              child: Text(
                                'Description: "Make it spicy and hot"',
                                style: TextStyle(
                                  fontSize: size.getS(14),
                                  fontFamily: kFontFMedium,
                                  color: Colors.yellow.shade900,
                                ),
                              ),
                            ),
                            Divider(
                              height: 8,
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.withAlpha(60),
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.symmetric(
                            vertical: size.getH(4), horizontal: size.getW(12)),
                        child: Text(
                          'Pending',
                          style: TextStyle(
                            fontSize: size.getS(14),
                            fontFamily: kFontFMedium,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
