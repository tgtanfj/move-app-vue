import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:move_app/config/theme/app_colors.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/comment_model.dart';

import '../../../../config/theme/app_images.dart';

class ItemComment extends StatefulWidget {
  final CommentModel? commentModel;
  final VoidCallback? onTapLike;
  final VoidCallback? onTapDislike;
  final Widget? widgetListReplies;
  final Widget? widgetShowListReplies;
  final Widget? widgetHideListReplies;
  final bool isHideReplies;
  final VoidCallback? onTapShowInputReply;
  final Widget? widgetReplyInput;
  final bool isShowReplyButton;
  final bool isShowTemporaryListReply;
  final int? originalNumOfReply;

  const ItemComment(
      {super.key,
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
      this.originalNumOfReply});

  @override
  State<ItemComment> createState() => _ItemCommentState();
}

class _ItemCommentState extends State<ItemComment> {
  bool isSeeMore = false;
  bool isShowInputReply = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 15, right: 12, left: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipOval(
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
                        )),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.rajah,
                      ),
                      child: Visibility(
                        visible: (widget.commentModel?.totalDonation ?? 0) > 0,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 3, left: 8, bottom: 3),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AppIcons.moveReps.svgAssetPath,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                Constants.repSender,
                                style:
                                    AppTextStyles.montserratStyle.bold12White,
                              ),
                              const SizedBox(
                                width: 19,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          (widget.commentModel?.user?.username?.isEmpty ?? true)
                              ? Constants.anonymous
                              : "${widget.commentModel?.user?.username!}",
                          maxLines: null,
                          style: AppTextStyles.montserratStyle.bold16Black,
                        ),
                        const SizedBox(
                          width: 17,
                        ),
                        Visibility(
                            visible: widget
                                    .commentModel?.user?.channel?.isBlueBadge ??
                                false,
                            child: SvgPicture.asset(
                              AppIcons.verify.svgAssetPath,
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        Visibility(
                            visible: widget
                                    .commentModel?.user?.channel?.isPinkBadge ??
                                false,
                            child: SvgPicture.asset(
                              AppIcons.starFlower.svgAssetPath,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Visibility(
                            visible:
                                (widget.commentModel?.totalDonation ?? 0) > 0,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.locReps.svgAssetPath,
                                  width: 14,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Gifted '${widget.commentModel?.totalDonation}' REPs",
                                  style: AppTextStyles
                                      .montserratStyle.semiBold14Rajah,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                              ],
                            )),
                        Expanded(
                          child: Text(
                            (widget.commentModel?.getTimeSinceCreated() ?? "")
                                .toString(),
                            style: AppTextStyles
                                .montserratStyle.regular14GraniteGray,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isSeeMore
                                ? widget.commentModel?.content ?? ""
                                : ((widget.commentModel?.content ?? "").length >
                                        300
                                    ? "${(widget.commentModel?.content ?? "").substring(0, 300)}..."
                                    : widget.commentModel?.content ?? ""),
                            style: AppTextStyles.montserratStyle.regular16Black,
                            maxLines: null,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.left,
                          ),
                          (widget.commentModel?.content ?? "").length > 300
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isSeeMore = !isSeeMore;
                                    });
                                  },
                                  child: Text(
                                    isSeeMore
                                        ? Constants.showLess
                                        : Constants.readMore,
                                    style: AppTextStyles
                                        .montserratStyle.semiBold16Grey,
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: GestureDetector(
                                onTap: widget.onTapLike,
                                child: SvgPicture.asset(
                                  widget.commentModel?.likeStatus ==
                                          LikeStatus.liked
                                      ? AppIcons.likeFiled.svgAssetPath
                                      : AppIcons.like.svgAssetPath,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                (widget.commentModel?.numberOfLike ?? 0)
                                    .toString(),
                                style: AppTextStyles
                                    .montserratStyle.regular16TiffanyBlue,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GestureDetector(
                                onTap: widget.onTapDislike,
                                child: SvgPicture.asset(
                                  widget.commentModel?.likeStatus ==
                                          LikeStatus.unliked
                                      ? AppIcons.dislikeFilled.svgAssetPath
                                      : AppIcons.dislike.svgAssetPath,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Visibility(
                              visible: widget.isShowReplyButton,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: GestureDetector(
                                  onTap: widget.onTapShowInputReply,
                                  child: Text(
                                    Constants.reply,
                                    style: AppTextStyles
                                        .montserratStyle.regular16TiffanyBlue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: SvgPicture.asset(
                            AppIcons.dots.svgAssetPath,
                          ),
                        ),
                      ],
                    ),
                    widget.widgetReplyInput ?? const SizedBox.shrink(),
                    widget.widgetHideListReplies ?? const SizedBox.shrink(),
                    (widget.isShowTemporaryListReply &&
                            ((widget.commentModel?.numberOfReply ?? 0) >=
                                (widget.originalNumOfReply ?? 0)))
                        ? Wrap(
                            children: [
                              Container(
                                margin: widget.isHideReplies
                                    ? const EdgeInsets.only(left: 70)
                                    : EdgeInsets.zero,
                                child: widget.widgetShowListReplies,
                              ),
                              widget.widgetListReplies ??
                                  const SizedBox.shrink(),
                            ],
                          )
                        : Wrap(
                            children: [
                              widget.widgetListReplies ??
                                  const SizedBox.shrink(),
                              Container(
                                margin: widget.isHideReplies
                                    ? const EdgeInsets.only(left: 70)
                                    : EdgeInsets.zero,
                                child: widget.widgetShowListReplies,
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 16,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
