// room_model.dart
import 'dart:convert';

class Payment {
  final double amountPaid;
  final String date;

  Payment({required this.amountPaid, required this.date});

  Map<String, dynamic> toJson() => {
        'amountPaid': amountPaid,
        'date': date,
      };

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      amountPaid: json['amountPaid'],
      date: json['date'],
    );
  }
}

class Room {
  final String roomNumber;
  String tenantName;
  String tenantContact;
  double rentAmount;
  double dueAmount;
  List<Payment> paymentHistory;

  Room({
    required this.roomNumber,
    required this.tenantName,
    required this.tenantContact,
    required this.rentAmount,
    required this.dueAmount,
    required this.paymentHistory, // Ensure this line exists
  });

  void markAsPaid(double amount) {
    dueAmount -= amount;
    paymentHistory.add(
        Payment(amountPaid: amount, date: DateTime.now().toIso8601String()));
  }

  Map<String, dynamic> toJson() {
    return {
      'roomNumber': roomNumber,
      'tenantName': tenantName,
      'tenantContact': tenantContact,
      'rentAmount': rentAmount,
      'dueAmount': dueAmount,
      'paymentHistory':
          paymentHistory.map((payment) => payment.toJson()).toList(),
    };
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    var paymentList = json['paymentHistory'] as List;
    List<Payment> payments =
        paymentList.map((i) => Payment.fromJson(i)).toList();
    return Room(
      roomNumber: json['roomNumber'],
      tenantName: json['tenantName'],
      tenantContact: json['tenantContact'],
      rentAmount: json['rentAmount'],
      dueAmount: json['dueAmount'],
      paymentHistory: payments,
    );
  }
}
