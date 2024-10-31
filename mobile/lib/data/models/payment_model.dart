import 'package:move_app/data/models/reps_package_model.dart';

class PaymentModel {
  final String? createdAt;
  final RepsPackage? repsPackage;
  final String? startDate;
  final String? endDate;
  final int? take;
  final int? page;
  final int? totalPages;
  final int? totalResult;

  PaymentModel({
    this.createdAt,
    this.repsPackage,
    this.startDate,
    this.endDate,
    this.page,
    this.take,
    this.totalPages,
    this.totalResult,
  });

  PaymentModel copyWith({
    String? createdAt,
    RepsPackage? repsPackage,
    String? startDate,
    String? endDate,
    int? take,
    int? page,
    int? totalPages,
    int? totalResult,
  }) {
    return PaymentModel(
      createdAt: createdAt ?? this.createdAt,
      repsPackage: repsPackage ?? this.repsPackage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      take: take ?? this.take,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      totalResult: totalResult ?? this.totalResult,
    );
  }

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      createdAt: json['createdAt'] is String? ? json['createdAt'] : '',
      repsPackage: json['repsPackage'] != null
          ? RepsPackage.fromJson(json['repsPackage'])
          : RepsPackage(numberOfREPs: 0),
      totalPages: json['totalPages'] is int? ? json['totalPages'] : 0,
      totalResult: json['total'] is int? ? json['total'] : 0,
      take: json['take'] is int? ? json['take'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'take': take,
      'page': page,
    };
  }
}

