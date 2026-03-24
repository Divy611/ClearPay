import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:clearpay/common/enums.dart';
import 'package:clearpay/state/authstate.dart';
import 'package:clearpay/auth/onboarding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clearpay/dashboard/dashboard.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  int currentMessageIndex = 0;
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<double> rotateAnimation;
  late AnimationController messageController;
  final List<String> loadingMessages = [
    "Securing connection...",
    "Loading your dashboard...",
    "Updating financial data...",
    "Almost there...",
  ];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
    rotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
    controller.repeat(reverse: false);
    messageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    messageController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            currentMessageIndex =
                (currentMessageIndex + 1) % loadingMessages.length;
          });
        }
        messageController.forward(from: 0);
      }
    });
    messageController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  void dispose() {
    controller.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> init() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      final auth = Provider.of<AuthState>(context, listen: false);
      await auth.getCurrentUser();
    } catch (_) {
      if (!mounted) return;
      final auth = Provider.of<AuthState>(context, listen: false);
      auth.authStatus = AuthStatus.NOT_LOGGED_IN;
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      auth.notifyListeners();
    }
  }

  Widget splashBody() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF334D8F), Color(0xFF1A2747)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: rotateAnimation.value,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.15),
                          ),
                          child: const Padding(padding: EdgeInsets.all(15)),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 50),
              FadeTransition(
                opacity: fadeAnimation,
                child: Text(
                  "ClearPay",
                  style: GoogleFonts.montserrat(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 13),
              FadeTransition(
                opacity: fadeAnimation,
                child: Text(
                  "Secure Financial Solutions",
                  style: GoogleFonts.montserrat(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: 40,
                height: 40,
                child: Platform.isIOS
                    ? const CupertinoActivityIndicator(
                        radius: 13,
                        color: Colors.white,
                      )
                    : const CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
              ),
              const SizedBox(height: 25),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  loadingMessages[currentMessageIndex],
                  key: ValueKey<int>(currentMessageIndex),
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthState>(context);
    switch (auth.authStatus) {
      case AuthStatus.LOGGED_IN:
        return const DashBoard();
      case AuthStatus.NOT_LOGGED_IN:
        return const OnboardingPage();
      case AuthStatus.NOT_DETERMINED:
        return Scaffold(body: splashBody());
    }
  }
}
