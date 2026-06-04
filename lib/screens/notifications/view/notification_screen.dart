import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/custom_widgets/custom_appBar.dart';
import '../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
import '../../../core/utils/theams/color_resource.dart';
import '../../home/view/bottom_controller.dart';
import '../../wallet/ui/walletScreen.dart';
import '../view_model/notification_view_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationViewModel>(
        context,
        listen: false,
      ).fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: const CustomAppBar(title: 'Notifications', isBack: true),
      body: Consumer<NotificationViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: ThreeDotsLoader());
          }

          if (viewModel.notifications.isEmpty) {
            return const Center(
              child: Text(
                "No notifications yet.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recent",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            viewModel.markAllAsRead();
                          },
                          icon: const Icon(Icons.done_all, color: ColorResource.primaryColor),
                          tooltip: "Mark all as read",
                        ),
                        IconButton(
                          onPressed: () {
                            viewModel.clearAllNotifications();
                          },
                          icon: const Icon(Icons.delete_sweep, color: Colors.red),
                          tooltip: "Clear All",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: viewModel.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = viewModel.notifications[index];
                    return GestureDetector(
                      onTap: () {
                        if (notification.sId != null) {
                          viewModel.markAsRead(notification.sId!);
                        }

                        // Handle routing based on notification type
                        if (notification.type != null) {
                          String type = notification.type!.toLowerCase();
                          if (type == 'appointment') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BottomNavController(initialIndex: 1),
                              ),
                            );
                          } else if (type == 'wallet' || type == 'payment') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const WalletScreen(isToday: false),
                              ),
                            );
                          }
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              (notification.isRead ?? false)
                                  ? Colors.white
                                  : const Color(0xFFE8F1F6),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: ColorResource.primaryColor.withOpacity(
                                  0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_active,
                                color: ColorResource.primaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.title ?? 'Notification',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          (notification.isRead ?? false)
                                              ? FontWeight.w500
                                              : FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notification.message ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    DateTimeHelper.formatIndianDateTime(
                                      notification.createdAt,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!(notification.isRead ?? false))
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: ColorResource.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
