import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widget/fiterable_l.dart';

class EasyAutocomplete extends StatefulWidget {
  /// The list of suggestions to be displayed
  final List<String>? suggestions;

  /// Fetches list of suggestions from a Future
  final Future<List<String>> Function(String searchValue)? asyncSuggestions;

  /// Text editing controller
  final TextEditingController? controller;

  /// Can be used to decorate the input
  final InputDecoration decoration;

  /// Function that handles the changes to the input
  final Function(String)? onChanged;

  /// Function that handles the submission of the input
  final Function(String)? onSubmitted;

  /// Can be used to set custom inputFormatters to field
  final List<TextInputFormatter> inputFormatter;

  /// Can be used to set the textfield initial value
  final String? initialValue;

  /// Can be used to set the text capitalization type
  final TextCapitalization textCapitalization;

  /// Determines if should gain focus on screen open
  final bool autofocus;

  /// Can be used to set different keyboardTypes to your field
  final TextInputType keyboardType;

  /// Can be used to manage TextField focus
  final FocusNode? focusNode;

  /// Can be used to set a custom color to the input cursor
  final Color? cursorColor;

  /// Can be used to set custom style to the suggestions textfield
  final TextStyle inputTextStyle;

  /// Can be used to set custom style to the suggestions list text
  final TextStyle suggestionTextStyle;

  /// Can be used to set custom background color to suggestions list
  final Color? suggestionBackgroundColor;

  /// Used to set the debounce time for async data fetch
  final Duration debounceDuration;

  /// Can be used to customize suggestion items
  final Widget Function(String data)? suggestionBuilder;
  final double maxSuggestionHeight;
  final double? maxSuggestionWidth;

  /// Creates a autocomplete widget to help you manage your suggestions
  const EasyAutocomplete(
      {super.key,
      this.suggestions,
      this.asyncSuggestions,
      this.suggestionBuilder,
      this.controller,
      this.decoration = const InputDecoration(),
      this.onChanged,
      this.onSubmitted,
      this.inputFormatter = const [],
      this.initialValue,
      this.autofocus = false,
      this.textCapitalization = TextCapitalization.sentences,
      this.keyboardType = TextInputType.text,
      this.focusNode,
      this.cursorColor,
      this.inputTextStyle = const TextStyle(),
      this.suggestionTextStyle = const TextStyle(),
      this.suggestionBackgroundColor,
      this.maxSuggestionHeight = 150,
      this.maxSuggestionWidth,
      this.debounceDuration = const Duration(milliseconds: 300)})
      : assert(onChanged != null || controller != null,
            'onChanged and controller parameters cannot be both null at the same time'),
        assert(!(controller != null && initialValue != null),
            'controller and initialValue cannot be used at the same time'),
        assert(
            suggestions != null && asyncSuggestions == null ||
                suggestions == null && asyncSuggestions != null,
            'suggestions and asyncSuggestions cannot be both null or have values at the same time');

  @override
  State<EasyAutocomplete> createState() => _EasyAutocompleteState();
}

class _EasyAutocompleteState extends State<EasyAutocomplete> {
  final LayerLink _layerLink = LayerLink();
  late TextEditingController _controller;
  bool _hasOpenedOverlay = false;
  bool _isLoading = false;
  OverlayEntry? _overlayEntry;
  List<String> _suggestions = [];
  Timer? _debounce;
  String _previousAsyncSearchText = '';
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ??
        TextEditingController(text: widget.initialValue ?? '');
    // _controller.addListener(() => updateSuggestions(_controller.text));
    _focusNode.addListener(() {
      if (_focusNode.hasFocus)
        openOverlay();
      else
        closeOverlay();
    });
  }

  void openOverlay() {
    if (_overlayEntry == null) {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      var size = renderBox.size;
      var offset = renderBox.localToGlobal(Offset.zero);

      _overlayEntry ??= OverlayEntry(
          builder: (context) => Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 5.0,
              width: widget.maxSuggestionWidth ?? size.width,
              child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0.0, size.height + 5.0),
                  child: FilterableList(
                      maxListHeight: widget.maxSuggestionHeight,
                      loading: _isLoading,
                      suggestionBuilder: widget.suggestionBuilder,
                      items: _suggestions,
                      suggestionTextStyle: widget.suggestionTextStyle,
                      suggestionBackgroundColor:
                          widget.suggestionBackgroundColor,
                      onItemTapped: (value) {
                        _controller.value = TextEditingValue(
                            text: value,
                            selection:
                                TextSelection.collapsed(offset: value.length));
                        widget.onChanged?.call(value);
                        widget.onSubmitted?.call(value);
                        closeOverlay();
                        _focusNode.unfocus();
                      }))));
    }
    if (!_hasOpenedOverlay) {
      Overlay.of(context).insert(_overlayEntry!);
      if (mounted) setState(() => _hasOpenedOverlay = true);
    }
  }

  void closeOverlay() {
    if (_hasOpenedOverlay) {
      _overlayEntry!.remove();
      if (mounted) setState(() => _hasOpenedOverlay = false);
    }
  }

  Future<void> updateSuggestions(String input) async {
    rebuildOverlay();
    if (widget.suggestions != null) {
      _suggestions = widget.suggestions!.where((element) {
        return element.toLowerCase().contains(input.toLowerCase());
      }).toList();
      rebuildOverlay();
    } else if (widget.asyncSuggestions != null) {
      if (mounted) setState(() => _isLoading = true);
      if (_debounce != null && _debounce!.isActive) _debounce!.cancel();
      _debounce = Timer(widget.debounceDuration, () async {
        if (_previousAsyncSearchText != input ||
            _previousAsyncSearchText.isEmpty ||
            input.isEmpty) {
          _suggestions = await widget.asyncSuggestions!(input);
          if (mounted)
            setState(() {
              _isLoading = false;
              _previousAsyncSearchText = input;
            });
          rebuildOverlay();
        }
      });
    }
  }

  void rebuildOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
        link: _layerLink,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                  decoration: widget.decoration,
                  controller: _controller,
                  inputFormatters: widget.inputFormatter,
                  autofocus: widget.autofocus,
                  focusNode: _focusNode,
                  textCapitalization: widget.textCapitalization,
                  keyboardType: widget.keyboardType,
                  cursorColor: widget.cursorColor ?? Colors.blue,
                  style: widget.inputTextStyle,
                  onChanged: (value) {
                    widget.onChanged?.call(value);
                    updateSuggestions(_controller.text);
                  },
                  onFieldSubmitted: (value) {
                    widget.onSubmitted?.call(value);
                    closeOverlay();
                    _focusNode.unfocus();
                  },
                  onEditingComplete: () => closeOverlay())
            ]));
  }

  @override
  void dispose() {
    if (_overlayEntry != null) _overlayEntry!.dispose();
    if (widget.controller == null) {
      // _controller.removeListener(() => updateSuggestions(_controller.text));
      _controller.dispose();
    }
    if (_debounce != null) _debounce?.cancel();
    if (widget.focusNode == null) {
      _focusNode.removeListener(() {
        if (_focusNode.hasFocus)
          openOverlay();
        else
          closeOverlay();
      });
      _focusNode.dispose();
    }
    super.dispose();
  }
}
