import 'package:bloc/bloc.dart';
import 'package:move_app/presentation/screens/category/bloc/category_event.dart';
import 'package:move_app/presentation/screens/category/bloc/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryState.initial()) {
    on<CategoryInitialEvent>(_onCategoryInitialEvent);
  }

  void _onCategoryInitialEvent(
      CategoryInitialEvent event, Emitter<CategoryState> emit) {}
}
