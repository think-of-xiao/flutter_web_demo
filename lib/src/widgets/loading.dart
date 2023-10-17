import 'package:fluent_ui/fluent_ui.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: Colors.white.withAlpha(128),
        // at first show shade, if loading takes longer than 0,5s show spinner
        child: FutureBuilder(
            future:
            Future.delayed(const Duration(milliseconds: 500), () => true),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? const SizedBox()
                  : Center(
                  child: Container(
                    color: Colors.yellow,
                    padding: const EdgeInsets.all(7),
                    width: 150,
                    height: 50,
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ProgressRing(
                            strokeWidth: 2,
                            activeColor: Colors.black,
                          ),
                          Text('Loading..')
                        ]),
                  ));
            }));
  }
}