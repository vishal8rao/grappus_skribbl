import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:grappus_skribbl/views/views.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

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
                  controller: _urlController,
                  hintText: 'Enter URL',
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
                      builder: (context) => GamePage(url: _urlController.text),
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
