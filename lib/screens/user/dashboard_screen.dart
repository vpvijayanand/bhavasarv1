import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user_model.dart';
import '../../widgets/common/custom_drawer.dart';
import '../../widgets/animated/fade_in_animation.dart';
import '../../widgets/animated/slide_animation.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildCommunityStats(),
              const SizedBox(height: 24),
              _buildRecentActivity(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        AppStrings.dashboard,
        style: AppStyles.heading3.copyWith(color: AppColors.textLight),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // TODO: Implement notifications
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        UserModel? user = authProvider.currentUser;

        return FadeInAnimation(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: AppStyles.gradientCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: AppStyles.bodyMedium.copyWith(
                              color: AppColors.textLight.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.fullName ?? 'Community Member',
                            style: AppStyles.heading2.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                          if (user?.caste != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.accent.withOpacity(0.5),
                                ),
                              ),
                              child: Text(
                                user!.caste,
                                style: AppStyles.bodySmall.copyWith(
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.textLight.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: AppColors.textLight,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    List<QuickAction> actions = [
    QuickAction(
        icon: Icons.person_outline,
        Widget _buildQuickActions() {
      List<QuickAction> actions = [
        QuickAction(
          icon: Icons.person_outline,
          label: 'My Profile',
          color: AppColors.primary,
          onTap: () => Navigator.of(context).pushNamed('/profile'),
        ),
        QuickAction(
          icon: Icons.edit,
          label: 'Edit Profile',
          color: AppColors.secondary,
          onTap: () => Navigator.of(context).pushNamed('/edit-profile'),
        ),
        QuickAction(
          icon: Icons.people_outline,
          label: 'Community',
          color: AppColors.accent,
          onTap: () {
            // TODO: Navigate to community page
          },
        ),
        QuickAction(
          icon: Icons.event,
          label: 'Events',
          color: AppColors.success,
          onTap: () {
            // TODO: Navigate to events page
          },
        ),
      ];

      return SlideAnimation(
        delay: const Duration(milliseconds: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: AppStyles.heading3,
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: actions.length,
              itemBuilder: (context, index) {
                return _buildQuickActionCard(actions[index]);
              },
            ),
          ],
        ),
      );
    }

    Widget _buildQuickActionCard(QuickAction action) {
      return GestureDetector(
        onTap: action.onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: AppStyles.cardDecoration.copyWith(
            border: Border.all(
              color: action.color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: action.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  action.icon,
                  color: action.color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                action.label,
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildCommunityStats() {
      return SlideAnimation(
        delay: const Duration(milliseconds: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Community Overview',
              style: AppStyles.heading3,
            ),
            const SizedBox(height: 16),
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                Map<String, int> stats = userProvider.statistics;

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppStyles.cardDecoration,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Total Members',
                              stats['totalUsers']?.toString() ?? '0',
                              Icons.people,
                              AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Male Members',
                              stats['maleUsers']?.toString() ?? '0',
                              Icons.male,
                              AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Female Members',
                              stats['femaleUsers']?.toString() ?? '0',
                              Icons.female,
                              AppColors.accent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Active Today',
                              '${(stats['totalUsers'] ?? 0) ~/ 10}', // Mock active users
                              Icons.online_prediction,
                              AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    Widget _buildStatCard(String title, String value, IconData icon, Color color) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppStyles.heading2.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    Widget _buildRecentActivity() {
      return SlideAnimation(
        delay: const Duration(milliseconds: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: AppStyles.heading3,
            ),
            const SizedBox(height: 16),
            Container(
              decoration: AppStyles.cardDecoration,
              child: Column(
                children: [
                  _buildActivityItem(
                    'Welcome to the community!',
                    'Your profile has been created successfully',
                    Icons.celebration,
                    AppColors.success,
                    '2 hours ago',
                  ),
                  const Divider(height: 1),
                  _buildActivityItem(
                    'Profile Update Reminder',
                    'Complete your profile to connect with more members',
                    Icons.person_add,
                    AppColors.secondary,
                    '1 day ago',
                  ),
                  const Divider(height: 1),
                  _buildActivityItem(
                    'Community Guidelines',
                    'Please read our community guidelines',
                    Icons.info_outline,
                    AppColors.primary,
                    '2 days ago',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildActivityItem(
        String title,
        String subtitle,
        IconData icon,
        Color color,
        String time,
        ) {
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: AppStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppStyles.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: AppStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
        isThreeLine: true,
      );
    }

    Future<void> _handleRefresh() async {
      final userProvider = context.read<UserProvider>();
      await userProvider.loadStatistics();
    }
  }

  class QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  QuickAction({
  required this.icon,
  required this.label,
  required this.color,
  required this.onTap,
  });
  }