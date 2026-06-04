import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/custom_widgets/custom_appBar.dart';
import '../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
import '../../../core/utils/theams/color_resource.dart';
import '../view_model/ticket_view_model.dart';
import 'create_ticket_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TicketViewModel>(context, listen: false).fetchTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: CustomAppBar(
        title: 'support_tickets'.tr(),
        isBack: true,
      ),
      body: Consumer<TicketViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: ThreeDotsLoader());
          }

          if (viewModel.tickets.isEmpty) {
            return Center(
              child: Text(
                "No support tickets found.",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.tickets.length,
            itemBuilder: (context, index) {
              final ticket = viewModel.tickets[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            ticket.subject ?? 'No Subject',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(ticket.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            (ticket.status ?? 'OPEN').toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getStatusColor(ticket.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ticket.description ?? '',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          ticket.createdAt != null ? ticket.createdAt!.substring(0, 10) : '',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    if (ticket.adminReply != null && ticket.adminReply!.isNotEmpty) ...[
                      const Divider(height: 20),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Admin Reply:",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ticket.adminReply!,
                              style: const TextStyle(fontSize: 13, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ]
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ColorResource.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateTicketScreen()),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Create Ticket", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.blue;
      case 'in-progress':
        return Colors.orange;
      case 'resolved':
      case 'closed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
