import 'package:fluent_ui/fluent_ui.dart';

class ErrorAndRetry extends StatelessWidget {
  const ErrorAndRetry(this.errorMessage, this.retry, {super.key});

  final String errorMessage;
  final void Function() retry;

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
            padding: const EdgeInsets.all(10),
            height: 70,
            color: Colors.red,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('出错了! $errorMessage',
                      style: const TextStyle(color: Colors.white)),
                  Button(
                      onPressed: retry,
                      child:
                          const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(
                          FluentIcons.refresh,
                          color: Colors.white,
                        ),
                        Text('Retry', style: TextStyle(color: Colors.white))
                      ]))
                ])),
      );
}
