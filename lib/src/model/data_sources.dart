import 'package:currencytrade_manager_backend/src/base/routers/router.dart';
import 'package:currencytrade_manager_backend/src/base/routers/router_path.dart';
import 'package:currencytrade_manager_backend/src/model/person_bean.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

/// Keeps track of selected rows, feed the data into DesertsDataSource
class RestorableDessertSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  /// Returns whether or not a dessert row is selected by index.
  bool isSelected(int index) => _dessertSelections.contains(index);

  /// Takes a list of [PersonBean]s and saves the row indices of selected rows
  /// into a [Set].
  void setDessertSelections(List<PersonBean> desserts) {
    final updatedSet = <int>{};
    for (var i = 0; i < desserts.length; i += 1) {
      var dessert = desserts[i];
      if (dessert.selected) {
        updatedSet.add(i);
      }
    }
    _dessertSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _dessertSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _dessertSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _dessertSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _dessertSelections = value;
  }

  @override
  Object toPrimitives() => _dessertSelections.toList();
}

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to FLutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class DessertDataSourceAsync extends AsyncDataTableSource {
  DessertDataSourceAsync() {
    print('DessertDataSourceAsync created');
  }

  DessertDataSourceAsync.empty() {
    _empty = true;
    print('DessertDataSourceAsync.empty created');
  }

  DessertDataSourceAsync.error() {
    _errorCounter = 0;
    print('DessertDataSourceAsync.error created');
  }

  bool _empty = false;
  int? _errorCounter;

  RangeValues? _caloriesFilter;

  RangeValues? get caloriesFilter => _caloriesFilter;

  set caloriesFilter(RangeValues? calories) {
    _caloriesFilter = calories;
    safeRefreshDatasource();
  }

  final DesertsFakeWebService _repo = DesertsFakeWebService();

  String _sortColumn = "name";
  bool _sortAscending = true;

  void sort(String columnName, bool ascending) {
    _sortColumn = columnName;
    _sortAscending = ascending;
    safeRefreshDatasource();
  }

  Future<int> getTotalRecords() {
    return Future<int>.delayed(
        const Duration(milliseconds: 0), () => _empty ? 0 : _dessertsX3.length);
  }

  @override
  Future<AsyncRowsResponse> getRows(int start, int end) async {
    print('getRows($start, $end)');
    if (_errorCounter != null) {
      _errorCounter = _errorCounter! + 1;

      if (_errorCounter! % 2 == 1) {
        await Future.delayed(const Duration(milliseconds: 1000));
        throw 'Error #${((_errorCounter! - 1) / 2).round() + 1} has occured';
      }
    }

    var index = start;
    assert(index >= 0);

    // List returned will be empty is there're fewer items than startingAt
    var x = _empty
        ? await Future.delayed(const Duration(milliseconds: 2000),
            () => DesertsFakeWebServiceResponse(0, []))
        : await _repo.getData(
            start, end, _caloriesFilter, _sortColumn, _sortAscending);

    var r = AsyncRowsResponse(
        x.totalRecords,
        x.data.map((dessert) {
          return DataRow2(
            key: ValueKey<int?>(dessert.userId),
            selected: dessert.selected,
            onSelectChanged: (value) {
              if (value != null) {
                setRowSelection(ValueKey<int?>(dessert.userId), value);
              }
            },
            cells: [
              DataCell(Text("${dessert.userId}")),
              DataCell(Text(dessert.nickName ?? "--")),
              DataCell(Text(dessert.phone ?? "--")),
              DataCell(Text('${dessert.accountStatus}')),
              DataCell(Text("${dessert.totalBalance}")),
              DataCell(Text('${dessert.freezeBalance}')),
              DataCell(Text("${dessert.groundedBalance}")),
              DataCell(Text(dessert.createTime ?? "--")),
              DataCell(Text("${dessert.volumeStatus}")),
              DataCell(
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    fluent.Button(
                      child: Text("查看",
                          style: TextStyle(color: fluent.Colors.teal)),
                      onPressed: () {
                        router.go("$userListPage/userDetail");
                      },
                    ),
                    fluent.Button(
                      child: Text("重置密码",
                          style: TextStyle(color: fluent.Colors.teal)),
                      onPressed: () {
                        safeRefreshDatasource();
                      },
                    ),
                    fluent.Button(
                      child: Text("冻结",
                          style: TextStyle(color: fluent.Colors.teal)),
                      onPressed: () {
                        safeRefreshDatasource();
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList());

    return r;
  }

  void safeRefreshDatasource() {
    if (hasListeners) {
      refreshDatasource();
    }
  }
}

/// 分页展示的数据bean
class DesertsFakeWebServiceResponse {
  DesertsFakeWebServiceResponse(this.totalRecords, this.data);

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<PersonBean> data;
}

/// 加载表格数据、以及对数据做排序处理
class DesertsFakeWebService {
  int Function(PersonBean, PersonBean)? _getComparisonFunction(
      String column, bool ascending) {
    var coef = ascending ? 1 : -1;
    switch (column) {
      case 'userId':
        return (PersonBean d1, PersonBean d2) =>
            coef * (d1.userId! - d2.userId!).round();
      case 'nickName':
      case 'name':
        return (PersonBean d1, PersonBean d2) =>
            coef * (d1.nickName?.compareTo(d2.nickName ?? "") ?? 1);
      case 'phone':
        return (PersonBean d1, PersonBean d2) =>
            coef * (d1.phone?.compareTo(d2.phone ?? "") ?? 1);
      case 'accountStatus':
        return (PersonBean d1, PersonBean d2) =>
            coef * ((d1.accountStatus ?? 0) - (d2.accountStatus ?? 0)).round();
      case 'totalBalance':
        return (PersonBean d1, PersonBean d2) =>
            coef * ((d1.totalBalance ?? 0) - (d2.totalBalance ?? 0)).round();
      case 'freezeBalance':
        return (PersonBean d1, PersonBean d2) =>
            coef * ((d1.freezeBalance ?? 0) - (d2.freezeBalance ?? 0)).round();
      case 'groundedBalance':
        return (PersonBean d1, PersonBean d2) =>
            coef *
            ((d1.groundedBalance ?? 0) - (d2.groundedBalance ?? 0)).round();
      case 'createTime':
        return (PersonBean d1, PersonBean d2) =>
            coef * (d1.createTime?.compareTo(d2.createTime ?? "") ?? 1);
      case 'volumeStatus':
        return (PersonBean d1, PersonBean d2) =>
            coef * ((d1.volumeStatus ?? 0) - (d2.volumeStatus ?? 0));
    }

    return null;
  }

  Future<DesertsFakeWebServiceResponse> getData(int startingAt, int count,
      RangeValues? caloriesFilter, String sortedBy, bool sortedAsc) async {
    // 模拟延时加载
    return Future.delayed(
        Duration(
            milliseconds: startingAt == 0
                ? 2650
                : startingAt < 20
                    ? 2000
                    : 400), () {
      var result = _dessertsX3;

      if (caloriesFilter != null) {
        result = result
            .where((e) =>
                e.userId! >= caloriesFilter.start &&
                e.userId! <= caloriesFilter.end)
            .toList();
      }

      result.sort(_getComparisonFunction(sortedBy, sortedAsc));
      return DesertsFakeWebServiceResponse(
          result.length, result.skip(startingAt).take(count).toList());
    });
  }
}

/// 模拟表格数据
List<PersonBean> _desserts = <PersonBean>[
  PersonBean(
    userId: 0,
    nickName: 'Frozen Yogurt',
    phone: "159",
    accountStatus: 6,
    totalBalance: 24,
    freezeBalance: 4.0,
    groundedBalance: 87,
    createTime: "2023-08-16 10:30",
    volumeStatus: 1,
  ),
  PersonBean(
    userId: 1,
    nickName: 'tom',
    phone: "15912345678",
    accountStatus: 6,
    totalBalance: 24,
    freezeBalance: 4.0,
    groundedBalance: 87,
    createTime: "2023-08-16 10:30",
    volumeStatus: 1,
  ),
  /*PersonBean(
    'Eclair',
    262,
    16.0,
    24,
    6.0,
    337,
    6,
    7,
  ),
  PersonBean(
    'Cupcake',
    305,
    3.7,
    67,
    4.3,
    413,
    3,
    8,
  ),
  PersonBean(
    'Gingerbread',
    356,
    16.0,
    49,
    3.9,
    327,
    7,
    16,
  ),
  PersonBean(
    'Jelly Bean',
    375,
    0.0,
    94,
    0.0,
    50,
    0,
    0,
  ),
  PersonBean(
    'Lollipop',
    392,
    0.2,
    98,
    0.0,
    38,
    0,
    2,
  ),
  PersonBean(
    'Honeycomb',
    408,
    3.2,
    87,
    6.5,
    562,
    0,
    45,
  ),
  PersonBean(
    'Donut',
    452,
    25.0,
    51,
    4.9,
    326,
    2,
    22,
  ),
  PersonBean(
    'Apple Pie',
    518,
    26.0,
    65,
    7.0,
    54,
    12,
    6,
  ),
  PersonBean(
    'Frozen Yougurt with sugar',
    168,
    6.0,
    26,
    4.0,
    87,
    14,
    1,
  ),
  PersonBean(
    'Ice Cream Sandich with sugar',
    246,
    9.0,
    39,
    4.3,
    129,
    8,
    1,
  ),
  PersonBean(
    'Eclair with sugar',
    271,
    16.0,
    26,
    6.0,
    337,
    6,
    7,
  ),
  PersonBean(
    'Cupcake with sugar',
    314,
    3.7,
    69,
    4.3,
    413,
    3,
    8,
  ),
  PersonBean(
    'Gingerbread with sugar',
    345,
    16.0,
    51,
    3.9,
    327,
    7,
    16,
  ),
  PersonBean(
    'Jelly Bean with sugar',
    364,
    0.0,
    96,
    0.0,
    50,
    0,
    0,
  ),
  PersonBean(
    'Lollipop with sugar',
    401,
    0.2,
    100,
    0.0,
    38,
    0,
    2,
  ),
  PersonBean(
    'Honeycomd with sugar',
    417,
    3.2,
    89,
    6.5,
    562,
    0,
    45,
  ),
  PersonBean(
    'Donut with sugar',
    461,
    25.0,
    53,
    4.9,
    326,
    2,
    22,
  ),
  PersonBean(
    'Apple pie with sugar',
    527,
    26.0,
    67,
    7.0,
    54,
    12,
    6,
  ),
  PersonBean(
    'Forzen yougurt with honey',
    223,
    6.0,
    36,
    4.0,
    87,
    14,
    1,
  ),
  PersonBean(
    'Ice Cream Sandwich with honey',
    301,
    9.0,
    49,
    4.3,
    129,
    8,
    1,
  ),
  PersonBean(
    'Eclair with honey',
    326,
    16.0,
    36,
    6.0,
    337,
    6,
    7,
  ),
  PersonBean(
    'Cupcake with honey',
    369,
    3.7,
    79,
    4.3,
    413,
    3,
    8,
  ),
  PersonBean(
    'Gignerbread with hone',
    420,
    16.0,
    61,
    3.9,
    327,
    7,
    16,
  ),
  PersonBean(
    'Jelly Bean with honey',
    439,
    0.0,
    106,
    0.0,
    50,
    0,
    0,
  ),
  PersonBean(
    'Lollipop with honey',
    456,
    0.2,
    110,
    0.0,
    38,
    0,
    2,
  ),
  PersonBean(
    'Honeycomd with honey',
    472,
    3.2,
    99,
    6.5,
    562,
    0,
    45,
  ),
  PersonBean(
    'Donut with honey',
    516,
    25.0,
    63,
    4.9,
    326,
    2,
    22,
  ),
  PersonBean(
    'Apple pie with honey',
    582,
    26.0,
    77,
    7.0,
    54,
    12,
    6,
  ),*/
];

/// 模拟表格list数据
List<PersonBean> _dessertsX3 = _desserts.toList()
  ..addAll(_desserts.map((i) => PersonBean(
      userId: i.userId! + 100, nickName: '${i.nickName} x2', phone: i.phone)))
  ..addAll(_desserts.map((i) => PersonBean(
      userId: i.userId! + 200, nickName: '${i.nickName} x3', phone: i.phone)));

_showSnackbar(BuildContext context, String text, [Color? color]) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: color,
    duration: const Duration(seconds: 1),
    content: Text(text),
  ));
}
