import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SafeCommentInput extends StatefulWidget {
  final Function(String) onCommentSubmit;
  
  const SafeCommentInput({
    Key? key,
    required this.onCommentSubmit,
  }) : super(key: key);
  
  @override
  _SafeCommentInputState createState() => _SafeCommentInputState();
}

class _SafeCommentInputState extends State<SafeCommentInput> {
  String selectedComment = '';
  bool showPresets = true;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showPresets) _buildPresetComments(),
          SizedBox(height: 12),
          _buildCommentInput(),
        ],
      ),
    );
  }
  
  Widget _buildPresetComments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Comments',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimary,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.presetComments.map((comment) {
            final isSelected = selectedComment == comment;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedComment = isSelected ? '' : comment;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppConstants.primaryColor 
                      : AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected 
                        ? AppConstants.primaryColor 
                        : AppConstants.primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  comment,
                  style: TextStyle(
                    color: isSelected 
                        ? Colors.white 
                        : AppConstants.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  Widget _buildCommentInput() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppConstants.backgroundColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: selectedComment.isNotEmpty 
                    ? AppConstants.primaryColor 
                    : Colors.grey[300]!,
                width: selectedComment.isNotEmpty ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.message,
                  color: selectedComment.isNotEmpty 
                      ? AppConstants.primaryColor 
                      : AppConstants.textSecondary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedComment.isNotEmpty 
                        ? selectedComment 
                        : 'Choose a comment above',
                    style: TextStyle(
                      color: selectedComment.isNotEmpty 
                          ? AppConstants.textPrimary 
                          : AppConstants.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (selectedComment.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedComment = '';
                      });
                    },
                    child: Icon(
                      Icons.close,
                      color: AppConstants.textSecondary,
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12),
        
        GestureDetector(
          onTap: selectedComment.isNotEmpty ? _submitComment : null,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: selectedComment.isNotEmpty 
                  ? AppConstants.primaryColor 
                  : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
  
  void _submitComment() {
    if (selectedComment.isNotEmpty) {
      widget.onCommentSubmit(selectedComment);
      setState(() {
        selectedComment = '';
      });
      
      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Comment added!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}