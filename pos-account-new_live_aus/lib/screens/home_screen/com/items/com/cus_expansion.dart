import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class CusExpansion extends StatefulWidget {
  const CusExpansion({
    super.key,
    required this.title,
    this.showMoreText,
    this.showLessText,
    this.children = const <Widget>[],
    this.initiallyExpanded = false,
  });

  final Widget title;

  final String? showMoreText;
  final String? showLessText;

  final List<Widget> children;

  final bool initiallyExpanded;

  @override
  State<CusExpansion> createState() => _CusExpansionState();
}

class _CusExpansionState extends State<CusExpansion>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<Color?> _borderColor;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.of(context).readState(context) as bool? ??
        widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
    // widget.onExpansionChanged?.call(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;
    final size = Ssize(context);

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor.value ?? Colors.transparent,
        border: Border(
          top: BorderSide(color: borderSideColor),
          bottom: BorderSide(color: borderSideColor),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTileTheme.merge(
              iconColor: _iconColor.value,
              textColor: _headerColor.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.title,
                  InkWell(
                    onTap: _handleTap,
                    child: Text(
                      _isExpanded
                          ? (widget.showLessText ?? 'View less')
                          : (widget.showMoreText ?? 'View more'),
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: size.getS(14),
                        color: kSecondaryColor,
                      ),
                    ),
                  )
                ],
              )),
          ClipRect(
            child: Align(
              alignment: Alignment.center,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    _borderColorTween.end = theme.dividerColor;
    _headerColorTween
      ..begin = theme.textTheme.titleSmall!.color
      ..end = colorScheme.primary;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = colorScheme.primary;
    _backgroundColorTween
      ..begin = null
      ..end = null;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.children,
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}
