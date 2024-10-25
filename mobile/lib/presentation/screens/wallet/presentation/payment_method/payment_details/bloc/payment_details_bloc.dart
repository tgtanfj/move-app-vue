import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/models/payment_method_model.dart';
import 'package:move_app/data/repositories/country_repository.dart';
import 'package:move_app/data/repositories/payment_method_repository.dart'; // Import repository
import 'package:move_app/data/services/stripe_service.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/payment_details/bloc/payment_details_event.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/payment_details/bloc/payment_details_state.dart';

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

  Future<void> _onPaymentDetailsInitialEvent(PaymentDetailsInitialEvent event,
      Emitter<PaymentDetailsState> emit) async {
    emit(state.copyWith(
        selectedCountry: event.selectedCountry,
        status: PaymentDetailsStatus.processing));
    add(const PaymentDetailsCountrySelectEvent());
  }

  Future<void> _onPaymentDetailsSubmitEvent(PaymentDetailsSubmitEvent event,
      Emitter<PaymentDetailsState> emit) async {
    emit(state.copyWith(status: PaymentDetailsStatus.processing));
    try {
      print(
          "state.cardHolderName ${state.cardHolderName}, state.cardNumber ${state.cardNumber}, state.expiryDate ${state.expiryDate}, state.cvv ${state.cvv}, contry ${state.selectedCountry?.name}");
      final paymentMethod = await stripeService.createPaymentMethod(
          cardNumber: state.cardNumber ?? '',
          expiryDate: state.expiryDate ?? '',
          cvv: state.cvv ?? '',
          cardHolderName: state.cardHolderName ?? '',
          country: 'US');
      print("object ${paymentMethod.toJson()}");
      final paymentMethodModel =
          PaymentMethodModel(paymentMethodId: event.paymentMethodId);

      final result = await paymentMethodRepository
          .postAddPaymentMethod(paymentMethodModel);

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
      emit(state.copyWith(
          status: PaymentDetailsStatus.failure, errorMessage: e.toString()));
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
    emit(state.copyWith(cardHolderName: event.cardHolderName));
  }

  Future<void> _onPaymentDetailsCardNumberEvent(
      PaymentDetailsCardNumberEvent event,
      Emitter<PaymentDetailsState> emit) async {
    emit(state.copyWith(cardNumber: event.cardNumber));
  }

  Future<void> _onPaymentDetailsExpiryDateEvent(
      PaymentDetailsExpiryDateEvent event,
      Emitter<PaymentDetailsState> emit) async {
    emit(state.copyWith(expiryDate: event.expiryDate));
  }

  Future<void> _onPaymentDetailsCvvEvent(
      PaymentDetailsCvvEvent event, Emitter<PaymentDetailsState> emit) async {
    emit(state.copyWith(cvv: event.cvv));
  }
}
