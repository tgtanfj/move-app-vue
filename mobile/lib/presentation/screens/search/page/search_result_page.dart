import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/home/bloc/home_bloc.dart';
import 'package:move_app/presentation/screens/home/bloc/home_event.dart';
import 'package:move_app/presentation/screens/home/page/home_body.dart';
import 'package:move_app/presentation/screens/search/bloc/search_result_bloc.dart';
import 'package:move_app/presentation/screens/search/bloc/search_result_event.dart';
import 'package:move_app/presentation/screens/search/page/search_result_body.dart';

class SearchResultPage extends StatelessWidget {
  final String? searchQuery;
  const SearchResultPage({super.key, this.searchQuery});

  @override
  Widget build(BuildContext context) {
    print(searchQuery);
    return BlocProvider<SearchResultBloc>(
      create: (context) => SearchResultBloc()..add(SearchResultInitialEvent(searchQuery: searchQuery)),
      child:  SearchResultBody(searchQuery: searchQuery,),
    );
  }
}
