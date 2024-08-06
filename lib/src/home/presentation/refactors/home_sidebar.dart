import 'package:ddfapp/core/common/app/providers/port_provider.dart';
import 'package:ddfapp/core/common/app/providers/power_provider.dart';
import 'package:ddfapp/core/extensions/context_extensions.dart';
import 'package:ddfapp/core/res/colours.dart';
import 'package:ddfapp/src/home/presentation/bloc/home_bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../../../core/common/app/providers/cartesius_provider.dart';
import '../../../../core/common/app/providers/ecu_provider.dart';
import '../../../../core/res/fonts.dart';
import '../../domain/entities/ecu.dart';
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
          width: 200,
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
              const PowerButton(),
              const PortSelection(),
              const StartSerialButton(),
              Consumer<ECUProvider>(
                builder: (_, ecuProvider, __) {
                  return ECUValueParameter(
                    tpsValue: cartesiusProvider.tpsValue.toStringAsFixed(2),
                    rpmValue: cartesiusProvider.rpmValue.toStringAsFixed(0),
                    ecu: ecuProvider.ecu,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class ECUValueParameter extends StatelessWidget {
  const ECUValueParameter({
    super.key,
    required this.tpsValue,
    required this.rpmValue,
    required this.ecu,
  });

  final String tpsValue;
  final String rpmValue;
  final ECU ecu;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                  dataValue: "${ecu.tps.toStringAsFixed(2)} V",
                  titleIcon: FluentIcons.chart_y_angle,
                ),
                SidebarItem(
                  title: "RPM",
                  dataValue: ecu.rpm.toStringAsFixed(0),
                  titleIcon: FluentIcons.speed_high,
                ),
                SidebarItem(
                  title: "MAP",
                  dataValue: "${ecu.map.toStringAsFixed(2)} V",
                  titleIcon: FluentIcons.duststorm,
                ),
                SidebarItem(
                  title: "TEMP 1",
                  dataValue: "${ecu.temp1.toStringAsFixed(0)} °C",
                  titleIcon: FluentIcons.frigid,
                ),
                SidebarItem(
                  title: "TEMP 2",
                  dataValue: "${ecu.temp2.toStringAsFixed(0)} °C",
                  titleIcon: FluentIcons.frigid,
                ),
                SidebarItem(
                  title: "TEMP 3",
                  dataValue: "${ecu.temp3.toStringAsFixed(0)} °C",
                  titleIcon: FluentIcons.frigid,
                ),
                SidebarItem(
                  title: "INJ 1",
                  dataValue: ecu.timing1.toStringAsFixed(2),
                  titleIcon: FluentIcons.timer,
                ),
                SidebarItem(
                  title: "INJ 2",
                  dataValue: ecu.timing2.toStringAsFixed(2),
                  titleIcon: FluentIcons.timer,
                ),
                SidebarItem(
                  title: "INJ 3",
                  dataValue: ecu.timing3.toStringAsFixed(2),
                  titleIcon: FluentIcons.timer,
                ),
                SidebarItem(
                  title: "INJ 4",
                  dataValue: ecu.timing4.toStringAsFixed(2),
                  titleIcon: FluentIcons.timer,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class StartSerialButton extends StatelessWidget {
  const StartSerialButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      height: 40,
      child: Consumer<PortProvider>(
        builder: (_, portProvider, __) {
          return IgnorePointer(
            ignoring: portProvider.selectedPort == "None",
            child: FilledButton(
              style: ButtonStyle(
                backgroundColor: ButtonState.all(portProvider.isStreaming
                    ? Colours.errorColour
                    : Colours.secondaryColour),
              ),
              child: Center(
                child: SizedBox(
                  width: 100,
                  child: Icon(
                    portProvider.isStreaming
                        ? FluentIcons.stop
                        : FluentIcons.play,
                    size: 20,
                  ),
                ),
              ),
              onPressed: () {
                if (portProvider.isStreaming) {
                  context.portProvider.closeSerialPortReader();
                } else {
                  context.portProvider.setSerialPortReader();
                  context.read<HomeBloc>().add(
                        GetTPSRPMLinesValueEvent(
                          serialPortReader:
                              context.portProvider.serialPortReader!,
                        ),
                      );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class PortSelection extends StatelessWidget {
  const PortSelection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PortProvider>(
      builder: (_, portProvider, __) {
        return IgnorePointer(
          ignoring: portProvider.isStreaming,
          child: ComboBox<String>(
            placeholder: const Text(
              "PORT",
              style: TextStyle(
                fontFamily: Fonts.segoe,
              ),
            ),
            isExpanded: true,
            value: portProvider.selectedPort,
            items: portProvider.comboBoxItems,
            onTap: () {
              context.read<HomeBloc>().add(const GetPortsEvent());
            },
            onChanged: ((value) {
              portProvider.setSelectedPort(value!);
            }),
          ),
        );
      },
    );
  }
}

class PowerButton extends StatelessWidget {
  const PowerButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PortProvider>(
      builder: (_, portProvider, __) {
        return IgnorePointer(
          ignoring:
              portProvider.selectedPort == "None" || portProvider.isStreaming,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 100,
            child: Consumer<PowerProvider>(
              builder: (_, powerProvider, __) {
                return FilledButton(
                  style: ButtonStyle(
                    backgroundColor: portProvider.selectedPort == "None" ||
                            portProvider.isStreaming
                        ? ButtonState.all(
                            Colours.secondaryColour.withOpacity(0.5))
                        : ButtonState.all(powerProvider.powerStatus
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
                    context.portProvider.setSerialPort();
                    context.read<HomeBloc>().add(SwitchPowerEvent(
                          serialPort: context.portProvider.serialPort!,
                          status: !powerProvider.powerStatus,
                        ));
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
