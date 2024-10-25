class CardModel {
  final String? brand;
  final String? last4;
  final int? exp_month;
  final int? exp_year;

  CardModel({
    this.brand,
    this.last4,
    this.exp_month,
    this.exp_year,
  });

  CardModel copyWith({
    String? brand,
    String? last4,
    int? exp_month,
    int? exp_year,
  }) {
    return CardModel(
      brand: brand ?? this.brand,
      last4: last4 ?? this.last4,
      exp_month: exp_month ?? this.exp_month,
      exp_year: exp_year ?? this.exp_year,
    );
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      brand: json['brand'] is String? ? json['brand'] : '',
      last4: json['last4'] is String? ? json['last4'] : '',
      exp_month: json['exp_month'] is int? ? json['exp_month'] : 0,
      exp_year: json['exp_year'] is int? ? json['exp_year'] : 0,
    );
  }
}
