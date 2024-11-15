import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_images.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/utils/util_number_format.dart';

import '../../videos_category/page/videos_category_page.dart';

class ListSearchResultCategories extends StatelessWidget {
  final List<CategoryModel> categoryList;

  const ListSearchResultCategories({super.key, required this.categoryList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: categoryList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideosCategoryPage(
                  categoryId: categoryList[index].id ?? 0,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                categoryList[index].image ?? "",
                height: MediaQuery.of(context).size.width * 0.33 * 1.45,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    AppImages.hiitCategory.pngAssetPath,
                    fit: BoxFit.cover,
                  );
                },
              ),
              const SizedBox(height: 8.0),
              Text(
                categoryList[index].title ?? "",
                style: AppTextStyles.montserratStyle.bold18black,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text:
                        categoryList[index].numberOfViews?.toCompactViewCount(),
                    style: AppTextStyles.montserratStyle.regular14graniteGray),
                TextSpan(
                    text: " views",
                    style: AppTextStyles.montserratStyle.regular14graniteGray),
              ]))
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          width: 20,
        );
      },
    );
  }
}
