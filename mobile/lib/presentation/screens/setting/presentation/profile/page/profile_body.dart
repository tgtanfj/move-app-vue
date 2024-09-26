import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/config/theme/app_colors.dart';

import '../../../../../../config/theme/app_text_styles.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../components/custom_button.dart';
import '../../../../../components/custom_dropdown_button.dart';
import '../../../../../components/custom_edit_text.dart';
import '../../../../../components/daypicker_dropdown/datepicker_dropdown.dart';
import '../../../../../components/daypicker_dropdown/order_format.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
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
      listener: (context, state) {},
      child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 19),
              _createTitle(title: Constants.profilePicture),
              ClipOval(
                child: Container(
                  alignment: Alignment.center,
                  width: 56,
                  height: 56,
                  color: AppColors.tiffanyBlue,
                  child: Text(Constants.j,
                      style: AppTextStyles.montserratStyle.bold23White),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft),
                child: Text(
                  Constants.updateProfilePicture,
                  style: AppTextStyles.montserratStyle.regular14tiffanyBlue,
                ),
              ),
              const CustomEditText(
                title: Constants.username,
              ),
              const SizedBox(height: 16),
              const CustomEditText(
                title: Constants.email,
              ),
              const SizedBox(height: 16),
              const CustomEditText(
                title: Constants.fullName,
              ),
              const SizedBox(height: 16),
              _createTitle(title: Constants.gender),
              GenderRadioGroup(
                selectedGender: state.selectedGender,
                onChanged: (gender) {
                  context
                      .read<ProfileBloc>()
                      .add(ProfileGenderChangedEvent(selectedGender: gender));
                },
              ),
              const SizedBox(height: 16),
              _createTitle(title: Constants.dateOfBirth),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(right: 36),
                child: DropdownDatePicker(
                  dateFormatOrder: OrderFormat.DMY,
                  isFormValidator: true,
                  startYear: 1959,
                  endYear: 2011,
                  width: 10,
                  onChangedDay: (value) {},
                  onChangedMonth: (value) {},
                  onChangedYear: (value) {},
                  hintTextStyle: AppTextStyles.montserratStyle.regular16Black,
                ),
              ),
              const SizedBox(height: 16),
              _createTitle(title: Constants.country),
              const CustomDropdownButton(hintText: Constants.malaysia),
              const SizedBox(height: 16),
              _createTitle(title: Constants.state),
              const CustomDropdownButton(hintText: Constants.pleaseSelectState),
              const SizedBox(height: 16),
              const CustomEditText(
                title: Constants.city,
              ),
              const SizedBox(height: 16),
              CustomButton(
                title: Constants.saveSetting,
                titleStyle: AppTextStyles.montserratStyle.bold16White,
                backgroundColor: AppColors.tiffanyBlue,
              ),
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
