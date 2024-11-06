import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/data_sources/local/shared_preferences.dart';
import 'package:move_app/data/models/comment_model.dart';
import '../../../../config/theme/app_images.dart';

class ItemComment extends StatefulWidget {
  final CommentModel? commentModel;
  final VoidCallback? onTapLike;
  final VoidCallback? onTapDislike;
  final Widget? widgetListReplies;
  final Widget? widgetShowListReplies;
  final Widget? widgetHideListReplies;
  final VoidCallback? onTapShowInputReply;
  final VoidCallback? onTapDelete;
  final bool isHideReplies;
  final Widget? widgetReplyInput;
  final bool isShowReplyButton;
  final bool isShowTemporaryListReply;
  final int? repliesLength;
  final bool hasTargetReplyId;
  final bool hasTargetCommentId;
  final bool isCommentable;

  const ItemComment({
    super.key,
    this.commentModel,
    this.onTapLike,
    this.onTapDislike,
    this.widgetListReplies,
    this.widgetShowListReplies,
    this.widgetHideListReplies,
    this.isHideReplies = true,
    this.widgetReplyInput,
    this.onTapShowInputReply,
    this.isShowReplyButton = true,
    this.isShowTemporaryListReply = false,
    this.repliesLength,
    this.hasTargetReplyId = false,
    this.hasTargetCommentId = false,
    this.isCommentable = true,
    this.onTapDelete,
  });

  @override
  State<ItemComment> createState() => _ItemCommentState();
}

class _ItemCommentState extends State<ItemComment> {
  bool isSeeMore = false;
  bool isShowTextCopy = false;

  void _handleCopy() {
    Clipboard.setData(ClipboardData(text: widget.commentModel?.content ?? ""));

    setState(() => isShowTextCopy = true);
    Future.delayed(const Duration(seconds: 3), () {
      setState(() => isShowTextCopy = false);
    });
  }

  String getRepImage(int totalDonation) {
    if (totalDonation == 100) {
      return AppIcons.grayRep.svgAssetPath;
    } else if (totalDonation > 100 && totalDonation <= 1000) {
      return AppIcons.tiffanyRep.svgAssetPath;
    } else if (totalDonation > 1000 && totalDonation <= 5000) {
      return AppIcons.pinkRep.svgAssetPath;
    } else if (totalDonation > 5000 && totalDonation <= 10000) {
      return AppIcons.blueRep.svgAssetPath;
    } else {
      return AppIcons.locReps.svgAssetPath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildHighlightDecoration(widget.hasTargetReplyId),
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 15, right: 12, left: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserRow(),
              _buildReplySection(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration? _buildHighlightDecoration(bool isHighlighted) {
    return isHighlighted
        ? BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.lavenderBlush,
            border: Border.all(width: 1, color: AppColors.tiffanyBlue),
          )
        : null;
  }

  Widget _buildUserRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildUserAvatar(),
        Expanded(child: _buildCommentContent()),
      ],
    );
  }

  Widget _buildUserAvatar() {
    return ClipOval(
      child: (widget.commentModel?.user?.avatar?.isEmpty) ?? true
          ? Image.asset(
              AppImages.defaultAvatar.webpAssetPath,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            )
          : Image.network(
              widget.commentModel?.user?.avatar ?? "",
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  AppImages.defaultAvatar.webpAssetPath,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                );
              },
            ),
    );
  }

  Widget _buildCommentContent() {
    return Container(
      padding: const EdgeInsets.only(left: 12),
      decoration: _buildHighlightDecoration(widget.hasTargetCommentId),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDonationTag(),
              _buildUsernameRow(),
              _buildDonationInfo(),
              const SizedBox(height: 6),
              _buildCommentText(),
              const SizedBox(height: 32),
              _buildActionsRow(),
            ],
          ),
          if (isShowTextCopy) _buildCopiedTextBox(),
        ],
      ),
    );
  }

  Widget _buildCopiedTextBox() {
    return Positioned(
      top: 30,
      right: 0.0,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          Constants.copied,
          style: AppTextStyles.montserratStyle.regular13GraniteGray,
        ),
      ),
    );
  }

  Widget _buildDonationTag() {
    if ((widget.commentModel?.totalDonation ?? 0) <= 0) {
      return const SizedBox.shrink();
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      runSpacing: 2,
      children: [
        SvgPicture.asset(
          AppIcons.repsSender.svgAssetPath,
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.rajah,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Text(widget.commentModel?.lastContentDonate ?? "",
                maxLines: null,
                overflow: TextOverflow.visible,
                style: AppTextStyles.montserratStyle.bold12White),
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameRow() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 4,
      children: [
        Text(widget.commentModel?.user?.username ?? "",
            style: AppTextStyles.montserratStyle.bold16Black),
        const SizedBox(width: 10),
        _buildUserBadge(AppIcons.verify.svgAssetPath,
            widget.commentModel?.user?.channel?.isBlueBadge),
        const SizedBox(width: 5),
        _buildUserBadge(AppIcons.starFlower.svgAssetPath,
            widget.commentModel?.user?.channel?.isPinkBadge),
      ],
    );
  }

  Widget _buildUserBadge(String iconPath, bool? isVisible) {
    if (!(isVisible ?? false)) return const SizedBox.shrink();
    return SvgPicture.asset(iconPath);
  }

  Widget _buildDonationInfo() {
    return Wrap(
      children: [
        if ((widget.commentModel?.totalDonation ?? 0) > 0)
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 4,
            children: [
              SvgPicture.asset(
                getRepImage(widget.commentModel?.totalDonation ?? 0),
                width: 14,
              ),
              const SizedBox(width: 8),
              Text(
                "Gifted '${widget.commentModel?.totalDonation}' REPs",
                style: AppTextStyles.montserratStyle.semiBold14Rajah,
              ),
              const SizedBox(width: 12),
            ],
          ),
        Text(
          widget.commentModel?.getTimeSinceCreated() ?? "",
          style: AppTextStyles.montserratStyle.regular14GraniteGray,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCommentText() {
    String content = widget.commentModel?.content ?? "";
    String previewText = isSeeMore
        ? content
        : (content.length > 300 ? "${content.substring(0, 300)}..." : content);

    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(previewText,
                  style: AppTextStyles.montserratStyle.regular16Black,
                  overflow: TextOverflow.visible),
              if (content.length > 300)
                GestureDetector(
                  onTap: () => setState(() => isSeeMore = !isSeeMore),
                  child: Text(
                    isSeeMore ? Constants.readLess : Constants.readMore,
                    style: AppTextStyles.montserratStyle.semiBold16Grey,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLikeButton(),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.commentModel?.numberOfLike.toString() ?? "0",
                style: widget.isCommentable
                    ? AppTextStyles.montserratStyle.regular16TiffanyBlue
                    : AppTextStyles.montserratStyle.regular16DarkSilver,
              ),
            ),
            const SizedBox(width: 15),
            _buildDislikeButton(),
            const SizedBox(width: 20),
            if (widget.isShowReplyButton) _buildReplyButton(),
          ],
        ),
        _buildPopupButton(),
      ],
    );
  }

  Widget _buildPopupButton() {
    return Column(
      children: [
        PopupMenuButton<String>(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          offset: const Offset(0, -70),
          icon: SvgPicture.asset(AppIcons.dots.svgAssetPath),
          onSelected: (value) {
            if (value == Constants.copy) {
              _handleCopy();
            } else {
              widget.onTapDelete?.call();
            }
          },
          itemBuilder: (BuildContext context) {
            List<PopupMenuEntry<String>> menuItems = [];
            if ((widget.commentModel?.user?.username) ==
                SharedPrefer.sharedPrefer.getUsername()) {
              menuItems.add(
                PopupMenuItem<String>(
                  value: Constants.delete,
                  child: Row(
                    children: [
                      SvgPicture.asset(AppIcons.bin.svgAssetPath),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          Constants.delete,
                          style: AppTextStyles.montserratStyle.regular16Black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            menuItems.add(
              PopupMenuItem<String>(
                value: Constants.copy,
                child: Row(
                  children: [
                    SvgPicture.asset(AppIcons.copy.svgAssetPath),
                    const SizedBox(width: 15),
                    Text(
                      Constants.copy,
                      style: AppTextStyles.montserratStyle.regular16Black,
                    ),
                  ],
                ),
              ),
            );

            return menuItems;
          },
        ),
      ],
    );
  }

  Widget _buildLikeButton() {
    return GestureDetector(
      onTap: widget.onTapLike,
      child: SvgPicture.asset(
        widget.commentModel?.likeStatus == LikeStatus.liked
            ? AppIcons.likeFiled.svgAssetPath
            : AppIcons.like.svgAssetPath,
        colorFilter: widget.isCommentable
            ? null
            : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
      ),
    );
  }

  Widget _buildDislikeButton() {
    return GestureDetector(
      onTap: widget.onTapDislike,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SvgPicture.asset(
          widget.commentModel?.likeStatus == LikeStatus.unliked
              ? AppIcons.dislikeFilled.svgAssetPath
              : AppIcons.dislike.svgAssetPath,
          colorFilter: widget.isCommentable
              ? null
              : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
        ),
      ),
    );
  }

  Widget _buildReplyButton() {
    return GestureDetector(
      onTap: widget.onTapShowInputReply,
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(Constants.reply,
            style: widget.isCommentable
                ? AppTextStyles.montserratStyle.regular16TiffanyBlue
                : AppTextStyles.montserratStyle.regular16DarkSilver),
      ),
    );
  }

  Widget _buildReplySection() {
    return Container(
      margin: const EdgeInsets.only(left: 62),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.widgetReplyInput ?? const SizedBox.shrink(),
          widget.widgetHideListReplies ?? const SizedBox.shrink(),
          widget.isShowTemporaryListReply && !widget.isHideReplies
              ? Wrap(
                  children: [
                    Container(
                      margin: widget.isHideReplies
                          ? const EdgeInsets.only(left: 70)
                          : EdgeInsets.zero,
                      child: widget.widgetShowListReplies,
                    ),
                    widget.widgetListReplies ?? const SizedBox.shrink(),
                  ],
                )
              : Wrap(
                  children: [
                    widget.widgetListReplies ?? const SizedBox.shrink(),
                    Container(
                      margin: widget.isHideReplies
                          ? const EdgeInsets.only(left: 70)
                          : EdgeInsets.zero,
                      child: widget.widgetShowListReplies,
                    ),
                  ],
                ),
          widget.hasTargetReplyId
              ? const SizedBox(height: 15)
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
