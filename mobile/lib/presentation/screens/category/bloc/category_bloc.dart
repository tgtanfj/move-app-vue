import 'package:bloc/bloc.dart';
import 'package:move_app/data/repositories/categories_repository.dart';
import 'package:move_app/presentation/screens/category/bloc/category_event.dart';
import 'package:move_app/presentation/screens/category/bloc/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryState.initial()) {
    on<CategoryInitialEvent>(_onCategoryInitialEvent);
  }
  final categoryRepository = CategoriesRepository();
  void _onCategoryInitialEvent(
      CategoryInitialEvent event, Emitter<CategoryState> emit) async {
    final result = await categoryRepository.getListCategoryAll();
    result.fold((l) {
      emit(state.copyWith(status: CategoryStatus.failure));
    }, (r) {
      emit(state.copyWith(status: CategoryStatus.success, listCategory: r));
    });
  }
}
