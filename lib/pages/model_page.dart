import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharqmotors/bloc/producer_event.dart';

import '../bloc/model_bloc.dart';
import '../bloc/option_constant_bloc.dart';
import '../bloc/producer_bloc.dart';
import '../bloc/producer_state.dart';
import '../bloc/section_bloc.dart';
import '../models/ModelSet.dart';
import '../models/OptionConstant.dart';
import '../models/OptionSet.dart';
import '../models/Producer.dart';
import '../models/Section.dart';
import '../models/ui.dart';
import '../services/producer_repository.dart';

class ModelPage extends StatefulWidget {
  const ModelPage({Key? key}) : super(key: key);

  @override
  State<ModelPage> createState() => _ModelPageState();
}

class _ModelPageState extends State<ModelPage> {
  List<ModelSet> _list = [];
  ModelSet? modelSet;
  late final Repository repository;
  Uint8List? _webImage;
  GlobalKey _globalKey_name = GlobalKey<FormState>();
  GlobalKey _globalKey_price = GlobalKey<FormState>();
  GlobalKey _globalKey_description = GlobalKey<FormState>();
  GlobalKey _globalKey_descriptionuz = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _descriptionuzController;
  List<Producer> _listProducers = [];
  List<Section> _listSection = [];
  Producer? producer;
  Section? section;
  late ProducerBloc producerBloc;
  late SectionBloc sectionBloc;
  List<OptionConstant> _listOptionConstant = [];
  late OptionConstantBloc optionConstantBloc;
  late ModelBloc modelBloc;
  int idx = 0;

  List<DropdownMenuItem<Section>> itemSectionDropDown() {
    return _listSection.map<DropdownMenuItem<Section>>((e) {
      return DropdownMenuItem(
        child: Text(e.name!),
        value: e,
      );
    }).toList();
  }

  List<DropdownMenuItem<Producer>> itemProduceDropDown() {
    return _listProducers.map<DropdownMenuItem<Producer>>((e) {
      return DropdownMenuItem(
        child: Text(e.name!),
        value: e,
      );
    }).toList();
  }

  void getApiAll() {
    producerBloc.getProducer().then((value) {
      setState(() {
        if (value != null) {
          _listProducers = value;
        }
      });
    });

    sectionBloc.getAll().then((value) {
      setState(() {
        _listSection = value;
      });

      List<OptionSet>? optionSet = modelSet?.optionSet;
      if (optionSet != null) {
        optionSet.sort((a, b) => a.id!.compareTo(b.id!));
      }
    });

    optionConstantBloc.getAll().then((value) {
      setState(() {
        _listOptionConstant = value;
      });
    });
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();
    _descriptionuzController = TextEditingController();
    producerBloc = BlocProvider.of<ProducerBloc>(context);
    sectionBloc = BlocProvider.of<SectionBloc>(context);
    optionConstantBloc = BlocProvider.of<OptionConstantBloc>(context);
    modelBloc = BlocProvider.of<ModelBloc>(context);
    _webImage = null;
    getApiAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ModelBloc, ProducerState>(
      builder: (context, state) {
        if (state is ProducerEmtyState) {
          return Center(child: Text("No data!"));
        }

        if (state is ProducerLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is ModelLoadedState) {
          //
          _list = state.loadedModel;
          return tabledata(context);
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

  Widget tabledata(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            height: 800,
            // width: MediaQuery.of(context).size.width,
            child: Card(
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // width: 100,
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          modelSet = ModelSet(
                              name: "",
                              description: "",
                              descriptionuz: "",
                              imagepath: "");
                          _webImage = null;
                          producer = null;
                          section = null;
                          showDialogWidget();
                        },
                        child: Text("Добавить"),
                      ),
                    ),
                    DataTable(
                        headingRowHeight: 30.0,
                        columns: [
                          DataColumn(label: Text("№")),
                          DataColumn(label: Text("Марка")),
                          DataColumn(label: Text("Модель")),
                          DataColumn(label: Text("Цена USD")),
                          DataColumn(label: Text("Цена SUM")),
                          DataColumn(label: Text("Описание")),
                          DataColumn(label: Text("Картинка")),
                          DataColumn(label: Text('Изменить')),
                          DataColumn(label: Text('Удалить')),
                        ],
                        rows: _list.map((e) {
                          // optionConstant = e.optionSet?.first.optionConstant;
                          return DataRow(cells: [
                            DataCell(Text((_list.indexOf(e) + 1).toString())),
                            DataCell(Text(
                              e.producername!,
                              style: TextStyle(fontSize: 10),
                            )),
                            DataCell(Text(e.name!, style: TextStyle(fontSize: 10))),
                            DataCell(Text(e.price.toString(),
                                style: TextStyle(fontSize: 15))),
                            DataCell(Text(e.priceuzs.toString(),
                                style: TextStyle(fontSize: 15))),
                            DataCell(Text(e.description!,
                                style: TextStyle(fontSize: 15))),
                            DataCell(Image.network(
                              "${Ui.url}download/model/${e.imagepath}",
                              width: 50,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error);
                              },
                            )),
                            DataCell(Icon(Icons.edit), onTap: () {
                              modelSet = e;
                              section = _listSection[_listSection.indexWhere(
                                      (element) => element.id == e.section!.id)];
                              producer = _listProducers[_listProducers.indexWhere(
                                      (element) => element.name == e.producername)];
                              // producer = e.producername
                              (_listSection.length == 0)
                                  ? Container()
                                  : showDialogWidget();
                            }),
                            DataCell(Icon(Icons.delete), onTap: () {
                              Map<String, dynamic> param = {'id': e.id.toString()};

                              modelBloc.remove('removemodel', param).then((value) {
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

  Future<void> showDialogWidget() async {
    _nameController.text = (modelSet?.name == null ? "" : modelSet?.name)!;
    _priceController.text =
    (modelSet?.price.toString() == null ? "" : modelSet!.price.toString());
    _descriptionController.text =
    (modelSet?.description == null ? "" : modelSet?.description)!;
    _descriptionuzController.text =
    (modelSet?.descriptionuz == null ? "" : modelSet?.descriptionuz)!;
    ModelBloc modelBloc = BlocProvider.of<ModelBloc>(context);

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
              title: Text("Модель (Остаток)"),
              content: Container(
                  width: 1200,
                  height: 800,
                  child: Column(
                    children: [
                      Container(
                          child: Row(children: [
                            Expanded(
                                child: DropdownButton<Producer>(
                                  items: itemProduceDropDown(),
                                  value: producer,
                                  isExpanded: true,
                                  hint: Text("Марка"),
                                  onChanged: (Producer? newValue) {
                                    setState(() {
                                      producer = newValue;
                                    });
                                  },
                                )),
                            Expanded(
                              child: DropdownButton<Section>(
                                items: itemSectionDropDown(),
                                value: section,
                                isExpanded: true,
                                hint: Text("Секция"),
                                onChanged: (Section? newValue) {
                                  setState(() {
                                    section = newValue;
                                  });
                                },
                              ),
                            ),
                          ])),
                      SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          child: Form(
                              key: _globalKey_name,
                              child: TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: "Наименование (Латинском)",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          width: 0.5, color: Colors.blue)),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Просим заполнить Наименование";
                                  }
                                },
                              ))),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        // height: 100,
                          child: Form(
                              key: _globalKey_description,
                              child: TextFormField(
                                maxLines: 6,
                                style: TextStyle(fontSize: 10),
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  labelText: "Описание (Рус)",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          width: 0.5, color: Colors.blue)),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Просим заполнить описание";
                                  }
                                },
                              ))),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        // height: 100,
                        child: Form(
                            key: _globalKey_descriptionuz,
                            child: TextFormField(
                              maxLines: 6,
                              style: TextStyle(fontSize: 10),
                              controller: _descriptionuzController,
                              decoration: InputDecoration(
                                labelText: "Описание (Узб.лат)",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        width: 0.5, color: Colors.blue)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Просим заполнить описание";
                                }
                              },
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        // alignment: Alignment.centerLeft,
                          width: 300,
                          child: Form(
                              key: _globalKey_price,
                              child: TextFormField(
                                controller: _priceController,
                                decoration: InputDecoration(
                                  labelText: "Цена (в долл США)",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          width: 0.5, color: Colors.blue)),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Просим заполнить цену";
                                  }
                                },
                              ))),
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _webImage == null
                                  ? Image.network(
                                  "${Ui.url}download/model/${modelSet!.imagepath}",
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
                              SizedBox(
                                width: 50,
                              ),
                              // Spacer(),
                              ElevatedButton(
                                  onPressed: () async {
                                    pickImage();
                                  },
                                  child: Text("Загрузить фото.."))
                            ]),
                      )
                    ],
                  )),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (modelSet == null) {
                      modelSet = ModelSet();
                    }

                    modelSet!.name = _nameController.text;
                    modelSet!.descriptionuz = _descriptionuzController.text;
                    modelSet!.description = _descriptionController.text;
                    modelSet!.price = double.parse(_priceController.text);
                    modelSet!.section = section;

                    modelBloc
                        .postModel(
                        "modeladd", modelSet!, producer!.id!.toString())
                        .then((value) {
                      if (_webImage != null) {
                        modelBloc
                            .postImage(
                            "modelupload", value.id.toString(), _webImage!)
                            .then((value) {
                          modelBloc.add(ProducerLoadEvent());

                        });
                      } else {
                        modelBloc.add(ProducerLoadEvent());
                      }
                      Navigator.of(context).pop();
                    }).catchError((onError) {
                      print(onError);
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
