import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatUiState {
  final bool isRequesting;

  ChatUiState({this.isRequesting = false});
}

class ChatUiStateNotifier extends StateNotifier<ChatUiState> {
  ChatUiStateNotifier() : super(ChatUiState());
  void setRequestState(bool isRequesting) {
    state = ChatUiState(isRequesting: isRequesting);
  }
}

final chatUiStateNotifierProvider = StateNotifierProvider<ChatUiStateNotifier, ChatUiState>(
    (ref) => ChatUiStateNotifier(),
);