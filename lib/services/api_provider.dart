import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sharqmotors/models/CustomerOrder.dart';
import 'package:sharqmotors/models/Rate.dart';

import '../models/Customer.dart';
import '../models/ModelSet.dart';
import '../models/News_Company.dart';
import '../models/OptionConstant.dart';
import '../models/OptionSet.dart';
import '../models/Producer.dart';
import '../models/Section.dart';
import '../models/ui.dart';

FlutterSecureStorage _storage = FlutterSecureStorage();

class ApiProvider {
  Map<String, String> header = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Credentials': 'true',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
  };

  String? token;

  Future<List<Producer>> getProducers() async {
    token = await _storage.read(key: "token");

    header["Authorization"] = "Bearer ${token}";

    Uri uri = Uri.parse("${Ui.url}producerget");
    final response = await http.get(uri, headers: header);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));

      return json.map((e) => Producer.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }

  Future<List<ModelSet>> getModelAll() async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Uri uri = Uri.parse("${Ui.url}modelget");
    final response = await http.get(uri, headers: header);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));

      return json.map((e) => ModelSet.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }

  Future<Customer> postCustomer(Customer customer) async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Uri uri = Uri.parse("${Ui.url}customeradd");

    final response =
    await http.post(uri, body: json.encode(customer), headers: header);
    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));

      return Customer.fromJson(json);
    } else {
      throw Exception("Error connect");
    }
  }

  Future<List<Section>> getSection() async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Uri uri = Uri.parse("${Ui.url}sectionget");
    final response = await http.get(uri, headers: header);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));

      return json.map((e) => Section.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }

  Future<List<CustomerOrder>> getCustomerOrder() async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Uri uri = Uri.parse("${Ui.urllogin}/custom/customerorderget");
    final response = await http.get(uri, headers: header);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));

      return json.map((e) => CustomerOrder.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }

  // Future<dynamic> getSection() async {
  //
  //   HttpClient httpClient = new HttpClient();
  //   httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  //   Uri uri = Uri.parse("${Ui.url}sectionget");
  //   final request = await httpClient.getUrl(uri);
  //
  //   HttpClientResponse response =await request.close();
  //
  //   final stringdata = response.transform(utf8.decoder).join();
  //
  //   return stringdata;
  //  // http.BaseClient().
  //   }

  Future<List<NewsCompany>> getNews() async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Uri uri = Uri.parse("${Ui.url}newsget");
    final response = await http.get(uri, headers: header);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));

      return json.map((e) => NewsCompany.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }

  Future<Section> postSection(Section section) async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Uri uri = Uri.parse("${Ui.url}sectionadd");

    final response =
    await http.post(uri, body: json.encode(section), headers: header);
    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));

      return Section.fromJson(json);
    } else {
      throw Exception("Error connect");
    }
  }

  Future postImage(String url, String id, Uint8List data) async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    List<int> list = data;
    final uri = Uri.parse('${Ui.url}${url}');
    var request = await http.MultipartRequest('POST', uri);
    request.fields['id'] = id;

    request.headers.addAll(header);
    request.files
        .add(http.MultipartFile.fromBytes("file", list, filename: ('$id.png')));
    request.send().then((value) => {
      if (value.statusCode == 200)
        {print('Ok')}
      else
        {print(value.statusCode)}
    });
  }

  Future remove(String url, Map<String, dynamic> param) async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Uri uri = Uri.parse('${Ui.url}${url}').replace(queryParameters: param);

    final response = await http.post(uri, headers: header);
    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));

      return json;
    } else {
      throw Exception("Error connect");
    }
  }

  Future<Producer> postProducer(String url, Producer producer) async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Uri uri = Uri.parse("${Ui.url}${url}");

    final response =
    await http.post(uri, body: json.encode(producer), headers: header);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));

      return Producer.fromJson(json);
    } else {
      throw Exception("Error connect");
    }
  }

  Future<NewsCompany> postNews(String url, NewsCompany newsCompany) async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Uri uri = Uri.parse("${Ui.url}${url}");

    final response =
    await http.post(uri, body: json.encode(newsCompany), headers: header);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));

      return NewsCompany.fromJson(json);
    } else {
      throw Exception("Error connect");
    }
  }

  Future<List<OptionConstant>> getOptionConstant() async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Uri uri = Uri.parse("${Ui.url}optionConstantget");
    final response = await http.get(uri, headers: header);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));

      return json.map((e) => OptionConstant.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }

  Future<OptionConstant> postOptionConstant(
      String url, OptionConstant optionConstant) async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Uri uri = Uri.parse("${Ui.url}${url}");

    final response = await http.post(uri,
        body: json.encode(optionConstant), headers: header);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));

      return OptionConstant.fromJson(json);
    } else {
      throw Exception("Error connect");
    }
  }

  Future<ModelSet> postModel(String url, ModelSet modelSet, String id) async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Map<String, dynamic> quiryParam = {
      'id': id,
    };
    Uri uri = Uri.parse("${Ui.url}${url}").replace(queryParameters: quiryParam);

    final response =
    await http.post(uri, body: json.encode(modelSet), headers: header);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));

      return ModelSet.fromJson(json);
    } else {
      throw Exception("Error connect");
    }
  }

  Future<ModelSet> postOption(
      String url, OptionSet optionSet, String id) async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Map<String, dynamic> quiryParam = {
      'model_id': id,
    };
    Uri uri = Uri.parse("${Ui.url}${url}").replace(queryParameters: quiryParam);

    final response =
    await http.post(uri, body: json.encode(optionSet), headers: header);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));

      return ModelSet.fromJson(json);
    } else {
      throw Exception("Error connect");
    }
  }

  Future<List<Rate>> getRate() async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Uri uri = Uri.parse("${Ui.url}getrate");
    final response = await http.get(uri, headers: header);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));

      return json.map((e) => Rate.fromJson(e)).toList();
    } else {
      throw Exception("Error");
    }
  }

  Future<Rate> postRate(String url, Rate rate) async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Uri uri = Uri.parse("${Ui.url}${url}");

    final response =
    await http.post(uri, body: json.encode(rate), headers: header);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));

      return Rate.fromJson(json);
    } else {
      throw Exception("Error connect");
    }
  }

  Future removeall(String url, Map<String, dynamic> param) async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Uri uri = Uri.parse('${Ui.url}${url}').replace(queryParameters: param);

    final response = await http.delete(uri, headers: header);
    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));

      return json;
    } else {
      throw Exception("Error connect");
    }
  }

  Future<bool> login(String user, String passwor) async {
    Map<String, String> data = {'username': user, 'password': passwor};
    Map<String, String> header1 = {
      "Content-Type": "application/x-www-form-urlencoded", //
      // "Authorization": "Bearer $token",
    };

    // final uri = Uri.parse();
    final uri = Uri.parse('${Ui.urllogin}/login');
    var response = await http.post(uri,
        body: data, headers: header1, encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> l = jsonDecode(utf8.decode(response.bodyBytes));
      await _storage.write(key: 'token', value: l['access_token']);
      return true;
    } else {
      return false;
    }
  }

  Future<CustomerOrder> removeOrder(String url, CustomerOrder customerOrder) async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Uri uri = Uri.parse('${Ui.urllogin}${url}');

    final response = await http.post(uri, body: json.encode(customerOrder), headers: header);
    if (response.statusCode == 200) {
      var json = CustomerOrder.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      print("ok");
      return json;
    } else {
      throw Exception("Error connect");
    }
  }

  Future<CustomerOrder> postCustomOrder(
      String url, CustomerOrder customerOrder) async {
    token = await _storage.read(key: "token");
    header["Authorization"] = "Bearer ${token}";
    Uri uri = Uri.parse("${Ui.urllogin}${url}");

    final response =
    await http.post(uri, body: json.encode(customerOrder), headers: header);
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));

      return CustomerOrder.fromJson(json);
    } else {
      throw Exception("Error connect");
    }
  }
}
