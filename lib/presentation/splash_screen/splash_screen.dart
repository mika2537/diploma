import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _loadingOpacityAnimation;

  bool _isInitializing = true;
  String _initializationStatus = 'Initializing...';
  bool _showRetryButton = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Loading animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // Loading opacity animation
    _loadingOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeIn,
    ));

    // Start logo animation
    _logoAnimationController.forward();

    // Start loading animation after logo animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _loadingAnimationController.forward();
      }
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate initialization tasks
      await _performInitializationTasks();

      if (mounted) {
        await _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _initializationStatus = 'Initialization failed';
          _showRetryButton = true;
        });
      }
    }
  }

  Future<void> _performInitializationTasks() async {
    // Task 1: Check authentication status
    setState(() {
      _initializationStatus = 'Checking authentication...';
    });
    await Future.delayed(const Duration(milliseconds: 500));

    // Task 2: Load vehicle documents
    setState(() {
      _initializationStatus = 'Loading vehicle documents...';
    });
    await Future.delayed(const Duration(milliseconds: 400));

    // Task 3: Fetch route data
    setState(() {
      _initializationStatus = 'Fetching route data...';
    });
    await Future.delayed(const Duration(milliseconds: 600));

    // Task 4: Prepare cached earnings
    setState(() {
      _initializationStatus = 'Preparing earnings data...';
    });
    await Future.delayed(const Duration(milliseconds: 500));

    // Task 5: Final setup
    setState(() {
      _initializationStatus = 'Finalizing setup...';
    });
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> _navigateToNextScreen() async {
    // Simulate authentication check
    final bool isAuthenticated = await _checkAuthenticationStatus();
    final bool isNewUser = await _checkIfNewUser();

    // Add delay for smooth transition
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Navigation logic
    if (isAuthenticated) {
      // Authenticated drivers go to dashboard
      Navigator.pushReplacementNamed(context, '/driver-dashboard');
    } else if (isNewUser) {
      // New drivers see onboarding (fallback to login for now)
      Navigator.pushReplacementNamed(context, '/driver-login');
    } else {
      // Returning non-authenticated drivers go to login
      Navigator.pushReplacementNamed(context, '/driver-login');
    }
  }

  Future<bool> _checkAuthenticationStatus() async {
    // Simulate authentication check
    await Future.delayed(const Duration(milliseconds: 200));
    // For demo purposes, return false to show login screen
    return false;
  }

  Future<bool> _checkIfNewUser() async {
    // Simulate new user check
    await Future.delayed(const Duration(milliseconds: 100));
    return false;
  }

  void _retryInitialization() {
    setState(() {
      _isInitializing = true;
      _showRetryButton = false;
      _initializationStatus = 'Retrying initialization...';
    });

    // Reset and restart animations
    _logoAnimationController.reset();
    _loadingAnimationController.reset();

    _logoAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _loadingAnimationController.forward();
      }
    });

    _initializeApp();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryBlue,
              Color(0xFF0A5FCC),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo section
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _logoAnimationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _logoOpacityAnimation.value,
                        child: Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: _buildLogo(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Loading section
              Expanded(
                flex: 1,
                child: AnimatedBuilder(
                  animation: _loadingAnimationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _loadingOpacityAnimation.value,
                      child: _buildLoadingSection(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App logo container
        Container(
          width: 35.w,
          height: 35.w,
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(20.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'local_taxi',
              color: AppTheme.primaryBlue,
              size: 18.w,
            ),
          ),
        ),

        SizedBox(height: 4.h),

        // App name
        Text(
          'Carpool Driver',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppTheme.onPrimaryWhite,
            letterSpacing: 0.5,
          ),
        ),

        SizedBox(height: 1.h),

        // App tagline
        Text(
          'Your Journey, Your Earnings',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.onPrimaryWhite.withValues(alpha: 0.8),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Loading indicator or retry button
        _showRetryButton ? _buildRetryButton() : _buildLoadingIndicator(),

        SizedBox(height: 2.h),

        // Status text
        Text(
          _initializationStatus,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.onPrimaryWhite.withValues(alpha: 0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 6.w,
      height: 6.w,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(
          AppTheme.onPrimaryWhite.withValues(alpha: 0.9),
        ),
      ),
    );
  }

  Widget _buildRetryButton() {
    return ElevatedButton(
      onPressed: _retryInitialization,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.surfaceWhite,
        foregroundColor: AppTheme.primaryBlue,
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'refresh',
            color: AppTheme.primaryBlue,
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Text(
            'Retry',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
