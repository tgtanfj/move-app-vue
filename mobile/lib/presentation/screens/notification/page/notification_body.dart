import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/screens/notification/bloc/notification_bloc.dart';
import 'package:move_app/presentation/screens/notification/bloc/notification_state.dart';
import 'package:move_app/presentation/screens/notification/widgets/item_notification.dart';

import '../../../../config/theme/app_colors.dart';
import '../bloc/notification_event.dart';

class NotificationBody extends StatefulWidget {
  const NotificationBody({super.key});

  @override
  State<NotificationBody> createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<NotificationBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      builder: (BuildContext context, NotificationState state) {
        return Material(
          color: AppColors.black,
          child: SafeArea(
            child: Column(
              children: [
                AppBarWidget(
                  title: Constants.notifications,
                  titleStyle: AppTextStyles.montserratStyle.bold20White,
                  titleAlign: TextAlign.center,
                  prefixButton: (){
                    Navigator.of(context).pop();
                  },
                  prefixIconPath: AppIcons.closeWhite.svgAssetPath,
                  paddingTitle: const EdgeInsets.only(right: 20),
                  isEnableSuffixIcon: false,
                ),
                Container(
                  color: Colors.white,
                  height: 1,
                ),
                state.listNotifications?.isEmpty ?? true
                    ? Flexible(
                        child: Center(
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                Constants.emptyNotification,
                                textAlign: TextAlign.center,
                                style: AppTextStyles
                                    .montserratStyle.regular14White,
                              )),
                        ),
                      )
                    : Expanded(
                        child: LazyLoadScrollView(
                          onEndOfPage: () {
                            context
                                .read<NotificationBloc>()
                                .add(NotificationsLoadMoreEvent());
                          },
                          child: Scrollbar(
                            thickness: 4.0,
                            radius: const Radius.circular(8),
                            thumbVisibility: true,
                            child: ListView.separated(
                              addAutomaticKeepAlives: true,
                              itemCount:
                                  (state.listNotifications?.length ?? 0) + 1,
                              itemBuilder: (context, index) {
                                if (index == state.listNotifications?.length) {
                                  return const SizedBox.shrink();
                                }
                                final notification =
                                    state.listNotifications?[index];
                                return ItemNotification(
                                  notificationModel: notification,
                                  onTapNotification: () {
                                    context.read<NotificationBloc>().add(
                                        NotificationMarkAsReadEvent(
                                            notification?.key ?? ""));
                                  },
                                );
                              },
                              separatorBuilder: (context, index) => Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 20),
                                  child: const Divider(height: 1)),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
      listener: (BuildContext context, NotificationState state) {
        state.status == NotificationStatus.processing
            ? EasyLoading.show()
            : EasyLoading.dismiss();
      },
    );
  }
}
