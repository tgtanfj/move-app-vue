class CardModel {
  final String? brand;
  final String? last4;
  final int? expMonth;
  final int? expYear;

  CardModel({
    this.brand,
    this.last4,
    this.expMonth,
    this.expYear,
  });

  CardModel copyWith({
    String? brand,
    String? last4,
    int? expMonth,
    int? expYear,
  }) {
    return CardModel(
      brand: brand ?? this.brand,
      last4: last4 ?? this.last4,
      expMonth: expMonth ?? this.expMonth,
      expYear: expYear ?? this.expYear,
    );
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      brand: json['brand'] is String? ? json['brand'] : '',
      last4: json['last4'] is String? ? json['last4'] : '',
      expMonth: json['exp_month'] is int? ? json['exp_month'] : 0,
      expYear: json['exp_year'] is int? ? json['exp_year'] : 0,
    );
  }
}