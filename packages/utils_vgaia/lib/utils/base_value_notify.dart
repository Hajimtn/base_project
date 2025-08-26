import 'package:flutter/material.dart';

class RxNotify<T> extends ValueNotifier<T> {
  RxNotify(T value) : super(value);

  void refresh() {
    notifyListeners();
  }

  void add(dynamic X) {
    if (value is List) {
      (value as List<dynamic>).add(X);
      notifyListeners();
    } else {
      value = X;
    }
  }

  void update(void Function(T? val) fn) {
    fn(value);
    add(value);
  }
}

class RxListNotify<T> extends ValueNotifier<List<T>> {
  RxListNotify(List<T> value) : super(value);

  void refresh() {
    notifyListeners();
  }

  void add(T item) {
    value.add(item);
    notifyListeners();
  }

  void clear() {
    value = <T>[];
    notifyListeners();
  }

  void addAll(Iterable<T> item) {
    value.addAll(item);
    refresh();
  }

  void insertAll(int index, Iterable<T> iterable) {
    value.insertAll(index, iterable);
    refresh();
  }

  void sort([int Function(T a, T b)? compare]) {
    value.sort(compare);
    refresh();
  }
}

extension RxNotifyxtention<T> on T {
  RxNotify<T> get objective => RxNotify<T>(this);
}

extension RxListNotifyExtention<T> on List<T> {
  RxListNotify<T> get objective => RxListNotify<T>(this);
}
