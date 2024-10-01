import 'package:flutter/material.dart';
import 'package:move_app/config/theme/app_text_styles.dart';

class ListCategories extends StatefulWidget {
  const ListCategories({super.key});

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
        return GestureDetector(
          onTap: () {},
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.33,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://tse3.mm.bing.net/th?id=OIP.AJsCJ50a7hBVrQjYpdhKOAHaLH&pid=Api&P=0&h=180',
                  height: MediaQuery.of(context).size.width * 0.33 * 1.45,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'MMA',
                  style: AppTextStyles.montserratStyle.bold18black,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('12k views',
                    style: AppTextStyles.montserratStyle.regular14graniteGray),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(width: 12.0);
      },
    );
  }
}
