import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharqmotors/bloc/producer_event.dart';
import 'package:sharqmotors/bloc/producer_state.dart';

import '../models/Producer.dart';
import '../services/producer_repository.dart';

class ProducerBloc extends Bloc<ProducerEvent, ProducerState> {
  final Repository producerRepository;

  ProducerBloc({required this.producerRepository})
      : super(ProducerEmtyState()) {
    on<ProducerLoadEvent>((event, emit) async {
      emit(ProducerLoadingState());

      try {
        final List<Producer> loadedProducerslist =
            await producerRepository.getAllProducers();

        emit(ProducerLoadedState(loadedProduser: loadedProducerslist));
      } catch (_) {
        emit(ProducerErrorState());
      }
    });

    on<ProducerClearEvent>((event, emit) async {
      emit(ProducerEmtyState());
    });
  }

  Future<List<Producer>> getProducer() async {
    return await producerRepository.getAllProducers();
  }

  Future<Producer> post(Producer producer) async {
    return await producerRepository.post("produceradd", producer);
  }

  Future postImage(String url, String id, Uint8List data) {
    return producerRepository.postImage(url, id, data);
  }

  Future remove(String url, Map<String, dynamic> param) {
    return producerRepository.remove(url, param);
  }
}
