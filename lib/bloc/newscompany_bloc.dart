import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharqmotors/bloc/producer_event.dart';
import 'package:sharqmotors/bloc/producer_state.dart';

import '../models/News_Company.dart';
import '../services/producer_repository.dart';

class NewsCompanyBloc extends Bloc<ProducerEvent, ProducerState> {
  final Repository repository;

  NewsCompanyBloc({required this.repository}) : super(ProducerEmtyState()) {
    on<ProducerLoadEvent>((event, emit) async {
      emit(ProducerLoadingState());

      try {
        final List<NewsCompany> loadednews = await repository.getNews();
        emit(NewsCompanyLoadedState(loadednews: loadednews));
      } catch (_) {
        throw Exception(ProducerErrorState());
      }
    });

    on<ProducerClearEvent>((event, emit) {
      emit(ProducerEmtyState());
    });
  }

  Future<dynamic> postNews(NewsCompany newsCompany) {
    return repository.postNews("newsadd", newsCompany);
  }

  Future postImage(String url, String id, Uint8List data) {
    return repository.postImage(url, id, data);
  }

  Future remove(String url, Map<String, dynamic> param) {
    return repository.remove(url, param);
  }
}
