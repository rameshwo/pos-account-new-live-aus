class MonthData {
  final String title;
  final int id;
  final String name;

  MonthData({required this.title, required this.id, required this.name});

  static final allMonths = <MonthData>[
    MonthData(id: 0, title: "Jan", name: "january"),
    MonthData(id: 1, title: "Feb", name: "february"),
    MonthData(id: 2, title: "Mar", name: "march"),
    MonthData(id: 3, title: "Apr", name: "april"),
    MonthData(id: 4, title: "May", name: "may"),
    MonthData(id: 5, title: "Jun", name: "june"),
    MonthData(id: 6, title: "Jul", name: "july"),
    MonthData(id: 7, title: "Aug", name: "august"),
    MonthData(id: 8, title: "Sep", name: "september"),
    MonthData(id: 9, title: "Oct", name: "october"),
    MonthData(id: 10, title: "Nov", name: "november"),
    MonthData(id: 11, title: "Dec", name: "december"),
  ];

  static List<MonthData> getMonths(String val, {bool isStartedValue = true}) {
    if (allMonths.any((e) => e.title == val)) {
      final index = allMonths.indexWhere((e) => e.title == val);
      if (isStartedValue)
        return List.generate(12, (i) {
          final m = allMonths[(index + i) % 12];
          return MonthData(id: i, title: m.title, name: m.name);
        });
      else
        return List.generate(12, (i) {
          final m = allMonths[(index + i + 1) % 12];
          return MonthData(id: i, title: m.title, name: m.name);
        });
    } else
      return allMonths;
  }
}
