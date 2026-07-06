import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

class TableSelectionGuide extends StatelessWidget {
  const TableSelectionGuide({super.key});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(size.getS(16.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.table_bar,
                        size: size.getS(20),
                        color: const Color(0xFF10B981), // emerald-500
                      ),
                      SizedBox(width: size.getW(8)),
                      Text(
                        'Select a Table',
                        style: TextStyle(
                          fontSize: size.getS(18),
                          fontFamily: kFontFRegular,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                'Please select a table before placing your order',
                style: TextStyle(
                  fontSize: size.getS(14),
                  fontFamily: kFontFRegular,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              size.getW(16), 0, size.getW(16), size.getW(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStep(
                number: 1,
                title: 'Find an available table',
                description: 'Look for tables marked with an ',
                tag: 'Available',
                size: size,
              ),
              SizedBox(height: size.getH(16)),
              _buildStep(
                number: 2,
                title: 'Click on your preferred table',
                description:
                    'Click directly on the table icon or number to select it.',
                showPointer: true,
                size: size,
              ),
              SizedBox(height: size.getH(16)),
              _buildStep(
                number: 3,
                title: 'Proceed to place your order',
                description:
                    'After selecting a table, you\'ll be able to browse the menu and place your order.',
                size: size,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: EdgeInsets.all(size.getS(16.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: size.getS(16),
                    color: Colors.amber[500],
                  ),
                  SizedBox(width: size.getW(8)),
                  Expanded(
                    child: Text(
                      'Your table selection will be reserved for 30 minutes while you place your order.',
                      style: TextStyle(
                        fontSize: size.getS(14),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.getH(12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep({
    required int number,
    required String title,
    required String description,
    String? tag,
    bool showPointer = false,
    required Ssize size,
  }) {
    return Container(
      padding: EdgeInsets.all(size.getS(12)),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: size.getS(24),
                height: size.getS(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981), // emerald-500
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.getS(12),
                      fontFamily: kFontFRegular,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: size.getW(8)),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: size.getS(16),
                    fontFamily: kFontFMedium,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.getH(8)),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: size.getS(14),
                fontFamily: kFontFMedium,
                color: Colors.grey[600],
              ),
              children: [
                if (showPointer)
                  WidgetSpan(
                    child: Icon(
                      Icons.mouse,
                      size: size.getS(12),
                    ),
                    alignment: PlaceholderAlignment.middle,
                  ),
                TextSpan(text: description),
                if (tag != null) ...[
                  const TextSpan(text: ' '),
                  WidgetSpan(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.getH(8),
                        vertical: size.getW(2),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981), // emerald-500
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.getS(12),
                          fontFamily: kFontFMedium,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  TextSpan(
                      text: ' tag.',
                      style: TextStyle(
                        fontSize: size.getS(12),
                        fontFamily: kFontFMedium,
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
