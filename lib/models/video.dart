class Video {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final String category;
  final int likes;
  final int views;
  final List<Comment> comments;
  final DateTime uploadedAt;
  final String uploaderName;
  final String uploaderAvatar;
  final Duration duration;
  final bool isLiked;
  
  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.category,
    this.likes = 0,
    this.views = 0,
    this.comments = const [],
    required this.uploadedAt,
    required this.uploaderName,
    required this.uploaderAvatar,
    this.duration = const Duration(seconds: 30),
    this.isLiked = false,
  });
  
  Video copyWith({
    String? id,
    String? title,
    String? description,
    String? thumbnailUrl,
    String? videoUrl,
    String? category,
    int? likes,
    int? views,
    List<Comment>? comments,
    DateTime? uploadedAt,
    String? uploaderName,
    String? uploaderAvatar,
    Duration? duration,
    bool? isLiked,
  }) {
    return Video(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      category: category ?? this.category,
      likes: likes ?? this.likes,
      views: views ?? this.views,
      comments: comments ?? this.comments,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      uploaderName: uploaderName ?? this.uploaderName,
      uploaderAvatar: uploaderAvatar ?? this.uploaderAvatar,
      duration: duration ?? this.duration,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class Comment {
  final String id;
  final String text;
  final String authorName;
  final String authorAvatar;
  final DateTime createdAt;
  
  Comment({
    required this.id,
    required this.text,
    required this.authorName,
    required this.authorAvatar,
    required this.createdAt,
  });
}