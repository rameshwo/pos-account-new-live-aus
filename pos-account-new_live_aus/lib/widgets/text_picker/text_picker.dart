import 'package:flutter/material.dart';

// typedef TextMapper = String Function(String numberText);

class TextPicker extends StatefulWidget {
  final List<String> list;
  final int selectedInt;

  final Function(int) onChanged;

  final double itemHeight;

  final double itemWidth;

  final Axis axis;

  final TextStyle? textStyle;

  final TextStyle? selectedTextStyle;

  const TextPicker({
    super.key,
    required this.onChanged,
    this.itemHeight = 50,
    this.itemWidth = 340,
    this.axis = Axis.vertical,
    this.textStyle,
    this.selectedTextStyle,
    required this.list,
    required this.selectedInt,
  });

  @override
  _TextPickerState createState() => _TextPickerState();
}

class _TextPickerState extends State<TextPicker> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final initialOffset = widget.selectedInt * itemExtent;
    _scrollController = ScrollController(initialScrollOffset: initialOffset);

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    var indexOfMiddleElement = (_scrollController.offset / itemExtent).round();

    indexOfMiddleElement = indexOfMiddleElement.clamp(0, itemCount - 1);

    final intValueInTheMiddle = _intValueFromIndex(indexOfMiddleElement);

    if ((widget.selectedInt) != intValueInTheMiddle) {
      widget.onChanged(intValueInTheMiddle);
    }
    Future.delayed(
      Duration(milliseconds: 100),
      () => _maybeCenterValue(),
    );
  }

  @override
  void didUpdateWidget(TextPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedInt != widget.selectedInt) {
      _maybeCenterValue();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get isScrolling => _scrollController.position.isScrollingNotifier.value;

  double get itemExtent =>
      widget.axis == Axis.vertical ? widget.itemHeight : widget.itemWidth;

  int get itemCount => getList.length;

  List<String> get getList => ["", ""] + widget.list + ["", ""];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.axis == Axis.vertical
          ? widget.itemWidth
          : getList.length * widget.itemWidth,
      height: widget.axis == Axis.vertical
          ? widget.itemHeight * 5
          : widget.itemHeight,
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (not) {
          if (not.dragDetails?.primaryVelocity == 0) {
            Future.microtask(() => _maybeCenterValue());
          }
          return true;
        },
        child: Stack(
          children: [
            ListView.builder(
              itemCount: itemCount,
              physics: BouncingScrollPhysics(),
              scrollDirection: widget.axis,
              controller: _scrollController,
              itemExtent: itemExtent,
              itemBuilder: _itemBuilder,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final themeData = Theme.of(context);
    final defaultStyle = widget.textStyle ?? themeData.textTheme.bodyMedium;
    final selectedStyle = themeData.textTheme.bodySmall;

    final value = _intValueFromIndex((index % itemCount));
    final itemStyle = value == widget.selectedInt + 2
        ? (widget.selectedTextStyle ?? selectedStyle)
        : defaultStyle;

    final child = Text(
      getList[index],
      style: itemStyle,
    );

    return Container(
      width: widget.itemWidth,
      height: widget.itemHeight,
      alignment: Alignment.center,
      child: child,
    );
  }

  int _intValueFromIndex(int index) {
    index %= itemCount;
    return index;
  }

  void _maybeCenterValue() {
    if (_scrollController.hasClients && !isScrolling) {
      _scrollController.animateTo(
        widget.selectedInt * itemExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }
}
