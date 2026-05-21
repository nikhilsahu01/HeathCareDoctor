import 'package:doctors/core/utils/custom_widgets/custom_appBar.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  final bool isToday; // true = Today, false = Total

  const WalletScreen({super.key, required this.isToday});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF156C8A);
    const greenColor = Color(0xFF27AE60);
    const bgColor = Color(0xFFF4F6F8);

    return Scaffold(
      backgroundColor: bgColor,
      appBar:CustomAppBar(title: "Wallet"),

      body: Column(
        children: [

          /// 🔹 Top Earning Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.48, -0.48),
                  end: Alignment(0.52, 1.48),
                  colors: [const Color(0xFF006492), const Color(0xFF2D9CDB)],
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
                      isToday ? "Today's Earnings" : "Total Earnings",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isToday ? "₹1,200" : "₹28,400",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "+8%",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),

          /// 🔹 Toggle Buttons (Today / Total)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _toggleButton("Today", isToday, primaryColor),
                const SizedBox(width: 10),
                _toggleButton("Total", !isToday, primaryColor),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// 🔹 Transaction List
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return _transactionCard(primaryColor, greenColor);
              },
            ),
          )
        ],
      ),
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
  Widget _transactionCard(Color primaryColor, Color greenColor) {
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
              children: const [
                Text(
                  "Video Consultation",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "24 Oct, 09:00 AM",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),

          /// Amount
          const Text(
            "+ ₹500",
            style: TextStyle(
              color: Color(0xFF27AE60),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}