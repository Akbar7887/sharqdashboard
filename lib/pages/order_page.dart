import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sharqmotors/bloc/customerorder_bloc.dart';

import '../bloc/producer_state.dart';
import '../models/CustomerOrder.dart';

List<CustomerOrder> _list = [];
CustomerOrderBloc? customerOrderBloc;
List<TextEditingController> _listController = [];

var formatter = new DateFormat('yyyy-MM-dd');

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    customerOrderBloc = BlocProvider.of<CustomerOrderBloc>(context);

    return BlocConsumer<CustomerOrderBloc, ProducerState>(
      builder: (context, state) {
        if (state is ProducerEmtyState) {
          return Center(child: Text("No data!"));
        }

        if (state is ProducerLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is CustomerOrderLoadedState) {
          //
          _list = state.loadCustomerOrder;

          _list.sort((a, b) => a.id!.compareTo(b.id!));

          for (CustomerOrder customerOrder in _list) {
            _listController.add(TextEditingController());
          }
          return getDataTable();
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

  Widget getDataTable() {
    return SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: Card(
                child: DataTable(
                    columns: [
                  DataColumn(label: Text("№")),
                  DataColumn(label: Text("Активность")),
                  DataColumn(label: Text("Дата заказа")),
                  DataColumn(label: Text("ФИО")),
                  DataColumn(label: Text("Модель")),
                  DataColumn(label: Text("Комментарий")),
                  DataColumn(label: Text('Прочтено'))
                ],
                    rows: _list.map((e) {
                      return DataRow(cells: [
                        DataCell(Text(e.id.toString())),
                        DataCell(Text(e.active!)),
                        DataCell(Text(
                            formatter.format(DateTime.parse(e.currentdate!)))),
                        DataCell(Text(e.customer!.name!)),
                        DataCell(Text(e.modelset!.name!)),
                        DataCell(
                          TextFormField(
                            controller: _listController[_list.indexOf(e)],
                            decoration: InputDecoration(
                                labelText: e.description.toString()),
                            onEditingComplete: () {
                              e.description =
                                  _listController[_list.indexOf(e)].text;
                              customerOrderBloc!
                                  .postCustomerOrder(
                                      "/custom/customerorderpost", e)
                                  .then((value) {
                                print("Ok");
                              }).catchError((onError) {
                                return print(onError);
                              });
                            },
                          ),
                          showEditIcon: true,
                        ),
                        DataCell(
                            Icon(
                              Icons.mark_chat_read,
                              color: _list[_list.indexOf(e)].active == 'ACTIVE'
                                  ? Colors.amber
                                  : Colors.green,
                            ), onTap: () {
                          customerOrderBloc!.remove(e).then((value) {
                            setState(() {
                              _list[_list.indexOf(e)] = value;
                            });
                            // customerOrderBloc!.add(ProducerLoadEvent());
                          });
                        })
                      ]);
                    }).toList()))));
  }
}
