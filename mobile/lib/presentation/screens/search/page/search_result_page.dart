import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/search/bloc/search_result_bloc.dart';
import 'package:move_app/presentation/screens/search/bloc/search_result_event.dart';
import 'package:move_app/presentation/screens/search/page/search_result_body.dart';

class SearchResultPage extends StatelessWidget {
  final String? searchQuery;
  const SearchResultPage({super.key, this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchResultBloc>(
      create: (context) {
        final bloc = SearchResultBloc();
        bloc.add(const SearchResultInitialEvent());
        return bloc;
      },
      child:  SearchResultBody(searchQuery: searchQuery,),
    );
  }
}
