import 'package:ddfapp/core/common/app/providers/port_provider.dart';
import 'package:ddfapp/core/common/app/providers/power_provider.dart';
import 'package:ddfapp/core/res/colours.dart';
import 'package:ddfapp/src/home/presentation/bloc/home_bloc.dart';
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
                child: Consumer<PowerProvider>(
                  builder: (_, powerProvider, __) {
                    return FilledButton(
                      style: ButtonStyle(
                        backgroundColor: ButtonState.all(
                            powerProvider.powerStatus
                                ? Colours.errorColour
                                : Colours.secondaryColour),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 100,
                          child: Icon(
                            powerProvider.powerStatus
                                ? FluentIcons.circle_stop
                                : FluentIcons.power_button,
                            size: 60,
                          ),
                        ),
                      ),
                      onPressed: () {
                        context.read<HomeBloc>().add(const SwitchPowerEvent());
                      },
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Consumer<PortProvider>(
                      builder: (_, portProvider, __) {
                        return ComboBox<String>(
                          placeholder: const Text(
                            "PORT",
                            style: TextStyle(
                              fontFamily: Fonts.segoe,
                            ),
                          ),
                          value: portProvider.selectedPort,
                          items: portProvider.ports.map((e) {
                            return ComboBoxItem(
                              value: e.toString(),
                              child: Text(e.toString()),
                            );
                          }).toList(),
                          onChanged: ((value) {
                            portProvider.setSelectedPort(value!);
                          }),
                        );
                      },
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
                        children: [
                          SidebarItem(
                            title: "TPS",
                            dataValue:
                                "${cartesiusProvider.tpsValue.toStringAsFixed(2)} V",
                            titleIcon: FluentIcons.chart_y_angle,
                          ),
                          SidebarItem(
                            title: "RPM",
                            dataValue:
                                cartesiusProvider.rpmValue.toStringAsFixed(2),
                            titleIcon: FluentIcons.speed_high,
                          ),
                          const SidebarItem(
                            title: "MAP",
                            dataValue: "0 V",
                            titleIcon: FluentIcons.duststorm,
                          ),
                          const SidebarItem(
                            title: "TEMP",
                            dataValue: "18 °C",
                            titleIcon: FluentIcons.frigid,
                          ),
                          const SidebarItem(
                            title: "INJ 1",
                            dataValue: "18 °C",
                            titleIcon: FluentIcons.frigid,
                          ),
                          const SidebarItem(
                            title: "INJ 2",
                            dataValue: "18 °C",
                            titleIcon: FluentIcons.frigid,
                          ),
                          const SidebarItem(
                            title: "INJ 3",
                            dataValue: "18 °C",
                            titleIcon: FluentIcons.frigid,
                          ),
                          const SidebarItem(
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
