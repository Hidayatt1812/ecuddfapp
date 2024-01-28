import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/res/colours.dart';
import '../../../../core/utils/core_utils.dart';
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
          CoreUtils.showSnackBar(context, state.data);
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
                  children: [
                    SizedBox(
                      width: 1060,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [],
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
