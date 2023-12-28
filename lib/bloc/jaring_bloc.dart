import 'dart:async';

import 'package:auto_indo/model/jaring.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JaringEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class JaringState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class JaringUnitialized extends JaringState {}

class JaringLoading extends JaringState {}

class JaringLoaded extends JaringState {
  final Future<List<Jaring>> jaring;
  JaringLoaded({required this.jaring});
}

class JaringAdd extends JaringEvent {
  final String koinId;
  final String modal;
  final String buy;
  final String sell;
  final String status;

  JaringAdd(
      {required this.koinId,
      required this.buy,
      required this.sell,
      required this.modal,
      required this.status});
}

class JaringUpdate extends JaringEvent {
  final Map<String, dynamic> data;
  final String id;
  JaringUpdate(this.data, this.id);
}

class JaringHapus extends JaringEvent {
  final String id;
  JaringHapus(this.id);
}

class JaringTrade extends JaringEvent {}

class JaringGet extends JaringEvent {}

class JaringBloc extends Bloc<JaringEvent, JaringState> {
  JaringBloc(super.initialState) {
    on<JaringGet>(onJaringGet);
    on<JaringAdd>(onJaringAdd);
    // on<JaringUpdate>(onJaringUpdate);
    on<JaringHapus>(onJaringHapus);
    // on<JaringTrade>(onJaringTrade);
  }

  FutureOr<void> onJaringAdd(JaringAdd event, Emitter<JaringState> emit) {
    Future<List<Jaring>> jaring;
    emit(JaringLoading());
    jaring = Jaring.tambahJaring(
        koinId: event.koinId,
        buy: event.buy,
        sell: event.sell,
        modal: event.modal,
        status: event.status);
    emit(JaringLoaded(jaring: jaring));
  }

  // FutureOr<void> onJaringUpdate(
  //     JaringUpdate event, Emitter<JaringState> emit) async {
  //   List<Jaring> jaring;
  //   emit(JaringLoading());
  //   jaring = await _databaseRepository.updateJaringData(event.id, event.data);
  //   emit(JaringLoaded(jaring: jaring));
  // }

  FutureOr<void> onJaringHapus(JaringHapus event, Emitter<JaringState> emit) {
    Future<List<Jaring>> jaring;
    emit(JaringLoading());
    jaring = Jaring.hapusJaring(event.id);
    emit(JaringLoaded(jaring: jaring));
  }

  // FutureOr<void> onJaringTrade(
  //     JaringTrade event, Emitter<JaringState> emit) async {
  //   List<Jaring> jaring;
  //   emit(JaringLoading());
  //   jaring = await TradeOrder.cekOrder();
  //   emit(JaringLoaded(jaring: jaring));
  // }

  FutureOr<void> onJaringGet(JaringGet event, Emitter<JaringState> emit) {
    Future<List<Jaring>> jaring;
    emit(JaringLoading());
    jaring = Jaring.getJaring();
    emit(JaringLoaded(jaring: jaring));
  }
}
