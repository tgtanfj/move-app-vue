import 'package:flutter/material.dart';
import 'package:move_app/data/models/category_model.dart';
import 'package:move_app/presentation/components/category_item.dart';

class ListCategories extends StatefulWidget {
  final List<CategoryModel> listCategories;
  const ListCategories({super.key, required this.listCategories});

  @override
  State<ListCategories> createState() => _ListCategoriesState();
}

class _ListCategoriesState extends State<ListCategories> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) {
        return CategoryItem(
          categoryModel: widget.listCategories[index],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(width: 12.0);
      },
    );
  }
}
