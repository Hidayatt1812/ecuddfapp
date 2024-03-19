import 'package:ddfapp/core/common/app/providers/port_provider.dart';
import 'package:ddfapp/core/common/widgets/main_divider.dart';
import 'package:ddfapp/src/home/presentation/bloc/home_bloc.dart';
import 'package:ddfapp/src/home/presentation/widgets/menu_container.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/app/providers/cartesius_provider.dart';
import '../../../../core/common/widgets/main_pop_up.dart';
import '../../../../core/common/widgets/main_text_input.dart';
import '../../../../core/res/colours.dart';
import '../../../../core/utils/core_utils.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  TextEditingController minRPMController = TextEditingController();
  TextEditingController maxRPMController = TextEditingController();
  TextEditingController stepRPMController = TextEditingController();
  TextEditingController minTPSController = TextEditingController();
  TextEditingController maxTPSController = TextEditingController();
  TextEditingController stepTPSController = TextEditingController();
  TextEditingController minINJController = TextEditingController();
  TextEditingController maxINJController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
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
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MenuContainer(
                  //   title: 'CLEAR',
                  //   icon: const Icon(
                  //     FluentIcons.remove_filter,
                  //     size: 14,
                  //   ),
                  //   children: [
                  //     Button(
                  //       child: const SizedBox(
                  //         width: 80,
                  //         child: Text(" TPS "),
                  //       ),
                  //       onPressed: () {},
                  //     ),
                  //     const SizedBox(
                  //       height: 5,
                  //     ),
                  //     Button(
                  //       child: const SizedBox(
                  //         width: 80,
                  //         child: Text(" RPM "),
                  //       ),
                  //       onPressed: () {},
                  //     ),
                  //     const SizedBox(
                  //       height: 5,
                  //     ),
                  //     Button(
                  //       child: const SizedBox(
                  //         width: 80,
                  //         child: Text(" INJ "),
                  //       ),
                  //       onPressed: () {},
                  //     ),
                  //     const SizedBox(
                  //       height: 16,
                  //     ),
                  //   ],
                  // ),
                  // const MainDivider(
                  //   size: 160,
                  //   marginH: 20,
                  //   marginV: 20,
                  // ),
                  MenuContainer(
                    title: 'INSERT',
                    icon: const Icon(
                      FluentIcons.insert,
                      size: 14,
                    ),
                    children: [
                      Row(
                        children: [
                          Button(
                            child: const SizedBox(
                                width: 110, child: Text("DEFAULT")),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return MainPopUp(
                                    title:
                                        'Yakin ingin reset ke default? semua data akan hilang',
                                    onPressedPositive: () {
                                      context
                                          .read<CartesiusProvider>()
                                          .defaultAll();
                                      Navigator.of(context).pop();
                                    },
                                    positiveText: 'Hapus',
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Button(
                            child: const SizedBox(
                                width: 110, child: Text("LOAD DATA")),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return MainPopUp(
                                    title:
                                        'Yakin ingin load data? semua data saat ini akan hilang',
                                    onPressedPositive: () {
                                      context
                                          .read<HomeBloc>()
                                          .add(const LoadRPMValueEvent());
                                      context
                                          .read<HomeBloc>()
                                          .add(const LoadTPSValueEvent());
                                      context
                                          .read<HomeBloc>()
                                          .add(const LoadTimingValueEvent());
                                      Navigator.of(context).pop();
                                    },
                                    positiveText: 'Load',
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const MainDivider(
                    size: 160,
                    marginH: 20,
                    marginV: 20,
                  ),
                  MenuContainer(
                    title: 'INSERT BY RANGE',
                    icon: const Icon(
                      FluentIcons.step_insert,
                      size: 14,
                    ),
                    width: 300,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "TPS > ",
                          ),
                          SizedBox(
                            height: 35,
                            child: MainTextInput(
                              boxDecoration: const BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Color.fromARGB(255, 249, 249, 249)),
                              disabled: false,
                              placholder: "min",
                              controller: minTPSController,
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: MainTextInput(
                              boxDecoration: const BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Color.fromARGB(255, 249, 249, 249)),
                              disabled: false,
                              placholder: "max",
                              controller: maxTPSController,
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: MainTextInput(
                              boxDecoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 249, 249, 249)),
                              disabled: false,
                              placholder: "step",
                              controller: stepTPSController,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          FilledButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  ButtonState.all(Colours.secondaryColour),
                            ),
                            child: const Text(
                              "OK",
                            ),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              context.read<HomeBloc>().add(
                                    SetTPSParameterEvent(
                                      minValue:
                                          double.parse(minTPSController.text),
                                      maxValue:
                                          double.parse(maxTPSController.text),
                                      steps: int.parse(stepTPSController.text),
                                    ),
                                  );
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "RPM > ",
                          ),
                          SizedBox(
                            height: 35,
                            child: MainTextInput(
                              boxDecoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 249, 249, 249)),
                              disabled: false,
                              placholder: "min",
                              controller: minRPMController,
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: MainTextInput(
                              boxDecoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 249, 249, 249)),
                              disabled: false,
                              placholder: "max",
                              controller: maxRPMController,
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            child: MainTextInput(
                              boxDecoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 249, 249, 249)),
                              disabled: false,
                              placholder: "step",
                              controller: stepRPMController,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          FilledButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  ButtonState.all(Colours.secondaryColour),
                            ),
                            child: const Text(
                              "OK",
                            ),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              context.read<HomeBloc>().add(
                                    SetRPMParameterEvent(
                                      minValue:
                                          double.parse(minRPMController.text),
                                      maxValue:
                                          double.parse(maxRPMController.text),
                                      steps: int.parse(stepRPMController.text),
                                    ),
                                  );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const MainDivider(
                    size: 160,
                    marginH: 20,
                    marginV: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: BlocConsumer<HomeBloc, HomeState>(
                      listener: (context, state) {
                        if (state is HomeError) {
                          CoreUtils.showSnackBar(context, state.message);
                        } else if (state is DataSaved) {
                          CoreUtils.showSnackBar(context, 'Data saved',
                              severity: InfoBarSeverity.success);
                        } else if (state is DataTablesLoaded) {
                          CoreUtils.showSnackBar(
                            context,
                            'Data tables imported',
                            severity: InfoBarSeverity.success,
                          );
                          // context.portProvider.closeSerialPort();
                        }
                      },
                      builder: (context, state) {
                        return MenuContainer(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  state is DataSaved
                                      ? Icon(FluentIcons.skype_circle_check,
                                          color: Colors.green)
                                      : const Icon(
                                          FluentIcons.sync_status_solid,
                                          color: Color.fromARGB(90, 49, 49, 49),
                                        ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  FlyoutTarget(
                                    controller: FlyoutController(),
                                    child: FilledButton(
                                      style: ButtonStyle(
                                        backgroundColor: ButtonState.all(
                                            Colours.secondaryColour),
                                      ),
                                      child: const SizedBox(
                                          width: 120,
                                          child: Text("Save Value")),
                                      onPressed: () {
                                        context.read<HomeBloc>().add(
                                              SaveValueEvent(
                                                tpss: context
                                                    .read<CartesiusProvider>()
                                                    .tpss,
                                                rpms: context
                                                    .read<CartesiusProvider>()
                                                    .rpms,
                                                timings: context
                                                    .read<CartesiusProvider>()
                                                    .timings,
                                              ),
                                            );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Consumer<PortProvider>(
                                builder: (_, portProvider, __) {
                                  return IgnorePointer(
                                    ignoring:
                                        portProvider.selectedPort == "None",
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        state is DataSent
                                            ? Icon(
                                                FluentIcons.skype_circle_check,
                                                color: Colors.green)
                                            : const Icon(
                                                FluentIcons.sync_status_solid,
                                                color: Color.fromARGB(
                                                    90, 49, 49, 49),
                                              ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        FilledButton(
                                          style: ButtonStyle(
                                            backgroundColor: portProvider
                                                        .selectedPort ==
                                                    "None"
                                                ? ButtonState.all(Colours
                                                    .secondaryColour
                                                    .withOpacity(0.5))
                                                : ButtonState.all(
                                                    Colours.secondaryColour),
                                          ),
                                          child: const SizedBox(
                                            width: 120,
                                            child: Text("Import from ECU"),
                                          ),
                                          onPressed: () {
                                            portProvider.setSerialPort();
                                            context.read<HomeBloc>().add(
                                                  GetDataFromECUEvent(
                                                    serialPort: portProvider
                                                        .serialPort!,
                                                  ),
                                                );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
