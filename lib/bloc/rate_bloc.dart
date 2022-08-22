import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharqmotors/bloc/producer_event.dart';
import 'package:sharqmotors/bloc/producer_state.dart';

import '../models/Rate.dart';
import '../services/producer_repository.dart';

class RateBloc extends Bloc<ProducerEvent, ProducerState> {
  final Repository repository;

  RateBloc({required this.repository}) : super(ProducerEmtyState()) {
    on<ProducerLoadEvent>((event, emit) async {
      emit(ProducerLoadingState());

      try {
        final List<Rate> loadedRate = await repository.getAllRate();
        emit(RateLoadedState(loadedRate: loadedRate));
      } catch (_) {
        throw Exception(ProducerErrorState());
      }
    });

    on<ProducerClearEvent>((event, emit) {
      emit(ProducerEmtyState());
    });
  }

  Future removeAll(String url, Map<String, dynamic> param) {
    return repository.removeAll(url, param);
  }

  Future postRate(String url, Rate modelSet) {
    return repository.postRate(url, modelSet);
  }


}
