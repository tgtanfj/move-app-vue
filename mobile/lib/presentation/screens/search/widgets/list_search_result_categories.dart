import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/data/models/category_model.dart';

import '../../../../config/theme/app_images.dart';

class ListSearchResultCategories extends StatelessWidget {
  final List<CategoryModel> categoryList;

  const ListSearchResultCategories({super.key, required this.categoryList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categoryList.isEmpty ? categoryList.length : 1,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {},
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
              Row(
                children: [
                  Text(categoryList[index].numberOfViews.toString() ?? '',
                      style:
                          AppTextStyles.montserratStyle.regular14graniteGray),
                  const Text(" views")
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
