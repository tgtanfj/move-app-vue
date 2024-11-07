import 'package:bloc/bloc.dart';
import 'package:move_app/data/models/payment_model.dart';
import 'package:move_app/data/repositories/payment_repository.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/bloc/payment_history_event.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_history/bloc/payment_history_state.dart';

class PaymentHistoryBloc
    extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  final PaymentRepository paymentRepository;

  PaymentHistoryBloc({required this.paymentRepository})
      : super(PaymentHistoryState.initial()) {
    on<PaymentHistoryInitialEvent>(_onPaymentHistoryInitialEvent);
    on<PaymentHistorySelectionStartDateEvent>(
        _onPaymentHistorySelectionStartDateEvent);
    on<PaymentHistorySelectionEndDateEvent>(
        _onPaymentHistorySelectionEndDateEvent);
    on<PaymentHistoryOnTapStartDateEvent>(_onPaymentHistoryOnTapStartDateEvent);
    on<PaymentHistoryOnTapEndDateEvent>(_onPaymentHistoryOnTapEndDateEvent);
    on<PaymentHistoryLoadMorePageEvent>(_onPaymentHistoryLoadMorePageEvent);
    on<PaymentHistoryLoadPreviousPageEvent>(
        _onPaymentHistoryLoadPreviousPageEvent);
    on<PaymentHistoryOnTapOutSideEvent>(_onPaymentHistoryOnTapOutSideEvent);
  }

  void _onPaymentHistoryInitialEvent(PaymentHistoryInitialEvent event,
      Emitter<PaymentHistoryState> emit) async {
    emit(state.copyWith(status: PaymentHistoryStatus.processing));
    final PaymentModel paymentModel = PaymentModel(
      startDate: state.startDate.toString(),
      endDate: state.endDate.toString(),
      take: 10,
      page: 1,
    );
    final result = await paymentRepository.getPaymentHistory(paymentModel);
    result.fold((l) {
      emit(state.copyWith(
        status: PaymentHistoryStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
        status: PaymentHistoryStatus.success,
        paymentHistoryList: r,
      ));
    });
    final totalResult =
        await paymentRepository.getTotalPaymentHistoryPages(PaymentModel(
      startDate: state.startDate.toString(),
      endDate: state.endDate.toString(),
      take: 10,
      page: 1,
    ));
    totalResult.fold((l) {
      emit(state.copyWith(
        status: PaymentHistoryStatus.failure,
        errorMessage: l,
      ));
    }, (r) {
      emit(state.copyWith(
        total: r,
        endResult: (state.startResult != null && r?.totalResult != null)
            ? (((r!.totalResult!) > 10) ? 10 : r.totalResult)
            : 0,
        status: PaymentHistoryStatus.success,
      ));
    });
  }

  void _onPaymentHistorySelectionStartDateEvent(
      PaymentHistorySelectionStartDateEvent event,
      Emitter<PaymentHistoryState> emit) async {
    emit(state.copyWith(
      status: PaymentHistoryStatus.processing,
    ));
    final PaymentModel paymentModel = PaymentModel(
      startDate: event.startDate.toString(),
      endDate: state.endDate.toString(),
      take: 10,
      page: 1,
    );
    final result = await paymentRepository.getPaymentHistory(paymentModel);
    result.fold((l) {
      emit(state.copyWith(
        status: PaymentHistoryStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
        status: PaymentHistoryStatus.success,
        paymentHistoryList: r,
        startDate: event.startDate,
        isPickedStartDate: !(state.isPickedStartDate),
      ));
    });
    final totalResult =
    await paymentRepository.getTotalPaymentHistoryPages(PaymentModel(
      startDate: event.startDate.toString(),
      endDate: state.endDate.toString(),
      take: 10,
      page: 1,
    ));
    totalResult.fold((l) {
      emit(state.copyWith(
        status: PaymentHistoryStatus.failure,
        errorMessage: l,
      ));
    }, (r) {
      emit(state.copyWith(
        total: r,
        currentPage: 1,
        startResult: 1,
        endResult: (state.startResult != null && r?.totalResult != null)
            ? (((r!.totalResult!) > 10) ? 10 : r.totalResult)
            : 0,
        status: PaymentHistoryStatus.success,
      ));
    });
  }

  void _onPaymentHistorySelectionEndDateEvent(
      PaymentHistorySelectionEndDateEvent event,
      Emitter<PaymentHistoryState> emit) async {
    emit(state.copyWith(
      status: PaymentHistoryStatus.processing,
    ));
    final PaymentModel paymentModel = PaymentModel(
      startDate: state.startDate.toString(),
      endDate: event.endDate.toString(),
      take: 10,
      page: 1,
    );
    final result = await paymentRepository.getPaymentHistory(paymentModel);
    result.fold((l) {
      emit(state.copyWith(
        status: PaymentHistoryStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
        status: PaymentHistoryStatus.success,
        paymentHistoryList: r,
        endDate: event.endDate,
        isPickedEndDate: !(state.isPickedEndDate),
      ));
    });
    final totalResult =
        await paymentRepository.getTotalPaymentHistoryPages(PaymentModel(
      startDate: state.startDate.toString(),
      endDate: state.endDate.toString(),
      take: 10,
      page: 1,
    ));
    totalResult.fold((l) {
      emit(state.copyWith(
        status: PaymentHistoryStatus.failure,
        errorMessage: l,
      ));
    }, (r) {
      emit(state.copyWith(
        total: r,
        currentPage: 1,
        startResult: 1,
        endResult: (state.startResult != null && r?.totalResult != null)
            ? (((r!.totalResult!) > 10) ? 10 : r.totalResult)
            : 0,
        status: PaymentHistoryStatus.success,
      ));
    });
  }

  void _onPaymentHistoryOnTapStartDateEvent(
      PaymentHistoryOnTapStartDateEvent event,
      Emitter<PaymentHistoryState> emit) {
    emit(state.copyWith(
      isPickedStartDate: !(state.isPickedStartDate),
      isPickedEndDate: false,
    ));
  }

  void _onPaymentHistoryOnTapEndDateEvent(PaymentHistoryOnTapEndDateEvent event,
      Emitter<PaymentHistoryState> emit) {
    emit(state.copyWith(
      isPickedEndDate: !(state.isPickedEndDate),
      isPickedStartDate: false,
    ));
  }

  void _onPaymentHistoryOnTapOutSideEvent(PaymentHistoryOnTapOutSideEvent event,
      Emitter<PaymentHistoryState> emit) {
    emit(state.copyWith(
      isPickedEndDate: false,
      isPickedStartDate: false,
    ));
  }

  void _onPaymentHistoryLoadMorePageEvent(PaymentHistoryLoadMorePageEvent event,
      Emitter<PaymentHistoryState> emit) async {
    var currentPage = state.currentPage ?? 1;
    final totalPages =
        await paymentRepository.getTotalPaymentHistoryPages(PaymentModel(
      startDate: state.startDate.toString(),
      endDate: state.endDate.toString(),
      take: 10,
      page: state.currentPage,
    ));
    totalPages.fold((l) {
      emit(state.copyWith(
        status: PaymentHistoryStatus.failure,
        errorMessage: l,
      ));
    }, (r) {
      emit(state.copyWith(
        total: r,
        status: PaymentHistoryStatus.success,
      ));
    });
    if (state.totalResult?.totalPages != null) {
      if (currentPage < state.totalResult!.totalPages!.toInt()) {
        currentPage++;
        final paymentHistoryList =
            await paymentRepository.getPaymentHistory(PaymentModel(
          startDate: state.startDate.toString(),
          endDate: state.endDate.toString(),
          take: 10,
          page: currentPage,
        ));
        paymentHistoryList.fold((l) {
          emit(state.copyWith(
            status: PaymentHistoryStatus.failure,
            errorMessage: l,
          ));
        }, (r) {
          emit(state.copyWith(
            totalPages: state.totalResult?.totalPages,
            status: PaymentHistoryStatus.success,
            paymentHistoryList: r,
            currentPage: currentPage,
            startResult: (state.startResult != null) ? (state.startResult! + 10) : 1,
            endResult: (state.startResult != null && state.totalResult?.totalResult != null)
                ? ((state.totalResult!.totalResult! - (state.startResult! + 10)) <= 10
                ? state.totalResult!.totalResult
                : (state.startResult! + 19))
                : 0,
          ));
        });
      }
    }
  }

  void _onPaymentHistoryLoadPreviousPageEvent(
      PaymentHistoryLoadPreviousPageEvent event,
      Emitter<PaymentHistoryState> emit) async {
    if (state.totalResult?.totalPages != null && state.currentPage != null) {
      if (state.totalResult!.totalPages! > 1 && state.currentPage! > 1) {
        var currentPage = state.currentPage ?? 1;
        currentPage--;
        final paymentHistoryList =
            await paymentRepository.getPaymentHistory(PaymentModel(
          startDate: state.startDate.toString(),
          endDate: state.endDate.toString(),
          take: 10,
          page: currentPage,
        ));
        paymentHistoryList.fold((l) {
          emit(state.copyWith(
            status: PaymentHistoryStatus.failure,
            errorMessage: l,
          ));
        }, (r) {
          emit(state.copyWith(
            paymentHistoryList: r,
            currentPage: currentPage,
            status: PaymentHistoryStatus.success,
            startResult: (state.startResult != null) ? (state.startResult! - 10) : 1,
            endResult: (state.startResult != null && state.totalResult?.totalResult != null)
                ? ((state.startResult! - 1) >= 10
                ? (state.startResult! - 1)
                : (state.totalResult!.totalResult! < 10 ? state.totalResult!.totalResult! : 10))
                : 0,
          ));
        });
      } else {
        final paymentHistoryList =
            await paymentRepository.getPaymentHistory(PaymentModel(
          startDate: state.startDate.toString(),
          endDate: state.endDate.toString(),
          take: 10,
          page: 1,
        ));
        paymentHistoryList.fold((l) {
          emit(state.copyWith(
            status: PaymentHistoryStatus.failure,
            errorMessage: l,
          ));
        }, (r) {
          emit(state.copyWith(
            status: PaymentHistoryStatus.success,
            paymentHistoryList: r,
          ));
        });
      }
    }
  }
}
