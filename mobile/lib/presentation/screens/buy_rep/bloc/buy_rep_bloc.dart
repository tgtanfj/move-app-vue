import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/models/payment_method_model.dart';
import 'package:move_app/data/repositories/country_repository.dart';
import 'package:move_app/data/repositories/payment_method_repository.dart';
import 'package:move_app/data/repositories/rep_repository.dart';
import 'package:move_app/data/services/stripe_service.dart';
import 'package:move_app/presentation/screens/buy_rep/bloc/buy_rep_event.dart';
import 'package:move_app/presentation/screens/buy_rep/bloc/buy_rep_state.dart';
import 'package:move_app/utils/input_validation_helper.dart';

class BuyRepBloc extends Bloc<BuyRepEvent, BuyRepState> {
  final PaymentMethodRepository paymentRepository = PaymentMethodRepository();
  final RepRepository repRepository = RepRepository();
  final CountryRepository countryRepository = CountryRepository();
  final StripeService stripeService = StripeService();

  BuyRepBloc() : super(BuyRepState.initial()) {
    on<BuyRepInitialEvent>(_onBuyRepInitialEvent);
    on<BuyRepSavePaymentEvent>(_onBuyRepSavePaymentEvent);
    on<BuyRepCardNumberEvent>(_onBuyRepCardNumberEvent);
    on<BuyRepExpiryDateEvent>(_onBuyRepCardExpiryDateEvent);
    on<BuyRepCvvEvent>(_onBuyRepCvvEvent);
    on<BuyRepPayNowEvent>(_onBuyRepPayNowEvent);
    on<BuyRepCardNameEvent>(_onBuyRepCardNameEvent);
    on<BuyRepCountryEvent>(_onBuyRepCountryEvent);
  }

  void _onBuyRepInitialEvent(
      BuyRepInitialEvent event, Emitter<BuyRepState> emit) async {
    emit(state.copyWith(rep: event.rep, status: BuyRepStatus.processing));
    final result = await paymentRepository.getCard();
    result.fold((l) {
      emit(state.copyWith(status: BuyRepStatus.failure));
    }, (r) {
      emit(state.copyWith(
          status: BuyRepStatus.success,
          cardPaymentMethod: r,
          isEnablePayNow: true));
    });
    if (state.status == BuyRepStatus.failure) {
      final countries = await countryRepository.getCountryList();
      countries.fold((l) {
        emit(state.copyWith(errorMessage: l));
      }, (r) {
        emit(state.copyWith(countries: r, countryCode: "VN"));
      });
    }
  }

  void _onBuyRepCardNameEvent(
      BuyRepCardNameEvent event, Emitter<BuyRepState> emit) {
    final isShowCardNameMessage =
        state.cardName != event.cardName ? false : state.isShowCardNameMessage;
    emit(state.copyWith(
      cardName: event.cardName,
      isShowCardNameMessage: isShowCardNameMessage,
    ));
  }

  void _onBuyRepCountryEvent(
      BuyRepCountryEvent event, Emitter<BuyRepState> emit) {
    emit(state.copyWith(
        countryCode: event.countryCode, isShowCountryMessage: false));
  }

  void _onBuyRepCardNumberEvent(
      BuyRepCardNumberEvent event, Emitter<BuyRepState> emit) {
    final isShowCardNumberMessage = state.cardNumber != event.cardNumber
        ? false
        : state.isShowCardNumberMessage;
    emit(state.copyWith(
      cardNumber: event.cardNumber,
      isShowCardNumberMessage: isShowCardNumberMessage,
    ));
  }

  void _onBuyRepCardExpiryDateEvent(
      BuyRepExpiryDateEvent event, Emitter<BuyRepState> emit) {
    final isShowExpiryDateMessage = state.expiryDate != event.expiryDate
        ? false
        : state.isShowExpiryDateMessage;

    emit(state.copyWith(
      expiryDate: event.expiryDate,
      isShowExpiryDateMessage: isShowExpiryDateMessage,
    ));
  }

  void _onBuyRepCvvEvent(BuyRepCvvEvent event, Emitter<BuyRepState> emit) {
    final isShowCvvMessage =
        state.cvv != event.cvv ? false : state.isShowCvvMessage;
    emit(state.copyWith(
      cvv: event.cvv,
      isShowCvvMessage: isShowCvvMessage,
    ));
  }

  void _onBuyRepSavePaymentEvent(
      BuyRepSavePaymentEvent event, Emitter<BuyRepState> emit) {
    emit(state.copyWith(
      isSavePayment: !state.isSavePayment,
    ));
  }

  void _onBuyRepPayNowEvent(
      BuyRepPayNowEvent event, Emitter<BuyRepState> emit) async {
    if (state.cardPaymentMethod != null) {
      emit(state.copyWith(status: BuyRepStatus.orderProcessing));
      final result = await repRepository.buyReps(
          repPackageId: state.rep?.id ?? 0,
          paymentMethodId: state.cardPaymentMethod?.id ?? '');
      result.fold((l) {
        emit(state.copyWith(
          status: BuyRepStatus.orderFailed,
          errorMessage: l,
        ));
      }, (r) {
        emit(state.copyWith(status: BuyRepStatus.orderSuccess));
      });
    } else {
      final validateCardName =
          InputValidationHelper.validateCardHolderName(state.cardName ?? '');
      final validateCardNumber =
          InputValidationHelper.validateCardNumber(state.cardNumber ?? '');
      final validateExpiryDate =
          InputValidationHelper.validateExpiryDate(state.expiryDate ?? '');
      final validateCvv = InputValidationHelper.validateCvv(state.cvv ?? '');
      emit(state.copyWith(
        isShowCardNameMessage: validateCardName != null,
        isShowCardNumberMessage: validateCardNumber != null,
        isShowExpiryDateMessage: validateExpiryDate != null,
        isShowCvvMessage: validateCvv != null,
        messageInputCardName: validateCardName,
        messageInputCardNumber: validateCardNumber,
        messageInputExpiryDate: validateExpiryDate,
        messageInputCvv: validateCvv,
      ));
      if (validateCardName == null ||
          validateCardNumber == null ||
          validateExpiryDate == null ||
          validateCvv == null) {
        final paymentMethod = await stripeService.createPaymentMethod(
            cardNumber: state.cardNumber ?? '',
            expiryDate: state.expiryDate ?? '',
            cvv: state.cvv ?? '',
            cardHolderName: state.cardName ?? '',
            country: state.countryCode ?? '');
        final paymentMethodId = paymentMethod.toJson()['id'].toString();
        final paymentMethodModel =
            PaymentMethodModel(paymentMethodId: paymentMethodId);
        if (state.isSavePayment) {
          emit(state.copyWith(status: BuyRepStatus.orderProcessing));
          final buyRep = await repRepository.buyReps(
              repPackageId: state.rep?.id ?? 0,
              paymentMethodId: paymentMethodModel.paymentMethodId,
              save: true);
          buyRep.fold((l) {
            emit(state.copyWith(
              status: BuyRepStatus.orderFailed,
              errorMessage: l,
            ));
          }, (r) {
            emit(state.copyWith(status: BuyRepStatus.orderSuccess));
          });
        } else {
          emit(state.copyWith(status: BuyRepStatus.orderProcessing));
          final buyRep = await repRepository.buyReps(
              repPackageId: state.rep?.id ?? 0,
              paymentMethodId: paymentMethodModel.paymentMethodId,
              save: false);
          buyRep.fold((l) {
            emit(state.copyWith(
              status: BuyRepStatus.orderFailed,
              errorMessage: l,
            ));
          }, (r) {
            emit(state.copyWith(status: BuyRepStatus.orderSuccess));
          });
        }
      }
    }
  }
}
