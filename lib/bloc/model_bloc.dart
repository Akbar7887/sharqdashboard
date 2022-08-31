import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharqmotors/bloc/producer_event.dart';
import 'package:sharqmotors/bloc/producer_state.dart';

import '../models/ModelSet.dart';
import '../models/OptionSet.dart';
import '../services/producer_repository.dart';

class ModelBloc extends Bloc<ProducerEvent, ProducerState> {
  final Repository repository;

  ModelBloc({required this.repository}) : super(ProducerEmtyState()) {
    on<ProducerLoadEvent>((event, emit) async {
      emit(ProducerLoadingState());

      try {
        final List<ModelSet> loadedmodels = await repository.getAllModels();
        emit(ModelLoadedState(loadedModel: loadedmodels));
      } catch (_) {
        throw Exception(ProducerErrorState());
      }
    });

    on<ProducerClearEvent>((event, emit) {
      emit(ProducerEmtyState());
    });
  }

  Future remove(String url, Map<String, dynamic> param) {
    return repository.remove(url, param);
  }

  Future postModel(String url, ModelSet modelSet, String id) {
    return repository.postModel(url, modelSet, id);
  }

  Future postImage(String url, String id, Uint8List data) {
    return repository.postImage(url, id, data);
  }
  Future<ModelSet> addOption(String url, OptionSet optionSet, String id) {
    return repository.postOption(url, optionSet, id);
  }
}
