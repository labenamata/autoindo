import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:auto_indo/model/ohcl_model.dart';

class OhclEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OhclState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class OhclUnitialized extends OhclState {}

class OhclLoading extends OhclState {}

class OhclLoaded extends OhclState {
  final Future<List<Ohcl>> ohcl;
  OhclLoaded({required this.ohcl});
}

class OhclGet extends OhclEvent {
  final String pair;
  final String timeFrame;
  OhclGet({
    required this.pair,
    required this.timeFrame,
  });
}

class OhclBloc extends Bloc<OhclEvent, OhclState> {
  OhclBloc(super.initialState) {
    on<OhclGet>(onOhclGet);
  }

  FutureOr<void> onOhclGet(OhclGet event, Emitter<OhclState> emit) async {
    Future<List<Ohcl>> ohcl;
    emit(OhclLoading());
    ohcl = Ohcl.fetchData(pair: event.pair, timeFrame: event.timeFrame);
    emit(OhclLoaded(ohcl: ohcl));
  }
}
