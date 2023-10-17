import 'package:fluent_ui/fluent_ui.dart';

class Empty extends StatelessWidget {
  const Empty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.grey[200],
        child: const Text('No data'),
      ),
    );
  }
}
