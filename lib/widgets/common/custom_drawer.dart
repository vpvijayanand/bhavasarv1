import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildMenuItems(context),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        UserModel? user = authProvider.currentUser;

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
          child: Column(
            children: [
              _buildProfileImage(user?.profileImageUrl),
              const SizedBox(height: 12),
              Text(
                user?.fullName ?? 'Welcome',
                style: AppStyles.heading3.copyWith(
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                user?.mobileNumber ?? '',
                style: AppStyles.bodyMedium.copyWith(
                  color: AppColors.textLight.withOpacity(0.8),
                ),
              ),
              if (user?.role == 'admin') ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'ADMIN',
                    style: AppStyles.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(String? imageUrl) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.textLight.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: imageUrl != null
            ? CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => _buildDefaultAvatar(),
        )
            : _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.accentGradient,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        size: 40,
        color: AppColors.textLight,
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        bool isAdmin = authProvider.isAdmin;

        List<DrawerMenuItem> menuItems = [
          DrawerMenuItem(
            icon: Icons.dashboard,
            title: AppStrings.dashboard,
            onTap: () => _navigateTo(context, '/dashboard'),
          ),
          DrawerMenuItem(
            icon: Icons.person,
            title: AppStrings.profile,
            onTap: () => _navigateTo(context, '/profile'),
          ),
        ];

        if (isAdmin) {
          menuItems.addAll([
            DrawerMenuItem(
              icon: Icons.people,
              title: AppStrings.users,
              onTap: () => _navigateTo(context, '/admin/users'),
            ),
            DrawerMenuItem(
              icon: Icons.storage,
              title: AppStrings.masterData,
              onTap: () => _navigateTo(context, '/admin/master-data'),
            ),
          ]);
        }

        menuItems.add(
          DrawerMenuItem(
            icon: Icons.settings,
            title: AppStrings.settings,
            onTap: () => _navigateTo(context, '/settings'),
          ),
        );

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            return _buildMenuItem(menuItems[index]);
          },
        );
      },
    );
  }

  Widget _buildMenuItem(DrawerMenuItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: Icon(
          item.icon,
          color: AppColors.textLight.withOpacity(0.8),
          size: 24,
        ),
        title: Text(
          item.title,
          style: AppStyles.bodyMedium.copyWith(
            color: AppColors.textLight,
          ),
        ),
        onTap: item.onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hoverColor: AppColors.textLight.withOpacity(0.1),
        splashColor: AppColors.textLight.withOpacity(0.2),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Divider(color: AppColors.textLight),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: AppColors.textLight,
            ),
            title: Text(
              AppStrings.logout,
              style: AppStyles.bodyMedium.copyWith(
                color: AppColors.textLight,
              ),
            ),
            onTap: () => _showLogoutDialog(context),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.tagline,
            style: AppStyles.bodySmall.copyWith(
              color: AppColors.textLight.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.of(context).pop(); // Close drawer
    Navigator.of(context).pushNamed(route);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close drawer
                context.read<AuthProvider>().logout();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}

class DrawerMenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}