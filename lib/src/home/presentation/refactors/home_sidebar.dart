import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../../../core/common/app/providers/cartesius_provider.dart';
import '../../../../core/res/fonts.dart';
import '../widgets/sidebar_item.dart';

class HomeSidebar extends StatefulWidget {
  const HomeSidebar({super.key});

  @override
  State<HomeSidebar> createState() => _HomeSidebarState();
}

class _HomeSidebarState extends State<HomeSidebar>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartesiusProvider>(
      builder: (_, cartesiusProvider, __) {
        return Container(
          margin: const EdgeInsets.only(left: 20),
          padding: const EdgeInsets.all(20),
          width: 1060,
          height: double.maxFinite,
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
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Flex(
            direction: Axis.vertical,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 150,
                child: FilledButton(
                  child: const Center(
                    child: SizedBox(
                      width: 100,
                      child: Icon(
                        FluentIcons.power_button,
                        size: 60,
                      ),
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ComboBox<String>(
                      placeholder: const Text(
                        "PORT",
                        style: TextStyle(
                          fontFamily: Fonts.segoe,
                        ),
                      ),
                      // value: ,
                      items: List.generate(10, (index) => index).map((e) {
                        return ComboBoxItem(
                          value: e.toString(),
                          child: Text(e.toString()),
                        );
                      }).toList(),
                      onChanged: ((value) {}),
                    ),
                  )
                ],
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double parentWidth = constraints.maxWidth;
                    double parentHeight = constraints.maxHeight;
                    return SizedBox(
                      height: parentHeight,
                      width: parentWidth,
                      child: ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SidebarItem(
                            title: "TPS",
                            dataValue: "0 V",
                            titleIcon: FluentIcons.chart_y_angle,
                          ),
                          SidebarItem(
                            title: "RPM",
                            dataValue: '0',
                            titleIcon: FluentIcons.speed_high,
                          ),
                          SidebarItem(
                            title: "MAP",
                            dataValue: "0 V",
                            titleIcon: FluentIcons.duststorm,
                          ),
                          SidebarItem(
                            title: "TEMP",
                            dataValue: "18 °C",
                            titleIcon: FluentIcons.frigid,
                          ),
                          SidebarItem(
                            title: "INJ 1",
                            dataValue: "18 °C",
                            titleIcon: FluentIcons.frigid,
                          ),
                          SidebarItem(
                            title: "INJ 2",
                            dataValue: "18 °C",
                            titleIcon: FluentIcons.frigid,
                          ),
                          SidebarItem(
                            title: "INJ 3",
                            dataValue: "18 °C",
                            titleIcon: FluentIcons.frigid,
                          ),
                          SidebarItem(
                            title: "INJ 4",
                            dataValue: "18 °C",
                            titleIcon: FluentIcons.frigid,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
