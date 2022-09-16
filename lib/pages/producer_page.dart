import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharqmotors/bloc/producer_event.dart';

import '../bloc/producer_bloc.dart';
import '../bloc/producer_state.dart';
import '../models/Producer.dart';
import '../models/ui.dart';
import '../services/producer_repository.dart';

class ProducerPage extends StatefulWidget {
  const ProducerPage({Key? key}) : super(key: key);

  @override
  State<ProducerPage> createState() => _ProducerPageState();
}

class _ProducerPageState extends State<ProducerPage> {
  List<Producer> _list = [];
  late Producer producer;
  late final Repository repository;
  late TextEditingController _name;
  late TextEditingController _country;
  late TextEditingController _countryuz;
  ProducerBloc? producerBloc;

  // TextEditingController _nameuz = TextEditingController();
  final _formkeyname = GlobalKey<FormState>();
  final _formkeycountry = GlobalKey<FormState>();
  final _formkeycountryuz = GlobalKey<FormState>();

  // final _formkeynameuz = GlobalKey<FormState>();
  Uint8List? _webImage;

  @override
  void initState() {
    super.initState();
    producer = Producer(name: "");
    _name = TextEditingController();
    _country = TextEditingController();
    _countryuz = TextEditingController();
    _webImage = null;
    producerBloc = BlocProvider.of<ProducerBloc>(context);
  }

  // @override
  // void dispose() {
  //   _name.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProducerBloc, ProducerState>(
      builder: (context, state) {
        if (state is ProducerEmtyState) {
          return Center(child: Text("No data!"));
        }

        if (state is ProducerLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is ProducerLoadedState) {
          //
          _list = state.loadedProduser;
          return tabledata();
        }

        if (state is ProducerErrorState) {
          return Center(
            child: Text("Сервер не работает!"),
          );
        }
        return SizedBox.shrink();
      },
      listener: (context, state) {},
    );
  }

  Widget tabledata() {
    ProducerBloc sectionBloc = BlocProvider.of<ProducerBloc>(context);
    // TextEditingController _namecontroller = TextEditingController();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: Card(
                child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      producer = Producer(name: "", country: "", countryuz: "");

                      _webImage = null;
                      showDialogform();
                    },
                    child: Text("Добавить"),
                  ),
                ),
                DataTable(
                    headingRowHeight: 30.0,
                    columns: [
                      DataColumn(label: Text("№")),
                      DataColumn(label: Text("Наименование (Рус)")),
                      DataColumn(label: Text("Страна (Рус)")),
                      DataColumn(label: Text("Страна (Узб.лат)")),
                      DataColumn(label: Text("Картинка")),
                      DataColumn(label: Text('Изменить')),
                      DataColumn(label: Text('Удалить')),
                    ],
                    rows: _list.map((e) {
                      return DataRow(cells: [
                        DataCell(Text((_list.indexOf(e) + 1).toString())),
                        DataCell(Text(e.name!)),
                        DataCell(Text(e.country!)),
                        DataCell(Text(e.countryuz!)),
                        DataCell(Image.network(
                          "${Ui.url}download/producer/${e.imagepath}",
                          width: 50,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error);
                          },
                        )),
                        DataCell(Icon(Icons.edit), onTap: () {
                          producer = e;
                          showDialogform();
                        }),
                        DataCell(Icon(Icons.delete), onTap: () {
                          Map<String, dynamic> param = {'id': e.id.toString()};

                          sectionBloc
                              .remove('removeproducer', param)
                              .then((value) {
                            setState(() {
                              _list.remove(e);
                            });
                          });
                        })
                      ]);
                    }).toList()),
              ],
            ))));
  }

  Future<void> showDialogform() async {
    _name.text = producer.name!;
    _country.text = producer.country!;
    _countryuz.text = producer.countryuz!;

    ProducerBloc producerBloc = BlocProvider.of<ProducerBloc>(context);

    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            Future<File?> pickImage() async {
              XFile? image =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (image != null) {
                var f = await image.readAsBytes();
                setState(() {
                  _webImage = f;
                });
              }
            }

            return AlertDialog(
              title: Text("Производитель"),
              content: Container(
                width: 400,
                height: 400,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text("№ ${producer.id.toString()}"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formkeyname,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Наименование (Рус)",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(width: 0.5, color: Colors.blue)),
                        ),
                        controller: _name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Просим заполнить Наименование";
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formkeycountry,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Страна (Рус)",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(width: 0.5, color: Colors.blue)),
                        ),
                        controller: _country,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Просим заполнить Страну производителя";
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formkeycountryuz,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Страна (Узб.лат)",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(width: 0.5, color: Colors.blue)),
                        ),
                        controller: _countryuz,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Просим заполнить Страну производителя";
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _webImage == null
                                ? Image.network(
                                    "${Ui.url}download/producer/${producer.imagepath}",
                                    width: 200,
                                    height: 200, errorBuilder:
                                        (BuildContext context, Object error,
                                            StackTrace? stackTrace) {
                                    return Icon(Icons.photo);
                                  })
                                : Container(
                                    child: Image.memory(
                                    _webImage!,
                                    width: 200,
                                    height: 200,
                                  )),
                            // Spacer(),
                            ElevatedButton(
                                onPressed: () {
                                  pickImage();
                                },
                                child: Text("Загрузить фото.."))
                          ]),
                    )
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (_formkeyname.currentState!.validate() == false) {
                      return;
                    }
                    if (_formkeycountry.currentState!.validate() == false) {
                      return;
                    }
                    if (_formkeycountryuz.currentState!.validate() == false) {
                      return;
                    }
                    if (_webImage == null && producer.imagepath == null) {
                      return;
                    }

                    producer.name = _name.text;
                    producer.country = _country.text;
                    producer.countryuz = _countryuz.text;

                    producerBloc.post(producer).then((value) {
                      if (_webImage != null) {
                        producerBloc
                            .postImage("producerupload", value.id.toString(),
                                _webImage!)
                            .then((value) {
                          producerBloc.add(ProducerLoadEvent());
                          // setState(() {
                          //   tabledata();
                          // });
                        });
                      } else {
                        producerBloc.add(ProducerLoadEvent());
                      }

                      Navigator.of(context).pop();
                    }).catchError((onError) {
                      return print("error");
                    });
                  },
                  child: Text("Сохранить"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Отмена"),
                ),
              ],
            );
          });
        });
  }
}
