import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PaginatedTableData extends StatefulWidget {
  PaginatedTableData({
    super.key,
    this.header,
    this.actions,
    required this.columns,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSelectAll,
    this.dataRowHeight = kMinInteractiveDimension,
    this.headingRowHeight = 56.0,
    this.horizontalMargin = 24.0,
    this.columnSpacing = 56.0,
    this.showCheckboxColumn = true,
    this.showFirstLastButtons = false,
    this.initialFirstRowIndex = 0,
    this.onPageNext,
    this.onPagePrev,
    this.rowsPerPage = defaultRowsPerPage,
    this.onRowsPerPageChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    this.arrowHeadColor,
    required this.source,
    this.checkboxHorizontalMargin,
    required this.totalLength,
    required this.page,
    required this.pageSize,
  })  : assert(actions == null || (header != null)),
        assert(columns.isNotEmpty),
        assert(sortColumnIndex == null ||
            (sortColumnIndex >= 0 && sortColumnIndex < columns.length)),
        assert(rowsPerPage > 0);

  final Widget? header;

  final List<Widget>? actions;

  final List<DataColumn> columns;
  final int? sortColumnIndex;

  final bool sortAscending;
  final ValueSetter<bool?>? onSelectAll;

  final double dataRowHeight;

  final double headingRowHeight;

  final double horizontalMargin;

  final double columnSpacing;

  final bool showCheckboxColumn;

  final bool showFirstLastButtons;

  final int? initialFirstRowIndex;

  final Function()? onPageNext;
  final Function()? onPagePrev;

  final int rowsPerPage;

  static const int defaultRowsPerPage = 10;

  final ValueChanged<int?>? onRowsPerPageChanged;

  final DataTableSource source;

  final DragStartBehavior dragStartBehavior;

  final double? checkboxHorizontalMargin;

  /// Defines the color of the arrow heads in the footer.
  final Color? arrowHeadColor;

  final int totalLength;
  final int page;
  final int pageSize;

  @override
  PaginatedTableDataState createState() => PaginatedTableDataState();
}

/// Holds the state of a [PaginatedTableData].
///
/// The table can be programmatically paged using the [pageTo] method.
class PaginatedTableDataState extends State<PaginatedTableData> {
  late int _rowCount;
  late bool _rowCountApproximate;
  int _selectedRowCount = 0;
  final Map<int, DataRow?> _rows = <int, DataRow?>{};

  @override
  void initState() {
    super.initState();
    widget.source.addListener(_handleDataSourceChanged);
    _handleDataSourceChanged();
  }

  @override
  void didUpdateWidget(PaginatedTableData oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      oldWidget.source.removeListener(_handleDataSourceChanged);
      widget.source.addListener(_handleDataSourceChanged);
      _handleDataSourceChanged();
    }
  }

  @override
  void dispose() {
    widget.source.removeListener(_handleDataSourceChanged);
    super.dispose();
  }

  void _handleDataSourceChanged() {
    setState(() {
      _rowCount = widget.source.rowCount;
      _rowCountApproximate = widget.source.isRowCountApproximate;
      _selectedRowCount = widget.source.selectedRowCount;
      _rows.clear();
    });
  }

  DataRow _getBlankRowFor(int index) {
    return DataRow.byIndex(
      index: index,
      cells: widget.columns
          .map<DataCell>((DataColumn column) => DataCell.empty)
          .toList(),
    );
  }

  DataRow _getProgressIndicatorRowFor(int index) {
    bool haveProgressIndicator = false;
    final List<DataCell> cells =
        widget.columns.map<DataCell>((DataColumn column) {
      if (!column.numeric) {
        haveProgressIndicator = true;
        return const DataCell(CircularProgressIndicator());
      }
      return DataCell.empty;
    }).toList();
    if (!haveProgressIndicator) {
      haveProgressIndicator = true;
      cells[0] = const DataCell(CircularProgressIndicator());
    }
    return DataRow.byIndex(
      index: index,
      cells: cells,
    );
  }

  List<DataRow> _getRows(int firstRowIndex, int rowsPerPage) {
    final List<DataRow> result = <DataRow>[];
    final int nextPageFirstRowIndex = firstRowIndex + rowsPerPage;
    bool haveProgressIndicator = false;
    for (int index = firstRowIndex; index < nextPageFirstRowIndex; index += 1) {
      DataRow? row;
      if (index < _rowCount || _rowCountApproximate) {
        row = _rows.putIfAbsent(index, () => widget.source.getRow(index));
        if (row == null && !haveProgressIndicator) {
          row ??= _getProgressIndicatorRowFor(index);
          haveProgressIndicator = true;
        }
      }
      row ??= _getBlankRowFor(index);
      result.add(row);
    }
    return result;
  }

  // bool _isNextPageUnavailable() =>
  //     !_rowCountApproximate &&
  //     (_firstRowIndex + widget.rowsPerPage >= _rowCount);

  final GlobalKey _tableKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData themeData = Theme.of(context);
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    // HEADER
    final List<Widget> headerWidgets = <Widget>[];
    if (_selectedRowCount == 0 && widget.header != null) {
      headerWidgets.add(Expanded(child: widget.header!));
    } else if (widget.header != null) {
      headerWidgets.add(Expanded(
        child: Text(localizations.selectedRowCountTitle(_selectedRowCount)),
      ));
    }
    if (widget.actions != null) {
      headerWidgets.addAll(
        widget.actions!.map<Widget>((Widget action) {
          return Padding(
            // 8.0 is the default padding of an icon button
            padding: const EdgeInsetsDirectional.only(start: 24.0 - 8.0 * 2.0),
            child: action,
          );
        }).toList(),
      );
    }

    // FOOTER
    final TextStyle? footerTextStyle = themeData.textTheme.bodyMedium;
    final List<Widget> footerWidgets = <Widget>[];
    footerWidgets.addAll(<Widget>[
      Container(width: 32.0),
      Text(
        localizations.pageRowsInfoTitle(
          widget.pageSize * (widget.page - 1) + 1,
          widget.pageSize * (widget.page - 1) + widget.rowsPerPage,
          widget.totalLength,
          _rowCountApproximate,
        ),
      ),
      if (widget.onPagePrev != null)
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: IconButton(
            icon: Icon(Icons.chevron_left, color: widget.arrowHeadColor),
            padding: EdgeInsets.zero,
            tooltip: localizations.previousPageTooltip,
            onPressed: widget.onPagePrev,
          ),
        ),
      if (widget.onPageNext != null)
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: IconButton(
            icon: Icon(Icons.chevron_right, color: widget.arrowHeadColor),
            padding: EdgeInsets.zero,
            tooltip: localizations.nextPageTooltip,
            onPressed: widget.onPageNext,
          ),
        ),
      Container(width: 14.0),
    ]);

    // CARD
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Card(
          semanticContainer: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (headerWidgets.isNotEmpty)
                Semantics(
                  container: true,
                  child: DefaultTextStyle(
                    style: _selectedRowCount > 0
                        ? themeData.textTheme.titleSmall!
                            .copyWith(color: themeData.colorScheme.secondary)
                        : themeData.textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.w400),
                    child: IconTheme.merge(
                      data: const IconThemeData(
                        opacity: 0.54,
                      ),
                      child: Ink(
                        height: 64.0,
                        color: _selectedRowCount > 0
                            ? themeData.secondaryHeaderColor
                            : null,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 24, end: 14.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: headerWidgets,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                dragStartBehavior: widget.dragStartBehavior,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.minWidth,
                  ),
                  child: DataTable(
                    key: _tableKey,
                    columns: widget.columns,
                    sortColumnIndex: widget.sortColumnIndex,
                    sortAscending: widget.sortAscending,
                    onSelectAll: widget.onSelectAll,
                    // Make sure no decoration is set on the DataTable
                    // from the theme, as its already wrapped in a Card.
                    decoration: const BoxDecoration(),
                    dataRowMinHeight: widget.dataRowHeight,
                    dataRowMaxHeight: widget.dataRowHeight,
                    dividerThickness: 0.5,
                    headingRowHeight: widget.headingRowHeight,
                    horizontalMargin: widget.horizontalMargin,
                    checkboxHorizontalMargin: widget.checkboxHorizontalMargin,
                    columnSpacing: widget.columnSpacing,
                    showCheckboxColumn: widget.showCheckboxColumn,
                    showBottomBorder: true,
                    rows: _getRows(0, widget.rowsPerPage),
                  ),
                ),
              ),
              DefaultTextStyle(
                style: footerTextStyle!,
                child: IconTheme.merge(
                  data: const IconThemeData(
                    opacity: 0.54,
                  ),
                  child: SizedBox(
                    height: 56.0,
                    child: SingleChildScrollView(
                      dragStartBehavior: widget.dragStartBehavior,
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Row(
                        children: footerWidgets,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
