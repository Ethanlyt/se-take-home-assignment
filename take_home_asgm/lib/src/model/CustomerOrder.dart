// ignore_for_file: file_names
import 'package:take_home_asgm/src/enum/OrderStatus.dart';

class CustomerOrder {
  final int orderId;
  final bool isVip;
  OrderStatus status;
  int processingTime;

  CustomerOrder({
    required this.orderId,
    this.isVip = false,
    this.status = OrderStatus.PENDING,
    this.processingTime = 10,
  });

  void markProcessing() {
    status = OrderStatus.PROCESSING;
  }

  void markCompleted() {
    status = OrderStatus.COMPLETED;
  }

  void resetOrder() {
    status = OrderStatus.PENDING;
    processingTime = 5;
  }
}
