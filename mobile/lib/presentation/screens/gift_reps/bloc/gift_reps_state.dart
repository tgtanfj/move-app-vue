import 'package:equatable/equatable.dart';
import 'package:move_app/constants/constants.dart';
import 'package:move_app/data/models/gift_model.dart';
import 'package:move_app/data/models/rep_model.dart';
import 'package:move_app/data/models/user_model.dart';

enum GiftRepsStatus {
  initial,
  loading,
  success,
  failure,
  giftSuccess,
}

enum GiftRepMessageType {
  bestWorkoutYet,
  thankYou,
  wellDone,
  youHaveDoneTheUnbelievable,
  youAreAwesome;

  String get title {
    switch (this) {
      case GiftRepMessageType.bestWorkoutYet:
        return Constants.bestWorkoutYet;
      case GiftRepMessageType.thankYou:
        return Constants.thankYou;
      case GiftRepMessageType.wellDone:
        return Constants.wellDone;
      case GiftRepMessageType.youHaveDoneTheUnbelievable:
        return Constants.youHaveDoneTheUnbelievable;
      case GiftRepMessageType.youAreAwesome:
        return Constants.youAreAwesome;
    }
  }
}

class GiftRepsState extends Equatable {
  final GiftRepMessageType? giftRepMessageType;
  final List<GiftModel>? listGifts;
  final int? giftIdSelected;
  final int? titleGiftIdSelected;
  final GiftRepsStatus? status;
  final bool isSendEnabled;
  final int? videoId;
  final UserModel? user;
  final List<RepModel>? reps;

  const GiftRepsState({
    this.giftRepMessageType,
    this.listGifts = const [],
    this.giftIdSelected = -1,
    this.titleGiftIdSelected = -1,
    this.status = GiftRepsStatus.initial,
    this.isSendEnabled = false,
    this.user,
    this.videoId,
    this.reps,
  });

  static GiftRepsState initial() => const GiftRepsState(
        status: GiftRepsStatus.initial,
        giftRepMessageType: GiftRepMessageType.bestWorkoutYet,
        listGifts: [],
        giftIdSelected: -1,
        titleGiftIdSelected: -1,
        isSendEnabled: false,
      );

  GiftRepsState copyWith({
    GiftRepMessageType? giftRepMessageType,
    List<GiftModel>? listGifts,
    int? giftIdSelected,
    int? titleGiftIdSelected,
    GiftRepsStatus? status,
    bool? isSendEnabled,
    UserModel? user,
    int? videoId,
    List<RepModel>? reps,
  }) {
    return GiftRepsState(
      giftRepMessageType: giftRepMessageType ?? this.giftRepMessageType,
      listGifts: listGifts ?? this.listGifts,
      giftIdSelected: giftIdSelected ?? this.giftIdSelected,
      titleGiftIdSelected: titleGiftIdSelected ?? this.titleGiftIdSelected,
      status: status ?? this.status,
      isSendEnabled: isSendEnabled ?? this.isSendEnabled,
      user: user ?? this.user,
      videoId: videoId ?? this.videoId,
      reps: reps ?? this.reps,
    );
  }

  @override
  List<Object?> get props => [
        giftRepMessageType,
        listGifts,
        giftIdSelected,
        titleGiftIdSelected,
        status,
        isSendEnabled,
        user,
        videoId,
        reps,
      ];
}
