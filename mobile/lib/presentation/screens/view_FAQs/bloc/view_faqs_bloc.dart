import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/models/faqs_model.dart';
import 'package:move_app/data/repositories/view_faqs_repository.dart';
import 'package:move_app/presentation/screens/view_faqs/bloc/view_faqs_event.dart';
import 'package:move_app/presentation/screens/view_faqs/bloc/view_faqs_state.dart';

class ViewFaqsBloc extends Bloc<ViewFaqsEvent, ViewFaqsState> {
  final ViewFaqsRepository viewFaqsRepository;

  List<FaqModel> allFaqs = [];

  ViewFaqsBloc(this.viewFaqsRepository) : super(ViewFaqsInitialState()) {
    on<FetchFaqsEvent>(_onFetchFaqsEvent);
  }

  Future<void> _onFetchFaqsEvent(
      FetchFaqsEvent event, Emitter<ViewFaqsState> emit) async {
    if (allFaqs.isEmpty) {
      emit(ViewFaqsLoadingState());

      final faqsResult = await viewFaqsRepository.getFaqs();
      faqsResult.fold(
        (error) => emit(ViewFaqsErrorState(errorMessage: error)),
        (faqs) {
          allFaqs = faqs.faqs;
          emit(ViewFaqsLoadedState(faqs: allFaqs));
        },
      );
    }
  }
}
