import 'dart:typed_data';

import '../models/Customer.dart';
import '../models/CustomerOrder.dart';
import '../models/ModelSet.dart';
import '../models/News_Company.dart';
import '../models/OptionConstant.dart';
import '../models/OptionSet.dart';
import '../models/Producer.dart';
import '../models/Rate.dart';
import '../models/Section.dart';
import 'api_provider.dart';

class Repository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<List<Producer>> getAllProducers() => _apiProvider.getProducers();

  Future<List<ModelSet>> getAllModels() => _apiProvider.getModelAll();

  Future<Customer> postCustomer(Customer customer) =>
      _apiProvider.postCustomer(customer);

  Future<dynamic> getSections() => _apiProvider.getSection();

  Future<List<NewsCompany>> getNews() => _apiProvider.getNews();

  Future<Section> postSection(Section section) =>
      _apiProvider.postSection(section);

  Future postImage(String url, String id, Uint8List data) =>
      _apiProvider.postImage(url, id, data);

  Future remove(String url, Map<String, dynamic> param) =>
      _apiProvider.remove(url, param);

  Future post(String url, Producer producer) {
    return _apiProvider.postProducer(url, producer);
  }

  Future postNews(String url, NewsCompany newsCompany) {
    return _apiProvider.postNews(url, newsCompany);
  }

  Future<List<OptionConstant>> getOptionConstant() {
    return _apiProvider.getOptionConstant();
  }

  Future postOptionConstant(String url, OptionConstant optionConstant) {
    return _apiProvider.postOptionConstant(url, optionConstant);
  }

  Future postModel(String url, ModelSet modelSet, String id) {
    return _apiProvider.postModel(url, modelSet, id);
  }

  Future postOption(String url, OptionSet optionSet, String id) {
    return _apiProvider.postOption(url, optionSet, id);
  }

  Future<List<Rate>> getAllRate() => _apiProvider.getRate();

  Future postRate(String url, Rate rate) {
    return _apiProvider.postRate(url, rate);
  }

  Future removeAll(String url, Map<String, dynamic> param) =>
      _apiProvider.removeall(url, param);

  Future<bool> login(String user, String passwor) =>
      _apiProvider.login(user, passwor);

  Future<List<CustomerOrder>> getCustomerOrder() {
    return _apiProvider.getCustomerOrder();
  }

  Future removeOrder(String url, CustomerOrder customerOrder) =>
      _apiProvider.removeOrder(url, customerOrder);

  Future postCustomOrder(String url, CustomerOrder customerOrder) {
    return _apiProvider.postCustomOrder(url, customerOrder);
  }
}
