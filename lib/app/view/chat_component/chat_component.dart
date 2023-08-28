import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grappus_skribbl/views/game/cubit/game_cubit.dart';
import 'package:models/chat_model.dart';
import 'package:models/player.dart';

class ChatComponent extends StatefulWidget {
  const ChatComponent({super.key});

  @override
  State<ChatComponent> createState() => _ChatComponentState();
}

class _ChatComponentState extends State<ChatComponent> {
  final message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 576,
          width: 356,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: BlocBuilder<GameCubit, GameState>(
                bloc: context.read<GameCubit>(),
                builder: (context, state) {
                  final sessionState = state.sessionState;
                  if (sessionState == null) {
                    return const SizedBox();
                  }
                  final messages = sessionState.messages;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      // If its a correct answer
                      // or the answer has been already given
                      final isMessageCorrectAnswer = messages[index].message ==
                              sessionState.correctAnswer ||
                          messages[index].player.hasAnsweredCorrectly;

                      final currentPlayer =
                          state.sessionState!.players[state.uid];
                      //  If this current player has not answered correct
                      // and the message is correct
                      // then dont show the chat

                      return isMessageCorrectAnswer &&
                              (!currentPlayer!.hasAnsweredCorrectly)
                          ? const SizedBox()
                          : Container(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: isMessageCorrectAnswer
                                        ? Colors.green
                                        : Colors.black,
                                  ),
                                  const SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(messages[index].player.name),
                                      Text(
                                        messages[index].message,
                                        style: TextStyle(
                                          color: messages[index]
                                                  .player
                                                  .hasAnsweredCorrectly
                                              ? Colors.orange
                                              : isMessageCorrectAnswer
                                                  ? Colors.green.shade900
                                                  : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                    },
                  );
                },
              ),
            ),
          ),
        ),
        Card(
          child: Container(
            height: 60,
            width: 356,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: 356,
                    height: 60,
                    child: TextField(
                      controller: message,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final gameState = context.read<GameCubit>().state;
                    if (gameState.sessionState == null) {
                      throw Exception('null session');
                    }
                    final players2 = gameState.sessionState!.players;
                    context.read<GameCubit>().addChats(
                          ChatModel(
                            player: players2[gameState.uid] ??
                                Player(name: 'err', userId: 'err'),
                            message: message.text,
                          ),
                        );
                    message.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
