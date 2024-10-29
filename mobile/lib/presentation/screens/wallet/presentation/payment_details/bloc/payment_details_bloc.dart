import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/payment_method_model.dart';
import 'package:move_app/data/repositories/country_repository.dart';
import 'package:move_app/data/repositories/payment_method_repository.dart'; // Import repository
import 'package:move_app/data/services/stripe_service.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_details/bloc/payment_details_event.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_details/bloc/payment_details_state.dart';
import 'package:move_app/utils/input_validation_helper.dart';

class PaymentDetailsBloc
    extends Bloc<PaymentDetailsEvent, PaymentDetailsState> {
  final StripeService stripeService = StripeService();
  final CountryRepository countryRepository = CountryRepository();
  final PaymentMethodRepository paymentMethodRepository =
      PaymentMethodRepository();

  PaymentDetailsBloc() : super(PaymentDetailsState.initial()) {
    on<PaymentDetailsInitialEvent>(_onPaymentDetailsInitialEvent);
    on<PaymentDetailsSubmitEvent>(_onPaymentDetailsSubmitEvent);
    on<PaymentDetailsCountrySelectEvent>(_onPaymentDetailsCountrySelectEvent);
    on<PaymentDetailsCardHolderNameEvent>(_onPaymentDetailsCardHolderNameEvent);
    on<PaymentDetailsCardNumberEvent>(_onPaymentDetailsCardNumberEvent);
    on<PaymentDetailsExpiryDateEvent>(_onPaymentDetailsExpiryDateEvent);
    on<PaymentDetailsCvvEvent>(_onPaymentDetailsCvvEvent);
  }

  bool _shouldEnableSubmit() {
    return (state.cardHolderName?.isNotEmpty ?? false) &&
        (state.cardNumber?.isNotEmpty ?? false) &&
        (state.expiryDate?.isNotEmpty ?? false) &&
        (state.cvv?.isNotEmpty ?? false);
  }

  Future<void> _onPaymentDetailsInitialEvent(PaymentDetailsInitialEvent event,
      Emitter<PaymentDetailsState> emit) async {
    emit(state.copyWith(
        selectedCountry: event.selectedCountry,
        status: PaymentDetailsStatus.processing));
    emit(state.copyWith(isEnableSubmitPaymentMethod: _shouldEnableSubmit()));
    add(const PaymentDetailsCountrySelectEvent());
  }

  Future<void> _onPaymentDetailsSubmitEvent(PaymentDetailsSubmitEvent event,
      Emitter<PaymentDetailsState> emit) async {
    final validateCardHolderName = InputValidationHelper.validateCardHolderName(
        state.cardHolderName ?? '');
    final validateCardNumber =
        InputValidationHelper.validateCardNumber(state.cardNumber ?? '');
    final validateExpiryDate =
        InputValidationHelper.validateExpiryDate(state.expiryDate ?? '');
    final validateCvv = InputValidationHelper.validateCvv(state.cvv ?? '');
    emit(state.copyWith(
        isShowCardHolderNameMessage: validateCardHolderName != null,
        isShowCardNumberMessage: validateCardNumber != null,
        isShowExpiryDateMessage: validateExpiryDate != null,
        isShowCvvMessage: validateCvv != null,
        cardHolderNameErrorMessage: validateCardHolderName,
        cardNumberErrorMessage: validateCardNumber,
        expiryDateErrorMessage: validateExpiryDate,
        cvvErrorMessage: validateCvv));
    if (validateCardHolderName == null ||
        validateCardNumber == null ||
        validateExpiryDate == null ||
        validateCvv == null) {
      emit(state.copyWith(status: PaymentDetailsStatus.processing));
      try {
        final paymentMethod = await stripeService.createPaymentMethod(
          cardNumber: state.cardNumber ?? '',
          expiryDate: state.expiryDate ?? '',
          cvv: state.cvv ?? '',
          cardHolderName: state.cardHolderName ?? '',
          country: state.selectedCountry?.countryCode ?? '',
        );
        final paymentMethodId = paymentMethod.toJson()['id'].toString();
        final paymentMethodModel =
            PaymentMethodModel(paymentMethodId: paymentMethodId);

        final result = await paymentMethodRepository
            .postAddPaymentMethod(paymentMethodModel);
        print("result $result");
        result.fold(
          (error) {
            emit(state.copyWith(
                status: PaymentDetailsStatus.failure, errorMessage: error));
          },
          (response) {
            emit(state.copyWith(status: PaymentDetailsStatus.success));
          },
        );
      } catch (e) {
        if (e is DioException && e.response != null) {
          final errorData = e.response?.data;
          emit(state.copyWith(
              status: PaymentDetailsStatus.failure,
              errorMessage:
                  errorData['message'] ?? Constants.unknownErrorOccurred));
        } else {
          emit(state.copyWith(
              status: PaymentDetailsStatus.failure,
              errorMessage: e.toString()));
        }
      }
    }
  }

  Future<void> _onPaymentDetailsCountrySelectEvent(
      PaymentDetailsCountrySelectEvent event,
      Emitter<PaymentDetailsState> emit) async {
    try {
      final countryResult = await countryRepository.getCountryList();

      countryResult.fold(
        (failure) {
          emit(state.copyWith(status: PaymentDetailsStatus.failure));
        },
        (countries) {
          var index = countries.indexWhere(
            (element) => element.id == event.selectedCountry?.id,
          );

          index = index < 0 ? 0 : index;
          emit(state.copyWith(
            selectedCountry: countries[index],
            countryList: countries,
            status: PaymentDetailsStatus.success,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(status: PaymentDetailsStatus.failure));
    }
  }

  Future<void> _onPaymentDetailsCardHolderNameEvent(
      PaymentDetailsCardHolderNameEvent event,
      Emitter<PaymentDetailsState> emit) async {
    final isShowCardHolderNameMessage =
        state.cardHolderName != event.cardHolderName
            ? false
            : state.isShowCardHolderNameMessage;
    emit(state.copyWith(
        cardHolderName: event.cardHolderName,
        isEnableSubmitPaymentMethod: _shouldEnableSubmit(),
        isShowCardHolderNameMessage: isShowCardHolderNameMessage));
  }

  Future<void> _onPaymentDetailsCardNumberEvent(
      PaymentDetailsCardNumberEvent event,
      Emitter<PaymentDetailsState> emit) async {
    final isShowCardNumberMessage = state.cardNumber != event.cardNumber
        ? false
        : state.isShowCardNumberMessage;
    emit(state.copyWith(
        cardNumber: event.cardNumber,
        isEnableSubmitPaymentMethod: _shouldEnableSubmit(),
        isShowCardNumberMessage: isShowCardNumberMessage));
  }

  Future<void> _onPaymentDetailsExpiryDateEvent(
      PaymentDetailsExpiryDateEvent event,
      Emitter<PaymentDetailsState> emit) async {
    final isShowExpiryDateMessage = state.expiryDate != event.expiryDate
        ? false
        : state.isShowExpiryDateMessage;
    emit(state.copyWith(
        expiryDate: event.expiryDate,
        isEnableSubmitPaymentMethod: _shouldEnableSubmit(),
        isShowExpiryDateMessage: isShowExpiryDateMessage));
  }

  Future<void> _onPaymentDetailsCvvEvent(
      PaymentDetailsCvvEvent event, Emitter<PaymentDetailsState> emit) async {
    final isShowCvvMessage =
        state.cvv != event.cvv ? false : state.isShowCvvMessage;
    emit(state.copyWith(
        cvv: event.cvv,
        isEnableSubmitPaymentMethod: _shouldEnableSubmit(),
        isShowCvvMessage: isShowCvvMessage));
  }
}
