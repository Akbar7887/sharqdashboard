import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharqmotors/bloc/customerorder_bloc.dart';
import 'package:sharqmotors/bloc/rate_bloc.dart';
import 'package:sharqmotors/pages/order_page.dart';
import 'package:sharqmotors/pages/producer_page.dart';
import 'package:sharqmotors/pages/rate_page.dart';

import '../bloc/customer_bloc.dart';
import '../bloc/model_bloc.dart';
import '../bloc/newscompany_bloc.dart';
import '../bloc/option_bloc.dart';
import '../bloc/option_constant_bloc.dart';
import '../bloc/producer_bloc.dart';
import '../bloc/producer_event.dart';
import '../bloc/section_bloc.dart';
import '../models/ui.dart';
import '../provider/simle_provider.dart';
import '../services/producer_repository.dart';
import 'model_option.dart';
import 'model_page.dart';
import 'news_page.dart';
import 'option_constant_page.dart';
import 'section_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => Repository(),
        child: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) => ProducerBloc(
                      producerRepository: context.read<Repository>())
                    ..add(ProducerLoadEvent())),
              BlocProvider(
                create: (context) =>
                    ModelBloc(repository: context.read<Repository>())
                      ..add(ProducerLoadEvent()),
              ),
              BlocProvider(
                create: (context) =>
                    CustomerBloc(repository: context.read<Repository>()),
              ),
              BlocProvider(
                create: (context) =>
                    SectionBloc(repository: context.read<Repository>())
                      ..add(ProducerLoadEvent()),
              ),
              BlocProvider(
                create: (context) =>
                    NewsCompanyBloc(repository: context.read<Repository>())
                      ..add(ProducerLoadEvent()),
              ),
              BlocProvider(
                create: (context) =>
                    OptionConstantBloc(repository: context.read<Repository>())
                      ..add(ProducerLoadEvent()),
              ),
              BlocProvider(
                create: (context) =>
                    OptionBloc(repository: context.read<Repository>()),
              ),
              BlocProvider(
                create: (context) =>
                    RateBloc(repository: context.read<Repository>())
                    ..add(ProducerLoadEvent())
              ),
              BlocProvider(
                  create: (context) =>
                  CustomerOrderBloc(repository: context.read<Repository>())
                    ..add(ProducerLoadEvent())
              ),
            ],
            child: Scaffold(
              appBar: AppBar(
                title: Text(Ui.fullname),
              ),
              body: mainBody(),
            )));
  }

  Widget mainBody() {
    return Row(
      children: [
        Expanded(
            child: Container(
                //
                color: Colors.black45,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      // alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<SimpleProvider>().changepage(1);
                        },
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Тип автотранспорта",
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<SimpleProvider>().changepage(2);
                        },
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Производитель",
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<SimpleProvider>().changepage(4);
                        },
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Характеристика константа",
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<SimpleProvider>().changepage(5);
                        },
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Модели (Остаток)",
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<SimpleProvider>().changepage(6);
                        },
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Модели и характеристики",
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<SimpleProvider>().changepage(3);
                        },
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Новости",
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<SimpleProvider>().changepage(7);
                        },
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Курс валют",
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<SimpleProvider>().changepage(8);
                        },
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Заказ звонка от клиентов",
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                    ),
                  ],
                ))),
        Expanded(
          flex: 4,
          child: selectionPage(context.watch<SimpleProvider>().getpage),
        ),
      ],
    );
  }

  selectionPage(int page) {
    switch (page) {
      case 1:
        return SectionPage();
      case 2:
        return ProducerPage();
      case 3:
        return NewsPage();
      case 4:
        return OptionConstantPage();
      case 5:
        return ModelPage();
      case 6:
        return ModelOption();
      case 7:
        return RatePage();
      case 8:
        return OrderPage();
    }
  }
}
