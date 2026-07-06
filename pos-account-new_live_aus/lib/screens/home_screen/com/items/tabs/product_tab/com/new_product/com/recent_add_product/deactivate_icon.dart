import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';

class DeactivateIcon<T> extends StatelessWidget {
  final Ssize size;
  final T? isActive;
  final Function()? onTap;
  const DeactivateIcon({
    super.key,
    required this.size,
    this.isActive,
    this.onTap,
  });

  bool get active {
    if (isActive != null) {
      if (isActive is String) {
        return isActive == "true";
      } else if (isActive is bool) {
        return isActive as bool;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: active ? Border.all(color: Colors.black26) : null,
          color: active ? Colors.transparent : Colors.grey.withOpacity(0.1)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(size.getS(6)),
          child: Icon(
            active ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            size: size.getS(24),
            color: active ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }
}
