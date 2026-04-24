import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit that handles current index for bottom tabs.
class MainTabsController extends Cubit<int> {
  MainTabsController() : super(0);

  /// Changes active tab by [index].
  void changeTab(int index) {
    if (index == state) {
      return;
    }
    emit(index);
  }
}
