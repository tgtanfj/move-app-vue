import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/category/bloc/category_bloc.dart';
import 'package:move_app/presentation/screens/category/bloc/category_event.dart';
import 'package:move_app/presentation/screens/category/page/category_body.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryBloc>(
      create: (context) => CategoryBloc()..add(CategoryInitialEvent()),
      child: const CategoryBody(),
    );
  }
}