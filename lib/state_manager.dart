// state_manager.dart
import 'package:flutter/material.dart';

class StateContainer<T> {
  T _state;
  final T _defaultState;
  final List<VoidCallback> _listeners = [];

  StateContainer(this._defaultState) : _state = _defaultState;

  T get state => _state;

  // Đồng bộ: Cập nhật state
  void setState(T newState) {
    if (_state != newState) {
      _state = newState;
      _notifyListeners();
    }
  }

  // Bất đồng bộ: Cập nhật state từ một Future
  Future<void> setStateAsync(Future<T> newStateFuture) async {
    final newState = await newStateFuture;
    if (_state != newState) {
      _state = newState;
      _notifyListeners();
    }
  }

  void resetState() {
    setState(_defaultState);
  }

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }
}

class Observer<T> extends StatefulWidget {
  final StateContainer<T> stateContainer;
  final Widget Function(BuildContext context, T state) builder;

  const Observer(
      {required this.stateContainer, required this.builder, Key? key})
      : super(key: key);

  @override
  _ObserverState<T> createState() => _ObserverState<T>();
}

class _ObserverState<T> extends State<Observer<T>> {
  late T currentState;

  @override
  void initState() {
    super.initState();
    currentState = widget.stateContainer.state;
    widget.stateContainer.addListener(_update);
  }

  @override
  void dispose() {
    widget.stateContainer.removeListener(_update);
    super.dispose();
  }

  void _update() {
    setState(() {
      currentState = widget.stateContainer.state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, currentState);
  }
}
