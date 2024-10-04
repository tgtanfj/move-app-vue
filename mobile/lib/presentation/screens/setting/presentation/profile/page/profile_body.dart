import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/config/theme/app_images.dart';
import 'package:move_app/presentation/screens/home/page/home_page.dart';
import 'package:move_app/utils/string_extentions.dart';

import '../../../../../../config/theme/app_colors.dart';
import '../../../../../../config/theme/app_text_styles.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../components/custom_button.dart';
import '../../../../../components/custom_dropdown_button.dart';
import '../../../../../components/custom_edit_text.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/date_picker.dart';
import '../widgets/gender_radio_group.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.success) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        return state.user == null
            ? const SizedBox()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 19),
                    _createTitle(title: Constants.profilePicture),
                    ClipOval(
                      child: state.imageLocal == null &&
                              state.user!.avatar.isNullOrEmpty
                          ? Image.asset(
                              AppImages.defaultAvatar.webpAssetPath,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            )
                          : state.imageLocal != null
                              ? Image.file(
                                  state.imageLocal!,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  state.user!.avatar!,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                ),
                    ),
                    Visibility(
                      visible: state.isShowAvatarMessage,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.lavenderBlush,
                            border: Border.all(
                                width: 1, color: AppColors.brinkPink),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            textAlign: TextAlign.center,
                            state.messageUpdateAvatar,
                            style: AppTextStyles.montserratStyle.regular14Black,
                          )),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<ProfileBloc>()
                            .add(ProfileUpdateAvatarEvent());
                      },
                      style: TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerLeft),
                      child: Text(
                        Constants.updateProfilePicture,
                        style:
                            AppTextStyles.montserratStyle.regular14TiffanyBlue,
                      ),
                    ),
                    CustomEditText(
                      controller:
                          TextEditingController(text: state.user?.username),
                      isShowMessage: state.isShowUsernameMessage,
                      title: Constants.username,
                      textStyle: state.isShowUsernameMessage
                          ? AppTextStyles.montserratStyle.regular16BrinkPink
                          : AppTextStyles.montserratStyle.regular16Black,
                      cursorColor: state.isShowUsernameMessage
                          ? AppColors.brinkPink
                          : AppColors.tiffanyBlue,
                      borderColor: AppColors.brinkPink,
                      preMessage: state.messageInputUsername,
                      widthMessage: MediaQuery.of(context).size.width,
                      onChanged: (value) {
                        context
                            .read<ProfileBloc>()
                            .add(ProfileUsernameChangeEvent(username: value));
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomEditText(
                      title: Constants.email,
                      textStyle: AppTextStyles.montserratStyle.regular16Black,
                      controller:
                          TextEditingController(text: state.user?.email),
                      enable: false,
                    ),
                    const SizedBox(height: 16),
                    CustomEditText(
                      controller:
                          TextEditingController(text: state.user?.fullName),
                      isShowMessage: state.isShowFullNameMessage,
                      title: Constants.fullName,
                      textStyle: state.isShowFullNameMessage
                          ? AppTextStyles.montserratStyle.regular16BrinkPink
                          : AppTextStyles.montserratStyle.regular16Black,
                      cursorColor: state.isShowFullNameMessage
                          ? AppColors.brinkPink
                          : AppColors.tiffanyBlue,
                      borderColor: AppColors.brinkPink,
                      preMessage: state.messageInputFullName,
                      widthMessage: MediaQuery.of(context).size.width,
                      onChanged: (value) {
                        context
                            .read<ProfileBloc>()
                            .add(ProfileFullNameChangeEvent(
                              fullName: value,
                            ));
                      },
                    ),
                    const SizedBox(height: 16),
                    _createTitle(title: Constants.gender),
                    GenderRadioGroup(
                      selectedGender: Gender.values.firstWhere(
                        (gender) => gender.value == state.user?.gender,
                        orElse: () => Gender.male,
                      ),
                      onChanged: (gender) {
                        context.read<ProfileBloc>().add(
                            ProfileGenderChangedEvent(selectedGender: gender));
                      },
                    ),
                    const SizedBox(height: 16),
                    _createTitle(title: Constants.dateOfBirth),
                    const SizedBox(height: 4),
                    DatePicker(
                      date: state.user?.dateOfBirth,
                      onDateChanged: (datetime) {
                        context
                            .read<ProfileBloc>()
                            .add(ProfileUpdateDateOfBirthEvent(datetime));
                      },
                      isShowMessage: state.isShowDateOfBirthMessage,
                      message: state.messageSelectDateOfBirth,
                    ),
                    const SizedBox(height: 16),
                    _createTitle(title: Constants.country),
                    CustomDropdownButton(
                      hintText: Constants.pleaseSelectCountry,
                      initialValue: state.user?.country?.id,
                      items: state.countryList.map((country) {
                        return {'id': country.id, 'name': country.name};
                      }).toList(),
                      onChanged: (countryId) {
                        final country = state.countryList
                            .firstWhere((e) => e.id == countryId);
                        if (country.id != null) {
                          context.read<ProfileBloc>().add(
                              ProfileCountrySelectEvent(
                                  countryId: country.id!));
                        }
                      },
                      isShowMessage: state.isShowCountryMessage,
                      message: state.messageSelectCountry,
                    ),
                    const SizedBox(height: 16),
                    _createTitle(title: Constants.state),
                    CustomDropdownButton(
                      hintText: Constants.pleaseSelectState,
                      initialValue: state.user?.state?.id,
                      items: state.stateList
                          .map((state) {
                            return {'id': state.id, 'name': state.name};
                          })
                          .toSet()
                          .toList(),
                      onChanged: (stateId) {
                        final stateItem =
                            state.stateList.firstWhere((e) => e.id == stateId);
                        if (stateItem.id != null) {
                          context.read<ProfileBloc>().add(
                              ProfileStateSelectEvent(stateId: stateItem.id!));
                        }
                      },
                      isShowMessage: state.isShowStateMessage,
                      message: state.messageSelectState,
                    ),
                    const SizedBox(height: 16),
                    CustomEditText(
                      controller: TextEditingController(text: state.user?.city),
                      title: Constants.city,
                      isShowMessage: state.isShowCityMessage,
                      textStyle: state.isShowCityMessage
                          ? AppTextStyles.montserratStyle.regular16BrinkPink
                          : AppTextStyles.montserratStyle.regular16Black,
                      cursorColor: state.isShowCityMessage
                          ? AppColors.brinkPink
                          : AppColors.tiffanyBlue,
                      borderColor: AppColors.brinkPink,
                      preMessage: state.messageInputCity,
                      widthMessage: MediaQuery.of(context).size.width,
                      onChanged: (value) {
                        context
                            .read<ProfileBloc>()
                            .add(ProfileCityChangeEvent(city: value));
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                        isEnabled: state.isEnableSaveSettings,
                        mainAxisSize: MainAxisSize.max,
                        title: Constants.saveSetting,
                        titleStyle: AppTextStyles.montserratStyle.bold16White,
                        borderColor: state.isEnableSaveSettings
                            ? AppColors.tiffanyBlue
                            : AppColors.spanishGray,
                        backgroundColor: state.isEnableSaveSettings
                            ? AppColors.tiffanyBlue
                            : AppColors.spanishGray,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          context
                              .read<ProfileBloc>()
                              .add(ProfileSaveSettingsEvent());
                        }),
                  ],
                ),
              );
      }),
    );
  }

  Widget _createTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: AppTextStyles.montserratStyle.regular16Black,
      ),
    );
  }
}
