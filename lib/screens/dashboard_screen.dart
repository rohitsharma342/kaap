import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/video_controller.dart';
import '../controllers/profile_controller.dart';
import '../utils/constants.dart';
import '../widgets/video_card.dart';
import 'video_player_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedBottomIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<VideoController, ProfileController>(
      builder: (context, videoController, profileController, child) {
        return Scaffold(
          backgroundColor: AppConstants.backgroundColor,
          body: _buildBody(videoController, profileController),
          bottomNavigationBar: _buildBottomNavBar(),
        );
      },
    );
  }
  
  Widget _buildBody(VideoController videoController, ProfileController profileController) {
    switch (_selectedBottomIndex) {
      case 0:
        return _buildHomeContent(videoController, profileController);
      case 1:
        return _buildUploadContent();
      case 2:
        return _buildAnalyticsContent();
      case 3:
        return ProfileScreen();
      default:
        return _buildHomeContent(videoController, profileController);
    }
  }
  
  Widget _buildHomeContent(VideoController videoController, ProfileController profileController) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(profileController),
          _buildSearchBar(videoController),
          _buildCategoryTabs(videoController),
          Expanded(
            child: _buildVideoFeed(videoController),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader(ProfileController profileController) {
    final profile = profileController.selectedProfile;
    
    return Container(
      padding: EdgeInsets.all(AppConstants.padding),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedBottomIndex = 3;
              });
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppConstants.primaryColor,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  profile?.avatarUrl ?? AppConstants.avatarUrls[0],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppConstants.primaryColor.withOpacity(0.2),
                      child: Icon(
                        Icons.person,
                        color: AppConstants.primaryColor,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, ${profile?.name ?? "Kid"}!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimary,
                  ),
                ),
                Text(
                  'Ready for some fun videos?',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Show notifications
            },
            icon: Stack(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 28,
                  color: AppConstants.textPrimary,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSearchBar(VideoController videoController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppConstants.padding),
      child: TextField(
        controller: _searchController,
        onChanged: (query) => videoController.setSearchQuery(query),
        decoration: InputDecoration(
          hintText: 'Search videos...',
          hintStyle: TextStyle(color: AppConstants.textSecondary),
          prefixIcon: Icon(
            Icons.search,
            color: AppConstants.textSecondary,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    videoController.setSearchQuery('');
                  },
                  icon: Icon(
                    Icons.clear,
                    color: AppConstants.textSecondary,
                  ),
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
  
  Widget _buildCategoryTabs(VideoController videoController) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppConstants.padding),
        itemCount: AppConstants.videoCategories.length,
        itemBuilder: (context, index) {
          final category = AppConstants.videoCategories[index];
          final isSelected = videoController.selectedCategory == category;
          
          return GestureDetector(
            onTap: () => videoController.setCategory(category),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 12),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppConstants.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: AppConstants.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppConstants.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildVideoFeed(VideoController videoController) {
    if (videoController.videos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 80,
              color: AppConstants.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'No videos found',
              style: TextStyle(
                fontSize: 18,
                color: AppConstants.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Try searching for something else',
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.textSecondary,
              ),
            ),
          ],
        ),
      );
    }
    
    return GridView.builder(
      padding: EdgeInsets.all(AppConstants.padding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: videoController.videos.length,
      itemBuilder: (context, index) {
        final video = videoController.videos[index];
        return VideoCard(
          video: video,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(video: video),
              ),
            );
          },
        );
      },
    );
  }
  
  Widget _buildUploadContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.video_call,
              size: 60,
              color: AppConstants.primaryColor,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Upload Videos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Create and share your amazing videos!',
            style: TextStyle(
              fontSize: 16,
              color: AppConstants.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Implement upload functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Start Recording',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnalyticsContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.analytics,
              size: 60,
              color: AppConstants.primaryColor,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Analytics',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Track your video performance',
            style: TextStyle(
              fontSize: 16,
              color: AppConstants.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedBottomIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: AppConstants.textSecondary,
        backgroundColor: Colors.white,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}