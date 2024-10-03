import 'package:ddfapp/core/common/app/providers/cartesius_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../src/dashboard/presentation/providers/dashboard_controller.dart';
import '../common/app/providers/ecu_provider.dart';
import '../common/app/providers/port_provider.dart';
import '../common/app/providers/power_provider.dart';
import '../common/app/providers/tab_navigator.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;
  double get width => size.width;
  double get height => size.height;

  CartesiusProvider get cartesiusProvider => read<CartesiusProvider>();

  PortProvider get portProvider => read<PortProvider>();

  PowerProvider get powerProvider => read<PowerProvider>();

  ECUProvider get ecuProvider => read<ECUProvider>();

  TabNavigator get tabNavigator => read<TabNavigator>();

  void pop() => tabNavigator.pop();

  void popToRoot() => tabNavigator.popToRoot();

  void push(Widget page) => tabNavigator.push(TabItem(child: page));

  DashboardController get dashboardController => read<DashboardController>();
}
