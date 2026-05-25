import 'package:doctors/core/utils/custom_widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../view_model/wallet_view_model.dart';

class WalletScreen extends StatefulWidget {
  final bool isToday; // true = Today, false = Total

  const WalletScreen({super.key, required this.isToday});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late bool _isToday;

  @override
  void initState() {
    super.initState();
    _isToday = widget.isToday;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WalletViewModel>(context, listen: false).fetchWalletData();
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF156C8A);
    const greenColor = Color(0xFF27AE60);
    const bgColor = Color(0xFFF4F6F8);

    return Scaffold(
      backgroundColor: bgColor,
      appBar:CustomAppBar(title: "Wallet"),

      body: Consumer<WalletViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = viewModel.walletModel?.data;
          final todayEarnings = 0; // Not returned from API explicitly unless filtered, using total
          final totalEarnings = data?.totalEarned ?? 0;
          final availableBalance = data?.availableBalance ?? 0;
          
          // Filter transactions for today if needed
          final now = DateTime.now();
          final allTxns = data?.transactions ?? [];
          final displayedTxns = _isToday ? allTxns.where((tx) {
            if (tx.date == null) return false;
            final d = DateTime.tryParse(tx.date!);
            return d != null && d.year == now.year && d.month == now.month && d.day == now.day;
          }).toList() : allTxns;

          return Column(
            children: [

              /// 🔹 Top Earning Card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(0.48, -0.48),
                      end: Alignment(0.52, 1.48),
                      colors: [Color(0xFF006492), Color(0xFF2D9CDB)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isToday ? "Available Balance" : "Total Earnings",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "₹${_isToday ? availableBalance : totalEarnings}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (_isToday) // Only show withdraw on balance view
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF006492),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          _showWithdrawalDialog(context, viewModel, availableBalance.toDouble());
                        },
                        child: const Text("Withdraw"),
                      ),
                  ],
                ),
              ),

              /// 🔹 Toggle Buttons (Today / Total)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isToday = true),
                      child: _toggleButton("Balance & Today", _isToday, primaryColor)
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => setState(() => _isToday = false),
                      child: _toggleButton("Total", !_isToday, primaryColor)
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// 🔹 Transaction List
              Expanded(
                child: displayedTxns.isEmpty 
                  ? const Center(child: Text("No transactions"))
                  : ListView.builder(
                  itemCount: displayedTxns.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final tx = displayedTxns[index];
                    return _transactionCard(primaryColor, greenColor, tx);
                  },
                ),
              )
            ],
          );
        }
      ),
    );
  }

  void _showWithdrawalDialog(BuildContext context, WalletViewModel viewModel, double maxAmount) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Withdraw Funds"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Available Balance: ₹$maxAmount"),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Enter Amount",
                  prefixText: "₹ ",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 0;
                if (amount <= 0 || amount > maxAmount) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid amount")),
                  );
                } else {
                  Navigator.pop(context);
                  viewModel.requestWithdrawal(context, amount);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006492),
                foregroundColor: Colors.white,
              ),
              child: const Text("Request Withdrawal"),
            ),
          ],
        );
      },
    );
  }

  /// 🔹 Toggle Button
  Widget _toggleButton(String text, bool isActive, Color primaryColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: isActive
            ? ShapeDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.48, -0.48),
            end: Alignment(0.52, 1.48),
            colors: [
              Color(0xFF006492),
              Color(0xFF2D9CDB),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        )
            : BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: primaryColor),
        ),

        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Transaction Card
  Widget _transactionCard(Color primaryColor, Color greenColor, dynamic tx) {
    bool isCredit = tx.type == 'CREDIT';
    
    String formattedDate = tx.date ?? "";
    if (tx.date != null) {
      final d = DateTime.tryParse(tx.date!);
      if (d != null) {
        formattedDate = DateFormat('dd MMM, hh:mm a').format(d);
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [

          /// Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.payment, color: primaryColor),
          ),

          const SizedBox(width: 12),

          /// Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.description ?? "Transaction",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),

          /// Amount
          Text(
            "${isCredit ? '+' : '-'} ₹${tx.amount}",
            style: TextStyle(
              color: isCredit ? greenColor : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}