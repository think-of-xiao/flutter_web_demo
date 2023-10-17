import 'package:currencytrade_manager_backend/src/model/data_sources.dart';
import 'package:currencytrade_manager_backend/src/providers/user_list_page_vm.dart';
import 'package:currencytrade_manager_backend/src/utils/log_util.dart';
import 'package:currencytrade_manager_backend/src/widgets/empty.dart';
import 'package:currencytrade_manager_backend/src/widgets/error_and_retry.dart';
import 'package:currencytrade_manager_backend/src/widgets/loading.dart';
import 'package:currencytrade_manager_backend/src/widgets/table_pager_indicator.dart';
import 'package:currencytrade_manager_backend/src/widgets/user_list_header.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late UserListPageVM<DessertDataSourceAsync> model;

  @override
  void initState() {
    super.initState();
    model = UserListPageVM<DessertDataSourceAsync>();
  }

  @override
  void didChangeDependencies() {
    // initState is to early to access route options, context is invalid at that stage
    model.dessertsDataSource ??= DessertDataSourceAsync();
    super.didChangeDependencies();
  }

  List<DataColumn2> get _columns {
    return [
      DataColumn2(
        label: const Text('用户ID'),
        size: ColumnSize.S,
        onSort: (columnIndex, ascending) => model.sort(columnIndex, ascending),
      ),
      DataColumn2(
        label: const Center(
          child: Text('账号昵称'),
        ),
        numeric: true,
        onSort: (columnIndex, ascending) => model.sort(columnIndex, ascending),
      ),
      DataColumn2(
        label: const Text('手机号'),
        numeric: true,
        onSort: (columnIndex, ascending) => model.sort(columnIndex, ascending),
      ),
      DataColumn2(
        label: const Text('账号状态'),
        numeric: true,
        onSort: (columnIndex, ascending) => model.sort(columnIndex, ascending),
      ),
      DataColumn2(
        label: const Text('总余额'),
        numeric: true,
        onSort: (columnIndex, ascending) => model.sort(columnIndex, ascending),
      ),
      DataColumn2(
        label: const Text('冻结'),
        numeric: true,
        onSort: (columnIndex, ascending) => model.sort(columnIndex, ascending),
      ),
      DataColumn2(
        label: const Text('已上架'),
        numeric: true,
        onSort: (columnIndex, ascending) => model.sort(columnIndex, ascending),
      ),
      DataColumn2(
        label: const Text('创建时间'),
        numeric: true,
        size: ColumnSize.L,
        fixedWidth: 150,
        onSort: (columnIndex, ascending) => model.sort(columnIndex, ascending),
      ),
      DataColumn2(
        label: const Text('内容量'),
        numeric: true,
        onSort: (columnIndex, ascending) => model.sort(columnIndex, ascending),
      ),
      const DataColumn2(
        label: Center(
          child: Text('操作'),
        ),
        numeric: true,
        fixedWidth: 200,
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserListPageVM>(
      create: (context) => model,
      builder: (context, child) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          header: UserListHeader(),
          content: material.Material(
            child: Consumer<UserListPageVM>(
              builder: (context, value, child) {
                return AsyncPaginatedDataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  checkboxHorizontalMargin: 0,
                  minWidth: 1200,
                  wrapInCard: true,
                  fit: FlexFit.tight,
                  border:
                      TableBorder.all(width: 1.0, color: material.Colors.grey),
                  headingRowColor: material.MaterialStateProperty.resolveWith(
                      (states) => material.Colors.grey[200]),
                  fixedColumnsColor: material.Colors.grey[300],
                  fixedCornerColor: material.Colors.grey[400],
                  fixedTopRows: 1,
                  fixedLeftColumns: 2,
                  autoRowsToHeight: false,
                  renderEmptyRowsInTheEnd: false,
                  sortArrowAnimationDuration: const Duration(milliseconds: 0),
                  hidePaginator: true,
                  // Default - do nothing, autoRows - goToLast, other - goToFirst
                  pageSyncApproach: PageSyncApproach.doNothing,
                  sortArrowIcon: FluentIcons.chevron_up_end,
                  rowsPerPage: model.rowsPerPage,
                  initialFirstRowIndex: model.initialRow,
                  sortColumnIndex: model.sortColumnIndex,
                  sortAscending: model.sortAscending,
                  controller: model.controller,
                  onRowsPerPageChanged: (value) {
                    // No need to wrap into setState, it will be called inside the widget
                    // and trigger rebuild
                    LogUtil().d('Row per page changed to $value');
                    model.rowsPerPage = value!;
                  },
                  onPageChanged: (rowIndex) {
                    LogUtil().d(rowIndex / model.rowsPerPage);
                  },
                  onSelectAll: (select) {
                    if (select == null) return;
                    if (select) {
                      // _dessertsDataSource!.selectAll();
                      model.dessertsDataSource?.selectAllOnThePage();
                    } else {
                      // _dessertsDataSource!.deselectAll();
                      model.dessertsDataSource?.deselectAllOnThePage();
                    }
                  },
                  loading: const Loading(),
                  empty: const Empty(),
                  errorBuilder: (error) => ErrorAndRetry(error.toString(), () {
                    // todo 重新加载数据
                    model.dessertsDataSource?.safeRefreshDatasource();
                  }),
                  columns: _columns,
                  source: model.dessertsDataSource!,
                );
              },
            ),
          ),
          bottomBar: Selector<UserListPageVM, bool>(
            builder: (context, dataLoaded, child) {
              return model.controller.isAttached
                  ? Center(
                      child: TablePagerIndicator(
                        totalCount: model.controller.rowCount,
                        pageEach: model.controller.rowsPerPage,
                        callback: (totalPages, currentPageIndex) {
                          LogUtil().d(
                              "TablePagerIndicator.callback totalPages = $totalPages, currentPageIndex = $currentPageIndex");
                          // data_table_2没有直接翻页到指定页方法，可根据goToPageWithRow传入单页展示条数以及指定页的数值来跳转
                          model.controller.goToPageWithRow(
                              model.controller.rowsPerPage * currentPageIndex);
                        },
                      ),
                    )
                  : const SizedBox.shrink();
            },
            selector: (p0, p1) => model.dataLoaded,
          ),
        );
      },
    );
  }
}
