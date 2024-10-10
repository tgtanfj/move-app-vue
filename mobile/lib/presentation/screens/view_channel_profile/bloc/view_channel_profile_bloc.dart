import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_app/presentation/screens/view_channel_profile/bloc/view_channel_profile_event.dart';
import 'package:move_app/presentation/screens/view_channel_profile/bloc/view_channel_profile_state.dart';

class ViewChannelProfileBloc
    extends Bloc<ViewChannelProfileEvent, ViewChannelProfileState> {
  ViewChannelProfileBloc() : super(ViewChannelProfileState.initialState());
}
