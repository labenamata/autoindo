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

class JaringBatch extends JaringEvent {
  final List<Jaring> data;

  JaringBatch({
    required this.data,
  });
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
    on<JaringBatch>(onJaringBatch);
    // on<JaringUpdate>(onJaringUpdate);
    on<JaringHapus>(onJaringHapus);
    // on<JaringTrade>(onJaringTrade);
  }

  Future<void> onJaringAdd(JaringAdd event, Emitter<JaringState> emit) async {
    Future<List<Jaring>> jaring;
    emit(JaringLoading());
    await Jaring.tambahJaring(
        koinId: event.koinId,
        buy: event.buy,
        sell: event.sell,
        modal: event.modal,
        status: event.status);
    jaring = Jaring.getJaring();
    emit(JaringLoaded(jaring: jaring));
  }

  Future<void> onJaringBatch(
      JaringBatch event, Emitter<JaringState> emit) async {
    Future<List<Jaring>> jaring;
    emit(JaringLoading());
    await Jaring.jaringBatch(jarings: event.data);
    jaring = Jaring.getJaring();
    emit(JaringLoaded(jaring: jaring));
  }

  // FutureOr<void> onJaringUpdate(
  //     JaringUpdate event, Emitter<JaringState> emit) async {
  //   List<Jaring> jaring;
  //   emit(JaringLoading());
  //   jaring = await _databaseRepository.updateJaringData(event.id, event.data);
  //   emit(JaringLoaded(jaring: jaring));
  // }

  Future<void> onJaringHapus(
      JaringHapus event, Emitter<JaringState> emit) async {
    Future<List<Jaring>> jaring;
    emit(JaringLoading());
    await Jaring.hapusJaring(event.id);
    jaring = Jaring.getJaring();
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
