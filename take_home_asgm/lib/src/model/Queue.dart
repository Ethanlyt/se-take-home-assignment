// ignore_for_file: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:take_home_asgm/src/enum/OrderStatus.dart';
import 'package:take_home_asgm/src/model/Bot.dart';
import 'package:take_home_asgm/src/model/CustomerOrder.dart';

import '../enum/BotStatus.dart';

class OrderQueue extends ChangeNotifier {
  List<CustomerOrder> pendingOrders = [];
  List<CustomerOrder> completedOrders = [];
  List<Bot> bots = [];

  Completer<void>? cancelInterupt;

  void addToQueue(CustomerOrder order) {
    if (order.isVip) {
      if (pendingOrders.isEmpty) {
        pendingOrders.add(order);
      } else {
        final indexOfLastOrder =
            pendingOrders.lastIndexWhere((order) => order.isVip);
        pendingOrders.insert(indexOfLastOrder + 1, order);
      }
    } else {
      pendingOrders.add(order);
    }
    notifyListeners();
    assignBotToOrder();
  }

  void addBot(Bot bot) {
    bots.add(bot);
    notifyListeners();
    assignBotToOrder();
  }

  int removeBot() {
    if (bots.isEmpty) {
      return -1;
    }
    final bot = bots.last;
    final id = bot.botId;
    if (bot.status == BotStatus.IDLE) {
      bots.remove(bot);
    } else if (bot.status == BotStatus.BUSY || bot.currentOrder != null) {
      bot.currentOrder!.resetOrder();
      bot.timer?.cancel();
      bot.currentOrder = null;
      bot.markIdle();
      bots.remove(bot);
    }
    notifyListeners();
    return id;
  }

  void assignBotToOrder() {
    if (pendingOrders.isEmpty ||
        pendingOrders.every((order) => order.status != OrderStatus.PENDING)) {
      return;
    }

    for (var bot in bots) {
      if (bot.status == BotStatus.IDLE && pendingOrders.isNotEmpty) {
        final order = pendingOrders
            .firstWhere((order) => order.status == OrderStatus.PENDING);
        processOrder(order, bot);
      }
    }
  }

  void processOrder(CustomerOrder order, Bot bot) {
    order.markProcessing();
    bot.markBusy();
    bot.currentOrder = order;

    bot.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (order.processingTime > 0) {
        order.processingTime--;
        notifyListeners();
      } else {
        timer.cancel();
        order.markCompleted();
        pendingOrders.remove(order);
        completedOrders.add(order);
        bot.markIdle();
        bot.currentOrder = null;
        assignBotToOrder();
        notifyListeners();
      }
    });
  }

  Bot getHandledBy(CustomerOrder order) {
    final handleBy = bots.firstWhere((bot) => bot.currentOrder == order,
        orElse: () => Bot(botId: -1));
    return handleBy;
  }

  List<Bot> getBots() => bots;

  List<CustomerOrder> getPendingOrders() => pendingOrders;

  List<CustomerOrder> getCompletedOrders() => completedOrders;
}
