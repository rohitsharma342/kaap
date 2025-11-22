import 'package:flutter/material.dart';
import '../models/video.dart';
import '../utils/constants.dart';

class VideoController extends ChangeNotifier {
  List<Video> _videos = [];
  List<Video> _filteredVideos = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  
  List<Video> get videos => _filteredVideos;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  
  VideoController() {
    _initializeVideos();
  }
  
  void _initializeVideos() {
    _videos = List.generate(20, (index) {
      final categories = AppConstants.videoCategories.where((c) => c != 'All').toList();
      final category = categories[index % categories.length];
      
      return Video(
        id: 'video_$index',
        title: _getVideoTitle(category, index),
        description: _getVideoDescription(category),
        thumbnailUrl: AppConstants.thumbnailUrls[index % AppConstants.thumbnailUrls.length],
        videoUrl: AppConstants.sampleVideoUrls[index % AppConstants.sampleVideoUrls.length],
        category: category,
        likes: (index + 1) * 123 + (index * 45),
        views: (index + 1) * 1500 + (index * 200),
        uploadedAt: DateTime.now().subtract(Duration(days: index)),
        uploaderName: _getUploaderName(index),
        uploaderAvatar: AppConstants.avatarUrls[index % AppConstants.avatarUrls.length],
        duration: Duration(seconds: 15 + (index * 3)),
        comments: _generateComments(index),
      );
    });
    _filteredVideos = List.from(_videos);
    notifyListeners();
  }
  
  String _getVideoTitle(String category, int index) {
    final titles = {
      'Educational': ['Learn Numbers', 'ABC Song', 'Colors & Shapes', 'Science Fun'],
      'Fun': ['Dance Party', 'Funny Animals', 'Magic Tricks', 'Silly Songs'],
      'Stories': ['Princess Tale', 'Animal Friends', 'Adventure Time', 'Bedtime Story'],
      'Music': ['Kids Songs', 'Nursery Rhymes', 'Musical Fun', 'Sing Along'],
      'Art': ['Drawing Fun', 'Craft Time', 'Paint & Play', 'Creative Art'],
      'Science': ['Space Facts', 'Animal World', 'How Things Work', 'Nature Magic'],
      'Sports': ['Ball Games', 'Running Fun', 'Team Sports', 'Exercise Time'],
    };
    
    final categoryTitles = titles[category] ?? ['Fun Video'];
    return categoryTitles[index % categoryTitles.length] + ' ${index + 1}';
  }
  
  String _getVideoDescription(String category) {
    final descriptions = {
      'Educational': 'Learn something new and exciting!',
      'Fun': 'Have fun with this amazing video!',
      'Stories': 'A wonderful story for kids!',
      'Music': 'Sing and dance along!',
      'Art': 'Express your creativity!',
      'Science': 'Discover the wonders of science!',
      'Sports': 'Get active and have fun!',
    };
    return descriptions[category] ?? 'An awesome video for kids!';
  }
  
  String _getUploaderName(int index) {
    final names = ['Teacher Sam', 'Fun Kids TV', 'Story Land', 'Music Box', 'Art Studio', 'Science Lab', 'Sports Zone'];
    return names[index % names.length];
  }
  
  List<Comment> _generateComments(int index) {
    if (index % 3 == 0) return [];
    
    return List.generate((index % 3) + 1, (i) => Comment(
      id: 'comment_${index}_$i',
      text: AppConstants.presetComments[i % AppConstants.presetComments.length],
      authorName: 'Kid ${index + i}',
      authorAvatar: AppConstants.avatarUrls[i % AppConstants.avatarUrls.length],
      createdAt: DateTime.now().subtract(Duration(hours: i + 1)),
    ));
  }
  
  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }
  
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }
  
  void _applyFilters() {
    _filteredVideos = _videos.where((video) {
      final matchesCategory = _selectedCategory == 'All' || video.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty || 
          video.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          video.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
    notifyListeners();
  }
  
  Future<void> toggleLike(String videoId) async {
    final videoIndex = _videos.indexWhere((v) => v.id == videoId);
    final filteredIndex = _filteredVideos.indexWhere((v) => v.id == videoId);
    
    if (videoIndex != -1) {
      final video = _videos[videoIndex];
      final newLikes = video.isLiked ? video.likes - 1 : video.likes + 1;
      final updatedVideo = video.copyWith(
        isLiked: !video.isLiked,
        likes: newLikes,
      );
      
      _videos[videoIndex] = updatedVideo;
      if (filteredIndex != -1) {
        _filteredVideos[filteredIndex] = updatedVideo;
      }
      notifyListeners();
    }
  }
  
  Future<void> addComment(String videoId, String comment, String authorName, String authorAvatar) async {
    final videoIndex = _videos.indexWhere((v) => v.id == videoId);
    if (videoIndex != -1) {
      final video = _videos[videoIndex];
      final newComment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: comment,
        authorName: authorName,
        authorAvatar: authorAvatar,
        createdAt: DateTime.now(),
      );
      
      final updatedComments = List<Comment>.from(video.comments)..insert(0, newComment);
      final updatedVideo = video.copyWith(comments: updatedComments);
      
      _videos[videoIndex] = updatedVideo;
      final filteredIndex = _filteredVideos.indexWhere((v) => v.id == videoId);
      if (filteredIndex != -1) {
        _filteredVideos[filteredIndex] = updatedVideo;
      }
      notifyListeners();
    }
  }
  
  Video? getVideoById(String id) {
    try {
      return _videos.firstWhere((video) => video.id == id);
    } catch (e) {
      return null;
    }
  }
}