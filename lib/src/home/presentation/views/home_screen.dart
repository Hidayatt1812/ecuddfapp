import 'package:ddfapp/core/common/app/providers/cartesius_provider.dart';
import 'package:ddfapp/src/home/presentation/refactors/home_cartesius.dart';
import 'package:ddfapp/src/home/presentation/refactors/home_menu.dart';
import 'package:ddfapp/src/home/presentation/refactors/home_sidebar.dart';
import 'package:ddfapp/src/home/presentation/refactors/home_voltage_graph.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    context.read<HomeBloc>().add(const LoadTimingValueEvent());
    context.read<HomeBloc>().add(const LoadTPSValueEvent());
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
          print('Axis updated: ${state.data}');
          context
              .read<CartesiusProvider>()
              .setTpsRPMLinesValue(state.data.width, state.data.height);

          // CoreUtils.showSnackBar(context, state.data.toString(),
          //     severity: InfoBarSeverity.success);
        } else if (state is TpsLoaded) {
          context.read<CartesiusProvider>().initTpss(state.data);
        } else if (state is RpmLoaded) {
          context.read<CartesiusProvider>().initRpms(state.data);
        } else if (state is TimingLoaded) {
          context.read<CartesiusProvider>().initTimings(state.data);
        } else if (state is DataSaved) {
          CoreUtils.showSnackBar(context, 'Data saved',
              severity: InfoBarSeverity.success);
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          color: Colours.primaryColour,
          child: Column(
            children: [
              Expanded(
                // height: 750,
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 1060,
                      height: double.infinity,
                      child: Flex(
                        direction: Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HomeMenu(),
                          const HomeCartesius(),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'TPS Timing: ${context.read<CartesiusProvider>().tpsLinesValue}',
                                ),
                                Text(
                                  'RPM Timing: ${context.read<CartesiusProvider>().rpmLinesValue}',
                                ),
                                Text(
                                  'Value Timing: ${context.read<CartesiusProvider>().valueTiming}',
                                ),
                              ],
                            ),
                          ),
                          const HomeVoltageGraph(),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: HomeSidebar(),
                    )
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
