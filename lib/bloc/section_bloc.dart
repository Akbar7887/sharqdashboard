import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharqmotors/bloc/producer_event.dart';
import 'package:sharqmotors/bloc/producer_state.dart';

import '../models/Section.dart';
import '../services/producer_repository.dart';

class SectionBloc extends Bloc<ProducerEvent, ProducerState> {
  final Repository repository;

  SectionBloc({required this.repository}) : super(ProducerEmtyState()) {
    on<ProducerLoadEvent>((event, emit) async {
      emit(ProducerLoadingState());

      try {
        final List<Section> loadedSection = await repository.getSections();
        emit(SectionLoadedState(loadedSection: loadedSection));
      } catch (_) {
        throw Exception(ProducerErrorState());
      }
    });

    on<ProducerClearEvent>((event, emit) {
      emit(ProducerEmtyState());
    });
  }

  Future<List<Section>> getAll() async {
    return await repository.getSections();
  }

  Future<Section> postSection(Section section) {
    return repository.postSection(section);
  }

  Future postImage(String url, String id, Uint8List data) {
    return repository.postImage(url, id, data);
  }

  Future remove(String url, Map<String, dynamic> param) {
    return repository.remove(url, param);
  }
}
