import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/presentation/components/custom_search_box.dart';
import 'package:move_app/presentation/components/custom_section_title.dart';
import 'package:move_app/presentation/screens/search/widgets/list_channels.dart';
import 'package:move_app/presentation/screens/search/widgets/list_search_result_categories.dart';
import 'package:move_app/presentation/screens/search/widgets/list_search_result_video.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_icons.dart';
import '../../home/bloc/home_bloc.dart';
import '../../home/bloc/home_event.dart';

class SearchResultBody extends StatefulWidget {
  final String searchQuery;

  const SearchResultBody({super.key, required this.searchQuery});

  @override
  State<SearchResultBody> createState() => _SearchResultBodyState();
}

class _SearchResultBodyState extends State<SearchResultBody> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSearchBox(
        controller: _controller,
        padding: const EdgeInsets.only(left: 16, bottom: 4, top: 4),
        borderRadius: 25,
        suffix: IconButton(
          onPressed: () {
            _controller.clear();
          },
          icon: SvgPicture.asset(AppIcons.closeCircle.svgAssetPath),
          padding: EdgeInsets.zero,
          iconSize: 28,
          constraints: const BoxConstraints(),
          style: const ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        ),
        onSubmitted: (value) {
          context
              .read<HomeBloc>()
              .add(HomeSaveSearchHistoryEvent(searchText: value));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResultBody(
                searchQuery: value,
              ),
            ),
          );
        },
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              const CustomSectionTitle(title: Constants.searchResults),
              const SizedBox(
                height: 24,
              ),
              Text(
                Constants.categories,
                style: AppTextStyles.montserratStyle.bold16Black,
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.33,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const ListSearchResultCategories(),
              ),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Text(
                Constants.channels,
                style: AppTextStyles.montserratStyle.bold16Black,
              ),
              const SizedBox(height: 16),
              const ListChannels(),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Text(
                Constants.videos,
                style: AppTextStyles.montserratStyle.bold16Black,
              ),
              const SizedBox(height: 16),
              const ListSearchResultVideo(),
            ],
          ),
        ),
      ),
    );
  }
}
