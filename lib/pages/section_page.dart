import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/producer_state.dart';
import '../bloc/section_bloc.dart';
import '../models/Section.dart';
import '../models/ui.dart';
import '../services/producer_repository.dart';

class SectionPage extends StatefulWidget {
  const SectionPage({Key? key}) : super(key: key);

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  List<Section> _list = [];
  late Section section;
  late final Repository repository;
  TextEditingController _name = TextEditingController();
  TextEditingController _nameuz = TextEditingController();
  final _formkeyname = GlobalKey<FormState>();
  final _formkeynameuz = GlobalKey<FormState>();
  Uint8List? _webImage;
  SectionBloc? sectionBloc;


  @override
  void initState() {
    super.initState();
    section = Section(name: "", nameuz: "");
  }

  // @override
  // void dispose() {
  //   _name.dispose();
  //   _nameuz.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SectionBloc, ProducerState>(
      builder: (context, state) {
        if (state is ProducerEmtyState) {
          return Center(child: Text("No data!"));
        }

        if (state is ProducerLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is SectionLoadedState) {
          //
          _list = state.loadedSection;
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
    sectionBloc = BlocProvider.of<SectionBloc>(context);
    // TextEditingController _namecontroller = TextEditingController();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            height: MediaQuery.of(context).size.height,
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
                      section = Section(name: "", nameuz: "");
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
                      DataColumn(label: Text("Наименование (Узб.Лат)")),
                      DataColumn(label: Text("Картинка")),
                      DataColumn(label: Text('Изменить')),
                      DataColumn(label: Text('Удалить')),
                    ],
                    rows: _list.map((e) {
                      return DataRow(cells: [
                        DataCell(Text((_list.indexOf(e) + 1).toString())),
                        DataCell(Text(e.name!)),
                        DataCell(Text(e.nameuz!)),
                        DataCell(Image.network(
                          "${Ui.url}download/section/${e.imagepath}",
                          width: 50,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error);
                          },
                        )),
                        DataCell(Icon(Icons.edit), onTap: () {
                          section = e;
                          showDialogform();
                        }),
                        DataCell(Icon(Icons.delete), onTap: () {
                          Map<String, dynamic> param = {'id': e.id.toString()};

                          sectionBloc!
                              .remove('removesection', param)
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
    _name.text = section.name!;
    _nameuz.text = section.nameuz!;

    SectionBloc sectionBloc = BlocProvider.of<SectionBloc>(context);

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
              title: Text("Группа спецтехники"),
              content: Container(
                width: 400,
                height: 400,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text("№ ${section.id.toString()}"),
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
                    Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _webImage == null
                                ? Image.network(
                                    "${Ui.url}download/section/${section.imagepath}",
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
                                onPressed: () async {
                                  pickImage();
                                },
                                child: Text("Загрузить фото.."))
                          ]),
                    )
                  ],
                ),
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    if (_formkeyname.currentState!.validate() == false ||
                        _formkeynameuz.currentState!.validate() == false) {
                      return;
                    }
                    if (_webImage == null && section.imagepath == null) {
                      return;
                    }
                    section.name = _name.text;
                    section.nameuz = _nameuz.text;
                    sectionBloc.postSection(section).then((value) {
                      if (_webImage != null) {
                        sectionBloc
                            .postImage("sectionupload", value.id.toString(),
                                _webImage!)
                            .then((value) {
                          setState(() {
                            tabledata();
                          });
                        });
                      } else {
                        setState(() {
                          tabledata();
                        });
                      }

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
