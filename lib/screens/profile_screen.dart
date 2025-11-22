import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_controller.dart';
import '../utils/constants.dart';
import '../widgets/profile_avatar.dart';
import 'profile_selection_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, profileController, child) {
        final selectedProfile = profileController.selectedProfile;
        
        return Scaffold(
          backgroundColor: AppConstants.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context, selectedProfile),
                  _buildProfileStats(selectedProfile),
                  _buildSubscriptionCard(selectedProfile),
                  _buildAllProfiles(context, profileController),
                  _buildSettingsOptions(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildHeader(BuildContext context, selectedProfile) {
    return Container(
      padding: EdgeInsets.all(AppConstants.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimary,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileSelectionScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.switch_account,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          if (selectedProfile != null) ...[
            Stack(
              children: [
                ProfileAvatar(
                  imageUrl: selectedProfile.avatarUrl,
                  size: 100,
                ),
                if (selectedProfile.isPremium)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              selectedProfile.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimary,
              ),
            ),
            Text(
              'Age ${selectedProfile.age}',
              style: TextStyle(
                fontSize: 16,
                color: AppConstants.textSecondary,
              ),
            ),
            if (selectedProfile.isPremium)
              Container(
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Premium Member',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildProfileStats(selectedProfile) {
    if (selectedProfile == null) return SizedBox.shrink();
    
    return Container(
      margin: EdgeInsets.all(AppConstants.padding),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('Videos Watched', '45'),
          _buildDivider(),
          _buildStatItem('Favorites', '12'),
          _buildDivider(),
          _buildStatItem('Comments', '8'),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppConstants.primaryColor,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppConstants.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.grey[300],
    );
  }
  
  Widget _buildSubscriptionCard(selectedProfile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppConstants.padding),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryColor,
            AppConstants.accentColor,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                selectedProfile?.isPremium == true ? 'Premium Active' : 'Upgrade to Premium',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            selectedProfile?.isPremium == true
                ? 'Enjoying ad-free videos and exclusive content!'
                : 'Get ad-free videos, exclusive content, and more!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          if (selectedProfile?.isPremium != true) ...[
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle premium upgrade
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppConstants.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Upgrade Now',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildAllProfiles(BuildContext context, ProfileController profileController) {
    return Container(
      margin: EdgeInsets.all(AppConstants.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Profiles',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          
          ...profileController.profiles.map((profile) {
            final isSelected = profileController.selectedProfile?.id == profile.id;
            
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppConstants.primaryColor : Colors.grey[200]!,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      ProfileAvatar(
                        imageUrl: profile.avatarUrl,
                        size: 60,
                      ),
                      if (profile.isPremium)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                        Text(
                          'Age ${profile.age}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppConstants.textSecondary,
                          ),
                        ),
                        if (profile.preferences.isNotEmpty)
                          Wrap(
                            spacing: 4,
                            children: profile.preferences.take(2).map((pref) {
                              return Container(
                                margin: EdgeInsets.only(top: 4),
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppConstants.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  pref,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppConstants.primaryColor,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: AppConstants.primaryColor,
                    )
                  else
                    IconButton(
                      onPressed: () {
                        profileController.selectProfile(profile);
                      },
                      icon: Icon(
                        Icons.radio_button_unchecked,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
  
  Widget _buildSettingsOptions(BuildContext context) {
    final settingsOptions = [
      {
        'title': 'Parental Controls',
        'subtitle': 'Manage safety settings',
        'icon': Icons.security,
        'onTap': () {},
      },
      {
        'title': 'Privacy Settings',
        'subtitle': 'Control data and privacy',
        'icon': Icons.privacy_tip,
        'onTap': () {},
      },
      {
        'title': 'Help & Support',
        'subtitle': 'Get help and contact us',
        'icon': Icons.help,
        'onTap': () {},
      },
      {
        'title': 'About KAAP',
        'subtitle': 'App version and info',
        'icon': Icons.info,
        'onTap': () {},
      },
    ];
    
    return Container(
      margin: EdgeInsets.all(AppConstants.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: settingsOptions.map((option) {
                final isLast = option == settingsOptions.last;
                
                return InkWell(
                  onTap: option['onTap'] as VoidCallback,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: !isLast
                          ? Border(
                              bottom: BorderSide(
                                color: Colors.grey[200]!,
                                width: 1,
                              ),
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            option['icon'] as IconData,
                            color: AppConstants.primaryColor,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option['title'] as String,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppConstants.textPrimary,
                                ),
                              ),
                              Text(
                                option['subtitle'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppConstants.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppConstants.textSecondary,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}