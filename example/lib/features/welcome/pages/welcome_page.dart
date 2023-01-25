import 'package:flutter/material.dart';
import 'package:fuse_connect_example/constants/colors.dart';
import 'package:fuse_connect_example/features/auth/pages/register_page.dart';
import 'package:fuse_connect_example/widgets/app_elevated_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset('assets/images/features/welcome/logo.png'),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Banking made easier',
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Image.asset('assets/images/features/welcome/card.png'),
                    ],
                  ),
                ),
              ),
              AppElevatedButton(
                child: const Text("Sign up"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RegisterPage(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
