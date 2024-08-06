import 'package:ddfapp/core/res/fonts.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../../core/res/colours.dart';

class SidebarItem extends StatelessWidget {
  final String title;
  final dynamic titleIcon;
  final String dataValue;
  const SidebarItem({
    super.key,
    required this.title,
    this.titleIcon,
    required this.dataValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colours.primaryColour,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // width: 130,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  dataValue,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: Fonts.segoe,
                  ),
                ),
                Icon(titleIcon, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
