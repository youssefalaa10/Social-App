import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import 'messages_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  static MessageCubit get(context) => BlocProvider.of(context);

  List<SocialUserModel> users = []; // List of all users
  List<MessageModel> messages = []; // List of chat messages
  SocialUserModel? userModel; // Current user

  // Fetch the list of users for chatting
  void getUsers() {
    emit(MessageLoadingState()); // Emit loading state before fetching users

    FirebaseFirestore.instance.collection('users').get().then((value) {
      users = [];
      for (var element in value.docs) {
        users.add(SocialUserModel.fromJson(element.data()));
      }
      emit(MessageUsersLoadedState()); // Emit success state after users are loaded
    }).catchError((error) {
      print("Error fetching users: $error");
      emit(MessageErrorState(error.toString())); // Emit error state in case of failure
    });
  }

  // Fetch chat messages between the current user and the receiver
  void getMessages({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('messages')
        .orderBy('dateTime') // Order messages by time
        .where('receiverId', isEqualTo: receiverId)
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(MessageLoadedState()); // Emit success state after messages are loaded
    });
  }

  // Send a new message
  void sendMessage({
    required String receiverId,
    required String text,
    required String dateTime,
  }) {
    MessageModel messageModel = MessageModel(
      senderId: userModel!.uId,
      receiverId: receiverId,
      text: text,
      dateTime: dateTime,
    );

    FirebaseFirestore.instance
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(MessageSentSuccessState()); // Emit success state when the message is sent
    }).catchError((error) {
      print("Error sending message: $error");
      emit(MessageErrorState(error.toString())); // Emit error state in case of failure
    });
  }
}
