import 'package:ddfapp/core/common/app/providers/cartesius_provider.dart';
import 'package:ddfapp/core/extensions/context_extensions.dart';
import 'package:ddfapp/src/home/presentation/refactors/home_cartesius.dart';
import 'package:ddfapp/src/home/presentation/refactors/home_menu.dart';
import 'package:ddfapp/src/home/presentation/refactors/home_sidebar.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/app/providers/power_provider.dart';
import '../../../../core/res/colours.dart';
import '../../../../core/utils/core_utils.dart';
import '../../domain/entities/rpm.dart';
import '../../domain/entities/timing.dart';
import '../../domain/entities/tps.dart';
import '../bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<HomeBloc>().add(const LoadRPMValueEvent());
    context.read<HomeBloc>().add(const LoadTPSValueEvent());
    context.read<HomeBloc>().add(const LoadTimingValueEvent());
    context.read<HomeBloc>().add(const GetPortsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) async {
        if (state is HomeError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is HomeUpdated) {
          if (state.data is List<TPS>) {
            context.read<CartesiusProvider>().initTpss(state.data);
          } else if (state.data is List<RPM>) {
            context.read<CartesiusProvider>().initRpms(state.data);
          } else if (state.data is List<Timing>) {
            context.read<CartesiusProvider>().initTimings(state.data);
            if (context.portProvider.selectedPort != "None") {
              context.portProvider.setSerialPort();
              context.read<HomeBloc>().add(
                    SendDataToECUEvent(
                      serialPort: context.portProvider.serialPort!,
                      tpss: context.read<CartesiusProvider>().tpss,
                      rpms: context.read<CartesiusProvider>().rpms,
                      timings: context.read<CartesiusProvider>().timings,
                      status: context.powerProvider.powerStatus,
                    ),
                  );
            }
          }
          final String message = state.data is List<TPS>
              ? 'TPS updated'
              : state.data is List<RPM>
                  ? 'RPM updated'
                  : state.data is List<Timing>
                      ? 'Timings updated'
                      : 'Data updated';
          CoreUtils.showSnackBar(context, message,
              severity: InfoBarSeverity.success);
        } else if (state is AxisUpdated) {
          context
              .read<CartesiusProvider>()
              .setTpsRPMLinesValue(state.data.width, state.data.height);
        } else if (state is TpsLoaded) {
          context.read<CartesiusProvider>().initTpss(state.data);
        } else if (state is RpmLoaded) {
          context.read<CartesiusProvider>().initRpms(state.data);
        } else if (state is TimingLoaded) {
          context.read<CartesiusProvider>().initTimings(state.data);
        } else if (state is HomePowerSwitched) {
          final status =
              context.read<PowerProvider>().switchPowerStatus(state.status);
          CoreUtils.showSnackBar(
              context, 'Power switched to ${status ? 'on' : 'off'}',
              severity: InfoBarSeverity.success);
        } else if (state is PortLoaded) {
          context.portProvider.initPorts(state.data);
        } else if (state is DataTablesLoaded) {
          context.read<CartesiusProvider>().initTpss(state.tpss);
          context.read<CartesiusProvider>().initRpms(state.rpms);
          context.read<CartesiusProvider>().initTimings(state.timings);
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          color: Colours.primaryColour,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Flex(
                      direction: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 1060,
                          height: MediaQuery.of(context).size.height - 80,
                          child: Flex(
                            direction: Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const HomeMenu(),
                              const HomeCartesius(),
                              Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Value Timing: ${context.read<CartesiusProvider>().valueTiming}',
                                    ),
                                  ],
                                ),
                              ),
                              // const HomeVoltageGraph(),
                            ],
                          ),
                        ),
                        const Expanded(
                          child: HomeSidebar(),
                        ),
                      ],
                    ),
                    state is HomeLoading
                        ? Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            bottom: 0,
                            child: Container(
                              color: Colours.primaryColour.withOpacity(0.8),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colours.secondaryColour),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
