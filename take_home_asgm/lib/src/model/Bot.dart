// ignore_for_file: file_names
import 'dart:async';

import 'package:take_home_asgm/src/enum/BotStatus.dart';
import 'package:take_home_asgm/src/model/CustomerOrder.dart';

class Bot {
  final int botId;
  CustomerOrder? currentOrder;
  BotStatus status;
  Timer? timer;

  Bot({
    required this.botId,
    this.status = BotStatus.IDLE,
  });

  void markBusy() {
    status = BotStatus.BUSY;
  }

  void markIdle() {
    status = BotStatus.IDLE;
  }
}
