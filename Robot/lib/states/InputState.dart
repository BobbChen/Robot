import 'package:hooks_riverpod/hooks_riverpod.dart';

class InputState {
  final bool textIsEmpty;
  InputState({this.textIsEmpty = true});
}

class InputStateProvider extends StateNotifier<InputState> {
  InputStateProvider() : super(InputState());
  void setTextEmptyState(bool isEmpty) {
    state = InputState(textIsEmpty: isEmpty);
  }
}

final inputStateProvider =
    StateNotifierProvider<InputStateProvider, InputState>(
  (ref) => InputStateProvider(),
);
