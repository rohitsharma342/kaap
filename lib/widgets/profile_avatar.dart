import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/constants.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final bool showBorder;
  final Color borderColor;
  final VoidCallback? onTap;
  
  const ProfileAvatar({
    Key? key,
    required this.imageUrl,
    this.size = 60,
    this.showBorder = false,
    this.borderColor = Colors.white,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: borderColor,
                width: 3,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildPlaceholder(),
          errorWidget: (context, url, error) => _buildErrorWidget(),
        ),
      ),
    );
    
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }
    
    return avatar;
  }
  
  Widget _buildPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
  
  Widget _buildErrorWidget() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        color: AppConstants.primaryColor,
        size: size * 0.5,
      ),
    );
  }
}