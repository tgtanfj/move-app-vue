import 'package:move_app/data/models/card_model.dart';

class CardPaymentModel {
  final String? id;
  final String? type;
  final CardModel? card;
  final String? name;

  CardPaymentModel({
    this.id,
    this.type,
    this.card,
    this.name,
  });

  CardPaymentModel copyWith({
    String? id,
    String? type,
    CardModel? card,
    String? name,
  }) {
    return CardPaymentModel(
      id: id ?? this.id,
      type: type ?? this.type,
      card: card ?? this.card,
      name: name ?? this.name,
    );
  }

  factory CardPaymentModel.fromJson(Map<String, dynamic> json) {
    return CardPaymentModel(
      id: json['id'] is String? ? json['id'] : '',
      type: json['type'] is String? ? json['type'] : '',
      card: json['card'] != null ? CardModel.fromJson(json['card']) : null,
      name: json['name'] is String? ? json['name'] : '',
    );
  }
}