import 'dart:async';

import 'package:auto_indo/model/Notif.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotifEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotifState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class NotifUnitialized extends NotifState {}

class NotifLoading extends NotifState {}

class NotifLoaded extends NotifState {
  final Future<NotifList?> userNotif;
  NotifLoaded({required this.userNotif});
}

class NotifGet extends NotifEvent {}

class NotifRead extends NotifEvent {
  final String id;
  NotifRead({required this.id});
}

class NotifBloc extends Bloc<NotifEvent, NotifState> {
  NotifBloc(super.initialState) {
    on<NotifGet>(onNotifGet);
    // on<NotifRead>(onNotifRead);
  }

  FutureOr<void> onNotifGet(NotifGet event, Emitter<NotifState> emit) async {
    Future<NotifList?> userNotif;
    emit(NotifLoading());
    userNotif = NotifList.getNotif();
    emit(NotifLoaded(userNotif: userNotif));
  }

  FutureOr<void> onNotifRead(NotifRead event, Emitter<NotifState> emit) async {
    Future<NotifList?> userNotif;
    emit(NotifLoading());
    userNotif = NotifList.getNotif();
    emit(NotifLoaded(userNotif: userNotif));
  }
}
