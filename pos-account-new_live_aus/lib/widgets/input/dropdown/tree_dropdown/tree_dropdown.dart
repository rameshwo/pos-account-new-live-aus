import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pos_account/config/responsive.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/model/common/category.dart';
import 'package:pos_account/widgets/input/dropdown/tree_dropdown/com/custom_exp_tile.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';

const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;
const double _kMenuHorizontalPadding = 0.0;
const double _kMenuMinWidth = 2.0 * _kMenuWidthStep;
const double _kMenuVerticalPadding = 0.0;
const double _kMenuWidthStep = 1.0;
const double _kMenuScreenPadding = 0.0;

typedef PositionCallback = RelativeRect Function(
    RenderBox popupButtonObject, RenderBox overlay);

class BuildOverlayWidget extends StatefulWidget {
  final List<Category>? categoryList;
  final String? selectedId;
  final Function(String?)? onChanged;
  final Color? selectedColor;
  const BuildOverlayWidget({
    super.key,
    this.categoryList,
    this.selectedId,
    this.onChanged,
    this.selectedColor,
  });

  @override
  State<BuildOverlayWidget> createState() => _BuildOverlayWidgetState();
}

class _BuildOverlayWidgetState extends State<BuildOverlayWidget> {
  final searchCltr = TextEditingController();

  void load() {
    if (mounted) setState(() {});
  }

  Widget listWidget({
    Category? category,
    String? selectedId,
    int callCount = 0,
  }) {
    final size = Ssize(context);
    final _isLastItem = category?.childernCategories == null ||
        category!.childernCategories!.isEmpty;
    final _selected = selectedId != null &&
        category?.categoryId?.toLowerCase() == selectedId.toLowerCase();

    if (search(category: category))
      return CusExpTile(
        initiallyExpanded: true,
        dense: category?.categoryId == null,
        isSelected: _selected,
        backgroundColor: _selected ? widget.selectedColor : Colors.white,
        collapsedBackgroundColor: _selected ? widget.selectedColor : null,
        trailing: _isLastItem ? SizedBox.shrink() : null,
        onTap: category?.categoryId == null
            ? null
            : () {
                if (widget.onChanged != null) {
                  widget.onChanged!(category?.categoryId);
                }
                Navigator.pop(context);
              },
        title: Padding(
          padding: EdgeInsets.only(left: size.getW(callCount * 12)),
          child: Text(
            category?.categoryName ?? '',
            style: TextStyle(
              fontSize: size.getS(category?.categoryId == null ? 14 : 16),
              color: category?.categoryId == null
                  ? Colors.black54
                  : _selected
                      ? Colors.white
                      : Colors.black,
              fontWeight: category?.categoryId == null ? FontWeight.bold : null,
            ),
          ),
        ),
        children: [
          if (category?.childernCategories != null &&
              category!.childernCategories!.isNotEmpty)
            ...List.generate(
                category.childernCategories!.length,
                (index) => listWidget(
                      category: category.childernCategories?[index],
                      selectedId: selectedId,
                      callCount: callCount + 1,
                    )),
        ],
      );
    else
      return Container();
  }

  bool search({Category? category}) {
    if (searchCltr.text.isEmpty) return true;
    if (category?.categoryName == null) return true;
    if (category!.categoryName!
        .toLowerCase()
        .contains(searchCltr.text.toLowerCase())) return true;
    return category.childernCategories != null &&
        category.childernCategories!.isNotEmpty &&
        category.childernCategories!.any((e) => search(category: e));
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Material(
      elevation: 4,
      child: Container(
        constraints:
            BoxConstraints(maxHeight: size.getH(800), minHeight: size.getH(40)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: TextFormWidget(
                cltr: searchCltr,
                hintText: '',
                borderColor: Colors.black26,
                onChanged: (p0) {
                  load();
                },
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (widget.categoryList != null)
                      ...List.generate(
                          widget.categoryList!.length,
                          (index) => listWidget(
                                category: widget.categoryList?[index],
                                selectedId: widget.selectedId,
                              ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum Mode { DIALOG, MENU }

class TreeDropWidget extends StatefulWidget {
  final List<Category>? categoryList;
  final String? selectedId;
  final String hintText;
  final Function(String?)? onChanged;
  final Color borderColor;
  final double borderRadius;
  final String? title;
  final String? dropdownTitle;
  final bool isReq;
  final Widget? suffix;
  final double width;
  final double dialogWidth;
  final Mode mode;
  final Color? selectedColor;
  final double? vPad;
  final Widget? suffixIcon;
  const TreeDropWidget({
    super.key,
    this.categoryList,
    this.selectedId,
    this.hintText = '',
    this.onChanged,
    this.borderColor = Colors.black,
    this.borderRadius = 5,
    this.title,
    this.isReq = false,
    this.suffix,
    this.width = 400,
    this.mode = Mode.MENU,
    this.dialogWidth = 600,
    this.selectedColor,
    this.vPad,
    this.dropdownTitle,
    this.suffixIcon,
  });

  @override
  State<TreeDropWidget> createState() => _TreeDropWidgetState();
}

class _TreeDropWidgetState extends State<TreeDropWidget> {
  String? _selectedData({Category? category}) {
    if (category == null) return null;
    if (category.categoryId?.toLowerCase() == widget.selectedId?.toLowerCase())
      return category.categoryName;
    else {
      return _getSelectedDataFromList(catList: category.childernCategories);
    }
  }

  String? _getSelectedDataFromList({List<Category>? catList}) {
    if (catList == null || catList.isEmpty) return null;
    for (final e in catList) {
      final val = _selectedData(category: e);
      if (val != null) return val;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width,
        child: TitleTextForm(
          textCltr: TextEditingController(
              text: _getSelectedDataFromList(catList: widget.categoryList)),
          hintText: widget.hintText,
          readOnly: true,
          isReq: widget.isReq,
          suffix: widget.suffix,
          borderColor: widget.borderColor,
          borderRadius: widget.borderRadius,
          onTap: widget.mode == Mode.MENU ? _openMenu : _openSelectDialog,
          title: widget.title,
          vPad: widget.vPad ?? (Responsive.isDesktop(context) ? 6 : 10),
          suffixIcon: widget.suffixIcon,
        ));
  }

  ///open dialog
  Future _openSelectDialog() {
    return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 400),
      barrierColor: const Color(0x80000000),
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        final size = Ssize(context);
        return SafeArea(
          child: AlertDialog(
            titlePadding: EdgeInsets.symmetric(
                horizontal: size.getW(12), vertical: size.getH(16)),
            title: Row(
              children: [
                if (widget.dropdownTitle?.isNotEmpty ?? false)
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                          text: widget.dropdownTitle,
                          style: TextStyle(
                            fontSize: size.getS(18),
                            color: Colors.black,
                          ),
                          children: widget.isReq
                              ? [
                                  TextSpan(
                                    text: " *",
                                    style: TextStyle(
                                      fontSize: size.getS(18),
                                      color: Colors.red,
                                    ),
                                  )
                                ]
                              : null),
                    ),
                  ),
                if (widget.suffix != null) widget.suffix!
              ],
            ),
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: widget.dialogWidth,
              child: _overlayWidget,
            ),
          ),
        );
      },
    );
  }

  ///openMenu
  Future _openMenu({
    PositionCallback? positionCallback,
  }) {
    final popupButtonObject = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    return customShowMenu(
        context: context,
        position: (positionCallback ?? _position)(popupButtonObject, overlay),
        items: [
          CustomPopupMenuItem(
            child: SizedBox(
              width: popupButtonObject.size.width,
              child: _overlayWidget,
            ),
          ),
        ]);
  }

  Widget get _overlayWidget => BuildOverlayWidget(
        categoryList: widget.categoryList,
        selectedId: widget.selectedId,
        onChanged: widget.onChanged,
        selectedColor: widget.selectedColor,
      );
}

RelativeRect _position(RenderBox popupButtonObject, RenderBox overlay) {
  // Calculate the show-up area for the dropdown using button's size & position based on the `overlay` used as the coordinate space.
  return RelativeRect.fromSize(
    Rect.fromPoints(
      popupButtonObject.localToGlobal(
          popupButtonObject.size.bottomLeft(Offset.zero),
          ancestor: overlay),
      popupButtonObject.localToGlobal(
          popupButtonObject.size.bottomRight(Offset.zero),
          ancestor: overlay),
    ),
    Size(overlay.size.width, overlay.size.height),
  );
}

Future<T?> customShowMenu<T>({
  required BuildContext context,
  required RelativeRect position,
  required List<PopupMenuEntry<T>> items,
  T? initialValue,
  double? elevation,
  String? semanticLabel,
  Color? barrierColor,
  ShapeBorder? shape,
  Color? color,
  bool captureInheritedThemes = true,
  bool useRootNavigator = false,
  PopupSafeAreaProps popupSafeArea = const PopupSafeAreaProps(),
  bool barrierDismissible = true,
}) {
  assert(items.isNotEmpty);
  assert(debugCheckHasMaterialLocalizations(context));

  String? label = semanticLabel;
  switch (Theme.of(context).platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      label = semanticLabel;
      break;
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      label = semanticLabel ?? MaterialLocalizations.of(context).popupMenuLabel;
  }

  return Navigator.of(context, rootNavigator: useRootNavigator).push(
    _PopupMenuRoute<T>(
      position: position,
      items: items,
      initialValue: initialValue,
      elevation: elevation,
      semanticLabel: label,
      theme: Theme.of(context),
      popupMenuTheme: PopupMenuTheme.of(context),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor,
      shape: shape,
      color: color,
      showMenuContext: context,
      captureInheritedThemes: captureInheritedThemes,
      popupSafeArea: popupSafeArea,
    ),
  );
}

class _PopupMenuRoute<T> extends PopupRoute<T> {
  _PopupMenuRoute({
    this.position,
    required this.items,
    this.initialValue,
    this.elevation,
    this.theme,
    this.popupMenuTheme,
    this.barrierLabel,
    this.semanticLabel,
    this.shape,
    this.color,
    this.showMenuContext,
    this.captureInheritedThemes,
    this.barrierColor,
    this.popupSafeArea = const PopupSafeAreaProps(),
    this.popupBarrierDismissible = true,
  }) : itemSizes = List<Size?>.filled(items.length, null, growable: false);

  final RelativeRect? position;
  final List<PopupMenuEntry<T>> items;
  final List<Size?> itemSizes;
  final T? initialValue;
  final double? elevation;
  final ThemeData? theme;
  final String? semanticLabel;
  final ShapeBorder? shape;
  final Color? color;
  final PopupMenuThemeData? popupMenuTheme;
  final BuildContext? showMenuContext;
  final bool? captureInheritedThemes;
  @override
  final Color? barrierColor;
  final PopupSafeAreaProps popupSafeArea;
  final bool popupBarrierDismissible;

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linear,
      reverseCurve: const Interval(0.0, _kMenuCloseIntervalEnd),
    );
  }

  @override
  Duration get transitionDuration => _kMenuDuration;

  @override
  bool get barrierDismissible => popupBarrierDismissible;

  @override
  final String? barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    int? selectedItemIndex;
    if (initialValue != null) {
      for (int index = 0;
          selectedItemIndex == null && index < items.length;
          index += 1) {
        if (items[index].represents(initialValue)) selectedItemIndex = index;
      }
    }

    Widget menu = _PopupMenu<T>(route: this, semanticLabel: semanticLabel);
    if (captureInheritedThemes!) {
      menu = InheritedTheme.captureAll(showMenuContext!, menu);
    } else {
      // For the sake of backwards compatibility. An (unlikely) app that relied
      // on having menus only inherit from the material Theme could set
      // captureInheritedThemes to false and get the original behavior.
      if (theme != null) menu = Theme(data: theme!, child: menu);
    }

    return SafeArea(
      top: popupSafeArea.top,
      bottom: popupSafeArea.bottom,
      left: popupSafeArea.left,
      right: popupSafeArea.right,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _PopupMenuRouteLayout(
              position,
              itemSizes,
              selectedItemIndex,
              Directionality.of(context),
            ),
            child: menu,
          );
        },
      ),
    );
  }
}

// Positioning of the menu on the screen.
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenuRouteLayout(this.position, this.itemSizes, this.selectedItemIndex,
      this.textDirection);

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect? position;

  // The sizes of each item are computed when the menu is laid out, and before
  // the route is laid out.
  List<Size?> itemSizes;

  // The index of the selected item, or null if PopupMenuButton.initialValue
  // was not specified.
  final int? selectedItemIndex;

  // Whether to prefer going to the left or to the right.
  final TextDirection textDirection;

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest -
            const Offset(_kMenuScreenPadding * 2.0, _kMenuScreenPadding * 2.0)
        as Size);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    // Find the ideal vertical position.
    double y = position!.top;
    if (selectedItemIndex != null) {
      double selectedItemOffset = _kMenuVerticalPadding;
      for (int index = 0; index < selectedItemIndex!; index += 1)
        selectedItemOffset += itemSizes[index]!.height;
      selectedItemOffset += itemSizes[selectedItemIndex!]!.height / 2;
      y = position!.top +
          (size.height - position!.top - position!.bottom) / 2.0 -
          selectedItemOffset;
    }

    // Find the ideal horizontal position.
    late double x;
    if (position!.left > position!.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position!.right - childSize.width;
    } else if (position!.left < position!.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position!.left;
    } else {
      // Menu button is equidistant from both edges, so grow in reading direction.
      switch (textDirection) {
        case TextDirection.rtl:
          x = size.width - position!.right - childSize.width;
          break;
        case TextDirection.ltr:
          x = position!.left;
          break;
      }
    }

    // Avoid going outside an area defined as the rectangle 8.0 pixels from the
    // edge of the screen in every direction.
    if (x < _kMenuScreenPadding)
      x = _kMenuScreenPadding;
    else if (x + childSize.width > size.width - _kMenuScreenPadding)
      x = size.width - childSize.width - _kMenuScreenPadding;
    if (y < _kMenuScreenPadding)
      y = _kMenuScreenPadding;
    else if (y + childSize.height > size.height - _kMenuScreenPadding)
      y = size.height - childSize.height - _kMenuScreenPadding;
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    // If called when the old and new itemSizes have been initialized then
    // we expect them to have the same length because there's no practical
    // way to change length of the items list once the menu has been shown.
    assert(itemSizes.length == oldDelegate.itemSizes.length);

    return position != oldDelegate.position ||
        selectedItemIndex != oldDelegate.selectedItemIndex ||
        textDirection != oldDelegate.textDirection ||
        !listEquals(itemSizes, oldDelegate.itemSizes);
  }
}

bool listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  if (identical(a, b)) return true;
  for (int index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) return false;
  }
  return true;
}

class _PopupMenu<T> extends StatelessWidget {
  const _PopupMenu({
    super.key,
    this.route,
    this.semanticLabel,
  });

  final _PopupMenuRoute<T>? route;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final double unit = 1.0 /
        (route!.items.length +
            1.5); // 1.0 for the width and 0.5 for the last item's fade.
    final List<Widget> children = <Widget>[];
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);

    for (int i = 0; i < route!.items.length; i += 1) {
      final double start = (i + 1) * unit;
      final double end = (start + 1.5 * unit).clamp(0.0, 1.0);
      final CurvedAnimation opacity = CurvedAnimation(
        parent: route!.animation!,
        curve: Interval(start, end),
      );
      Widget item = route!.items[i];
      if (route!.initialValue != null &&
          route!.items[i].represents(route!.initialValue)) {
        item = Container(
          color: Theme.of(context).highlightColor,
          child: item,
        );
      }
      children.add(
        _MenuItem(
          onLayout: (Size size) {
            route!.itemSizes[i] = size;
          },
          child: FadeTransition(
            opacity: opacity,
            child: item,
          ),
        ),
      );
    }

    final CurveTween opacity =
        CurveTween(curve: const Interval(0.0, 1.0 / 3.0));
    final CurveTween width = CurveTween(curve: Interval(0.0, unit));
    final CurveTween height =
        CurveTween(curve: Interval(0.0, unit * route!.items.length));

    final Widget child = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: _kMenuMinWidth),
      child: IntrinsicWidth(
        stepWidth: _kMenuWidthStep,
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: semanticLabel,
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(vertical: _kMenuVerticalPadding),
            child: ListBody(children: children),
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: route!.animation!,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: opacity.evaluate(route!.animation!),
          child: Material(
            shape: route!.shape ?? popupMenuTheme.shape,
            color: route!.color ?? popupMenuTheme.color,
            type: MaterialType.card,
            elevation: route!.elevation ?? popupMenuTheme.elevation ?? 8.0,
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              widthFactor: width.evaluate(route!.animation!),
              heightFactor: height.evaluate(route!.animation!),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

class _MenuItem extends SingleChildRenderObjectWidget {
  const _MenuItem({
    required this.onLayout,
    super.child,
  });

  final ValueChanged<Size> onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMenuItem(onLayout);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderMenuItem renderObject) {
    renderObject.onLayout = onLayout;
  }
}

class _RenderMenuItem extends RenderShiftedBox {
  _RenderMenuItem(this.onLayout, [RenderBox? child]) : super(child);

  ValueChanged<Size> onLayout;

  @override
  void performLayout() {
    if (child == null) {
      size = Size.zero;
    } else {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
    }
    final BoxParentData childParentData = child!.parentData as BoxParentData;
    childParentData.offset = Offset.zero;
    onLayout(size);
  }
}

class PopupSafeAreaProps {
  /// Whether to avoid system intrusions on the left.
  final bool left;

  /// Whether to avoid system intrusions at the top of the screen, typically the
  /// system status bar.
  final bool top;

  /// Whether to avoid system intrusions on the right.
  final bool right;

  /// Whether to avoid system intrusions on the bottom side of the screen.
  final bool bottom;

  /// This minimum padding to apply.
  ///
  /// The greater of the minimum insets and the media padding will be applied.
  final EdgeInsets minimum;

  /// Specifies whether the [SafeArea] should maintain the
  /// [MediaQueryData.viewPadding] instead of the [MediaQueryData.padding] when
  /// consumed by the [MediaQueryData.viewInsets] of the current context's
  /// [MediaQuery], defaults to false.
  ///
  /// For example, if there is an onscreen keyboard displayed above the
  /// SafeArea, the padding can be maintained below the obstruction rather than
  /// being consumed. This can be helpful in cases where your layout contains
  /// flexible widgets, which could visibly move when opening a software
  /// keyboard due to the change in the padding value. Setting this to true will
  /// avoid the UI shift.
  final bool maintainBottomViewPadding;

  const PopupSafeAreaProps({
    this.left = false,
    this.top = false,
    this.right = false,
    this.bottom = false,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
  });
}

class CustomPopupMenuItem<T> extends PopupMenuEntry<T> {
  /// Creates an item for a popup menu.
  ///
  /// By default, the item is [enabled].
  ///
  /// The `enabled` and `height` arguments must not be null.
  const CustomPopupMenuItem({
    super.key,
    this.value,
    this.height = kMinInteractiveDimension,
    this.textStyle,
    required this.child,
  });

  /// The value that will be returned by [customShowMenu] if this entry is selected.
  final T? value;

  /// Whether the user is permitted to select this item.
  ///
  /// Defaults to true. If this is false, then the item will not react to
  /// touches.

  /// The minimum height height of the menu item.
  ///
  /// Defaults to [kMinInteractiveDimension] pixels.
  @override
  final double height;

  /// The text style of the popup menu item.
  ///
  /// If this property is null, then [PopupMenuThemeData.textStyle] is used.
  /// If [PopupMenuThemeData.textStyle] is also null, then [ThemeData.textTheme.subhead] is used.
  final TextStyle? textStyle;

  /// The widget below this widget in the tree.
  ///
  /// Typically a single-line [ListTile] (for menus with icons) or a [Text]. An
  /// appropriate [DefaultTextStyle] is put in scope for the child. In either
  /// case, the text should be short enough that it won't wrap.
  final Widget child;

  @override
  bool represents(T? value) => value == this.value;

  @override
  PopupMenuItemState<T, CustomPopupMenuItem<T>> createState() =>
      PopupMenuItemState<T, CustomPopupMenuItem<T>>();
}

class PopupMenuItemState<T, W extends CustomPopupMenuItem<T>> extends State<W> {
  /// The menu item contents.
  ///
  /// Used by the [build] method.
  ///
  /// By default, this returns [CustomPopupMenuItem.child]. Override this to put
  /// something else in the menu entry.
  @protected
  Widget buildChild() => widget.child;

  /// The handler for when the user selects the menu item.
  ///
  /// Used by the [InkWell] inserted by the [build] method.
  ///
  /// By default, uses [Navigator.pop] to return the [CustomPopupMenuItem.value] from
  /// the menu route.
  @protected
  void handleTap() {
    Navigator.pop<T>(context, widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    TextStyle? style = widget.textStyle ??
        popupMenuTheme.textStyle ??
        theme.textTheme.titleSmall;

    Widget item = AnimatedDefaultTextStyle(
      style: style!,
      duration: kThemeChangeDuration,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        constraints: BoxConstraints(minHeight: widget.height),
        padding:
            const EdgeInsets.symmetric(horizontal: _kMenuHorizontalPadding),
        child: buildChild(),
      ),
    );

    return InkWell(
      onTap: null,
      canRequestFocus: false,
      child: item,
    );
  }
}
