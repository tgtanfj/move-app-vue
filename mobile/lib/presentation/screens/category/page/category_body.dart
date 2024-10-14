import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:move_app/config/theme/app_images.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/constants/key_screen.dart';
import 'package:move_app/data/data_sources/dummy_data.dart';
import 'package:move_app/presentation/components/app_bar_widget.dart';
import 'package:move_app/presentation/components/category_item.dart';
import 'package:move_app/presentation/screens/category/bloc/category_bloc.dart';
import 'package:move_app/presentation/screens/category/bloc/category_state.dart';

class CategoryBody extends StatefulWidget {
  const CategoryBody({super.key});

  @override
  State<CategoryBody> createState() => _CategoryBodyState();
}

class _CategoryBodyState extends State<CategoryBody> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BlocConsumer<CategoryBloc, CategoryState>(
      listener: (context, state) {
        state.status == CategoryStatus.processing
            ? EasyLoading.show()
            : EasyLoading.dismiss();
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const AppBarWidget(),
          body: Dismissible(
            key: const Key(KeyScreen.categoryPage),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) => Navigator.pop(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Constants.categories,
                          style: AppTextStyles.montserratStyle.bold20black),
                      Image.asset(
                        AppImages.headline.webpAssetPath,
                        width: width * 0.5,
                        height: 8.0,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.68,
                    ),
                    padding: const EdgeInsets.all(10),
                    itemCount: dummyCategories.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: CategoryItem(
                          categoryModel: dummyCategories[index],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
