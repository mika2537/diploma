import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessagePreviewCard extends StatefulWidget {
  final Map<String, dynamic> messageData;
  final Function(String) onMessageSent;

  const MessagePreviewCard({
    super.key,
    required this.messageData,
    required this.onMessageSent,
  });

  @override
  State<MessagePreviewCard> createState() => _MessagePreviewCardState();
}

class _MessagePreviewCardState extends State<MessagePreviewCard> {
  final TextEditingController _messageController = TextEditingController();
  final int _maxCharacters = 200;
  bool _isExpanded = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow,
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMessageHeader(context),
          SizedBox(height: 2.h),
          if (widget.messageData["hasExistingMessages"] as bool) ...[
            _buildExistingMessages(context),
            SizedBox(height: 2.h),
          ],
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: CustomIconWidget(
            iconName: 'chat',
            color: colorScheme.primary,
            size: 5.w,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Зорчигчтой харилцах',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                'Аялалын өмнө асуулт асуух боломжтой',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExistingMessages(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final messages = widget.messageData["existingMessages"] as List;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Өмнөх мессежүүд',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded ? 'Хураах' : 'Дэлгэх',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: _isExpanded ? 'expand_less' : 'expand_more',
                      color: colorScheme.primary,
                      size: 4.w,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded ? null : 8.h,
            child: SingleChildScrollView(
              child: Column(
                children: messages
                    .take(_isExpanded ? messages.length : 2)
                    .map((message) {
                  final msg = message as Map<String, dynamic>;
                  return _buildMessageBubble(context, msg);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
      BuildContext context, Map<String, dynamic> message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isFromPassenger = message["isFromPassenger"] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment:
        isFromPassenger ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isFromPassenger) ...[
            Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                child: CustomImageWidget(
                  imageUrl: message["senderAvatar"] as String,
                  width: 6.w,
                  height: 6.w,
                  fit: BoxFit.cover,
                  semanticLabel: message["senderAvatarSemanticLabel"] as String,
                ),
              ),
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
              decoration: BoxDecoration(
                color: isFromPassenger
                    ? colorScheme.surfaceContainerHigh
                    : colorScheme.primary,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message["content"] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isFromPassenger
                          ? colorScheme.onSurface
                          : AppTheme.onPrimaryWhite,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    message["timestamp"] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isFromPassenger
                          ? colorScheme.onSurfaceVariant
                          : AppTheme.onPrimaryWhite.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isFromPassenger) SizedBox(width: 8.w),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final remainingChars = _maxCharacters - _messageController.text.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: TextField(
            controller: _messageController,
            maxLines: 3,
            maxLength: _maxCharacters,
            decoration: InputDecoration(
              hintText: 'Зорчигчид мессеж бичих...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(3.w),
              counterText: '',
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
            onChanged: (value) => setState(() {}),
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$remainingChars тэмдэгт үлдсэн',
              style: theme.textTheme.bodySmall?.copyWith(
                color: remainingChars < 20
                    ? AppTheme.errorRed
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            Row(
              children: [
                _buildQuickMessageButton(context, 'Сайн байна уу?'),
                SizedBox(width: 2.w),
                _buildQuickMessageButton(context, 'Хэзээ хүрэх вэ?'),
              ],
            ),
          ],
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _messageController.text.trim().isNotEmpty
                ? () => _sendMessage()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: AppTheme.onPrimaryWhite,
              padding: EdgeInsets.symmetric(vertical: 3.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'send',
                  color: AppTheme.onPrimaryWhite,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Мессеж илгээх',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.onPrimaryWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickMessageButton(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => _setQuickMessage(message),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          message,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _setQuickMessage(String message) {
    setState(() {
      _messageController.text = message;
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      widget.onMessageSent(_messageController.text.trim());
      _messageController.clear();
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Мессеж амжилттай илгээгдлээ'),
          backgroundColor: AppTheme.successGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      );
    }
  }
}
