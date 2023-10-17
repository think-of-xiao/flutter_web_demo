import 'package:currencytrade_manager_backend/src/utils/log_util.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'dart:math';

enum PagerItemTypes { prev, next, ellipsis, number }

typedef PagerClickCallback = void Function(
    int totalPages, int currentPageIndex)?;

class _PagerIndicatorItem extends StatefulWidget {
  final PagerItemTypes type;
  final int? index;
  final bool isFocused;

  const _PagerIndicatorItem({
    super.key,
    required this.type,
    this.index,
    this.isFocused = false,
  });

  @override
  State<_PagerIndicatorItem> createState() => _PagerIndicatorItemState();
}

class _PagerIndicatorItemState extends State<_PagerIndicatorItem> {
  @override
  Widget build(BuildContext context) {
    String itemName = "";
    switch (widget.type) {
      case PagerItemTypes.prev:
        itemName = "<";
        break;
      case PagerItemTypes.next:
        itemName = ">";
        break;
      case PagerItemTypes.ellipsis:
        itemName = "...";
        break;
      case PagerItemTypes.number:
        itemName = (widget.index! + 1).toString();
        break;
    }
    return MouseRegion(
      cursor: widget.index == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: Container(
        height: 30,
        padding: EdgeInsets.symmetric(
            horizontal: widget.type == PagerItemTypes.ellipsis ? 0 : 10),
        decoration: BoxDecoration(
          border: widget.type == PagerItemTypes.ellipsis
              ? null
              : Border.all(
                  color: widget.isFocused ? Colors.blue : Colors.transparent),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          color: widget.isFocused ? Colors.blue : null,
        ),
        child: Center(
          child: Text(
            itemName,
            style: TextStyle(
              fontSize: 14,
              color: widget.index == null
                  ? (widget.type == PagerItemTypes.ellipsis
                      ? Colors.black.withOpacity(.44)
                      : Colors.black.withOpacity(.2))
                  : widget.isFocused
                      ? Colors.white
                      : Colors.black.withOpacity(.6),
            ),
          ),
        ),
      ),
    );
  }
}

class TablePagerIndicator extends StatefulWidget {
  final int totalCount;
  final int pageEach;
  final PagerClickCallback callback;

  const TablePagerIndicator({
    super.key,
    required this.totalCount,
    required this.pageEach,
    this.callback,
  });

  @override
  State<TablePagerIndicator> createState() => _TablePagerIndicatorState();
}

class _TablePagerIndicatorState extends State<TablePagerIndicator> {
  // 当两端同时出现省略(...)时中间展示条数
  int pagesBetweenEllipsesCount = 5;
  late int sideDiff;

  // 总页数
  late int totalPages;
  int? lastTotalPages;
  int? lastCurrentPageIndex;

  // 每页的数据数量
  late int pageEach;

  // 当前所在页
  int currentPageIndex = 0;

  TextEditingController gotoControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    pageEach = widget.pageEach;
    initData();
  }

  initData() {
    sideDiff = (pagesBetweenEllipsesCount / 2).floor();
    currentPageIndex = 0;
  }

  executeCallback() {
    if (widget.callback != null) {
      if ((lastTotalPages == null || lastCurrentPageIndex == null) ||
          (lastTotalPages != totalPages ||
              lastCurrentPageIndex != currentPageIndex)) {
        lastTotalPages = totalPages;
        lastCurrentPageIndex = currentPageIndex;
        widget.callback!(totalPages, currentPageIndex);
      }
    }
  }

  Widget pageItem(_PagerIndicatorItem item) {
    return GestureDetector(
      onTapUp: (e) {
        if (item.index != null) {
          setState(() {
            currentPageIndex = item.index!;
          });
        }
        executeCallback();
      },
      child: item,
    );
  }

  List<Widget> generatePager() {
    List<Widget> pageItems = [];
    // prev添加上一页按钮（<）
    pageItems.add(pageItem(_PagerIndicatorItem(
      type: PagerItemTypes.prev,
      index: currentPageIndex > 0 ? currentPageIndex - 1 : null,
    )));
    // 添加第一页（首页）
    pageItems.add(pageItem(_PagerIndicatorItem(
      type: PagerItemTypes.number,
      index: 0,
      isFocused: currentPageIndex == 0,
    )));
    // 添加数字number list
    List<int> indexesBetweenEllipses = [];
    bool isReachStart = false;
    bool isReachEnd = false;
    int index = max(1, currentPageIndex - sideDiff);
    // 居中模式
    for (; index <= min(currentPageIndex + sideDiff, totalPages - 2); index++) {
      if (index == 1) {
        isReachStart = true;
      }
      if (index == totalPages - 2) {
        isReachEnd = true;
      }
      indexesBetweenEllipses.add(index);
    }
    // 补缺
    int lackDiff = pagesBetweenEllipsesCount - indexesBetweenEllipses.length;
    if (lackDiff > 0) {
      if (isReachStart) {
        for (int i = 0; i < lackDiff; i++) {
          if (index < totalPages - 1) {
            if (index == totalPages - 2) {
              isReachEnd = true;
            }
            indexesBetweenEllipses.add(index++);
          }
        }
      }
      if (isReachEnd) {
        var indexStart = indexesBetweenEllipses.first;
        for (int i = 0; i < lackDiff; i++) {
          if (indexStart > 1) {
            if (indexStart == 2) {
              isReachStart = true;
            }
            indexesBetweenEllipses.insert(0, --indexStart);
          }
        }
      }
    }
    for (var i = 0; i < indexesBetweenEllipses.length; i++) {
      int index = indexesBetweenEllipses[i];
      // 添加数字页码ui
      pageItems.add(pageItem(_PagerIndicatorItem(
        type: PagerItemTypes.number,
        index: index,
        isFocused: currentPageIndex == index,
      )));
    }
    // 尾页
    if (totalPages > 1) {
      pageItems.add(pageItem(_PagerIndicatorItem(
        type: PagerItemTypes.number,
        index: totalPages - 1,
        isFocused: currentPageIndex == totalPages - 1,
      )));
    }
    // next
    pageItems.add(pageItem(_PagerIndicatorItem(
      type: PagerItemTypes.next,
      index: currentPageIndex < totalPages - 1 ? currentPageIndex + 1 : null,
    )));
    // ...
    if (!isReachStart &&
        indexesBetweenEllipses.length >= pagesBetweenEllipsesCount) {
      // 前
      pageItems.insert(
          2,
          pageItem(_PagerIndicatorItem(
            type: PagerItemTypes.number,
            index: 1,
            isFocused: currentPageIndex == 1,
          )));
      if (currentPageIndex > 4) {
        // 当前选中下标大于4时才展示前（...）
        pageItems.insert(3,
            pageItem(const _PagerIndicatorItem(type: PagerItemTypes.ellipsis)));
      }
    }
    if (!isReachEnd &&
        indexesBetweenEllipses.length >= pagesBetweenEllipsesCount) {
      // 后
      if (currentPageIndex < totalPages - 5) {
        // 当前选中下标小于总页码减5时才展示后（...）
        pageItems.insert(pageItems.length - 2,
            pageItem(const _PagerIndicatorItem(type: PagerItemTypes.ellipsis)));
      }
      pageItems.insert(
          pageItems.length - 2,
          pageItem(_PagerIndicatorItem(
            type: PagerItemTypes.number,
            index: totalPages - 2,
            isFocused: currentPageIndex == totalPages - 2,
          )));
    }
    executeCallback();
    return pageItems;
  }

  Widget text(String text) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.6)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    totalPages = (widget.totalCount / pageEach).ceil();
    List<Widget> pageItems = generatePager();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          text("共\t${widget.totalCount}\t条"),
          ...pageItems.map((pageItem) {
            // int index = pageItems.indexOf(pageItem);
            return Container(
              // margin: const EdgeInsets.only(left: 10),
              child: pageItem,
            );
          }).toList(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              text("前往"),
              SizedBox(
                width: 52,
                height: 28,
                child: TextBox(
                  unfocusedColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  controller: gotoControl,
                  autocorrect: false,
                  maxLines: 1,
                  // style: HLTextStyles.s14c000000o60,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  onEditingComplete: () {
                    try {
                      int goto = int.parse(gotoControl.text);
                      setState(() {
                        currentPageIndex = max(0, goto - 1);
                        currentPageIndex =
                            min(currentPageIndex, totalPages - 1);
                        gotoControl.text = (currentPageIndex + 1).toString();
                        gotoControl.selection = TextSelection.fromPosition(
                            TextPosition(offset: gotoControl.text.length));
                      });
                    } on FormatException catch (e) {
                      LogUtil().e("unvalid number : $e");
                    }
                  },
                ),
              ),
              text("页"),
            ],
          ),
        ],
      ),
    );
  }
}
