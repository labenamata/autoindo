import 'dart:async';

import 'package:auto_indo/model/bot_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BstateEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BstateState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class BstateUnitialized extends BstateState {}

class BstateUpdate extends BstateEvent {
  final String status;
  BstateUpdate(this.status);
}

class BstateLoading extends BstateState {}

class BstateLoaded extends BstateState {
  final Future<BotStatus?> userBstate;
  BstateLoaded({required this.userBstate});
}

class BstateGet extends BstateEvent {}

class BstateBloc extends Bloc<BstateEvent, BstateState> {
  BstateBloc(super.initialState) {
    on<BstateGet>(onBstateGet);
    on<BstateUpdate>(onBstateUpdate);
  }

  FutureOr<void> onBstateGet(BstateGet event, Emitter<BstateState> emit) async {
    Future<BotStatus?> userBstate;
    emit(BstateLoading());
    userBstate = BotStatus.getStatus();
    emit(BstateLoaded(userBstate: userBstate));
  }

  FutureOr<void> onBstateUpdate(
      BstateUpdate event, Emitter<BstateState> emit) async {
    Future<BotStatus?> userBstate;
    emit(BstateLoading());
    await BotStatus.updateStatus(event.status);
    userBstate = BotStatus.getStatus();
    emit(BstateLoaded(userBstate: userBstate));
  }
}
