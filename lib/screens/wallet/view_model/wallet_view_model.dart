import 'package:flutter/material.dart';

import '../model/wallet_model.dart';
import '../repository/wallet_repository.dart';

class WalletViewModel extends ChangeNotifier {
  final _repository = WalletRepository();
  WalletModel? _walletModel;
  bool _isLoading = false;
  String? _errorMessage;

  WalletModel? get walletModel => _walletModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWalletData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.getWalletApi();
      _walletModel = response;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> requestWithdrawal(BuildContext context, double amount) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Update local state for mock
      if (_walletModel?.data != null) {
        _walletModel!.data!.availableBalance = 
            (_walletModel!.data!.availableBalance ?? 0) - amount;
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Withdrawal request for ₹$amount submitted successfully."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to submit withdrawal request."),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
