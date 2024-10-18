import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_text_styles.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/utils/util_number_format.dart';

class CategoryItem extends StatefulWidget {
  final CategoryModel categoryModel;
  const CategoryItem({super.key, required this.categoryModel});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.33,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.categoryModel.image ?? '',
              height: MediaQuery.of(context).size.width * 0.33 * 1.45,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.categoryModel.title ?? '',
              style: AppTextStyles.montserratStyle.bold18black,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
                '${widget.categoryModel.numberOfViews?.toCompactViewCount()} views',
                style: AppTextStyles.montserratStyle.regular14graniteGray),
          ],
        ),
      ),
    );
  }
}
