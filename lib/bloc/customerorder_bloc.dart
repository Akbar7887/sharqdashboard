import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharqmotors/bloc/producer_event.dart';
import 'package:sharqmotors/bloc/producer_state.dart';
import 'package:sharqmotors/models/CustomerOrder.dart';

import '../services/producer_repository.dart';

class CustomerOrderBloc extends Bloc<ProducerEvent, ProducerState> {
  final Repository repository;

  CustomerOrderBloc({required this.repository}) : super(ProducerEmtyState()) {
    on<ProducerLoadEvent>((event, emit) async {
      emit(ProducerLoadingState());

      try {
        final List<CustomerOrder> loadedcustomerorder =
            await repository.getCustomerOrder();
        emit(CustomerOrderLoadedState(loadCustomerOrder: loadedcustomerorder));
      } catch (_) {
        throw Exception(ProducerErrorState());
      }
    });

    on<ProducerClearEvent>((event, emit) {
      emit(ProducerEmtyState());
    });
  }

  Future<CustomerOrder> remove(CustomerOrder customerOrder) async {

    return await repository.removeOrder("/custom/customerorderremove",customerOrder);
  }

  Future<CustomerOrder> postCustomerOrder(String url, CustomerOrder customerOrder) async {

    return await repository.postCustomOrder(url, customerOrder);
  }
}
