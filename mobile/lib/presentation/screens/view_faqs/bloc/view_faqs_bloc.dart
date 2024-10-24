import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/repositories/view_faqs_repository.dart';
import 'package:move_app/presentation/screens/view_faqs/bloc/view_faqs_event.dart';
import 'package:move_app/presentation/screens/view_faqs/bloc/view_faqs_state.dart';

class ViewFaqsBloc extends Bloc<ViewFaqsEvent, ViewFaqsState> {
  ViewFaqsBloc() : super(ViewFaqsState.initialState()) {
    on<ViewFaqsInitialEvent>(_onViewFaqsInitialEvent);
    on<FetchFaqsEvent>(_onFetchFaqsEvent);
    on<ViewFaqsClickEvent>(_onViewFaqsClickEvent);
  }

  Future<void> _onFetchFaqsEvent(
      FetchFaqsEvent event, Emitter<ViewFaqsState> emit) async {
    emit(state.copyWith(status: ViewFaqsStatus.loading));
    final faqs = await ViewFaqsRepository().getFaqs();
    faqs.fold(
      (error) => emit(state.copyWith(status: ViewFaqsStatus.error)),
      (faqs) =>
          emit(state.copyWith(status: ViewFaqsStatus.loaded, faqs: faqs.faqs)),
    );
  }

  void _onViewFaqsInitialEvent(
      ViewFaqsInitialEvent event, Emitter<ViewFaqsState> emit) {}

  void _onViewFaqsClickEvent(
      ViewFaqsClickEvent event, Emitter<ViewFaqsState> emit) {
    final isExpanded = state.isExpanded ?? {};
    final isCurrentExpanded = isExpanded[event.faqId] ?? false;

    emit(state.copyWith(
      isExpanded: {
        ...isExpanded, 
        event.faqId: !isCurrentExpanded, 
      },
    ));
  }
}
