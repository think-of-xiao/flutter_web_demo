import 'package:currencytrade_manager_backend/src/constant/colors.dart';
import 'package:currencytrade_manager_backend/src/widgets/image_placeholder.dart';
import 'package:currencytrade_manager_backend/src/base/routers/router_path.dart'
    as route_path;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String restorationId = "login_page";

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with RestorationMixin {
  final RestorableTextEditingController _usernameController =
      RestorableTextEditingController();
  final RestorableTextEditingController _passwordController =
      RestorableTextEditingController();

  late List<Widget> listViewChildren;

  @override
  String? get restorationId => LoginPage.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(
        _usernameController, restorationId ?? LoginPage.restorationId);
    registerForRestoration(
        _passwordController, restorationId ?? LoginPage.restorationId);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width / 3;
    listViewChildren = [
      _UsernameInput(
        maxWidth: maxWidth,
        usernameController: _usernameController.value,
      ),
      const SizedBox(height: 12),
      _PasswordInput(
        maxWidth: maxWidth,
        passwordController: _passwordController.value,
      ),
      _LoginButton(
        maxWidth: maxWidth,
        onTap: () {
          context.go(route_path.homePage);
        },
      ),
    ];

    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: const _TopBar(),
      content: Align(
        alignment: Alignment.center,
        child: ListView(
          restorationId: 'login_list_view',
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: listViewChildren,
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(width: 30);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: SizedBox(
                  height: 80,
                  child: FadeInImagePlaceholder(
                    image: const AssetImage('assets/images/1.5x/logo.png'),
                    placeholder: LayoutBuilder(builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxHeight,
                        height: constraints.maxHeight,
                      );
                    }),
                  ),
                ),
              ),
              spacing,
              Text(
                "登录管理后台",
                style: FluentTheme.of(context).typography.bodyLarge?.copyWith(
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "还没有账号？",
                style: FluentTheme.of(context).typography.body,
              ),
              spacing,
              _BorderButton(
                text: "注册",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BorderButton extends StatelessWidget {
  const _BorderButton({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        foregroundColor: ButtonState.all<Color?>(Colors.white),
        border: ButtonState.all(
          const BorderSide(color: AppColors.buttonColor),
        ),
        padding: ButtonState.all(
          const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        ),
        shape: ButtonState.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      onPressed: () {
        context.go(route_path.registerPage);
      },
      child: Text(text, style: const TextStyle(color: AppColors.buttonColor)),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  const _UsernameInput({
    this.maxWidth,
    this.usernameController,
  });

  final double? maxWidth;
  final TextEditingController? usernameController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: TextBox(
          autofillHints: const [AutofillHints.username],
          textInputAction: TextInputAction.next,
          controller: usernameController,
          placeholder: "请输入用户名",
        ),
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    this.maxWidth,
    this.passwordController,
  });

  final double? maxWidth;
  final TextEditingController? passwordController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: TextBox(
          controller: passwordController,
          obscureText: true,
          placeholder: "请输入密码",
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.onTap,
    this.maxWidth,
  });

  final double? maxWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Row(
          children: [
            const Icon(FluentIcons.skype_circle_check,
                color: AppColors.buttonColor),
            const SizedBox(width: 12),
            Text("记住我的登录信息"),
            const Expanded(child: SizedBox.shrink()),
            _FilledButton(
              text: "登录",
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilledButton extends StatelessWidget {
  const _FilledButton({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        padding: ButtonState.all(
          const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        ),
        shape: ButtonState.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      onPressed: onTap,
      child: Row(
        children: [
          const Icon(FluentIcons.lock),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}
