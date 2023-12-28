import 'dart:async';

import 'package:auto_indo/model/info.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InfoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InfoState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class InfoUnitialized extends InfoState {}

class InfoLoading extends InfoState {}

class InfoLoaded extends InfoState {
  final Future<Info> userInfo;
  InfoLoaded({required this.userInfo});
}

class InfoGet extends InfoEvent {}

class InfoBloc extends Bloc<InfoEvent, InfoState> {
  InfoBloc(super.initialState) {
    on<InfoGet>(onInfoGet);
  }

  FutureOr<void> onInfoGet(InfoGet event, Emitter<InfoState> emit) async {
    Future<Info> userInfo;
    emit(InfoLoading());
    userInfo = Info.getInfo();
    emit(InfoLoaded(userInfo: userInfo));
  }
}
