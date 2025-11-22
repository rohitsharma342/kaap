import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import '../utils/constants.dart';
import 'profile_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
    _navigateToNextScreen();
  }

  void _setupAnimations() {
    _logoController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));
  }

  void _startAnimations() {
    _logoController.forward();
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) _textController.forward();
    });
  }

  void _navigateToNextScreen() {
    Future.delayed(Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ProfileSelectionScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeScaleTransition(
                animation: animation,
                child: child,
              );
            },
            transitionDuration: Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              AppConstants.primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              
              AnimatedBuilder(
                animation: _logoAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.primaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.play_circle_fill,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              
              SizedBox(height: 24),
              
              SlideTransition(
                position: _slideAnimation,
                child: AnimatedBuilder(
                  animation: _textAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textAnimation.value,
                      child: Column(
                        children: [
                          Text(
                            AppConstants.appName,
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.primaryColor,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Safe Videos for Kids',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppConstants.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              Spacer(flex: 2),
              
              SlideTransition(
                position: _slideAnimation,
                child: AnimatedBuilder(
                  animation: _textAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textAnimation.value * 0.8,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppConstants.primaryColor.withOpacity(0.7),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            AppConstants.tagline,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppConstants.textSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}