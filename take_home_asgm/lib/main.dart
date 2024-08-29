import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_home_asgm/src/feature/OrderManagement.dart';
import 'package:take_home_asgm/src/model/Queue.dart';
import 'package:take_home_asgm/src/util/BotIdGenerator.dart';
import 'package:take_home_asgm/src/util/OrderIdGenerator.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderQueue()),
        Provider(create: (_) => OrderIdGenerator()),
        Provider(create: (_) => BotIdGenerator()),
      ],
      child: MaterialApp(
        title: 'MCD Order Management',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: const OrderManagement(),
      ),
    ),
  );
}
