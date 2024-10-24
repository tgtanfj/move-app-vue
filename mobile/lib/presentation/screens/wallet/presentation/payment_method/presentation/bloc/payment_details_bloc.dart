import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/data/models/payment_method_model.dart';
import 'package:move_app/data/repositories/country_repository.dart';
import 'package:move_app/data/repositories/payment_method_repository.dart'; // Import repository
import 'package:move_app/data/services/stripe_service.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/presentation/bloc/payment_details_event.dart';
import 'package:move_app/presentation/screens/wallet/presentation/payment_method/presentation/bloc/payment_details_state.dart';

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
          var index = countries
              .indexWhere((element) => element.id == state.selectedCountry?.id);

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
}
