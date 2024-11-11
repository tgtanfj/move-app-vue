import 'package:equatable/equatable.dart';
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

class GiftRepsState extends Equatable {
  final List<GiftModel>? listGifts;
  final int? giftIdSelected;
  final String? donateMessage;
  final GiftRepsStatus? status;
  final bool isSendEnabled;
  final int? videoId;
  final UserModel? user;
  final List<RepModel>? reps;

  const GiftRepsState({
    this.listGifts = const [],
    this.giftIdSelected = -1,
    this.donateMessage = '',
    this.status = GiftRepsStatus.initial,
    this.isSendEnabled = false,
    this.user,
    this.videoId,
    this.reps,
  });

  static GiftRepsState initial() => const GiftRepsState(
        status: GiftRepsStatus.initial,
        listGifts: [],
        giftIdSelected: -1,
        isSendEnabled: false,
      );

  GiftRepsState copyWith({
    List<GiftModel>? listGifts,
    int? giftIdSelected,
    String? donateMessage,
    GiftRepsStatus? status,
    bool? isSendEnabled,
    UserModel? user,
    int? videoId,
    List<RepModel>? reps,
  }) {
    return GiftRepsState(
      donateMessage: donateMessage ?? this.donateMessage,
      listGifts: listGifts ?? this.listGifts,
      giftIdSelected: giftIdSelected ?? this.giftIdSelected,
      status: status ?? this.status,
      isSendEnabled: isSendEnabled ?? this.isSendEnabled,
      user: user ?? this.user,
      videoId: videoId ?? this.videoId,
      reps: reps ?? this.reps,
    );
  }

  @override
  List<Object?> get props => [
        donateMessage,
        listGifts,
        giftIdSelected,
        status,
        isSendEnabled,
        user,
        videoId,
        reps,
      ];
}
