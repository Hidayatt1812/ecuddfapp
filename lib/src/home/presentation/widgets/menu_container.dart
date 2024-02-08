import 'package:fluent_ui/fluent_ui.dart';

class MenuContainer extends StatelessWidget {
  const MenuContainer({
    super.key,
    this.title,
    this.icon,
    this.children,
    this.width = 100,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.end,
    this.child,
  });

  final String? title;
  final Widget? icon;
  final List<Widget>? children;
  final double? width;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return children != null
        ? Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: [
              title != null
                  ? Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title!,
                          ),
                          icon ?? const SizedBox(),
                        ],
                      ),
                    )
                  : const SizedBox(),
              ...children!,
            ],
          )
        : Container(
            width: 180,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  offset: const Offset(-6.0, -6.0),
                  blurRadius: 16.0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(6.0, 6.0),
                  blurRadius: 16.0,
                ),
              ],
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: child,
          );
  }
}
