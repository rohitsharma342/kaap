import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/video.dart';
import '../utils/constants.dart';

class VideoCard extends StatelessWidget {
  final Video video;
  final VoidCallback onTap;
  
  const VideoCard({
    Key? key,
    required this.video,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(),
            _buildVideoInfo(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildThumbnail() {
    return Expanded(
      flex: 3,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.borderRadius),
          ),
          color: Colors.grey[200],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppConstants.borderRadius),
              ),
              child: CachedNetworkImage(
                imageUrl: video.thumbnailUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildThumbnailPlaceholder(),
                errorWidget: (context, url, error) => _buildThumbnailError(),
              ),
            ),
            
            // Play button overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppConstants.borderRadius),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            
            // Duration badge
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _formatDuration(video.duration),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            
            // Category badge
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  video.category,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildThumbnailPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
      ),
    );
  }
  
  Widget _buildThumbnailError() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            color: Colors.grey[400],
            size: 32,
          ),
          SizedBox(height: 4),
          Text(
            'No image',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildVideoInfo() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              video.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 6),
            
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: video.uploaderAvatar,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppConstants.primaryColor.withOpacity(0.2),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppConstants.primaryColor.withOpacity(0.2),
                        child: Icon(
                          Icons.person,
                          size: 12,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    video.uploaderName,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppConstants.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 6),
            
            Row(
              children: [
                Icon(
                  Icons.remove_red_eye,
                  size: 12,
                  color: AppConstants.textSecondary,
                ),
                SizedBox(width: 4),
                Text(
                  _formatCount(video.views),
                  style: TextStyle(
                    fontSize: 11,
                    color: AppConstants.textSecondary,
                  ),
                ),
                SizedBox(width: 12),
                Icon(
                  video.isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 12,
                  color: video.isLiked ? Colors.red : AppConstants.textSecondary,
                ),
                SizedBox(width: 4),
                Text(
                  _formatCount(video.likes),
                  style: TextStyle(
                    fontSize: 11,
                    color: AppConstants.textSecondary,
                  ),
                ),
                Spacer(),
                Text(
                  _formatTimeAgo(video.uploadedAt),
                  style: TextStyle(
                    fontSize: 10,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
  
  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
  
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}