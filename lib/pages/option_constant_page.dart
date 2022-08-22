import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharqmotors/bloc/producer_event.dart';

import '../bloc/option_constant_bloc.dart';
import '../bloc/producer_state.dart';
import '../models/OptionConstant.dart';
import '../services/producer_repository.dart';

class OptionConstantPage extends StatefulWidget {
  const OptionConstantPage({Key? key}) : super(key: key);

  @override
  State<OptionConstantPage> createState() => _OptionConstantPageState();
}

class _OptionConstantPageState extends State<OptionConstantPage> {
  List<OptionConstant> _list = [];
  late OptionConstant optionConstant;
  late final Repository repository;
  late TextEditingController _namerus;
  late TextEditingController _nameuz;
  final _formkeyname = GlobalKey<FormState>();
  final _formkeynameuz = GlobalKey<FormState>();
  Uint8List? _webImage;
  OptionConstantBloc? optionConstantBloc;

  @override
  void initState() {
    super.initState();
    optionConstant = OptionConstant(namerus: "", nameuz: "");
    _namerus = TextEditingController();
    _nameuz = TextEditingController();
    _webImage = null;
    optionConstantBloc = BlocProvider.of<OptionConstantBloc>(context);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OptionConstantBloc, ProducerState>(
      builder: (context, state) {
        if (state is ProducerEmtyState) {
          return Center(child: Text("No data!"));
        }

        if (state is ProducerLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is OptionConstantLoadedState) {
          // setState(() {
            _list = state.loadedoptionconstant;

          // });
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
    OptionConstantBloc optionConstantBloc =
        BlocProvider.of<OptionConstantBloc>(context);
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
                      optionConstant = OptionConstant(namerus: "", nameuz: "");
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
                      DataColumn(label: Text("Наименование (Узб)")),
                      DataColumn(label: Text('Изменить')),
                      DataColumn(label: Text('Удалить')),
                    ],
                    rows: _list.map((e) {
                      return DataRow(cells: [
                        DataCell(Text((_list.indexOf(e) + 1).toString())),
                        DataCell(Text(e.namerus!)),
                        DataCell(Text(e.nameuz!)),
                        DataCell(Icon(Icons.edit), onTap: () {
                          optionConstant = e;
                          showDialogform();
                        }),
                        DataCell(Icon(Icons.delete), onTap: () {
                          Map<String, dynamic> param = {'id': e.id.toString()};

                          optionConstantBloc
                              .remove('removeoptionconstant', param)
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
    _nameuz.text = optionConstant.nameuz!;
    _namerus.text = optionConstant.namerus!;

    OptionConstantBloc optionConstantBloc =
        BlocProvider.of<OptionConstantBloc>(context);

    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Производитель"),
              content: Container(
                width: 400,
                height: 400,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text("№ ${optionConstant.id.toString()}"),
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
                        controller: _namerus,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Просим заполнить Наименование (Рус)";
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formkeynameuz,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Наименование (Узб)",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(width: 0.5, color: Colors.blue)),
                        ),
                        controller: _nameuz,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Просим заполнить Наименование (Узб)";
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    if (_formkeyname.currentState!.validate() == false) {
                      return;
                    }

                    optionConstant.namerus = _namerus.text;
                    optionConstant.nameuz = _nameuz.text;

                    optionConstantBloc
                        .postOptionConstant("optionConstantadd", optionConstant)
                        .then((value) {
                      optionConstantBloc.add(ProducerLoadEvent());
                      Navigator.of(context).pop();
                    }).catchError((onError) {
                      return print("error");
                    });
                  },
                  child: Text("Сохранить"),
                ),
                FlatButton(
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
