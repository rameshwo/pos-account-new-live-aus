import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';

class PinLockSection extends StatefulWidget {
  final bool loading;
  final Widget? topWidget;
  final Decoration? decoration;
  final bool isSection;
  final Future<void> Function({
    required String pin,
    required void Function() clear,
  }) validate;

  const PinLockSection({
    super.key,
    this.loading = false,
    required this.validate,
    this.topWidget,
    this.decoration,
    this.isSection = false,
  });

  @override
  State<PinLockSection> createState() => _PinLockSectionState();
}

class _PinLockSectionState extends State<PinLockSection> {
  String pin = ''; // Store the entered pin
  List<bool> pinToDot =
      []; // Track whether to show bold dot for each pin entered

  void load() {
    if (mounted) setState(() {});
  }

  void _addToPin(String number) {
    if (pin.length < 4) {
      pin += number;
      pinToDot.add(false);
      load();

      if (pin.length > 1) pinToDot[pin.length - 2] = true;

      Utils.handleSearch(callback: () async {
        if (mounted && pinToDot.isNotEmpty && pinToDot.length >= pin.length) {
          pinToDot[pin.length - 1] = true;
          load();
        }
      });
      if (pin.length == 4) {
        widget.validate(
            pin: pin,
            clear: () {
              pin = '';
              pinToDot.clear();
              load();
            });
      }
    }
  }

  double get _fRatio => widget.isSection ? 0.75 : 1;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Container(
      decoration: widget.decoration ??
          BoxDecoration(
            border: Border.all(color: kSecondaryColor, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (!widget.isSection) ...[
            widget.loading
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.getW(24)),
                    child: LinearProgressIndicator(),
                  )
                : SizedBox(height: 4)
          ],
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: size.getW(350 * _fRatio),
                  ),
                  child: Column(
                    mainAxisAlignment: widget.isSection
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                          (index) => _buildPinIndicator(size, index),
                        ),
                      ),
                      if (widget.isSection)
                        SizedBox(
                          height: size.getH(12),
                        ),
                      Flexible(
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: 12,
                          padding:
                              EdgeInsets.symmetric(vertical: size.getH(12)),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing:
                                size.getS(widget.isSection ? 12 : 24),
                            mainAxisSpacing:
                                size.getS(widget.isSection ? 12 : 24),
                          ),
                          itemBuilder: (context, index) {
                            if (index == 9) {
                              return _buildDeleteKey(size);
                            } else if (index == 10) {
                              return _buildKey('0', size);
                            } else if (index == 11) {
                              return SizedBox.shrink();
                            } else {
                              return _buildKey('${index + 1}', size);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.topWidget != null) widget.topWidget!
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinIndicator(Ssize size, int index) {
    final text = index < pin.length ? pin[index] : null;
    final showDot = index < pinToDot.length ? pinToDot[index] : false;

    return SizedBox(
      width: size.getS(54 * _fRatio),
      height: size.getS(44 * _fRatio),
      child: AnimatedSwitcher(
        duration:
            const Duration(milliseconds: 300), // Duration of the animation
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: showDot
            ? Container(
                key: ValueKey('dot_$index'),
                width: size.getS(32 * _fRatio),
                height: size.getS(32 * _fRatio),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryColor,
                ),
              )
            : text != null
                ? Text(
                    text,
                    key: ValueKey('text_$index'),
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: size.getS(44 * _fRatio),
                      fontFamily: kFontFMedium,
                      height: 1.2,
                      // decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
                    child: Container(
                      key: ValueKey('empty_$index'),
                      height: size.getS(32 * _fRatio),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: kSecondaryColor, width: 2),
                        color: Colors.transparent,
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildKey(String number, Ssize size) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: widget.isSection
            ? Border.all(color: kSecondaryColor, width: 2)
            : null,
        gradient: widget.isSection
            ? null
            : LinearGradient(
                colors: [
                  // Colors.white,
                  kSecondaryColor,
                  kPrimaryColor
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
      ),
      child: ElevatedButton(
        onPressed: () => _addToPin(number),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          elevation: 6,
          padding: const EdgeInsets.all(12),
        ),
        child: Text(
          number,
          style: TextStyle(
            fontSize: size.getS(44 * _fRatio),
            color: widget.isSection ? kSecondaryColor : Colors.white,
            fontFamily: kFontFBold,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteKey(Ssize size) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: widget.isSection
            ? Border.all(color: kSecondaryColor, width: 2)
            : null,
        gradient: widget.isSection
            ? null
            : LinearGradient(
                colors: [
                  // Colors.white,
                  kSecondaryColor,
                  kPrimaryColor
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
      ),
      child: IconButton(
        onPressed: () {
          if (pin.isNotEmpty) {
            pin = pin.substring(0, pin.length - 1);
            pinToDot.removeLast(); // Remove the last tracked digit
            load();
          }
        },
        splashRadius: size.getS(54),
        icon: Icon(
          Icons.backspace_outlined,
          color: widget.isSection ? kSecondaryColor : Colors.white,
          size: size.getS(36 * _fRatio),
        ),
      ),
    );
  }
}
