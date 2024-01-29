import 'package:fluent_ui/fluent_ui.dart';

class MainDivider extends StatelessWidget {
  const MainDivider(
      {super.key,
      this.direction = Axis.vertical,
      this.marginV,
      this.marginH,
      this.size});

  final double? marginH;
  final double? marginV;
  final double? size;
  final Axis direction;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: marginH,
          height: marginV,
        ),
        Divider(
          direction: direction,
          size: size,
        ),
        SizedBox(
          width: marginH,
          height: marginV,
        ),
      ],
    );
  }
}
