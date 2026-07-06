import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';

class PaginateButton extends StatelessWidget {
  final int pageSize;
  final int total;
  final int pageIndex;
  final Function()? prev;
  final Function()? next;
  final bool? removePaddings;
  const PaginateButton({
    super.key,
    this.prev,
    this.next,
    this.pageSize = 10,
    required this.total,
    required this.pageIndex,
    this.removePaddings,
  });

  @override
  Widget build(BuildContext context) {
    int i = 0, j = 0;

    j = pageIndex * pageSize;
    i = j - (pageSize - 1);

    if (total < j) j = total;
    final pageText = "$i-$j of $total";
    final size = Ssize(context);
    return Align(
      alignment: Alignment.bottomRight,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: size.getH(12)),
        child: Padding(
          padding: removePaddings ?? false
              ? EdgeInsets.zero
              : EdgeInsets.symmetric(horizontal: size.getW(12)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: size.getW(12),
              ),
              Text(
                pageText,
                style: TextStyle(
                  fontSize: size.getS(16),
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: size.getW(18),
              ),
              IconButton(
                  onPressed: pageIndex > 1 ? prev : null,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: size.getS(18),
                  )),
              SizedBox(
                width: size.getW(12),
              ),
              IconButton(
                  onPressed: pageIndex * pageSize < total ? next : null,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: size.getS(18),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
