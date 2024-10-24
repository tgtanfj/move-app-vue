import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/config/theme/app_icons.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/screens/notification/bloc/notification_bloc.dart';
import 'package:move_app/presentation/screens/notification/bloc/notification_state.dart';
import 'package:move_app/presentation/screens/notification/widgets/dialog_notice.dart';
import 'package:move_app/presentation/screens/notification/widgets/item_notification.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../data/data_sources/dummy_data.dart';

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
                  prefixIconPath: AppIcons.closeWhite.svgAssetPath,
                  paddingTitle: const EdgeInsets.only(right: 20),
                  isEnableSuffixIcon: false,
                ),
                Container(
                  color: Colors.white,
                  height: 1,
                ),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    thickness: 8.0,
                    radius: const Radius.circular(5),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        return ItemNotification(
                          notificationModel: notifications[index],
                          onTapNotification: () {},
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      listener: (BuildContext context, NotificationState state) {},
    );
  }
}
