import 'package:ddfapp/core/common/app/providers/cartesius_provider.dart';
import 'package:ddfapp/src/home/presentation/refactors/home_cartesius.dart';
import 'package:ddfapp/src/home/presentation/refactors/home_menu.dart';
import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/res/colours.dart';
import '../../../../core/utils/core_utils.dart';
import '../../domain/entities/rpm.dart';
import '../../domain/entities/tps.dart';
import '../bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is HomeUpdated) {
          if (state.data is List<TPS>) {
            context.read<CartesiusProvider>().initTpss(state.data);
          } else if (state.data is List<RPM>) {
            context.read<CartesiusProvider>().initRpms(state.data);
          }
          final String message = state.data is List<TPS>
              ? 'TPS updated'
              : state.data is List<RPM>
                  ? 'RPM updated'
                  : 'Data updated';
          CoreUtils.showSnackBar(context, message,
              severity: InfoBarSeverity.success);
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          color: Colours.primaryColour,
          child: const Column(
            children: [
              Expanded(
                // height: 750,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 1060,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeMenu(),
                          HomeCartesius(),
                        ],
                      ),
                    ),
                    // const SizedBox(
                    //   width: 20,
                    // ),
                    // const Expanded(
                    //   child: SideView(),
                    // )
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
