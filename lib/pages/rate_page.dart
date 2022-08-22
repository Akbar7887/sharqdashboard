import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sharqmotors/bloc/rate_bloc.dart';

import '../bloc/producer_event.dart';
import '../bloc/producer_state.dart';
import '../models/Rate.dart';

List<Rate> _list = [];
var formatter = new DateFormat('yyyy-MM-dd');
TextEditingController _dateController = TextEditingController();
TextEditingController _courseController = TextEditingController();
Rate? rate;

class RatePage extends StatelessWidget {
  const RatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    _dateController.text = formatter.format(now);

    return BlocConsumer<RateBloc, ProducerState>(
      builder: (context, state) {
        if (state is ProducerEmtyState) {
          return Center(child: Text("No data!"));
        }

        if (state is ProducerLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is RateLoadedState) {
          //
          _list = state.loadedRate;
          return mainUntil(context);
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

  Widget mainUntil(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            "Курс валют!",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Дата",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(width: 0.5, color: Colors.blue)),
                  ),
                  controller: _dateController,
                  onTap: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015),
                      lastDate: DateTime(2030),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        _dateController.text =
                            formatter.format(selectedDate);
                      }
                    });
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                )),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Курс",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(width: 0.5, color: Colors.blue)),
                    ),
                    controller: _courseController,
                  ),
                )
              ],
            )),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.only(left: 100, right: 100),
          child: ElevatedButton(
            onPressed: () {
              if (rate == null) {
                rate = Rate();
              }
              RateBloc rateBloc = BlocProvider.of<RateBloc>(context);

              rate?.currentdate = _dateController.text;
              rate?.course = double.tryParse(_courseController.text);

              rateBloc.postRate('addrate', rate!).then((value) {
                rateBloc.add(ProducerLoadEvent());
                _courseController.text = "0";
              });
            },
            child: Text("Добавить курс валют"),
          ),
        ),
        Container(child: getDataTable(context)),

        //getDataTable()),
      ],
    );
  }

  Widget getDataTable(context) {
    return DataTable(
        columns: [
          DataColumn(label: Text("Дата")),
          DataColumn(label: Text("Курс")),
          DataColumn(label: Text('Удалить')),
        ],
        rows: _list.map((e) {
          return DataRow(cells: [
            DataCell(Text(formatter.format(DateTime.parse(e.currentdate!)))),
            DataCell(Text(e.course.toString())),
            DataCell(Icon(Icons.delete), onTap: () {
              Map<String, dynamic> param = {'id': e.id.toString()};
              RateBloc rateBloc = BlocProvider.of<RateBloc>(context);

              rateBloc.removeAll('removerate', param).then((value) {
                rateBloc.add(ProducerLoadEvent());
              }).catchError((onError){
                print(onError);
              });
            })
          ]);
        }).toList());
  }
}
