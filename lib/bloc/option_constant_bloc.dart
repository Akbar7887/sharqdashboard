import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharqmotors/bloc/producer_event.dart';
import 'package:sharqmotors/bloc/producer_state.dart';

import '../models/OptionConstant.dart';
import '../services/producer_repository.dart';

class OptionConstantBloc extends Bloc<ProducerEvent, ProducerState> {
  final Repository repository;

  OptionConstantBloc({required this.repository}) : super(ProducerEmtyState()) {
    on<ProducerLoadEvent>((event, emit) async {
      emit(ProducerLoadingState());

      try {
        final List<OptionConstant> loadedOptionConstant =
            await repository.getOptionConstant();
        emit(OptionConstantLoadedState(
            loadedoptionconstant: loadedOptionConstant));
      } catch (_) {
        throw Exception(ProducerErrorState());
      }
    });

    on<ProducerClearEvent>((event, emit) {
      emit(ProducerEmtyState());
    });
  }

  Future<List<OptionConstant>> getAll() {
    return repository.getOptionConstant();
  }

  Future remove(String url, Map<String, dynamic> param) {
    return repository.remove(url, param);
  }

  Future postOptionConstant(String url, OptionConstant optionConstant) {
    return repository.postOptionConstant(url, optionConstant);
  }
}

