// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_home_asgm/src/enum/OrderStatus.dart';
import 'package:take_home_asgm/src/model/Bot.dart';
import 'package:take_home_asgm/src/model/Queue.dart';

import '../enum/BotStatus.dart';
import '../model/CustomerOrder.dart';
import '../util/BotIdGenerator.dart';
import '../util/OrderIdGenerator.dart';

class OrderManagement extends StatefulWidget {
  const OrderManagement({super.key});

  static const routeName = '/pending_area';

  @override
  // ignore: library_private_types_in_public_api
  _OrderManagement createState() => _OrderManagement();
}

class _OrderManagement extends State<OrderManagement> {
  @override
  Widget build(BuildContext context) {
    final orderIdGenerator = Provider.of<OrderIdGenerator>(context);
    final botIdGenerator = Provider.of<BotIdGenerator>(context);
    final queueHandler = Provider.of<OrderQueue>(context);

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.fastfood),
        title: const Text('MCD Order Manegement'),
      ),
      body: Column(
        children: [
          Container(
            height: 150,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const BotInfo(),
          ),
          const Divider(color: Colors.black, indent: 20, endIndent: 20),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Expanded(child: PendingOrderList()),
                SizedBox(
                  width: 1,
                  child: Container(
                    color: Colors.black,
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                  ),
                ),
                const Expanded(child: CompletedOrderList())
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          ButtonAddNormalOrder(
              orderIdGenerator: orderIdGenerator, queueHandler: queueHandler),
          const SizedBox(width: 10),
          ButtonAddVipOrder(
              orderIdGenerator: orderIdGenerator, queueHandler: queueHandler),
          const SizedBox(width: 10),
          ButtonAddBot(
              botIdGenerator: botIdGenerator, queueHandler: queueHandler),
          const SizedBox(width: 10),
          ButtonRemoveBot(queueHandler: queueHandler),
        ]),
      ),
    );
  }
}

class ButtonRemoveBot extends StatelessWidget {
  const ButtonRemoveBot({
    super.key,
    required this.queueHandler,
  });

  final OrderQueue queueHandler;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          final botId = queueHandler.removeBot();
          final snackBar = SnackBar(
            duration: const Duration(milliseconds: 800),
            content: Text(
                botId == -1 ? "No bot to remove" : "Bot ID: $botId removed"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        tooltip: "Remove last bot",
        child: const Icon(Icons.remove_from_queue));
  }
}

class ButtonAddBot extends StatelessWidget {
  const ButtonAddBot({
    super.key,
    required this.botIdGenerator,
    required this.queueHandler,
  });

  final BotIdGenerator botIdGenerator;
  final OrderQueue queueHandler;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          Bot bot = Bot(botId: botIdGenerator.generateId());
          queueHandler.addBot(bot);
          final snackBar = SnackBar(
            duration: const Duration(milliseconds: 800),
            content: Text('Bot ID: ${bot.botId} added.'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        tooltip: "Add bot",
        child: const Icon(Icons.add_to_queue));
  }
}

class ButtonAddVipOrder extends StatelessWidget {
  const ButtonAddVipOrder({
    super.key,
    required this.orderIdGenerator,
    required this.queueHandler,
  });

  final OrderIdGenerator orderIdGenerator;
  final OrderQueue queueHandler;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          CustomerOrder order = CustomerOrder(
            orderId: orderIdGenerator.generateId(),
            isVip: true,
          );
          queueHandler.addToQueue(order);
          final snackBar = SnackBar(
            duration: const Duration(milliseconds: 800),
            content: Text(
                'Order ID: ${order.orderId} added to queue. \$VIP ORDER\$'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        tooltip: "Add vip order",
        child: const Icon(Icons.add_circle));
  }
}

class ButtonAddNormalOrder extends StatelessWidget {
  const ButtonAddNormalOrder({
    super.key,
    required this.orderIdGenerator,
    required this.queueHandler,
  });

  final OrderIdGenerator orderIdGenerator;
  final OrderQueue queueHandler;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        CustomerOrder order = CustomerOrder(
          orderId: orderIdGenerator.generateId(),
          isVip: false,
        );
        queueHandler.addToQueue(order);
        final snackBar = SnackBar(
          showCloseIcon: true,
          duration: const Duration(milliseconds: 800),
          content: Text('Order ID: ${order.orderId} added to queue.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      tooltip: "Add normal order",
      child: const Icon(Icons.add_circle_outline),
    );
  }
}

class PendingOrderList extends StatelessWidget {
  const PendingOrderList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderQueue>(
      builder: (context, orderQueue, child) {
        final queues = orderQueue.getPendingOrders();
        return queues.isEmpty
            ? const Center(
                child: Text(
                'No pending orders',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.red),
              ))
            : ListView.builder(
                itemCount: queues.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Order ID: ${queues[index].orderId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          queues[index].isVip ? "VIP order" : "Normal order",
                          style: TextStyle(
                            fontWeight: queues[index].isVip
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        Text(
                          queues[index].status == OrderStatus.PROCESSING
                              ? "Processing order..."
                              : "Waiting for bot",
                          style: TextStyle(
                              color: queues[index].status == OrderStatus.PENDING
                                  ? Colors.yellow
                                  : Colors.red,
                              fontWeight:
                                  queues[index].status == OrderStatus.PENDING
                                      ? FontWeight.normal
                                      : FontWeight.bold),
                        ),
                        Text(
                            'Time remaining (seconds): ${queues[index].processingTime}'),
                      ],
                    ),
                  );
                },
              );
      },
    );
  }
}

class CompletedOrderList extends StatelessWidget {
  const CompletedOrderList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderQueue>(
      builder: (context, orderQueue, child) {
        final queues = orderQueue.getCompletedOrders();
        return queues.isEmpty
            ? const Center(
                child: Text(
                'No completed orders',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.red),
              ))
            : ListView.builder(
                itemCount: queues.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Order ID: ${queues[index].orderId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          queues[index].isVip ? "VIP order" : "Normal order",
                          style: TextStyle(
                            fontWeight: queues[index].isVip
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        const Text(
                          "Completed",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              );
      },
    );
  }
}

class BotInfo extends StatelessWidget {
  const BotInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderQueue>(builder: (context, orderQueue, child) {
      final bots = orderQueue.getBots();
      return bots.isEmpty
          ? const Center(
              child: Text(
              'No Bots',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
            ))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: bots.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 130,
                  alignment: Alignment.center,
                  child: ListTile(
                    title: Text('Bot ID: ${bots[index].botId}'),
                    subtitle: Text(
                      'Status: ${bots[index].status == BotStatus.IDLE ? "Idle" : "Busy"}',
                      style: TextStyle(
                          color: bots[index].status == BotStatus.IDLE
                              ? Colors.green
                              : Colors.red,
                          fontWeight: bots[index].status == BotStatus.IDLE
                              ? FontWeight.normal
                              : FontWeight.bold),
                    ),
                  ),
                );
              },
            );
    });
  }
}
