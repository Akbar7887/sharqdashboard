import '../models/Customer.dart';
import '../models/CustomerOrder.dart';
import '../models/ModelSet.dart';
import '../models/News_Company.dart';
import '../models/OptionConstant.dart';
import '../models/Producer.dart';
import '../models/Rate.dart';
import '../models/Section.dart';

abstract class ProducerState {}

class ProducerEmtyState extends ProducerState {}

class ProducerLoadingState extends ProducerState {}

class ProducerLoadedState extends ProducerState {
  List<Producer> loadedProduser;

  ProducerLoadedState({required this.loadedProduser});
}

class ProducerErrorState extends ProducerState {}


class ModelLoadedState extends ProducerState {
  List<ModelSet> loadedModel;

  ModelLoadedState({required this.loadedModel});
}

class CustomerLoadedState extends ProducerState {
  Customer loadedCustomer;

  CustomerLoadedState({required this.loadedCustomer});
}

class SectionLoadedState extends ProducerState {
  List<Section> loadedSection;

  SectionLoadedState({required this.loadedSection});
}

class NewsCompanyLoadedState extends ProducerState {
  List<NewsCompany> loadednews;

  NewsCompanyLoadedState({required this.loadednews});
}

class OptionConstantLoadedState extends ProducerState {
  List<OptionConstant> loadedoptionconstant;

  OptionConstantLoadedState({required this.loadedoptionconstant});
}

class RateLoadedState extends ProducerState{
  List<Rate>  loadedRate;

  RateLoadedState({required this.loadedRate});
}

class CustomerOrderLoadedState extends ProducerState{

  List<CustomerOrder> loadCustomerOrder;

  CustomerOrderLoadedState({required this.loadCustomerOrder});
}


