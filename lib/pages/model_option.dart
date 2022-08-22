import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/model_bloc.dart';
import '../bloc/option_bloc.dart';
import '../bloc/option_constant_bloc.dart';
import '../bloc/producer_bloc.dart';
import '../bloc/producer_state.dart';
import '../models/ModelSet.dart';
import '../models/OptionConstant.dart';
import '../models/OptionSet.dart';
import '../widgets/showTextDialog.dart';

class ModelOption extends StatefulWidget {
  const ModelOption({Key? key}) : super(key: key);

  @override
  State<ModelOption> createState() => _ModelOptionState();
}

class _ModelOptionState extends State<ModelOption> {
  List<ModelSet> _list = [];
  ModelSet? modelSet;

  // List<OptionSet> _listOptionSet = [];
  List<OptionConstant> _options = [];
  OptionConstantBloc? optionConstantBloc;
  int idx = 0;
  int index = 0;
  ModelSet? _model;
  ModelBloc? modelBloc;
  ProducerBloc? producerBloc;
  OptionBloc? optionBloc;

  // OptionConstant? optionConstant;

  void getApiAll() {
    optionConstantBloc!.getAll().then((value) {
      return _options = value;
    });
  }

  @override
  void initState() {
    optionConstantBloc = BlocProvider.of<OptionConstantBloc>(context);
    optionBloc = BlocProvider.of<OptionBloc>(context);
    // modelBloc.on((event, emit) => null)
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
          _list = state.loadedModel;
          _model = _list.first;
          _model!.optionSet!.sort((a, b) => a.id!.compareTo(b.id!));

          return main(context);
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

  Widget main(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "Модели и характеристики",
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      padding: EdgeInsets.all(5),
                      child: Card(
                          // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                          child: ListView.builder(
                              itemCount: _list.length,
                              itemBuilder: (context, idx) {
                                return Container(
                                  // alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(5),
                                  child: ElevatedButton(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: 200,
                                      height: 50,
                                      child: Text(
                                        '${_list[idx].name!} (${_list[idx].producername!})',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        index = idx;
                                        _model = _list[index];
                                        // optionTable(context, setState);
                                      });
                                    },
                                  ),
                                );
                              }))),
                ),
                Expanded(
                    flex: 5,
                    child: Container(
                        padding: EdgeInsets.all(5),
                        // height: MediaQuery.of(context).size.height,
                        child: Card(
                            // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                            child: optionTable(context, setState))))
              ],
            ),
          )
        ],
      );
    });
  }

  Widget optionTable(BuildContext context, setState) {
    return Column(children: [
      // SizedBox(height: 20,),
      Container(
        alignment: Alignment.center,
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        color: Colors.amber,
        child: Text(
          _model!.name!,
          style: TextStyle(fontSize: 25),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: Icon(
            Icons.add_box_rounded,
            color: Colors.blue,
            size: 40,
          ),
          onPressed: () {
            // setState(() {
            shownewdialog(context, setState);
            // _listOptionSet.add(OptionSet());
            // });
          },
        ),
      ),
      Expanded(
          flex: 5,
          child: SingleChildScrollView(
              child: DataTable(
                  // columnSpacing: 150,
                  columns: [
                DataColumn(label: Text("№")),
                DataColumn(label: Text("Характеристика")),
                DataColumn(label: Text("Значение")),
                DataColumn(label: Text("Удалить")),
              ],
                  rows: _model!.optionSet!.map((e) {
                    TextEditingController textEditingController =
                        TextEditingController();
                    textEditingController.text = e.optionname!;
                    idx = _options.indexWhere(
                        (element) => element.id == e.optionConstant!.id);
                    OptionConstant optionConstant = _options[idx];
                    return DataRow(cells: [
                      DataCell(
                          Text((_model!.optionSet!.indexOf(e) + 1).toString())),
                      DataCell(StatefulBuilder(
                        builder: (context, setState) {
                          return DropdownButton<OptionConstant>(
                            items: _options
                                .map<DropdownMenuItem<OptionConstant>>((elc) {
                              return DropdownMenuItem(
                                  child: Text(
                                    elc.namerus!,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  value: elc);
                            }).toList(),
                            value: optionConstant,
                            onChanged: (OptionConstant? newoptionConstant) {
                              setState(() {
                                optionConstant = newoptionConstant!;
                              });
                            },
                          );
                        },
                      )),
                      DataCell(Text(e.optionname!), showEditIcon: true,
                          onTap: () {
                        editOptionName(e).then((value) {
                          setState(() {
                            e.optionname = value;
                          });
                        });
                      }),
                      DataCell(Icon(Icons.delete), onTap: () {
                        Map<String, dynamic> param = {'id': e.id.toString()};
                        optionBloc!.remove('optionremove', param).then((value) {
                          setState(() {
                            _model!.optionSet!.remove(e);
                            // optionTable(context, setState);
                          });
                        });
                      })
                    ]);
                  }).toList()))),
    ]);
  }

  Future editOptionName(OptionSet optionSet) async {
    final newOptinName = await showTextDialog(context,
        title: "Значение опций", value: optionSet.optionname!);

    return newOptinName;
  }

  Future<void> shownewdialog(BuildContext context, setState) async {
    OptionConstant? optionConstant;
    TextEditingController optionController = TextEditingController();

    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Форма характеристики"),
            content: Container(
              height: 400,
              width: 600,
              child: Column(
                children: [
                  Container(
                      // width: MediaQuery.of(context).size.width,
                      child: StatefulBuilder(
                    builder: (context, setState) {
                      return DropdownButton<OptionConstant>(
                          isExpanded: true,
                          value: optionConstant,
                          items: _options
                              .map<DropdownMenuItem<OptionConstant>>((e) =>
                                  DropdownMenuItem(
                                      child: Text(e.namerus!), value: e))
                              .toList(),
                          onChanged: (OptionConstant? newoption) {
                            setState(() {
                              optionConstant = newoption;
                            });
                          });
                    },
                  )),
                  Container(
                    child: TextFormField(
                      controller: optionController,
                      decoration: InputDecoration(
                          label: Text("Значение характеристики")),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    OptionSet optionSet = OptionSet(
                        // id: _model!.optionSet!.length + 1,
                        optionConstant: optionConstant,
                        optionname: optionController.text);

                    optionBloc!
                        .addOption(
                            "modelcreate", optionSet, _model!.id.toString())
                        .then((value) {
                      // getApiAll();
                      setState(() {
                        _model!.optionSet!.add(optionSet);
                      });

                      // optionTable(context, setState);
                      // _model = value;//

                      Navigator.of(context).pop();
                    }).catchError((onError) {
                      print(onError);
                    });
                    // optionSet.id = null;
                    // optionBloc!.addOption("optionadd", optionSet).then((value) {
                    //
                    // }).catchError((onError) {
                    //   print(onError);
                    // });
                  },
                  child: Text("Ок")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Отмена"))
            ],
          );
        });
  }
}
