import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/master_data_provider.dart';
import '../../models/user_model.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/animated/fade_in_animation.dart';
import '../../widgets/animated/slide_animation.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.profile,
          style: AppStyles.heading3.copyWith(color: AppColors.textLight),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed('/edit-profile');
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          UserModel? user = authProvider.currentUser;

          if (user == null) {
            return const Center(
              child: Text('No user data available'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(user),
                const SizedBox(height: 24),
                _buildPersonalInfo(context, user),
                const SizedBox(height: 24),
                _buildAstrologicalInfo(context, user),
                const SizedBox(height: 24),
                _buildActionButtons(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    return FadeInAnimation(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: AppStyles.gradientCardDecoration,
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.textLight.withOpacity(0.3),
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: user.profileImageUrl != null
                    ? CachedNetworkImage(
                  imageUrl: user.profileImageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => _buildDefaultAvatar(),
                )
                    : _buildDefaultAvatar(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.fullName ?? 'Name not provided',
              style: AppStyles.heading2.copyWith(
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              user.mobileNumber,
              style: AppStyles.bodyMedium.copyWith(
                color: AppColors.textLight.withOpacity(0.8),
              ),
            ),
            if (user.email != null) ...[
              const SizedBox(height: 4),
              Text(
                user.email!,
                style: AppStyles.bodyMedium.copyWith(
                  color: AppColors.textLight.withOpacity(0.8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.accentGradient,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        size: 50,
        color: AppColors.textLight,
      ),
    );
  }

  Widget _buildPersonalInfo(BuildContext context, UserModel user) {
    return SlideAnimation(
      delay: const Duration(milliseconds: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: AppStyles.heading3,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppStyles.cardDecoration,
            child: Column(
              children: [
                _buildInfoRow('Gender', user.gender ?? 'Not specified'),
                if (user.dateOfBirth != null)
                  _buildInfoRow(
                    'Date of Birth',
                    DateFormat('dd/MM/yyyy').format(user.dateOfBirth!),
                  ),
                _buildInfoRow('Occupation', user.occupation ?? 'Not specified'),
                if (user.city != null || user.state != null)
                  _buildInfoRow(
                    'Location',
                    '${user.city ?? ''} ${user.state != null ? ', ${user.state}' : ''}',
                  ),
                _buildInfoRow('Caste', user.caste),
                if (user.communitySubGroup != null)
                  _buildInfoRow('Community Sub-group', user.communitySubGroup!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAstrologicalInfo(BuildContext context, UserModel user) {
    return SlideAnimation(
      delay: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Astrological Information',
            style: AppStyles.heading3,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppStyles.cardDecoration,
            child: Consumer<MasterDataProvider>(
              builder: (context, masterDataProvider, child) {
                return Column(
                  children: [
                    if (user.rashi != null)
                      _buildInfoRow(
                        'Rashi',
                        masterDataProvider.getRasiName(user.rashi) ?? user.rashi!,
                      ),
                    if (user.natchatiram != null)
                      _buildInfoRow(
                        'Natchatiram',
                        masterDataProvider.getNatchatiramName(user.natchatiram) ?? user.natchatiram!,
                      ),
                    if (user.annav != null)
                      _buildInfoRow('Annav', user.annav!),
                    if (user.kotiram != null)
                      _buildInfoRow('Kotiram', user.kotiram!),
                    if (user.rashi == null && user.natchatiram == null &&
                        user.annav == null && user.kotiram == null)
                      Center(
                        child: Text(
                          'No astrological information provided',
                          style: AppStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: AppStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return SlideAnimation(
      delay: const Duration(milliseconds: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomButton(
            text: 'Edit Profile',
            onPressed: () {
              Navigator.of(context).pushNamed('/edit-profile');
            },
            icon: Icons.edit,
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Share Profile',
            onPressed: () {
              // TODO: Implement profile sharing
            },
            icon: Icons.share,
            isSecondary: true,
          ),
        ],
      ),
    );
  }
}