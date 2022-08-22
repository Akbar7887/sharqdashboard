import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharqmotors/bloc/producer_state.dart';

import '../models/OptionSet.dart';
import '../services/producer_repository.dart';

class OptionBloc extends Cubit<ProducerState> {
  final Repository repository;

  OptionBloc({required this.repository}) : super(ProducerEmtyState());

  Future addOption(String url, OptionSet optionSet, String id) {
    return repository.postOption(url, optionSet, id);
  }

  Future remove(String url, Map<String, dynamic> param) {
    return repository.remove(url, param);
  }
}
