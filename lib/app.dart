import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/app_colors.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/registration_screen.dart';
import 'screens/auth/otp_verification_screen.dart';
import 'screens/user/dashboard_screen.dart';
import 'screens/user/profile_screen.dart';
import 'screens/user/edit_profile_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/users_list_screen.dart';
import 'screens/admin/user_detail_screen.dart';
import 'widgets/common/loading_widget.dart';

class BhavasaraCommunityApp extends StatelessWidget {
  const BhavasaraCommunityApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bhavasara Community',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          elevation: 0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          switch (authProvider.state) {
            case AuthState.initial:
            case AuthState.loading:
              return const Scaffold(
                body: LoadingWidget(message: 'Loading...'),
              );
            case AuthState.authenticated:
              return authProvider.isAdmin
                  ? const AdminDashboardScreen()
                  : const DashboardScreen();
            case AuthState.unauthenticated:
            case AuthState.error:
              return const LoginScreen();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/dashboard': (context) => Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return authProvider.isAdmin
                ? const AdminDashboardScreen()
                : const DashboardScreen();
          },
        ),
        '/profile': (context) => const ProfileScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/admin/dashboard': (context) => const AdminDashboardScreen(),
        '/admin/users': (context) => const UsersListScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/otp-verification':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => OTPVerificationScreen(arguments: args),
            );
          case '/admin/user-detail':
            final userId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => UserDetailScreen(userId: userId),
            );
          default:
            return null;
        }
      },
    );
  }
}