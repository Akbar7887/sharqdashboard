import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharqmotors/bloc/producer_event.dart';

import '../bloc/newscompany_bloc.dart';
import '../bloc/producer_state.dart';
import '../models/News_Company.dart';
import '../models/ui.dart';
import '../services/producer_repository.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<NewsCompany> _list = [];
  late NewsCompany newsCompany;
  late final Repository repository;
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  final _formkeytitle = GlobalKey<FormState>();
  final _formkeydescription = GlobalKey<FormState>();
  Uint8List? _webImage;

  @override
  void initState() {
    super.initState();
    newsCompany = NewsCompany(description: "", title: "");
  }

  // @override
  // void dispose() {
  //   _title.dispose();
  //   _description.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCompanyBloc, ProducerState>(
      builder: (context, state) {
        if (state is ProducerEmtyState) {
          return Center(child: Text("No data!"));
        }

        if (state is ProducerLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is NewsCompanyLoadedState) {
          //
          _list = state.loadednews;
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
    NewsCompanyBloc newsCompanyBloc = BlocProvider.of<NewsCompanyBloc>(context);
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
                      newsCompany = NewsCompany(title: "", description: "");
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
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(
                          e.title!,
                          style: TextStyle(fontSize: 10),
                        )),
                        DataCell(Text(e.description!,
                            style: TextStyle(fontSize: 10))),
                        DataCell(Image.network(
                          "${Ui.url}download/news/${e.imagepath}",
                          width: 50,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error);
                          },
                        )),
                        DataCell(Icon(Icons.edit), onTap: () {
                          newsCompany = e;
                          showDialogform();
                        }),
                        DataCell(Icon(Icons.delete), onTap: () {
                          Map<String, dynamic> param = {'id': e.id.toString()};

                          newsCompanyBloc
                              .remove('removenews', param)
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
    _title.text = newsCompany.title!;
    _description.text = newsCompany.description!;

    NewsCompanyBloc newsCompanyBloc = BlocProvider.of<NewsCompanyBloc>(context);

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
                      child: Text("№ ${newsCompany.id.toString()}"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formkeytitle,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Заголовок",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(width: 0.5, color: Colors.blue)),
                        ),
                        controller: _title,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Просим заполнить заголовок";
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formkeydescription,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Описание",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(width: 0.5, color: Colors.blue)),
                        ),
                        controller: _description,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Просим заполнить описание";
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
                                    "${Ui.url}download/news/${newsCompany.imagepath}",
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
                ElevatedButton(
                  onPressed: () {
                    if (_formkeytitle.currentState!.validate() == false ||
                        _formkeydescription.currentState!.validate() == false) {
                      return;
                    }
                    if (_webImage == null && newsCompany.imagepath == null) {
                      return;
                    }

                    newsCompany.title = _title.text;
                    newsCompany.description = _description.text;

                    newsCompanyBloc.postNews(newsCompany).then((value) {
                      if (_webImage != null) {
                        newsCompanyBloc
                            .postImage(
                                "newsupload", value.id.toString(), _webImage!)
                            .then((value) {
                          // setState(() {
                          //   tabledata();
                          // });
                           newsCompanyBloc.add(ProducerLoadEvent());
                        });
                      } else {
                        newsCompanyBloc.add(ProducerLoadEvent());

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
