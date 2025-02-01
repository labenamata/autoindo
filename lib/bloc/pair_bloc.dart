import 'dart:async';

import 'package:auto_indo/model/pair.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PairEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PairState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class PairUnitialized extends PairState {}

class PairLoading extends PairState {}

class PairLoaded extends PairState {
  final Future<List<Pair>> pair;
  PairLoaded({required this.pair});
}

class PairGet extends PairEvent {
  final String current;
  PairGet({required this.current});
}

class PairBloc extends Bloc<PairEvent, PairState> {
  PairBloc(super.initialState) {
    on<PairGet>(onPairGet);
  }

  FutureOr<void> onPairGet(PairGet event, Emitter<PairState> emit) async {
    Future<List<Pair>> pair;
    emit(PairLoading());
    pair = Pair.getPair(currency: event.current);
    emit(PairLoaded(pair: pair));
  }
}
