class WalletModel {
  bool? success;
  String? message;
  WalletData? data;

  WalletModel({this.success, this.message, this.data});

  WalletModel.fromJson(Map<String, dynamic> json) {
    success = json['status'] ?? json['success'];
    message = json['message'];
    data = json['data'] != null ? WalletData.fromJson(json['data']) : null;
  }
}

class WalletData {
  dynamic availableBalance;
  dynamic totalEarned;
  List<WalletTransaction>? transactions;

  WalletData({this.availableBalance, this.totalEarned, this.transactions});

  WalletData.fromJson(Map<String, dynamic> json) {
    availableBalance = json['available_balance'];
    totalEarned = json['total_earned'];
    if (json['transactions'] != null) {
      transactions = <WalletTransaction>[];
      json['transactions'].forEach((v) {
        transactions!.add(WalletTransaction.fromJson(v));
      });
    }
  }
}

class WalletTransaction {
  String? id;
  String? type;
  dynamic amount;
  String? description;
  String? date;

  WalletTransaction({this.id, this.type, this.amount, this.description, this.date});

  WalletTransaction.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    type = json['type'];
    amount = json['amount'];
    description = json['description'];
    date = json['createdAt'] ?? json['date'];
  }
}
