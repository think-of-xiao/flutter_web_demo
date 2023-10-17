import 'package:currencytrade_manager_backend/src/model/data_sources.dart';
import 'package:currencytrade_manager_backend/src/providers/base_table_page_vm.dart';
import 'package:currencytrade_manager_backend/src/utils/log_util.dart';
import 'package:data_table_2/data_table_2.dart';

class UserListPageVM<T extends AsyncDataTableSource>
    extends BaseTablePageVM<T> {
  bool _dataLoaded = false;
  bool get dataLoaded => _dataLoaded;
  set dataLoaded(value) {
    if (value == _dataLoaded) return;
    _dataLoaded = value;
    safeNotifyListeners();
  }

  UserListPageVM() {
    // 监听数据源变化，刷新底部页码指示器各项参数
    controller.addListener(() {
      dataLoaded = !dataLoaded;
    });
  }

  void sort(
    int columnIndex,
    bool ascending,
  ) {
    var columnName = "name";
    switch (columnIndex) {
      case 1:
        columnName = "userId";
        break;
      case 2:
        columnName = "nickName";
        break;
      case 3:
        columnName = "phone";
        break;
      case 4:
        columnName = "accountStatus";
        break;
      case 5:
        columnName = "totalBalance";
        break;
      case 6:
        columnName = "freezeBalance";
        break;
      case 7:
        columnName = "groundedBalance";
        break;
      case 8:
        columnName = "createTime";
        break;
      case 9:
        columnName = "volumeStatus";
        break;
    }
    (dessertsDataSource as DessertDataSourceAsync?)
        ?.sort(columnName, ascending);
    sortColumnIndex = columnIndex;
    sortAscending = ascending;
    // 刷新表格
    safeNotifyListeners();
  }

  @override
  void dispose() {
    dessertsDataSource?.dispose();
    super.dispose();
  }
}
