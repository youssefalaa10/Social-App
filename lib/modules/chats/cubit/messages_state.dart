abstract class MessageState {}

class MessageInitial extends MessageState {} // Initial state when nothing is loaded

class MessageLoadingState extends MessageState {} // State when data is being loaded

class MessageUsersLoadedState extends MessageState {} // State when users are loaded

class MessageLoadedState extends MessageState {} // State when messages are loaded

class MessageSentSuccessState extends MessageState {} // State when a message is successfully sent

class MessageErrorState extends MessageState {
  final String error;
  MessageErrorState(this.error);
}
