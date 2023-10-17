import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';

abstract class BaseTablePageVM<T extends AsyncDataTableSource> extends ChangeNotifier {
  T? dessertsDataSource;
  int rowsPerPage = 20 /*material.PaginatedDataTable.defaultRowsPerPage*/;
  int initialRow = 0;
  bool sortAscending = true;
  int? sortColumnIndex;
  final PaginatorController controller = PaginatorController();

  void safeNotifyListeners() {
    if (hasListeners) {
      notifyListeners();
    }
  }
}