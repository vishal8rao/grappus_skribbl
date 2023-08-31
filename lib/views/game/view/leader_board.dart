import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grappus_skribbl/views/views.dart';
import 'package:models/player.dart';

class LeaderBoard extends StatelessWidget {
  const LeaderBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.lightPurple,
      surfaceTintColor: AppColors.lightPurple,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(14).responsive(context),
        child: BlocBuilder<GameCubit, GameState>(
          bloc: context.read<GameCubit>(),
          builder: (context, state) {
            final sessionState = state.sessionState;
            if (sessionState == null) {
              return const SizedBox();
            }
            final players = sessionState.players;
            return ListView.builder(
              itemCount: players.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final playerKey = players.keys.toList()[index];
                return _LeaderboardListItem(
                  player: players[playerKey]!,
                  isDrawing: playerKey == state.sessionState?.isDrawing,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _LeaderboardListItem extends StatelessWidget {
  const _LeaderboardListItem({required this.player, required this.isDrawing});

  final Player player;
  final bool isDrawing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8,bottom: 8).responsive(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                player.name,
                style: context.textTheme.titleLarge?.copyWith(
                  color: AppColors.midnightBlue,
                ),
              ),
              Text(
                '${player.score}',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.midnightBlue,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (isDrawing) ...[
            SvgPicture.asset(Assets.icPencil, width: 30),
          ],
          SizedBox(width: 5.toResponsiveHeight(context)),
          Image.asset(
            player.imagePath,
            width: 70.toResponsiveHeight(context),
            height: 70.toResponsiveHeight(context),
          ),

        ],
      ),
    );
  }
}
