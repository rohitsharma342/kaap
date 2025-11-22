import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../models/video.dart';
import '../controllers/video_controller.dart';
import '../controllers/profile_controller.dart';
import '../widgets/safe_comment_input.dart';
import '../utils/constants.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Video video;
  
  const VideoPlayerScreen({Key? key, required this.video}) : super(key: key);
  
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showControls = true;
  bool _isPlaying = false;
  bool _showComments = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() async {
    _controller = VideoPlayerController.network(widget.video.videoUrl);
    try {
      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });
      _controller.addListener(() {
        if (mounted) {
          setState(() {
            _isPlaying = _controller.value.isPlaying;
          });
        }
      });
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildVideoPlayer(),
          _buildVideoOverlay(),
          _buildVideoControls(),
          if (_showComments) _buildCommentsSheet(),
        ],
      ),
    );
  }
  
  Widget _buildVideoPlayer() {
    if (!_isInitialized) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Loading video...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    
    return GestureDetector(
      onTap: _toggleControls,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }
  
  Widget _buildVideoOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.video.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${widget.video.views} views',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildVideoControls() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        width: 80,
        height: MediaQuery.of(context).size.height * 0.6,
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              icon: widget.video.isLiked ? Icons.favorite : Icons.favorite_border,
              label: _formatCount(widget.video.likes),
              onTap: _toggleLike,
              isActive: widget.video.isLiked,
            ),
            _buildActionButton(
              icon: Icons.comment,
              label: _formatCount(widget.video.comments.length),
              onTap: _toggleComments,
            ),
            _buildActionButton(
              icon: Icons.share,
              label: 'Share',
              onTap: _shareVideo,
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  widget.video.uploaderAvatar,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppConstants.primaryColor,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.red : Colors.white,
              size: 24,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCommentsSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showComments = false;
                      });
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: widget.video.comments.length,
                itemBuilder: (context, index) {
                  final comment = widget.video.comments[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(comment.authorAvatar),
                          backgroundColor: AppConstants.primaryColor.withOpacity(0.2),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.authorName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppConstants.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                comment.text,
                                style: TextStyle(
                                  color: AppConstants.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SafeCommentInput(
              onCommentSubmit: _addComment,
            ),
          ],
        ),
      ),
    );
  }
  
  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }
  
  void _toggleLike() {
    context.read<VideoController>().toggleLike(widget.video.id);
  }
  
  void _toggleComments() {
    setState(() {
      _showComments = !_showComments;
    });
  }
  
  void _shareVideo() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Video',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(Icons.link, 'Copy Link'),
                _buildShareOption(Icons.message, 'Message'),
                _buildShareOption(Icons.email, 'Email'),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildShareOption(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label feature coming soon!')),
        );
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppConstants.primaryColor,
              size: 30,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppConstants.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  void _addComment(String comment) {
    final profileController = context.read<ProfileController>();
    final profile = profileController.selectedProfile;
    
    if (profile != null) {
      context.read<VideoController>().addComment(
        widget.video.id,
        comment,
        profile.name,
        profile.avatarUrl,
      );
    }
  }
  
  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}