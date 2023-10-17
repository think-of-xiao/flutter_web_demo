import 'package:fluent_ui/fluent_ui.dart';

class UserListHeader extends StatelessWidget {
  const UserListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: EdgeInsets.all(16),
        width: constraints.maxWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("查询表格"),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textFieldView(labelTitle: "用户ID", hint: "请输入id"),
                  textFieldView(labelTitle: "用户ID", hint: "请输入id"),
                  Flexible(
                    child: UnconstrainedBox(
                      alignment: Alignment.center,
                      child: FilledButton(
                        child: Text("查询"),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textFieldView(labelTitle: "用户ID", hint: "请输入id"),
                  textFieldView(labelTitle: "用户ID", hint: "请输入id"),
                  Flexible(
                    child: UnconstrainedBox(
                      alignment: Alignment.center,
                      child: FilledButton(
                        child: Text("查询"),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },);
  }

  Widget textFieldView({required String labelTitle, required String hint}) {
    return Flexible(
        child: Row(
      children: [
        Text(labelTitle),
        // TextBox(
        //   placeholder: hint,
        // )
      ],
    ));
  }

  Widget textChoiceView({required String labelTitle, required String hint}) {
    return Flexible(
        child: Row(
          children: [
            Text(labelTitle),
            // TextBox(
            //   placeholder: hint,
            // )
          ],
        ));
  }
}
