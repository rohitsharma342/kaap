import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/profile_controller.dart';
import '../models/child_profile.dart';
import '../utils/constants.dart';
import '../widgets/profile_avatar.dart';
import 'dashboard_screen.dart';

class ProfileSelectionScreen extends StatefulWidget {
  @override
  _ProfileSelectionScreenState createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  ChildProfile? selectedProfile;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, profileController, child) {
        return Scaffold(
          backgroundColor: AppConstants.backgroundColor,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppConstants.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.family_restroom,
                          color: AppConstants.primaryColor,
                          size: 32,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose Profile',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.textPrimary,
                              ),
                            ),
                            Text(
                              'Select your child\'s profile to continue',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppConstants.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 40),
                  
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: profileController.profiles.length + 1,
                      itemBuilder: (context, index) {
                        if (index == profileController.profiles.length) {
                          return _buildAddProfileCard();
                        }
                        
                        final profile = profileController.profiles[index];
                        final isSelected = selectedProfile?.id == profile.id;
                        
                        return _buildProfileCard(profile, isSelected);
                      },
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  Container(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: selectedProfile != null && !profileController.isLoading
                          ? () => _continueWithProfile(context, profileController)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: profileController.isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildProfileCard(ChildProfile profile, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedProfile = profile;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppConstants.primaryColor : Colors.grey[200]!,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? AppConstants.primaryColor.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 15 : 8,
              spreadRadius: isSelected ? 2 : 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                ProfileAvatar(
                  imageUrl: profile.avatarUrl,
                  size: 80,
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
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              profile.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Age ${profile.age}',
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.textSecondary,
              ),
            ),
            if (profile.isPremium)
              Container(
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Premium',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.amber[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAddProfileCard() {
    return GestureDetector(
      onTap: () => _showAddProfileDialog(),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 2,
            style: BorderStyle.values[1],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: 40,
                color: AppConstants.primaryColor,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Add Profile',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppConstants.primaryColor,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Create new child profile',
              style: TextStyle(
                fontSize: 12,
                color: AppConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  void _showAddProfileDialog() {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    String selectedAvatar = AppConstants.avatarUrls[0];
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Add New Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Child Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.cake),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Choose Avatar',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppConstants.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppConstants.avatarUrls.length,
                  itemBuilder: (context, index) {
                    final avatar = AppConstants.avatarUrls[index];
                    final isSelected = selectedAvatar == avatar;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAvatar = avatar;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppConstants.primaryColor : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: ProfileAvatar(
                          imageUrl: avatar,
                          size: 60,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && ageController.text.isNotEmpty) {
                  final profile = context.read<ProfileController>().createNewProfile(
                    name: nameController.text.trim(),
                    avatarUrl: selectedAvatar,
                    age: int.tryParse(ageController.text) ?? 5,
                  );
                  context.read<ProfileController>().addProfile(profile);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
              ),
              child: Text('Add Profile'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _continueWithProfile(BuildContext context, ProfileController profileController) async {
    if (selectedProfile != null) {
      await profileController.selectProfile(selectedProfile!);
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ),
      );
    }
  }
}