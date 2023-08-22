import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:grappus_skribbl/views/views.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _gameUrlController =
      TextEditingController(text: 'ws://localhost:8080/ws/ws');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _chatUrlController =
      TextEditingController(text: 'ws://localhost:8080/ws/chat');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.spiroDiscoBall,
            ),
            padding: const EdgeInsets.all(30).responsive(context),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CurvedTextField(
                  controller: _gameUrlController,
                  hintText: 'Enter Game URL',
                  fillColor: AppColors.spiroDiscoBallDark,
                ),
                const SizedBox(
                  height: 10,
                ),
                CurvedTextField(
                  controller: _chatUrlController,
                  hintText: 'Enter Chat URL',
                  fillColor: AppColors.spiroDiscoBallDark,
                ),
                CurvedTextField(
                  controller: _nameController,
                  hintText: 'Enter Name',
                  fillColor: AppColors.spiroDiscoBallDark,
                ),
                MaterialButton(
                  color: AppColors.kiwi,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ).responsive(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onPressed: () => Navigator.of(context).push<Widget>(
                    MaterialPageRoute(
                      builder: (context) => GamePage(
                        url: _gameUrlController.text,
                        chatUrl: _chatUrlController.text,
                      ),
                    ),
                  ),
                  child: Text(
                    'Connect',
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: AppColors.flashWhite,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
