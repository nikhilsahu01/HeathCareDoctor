import 'package:flutter/material.dart';
import '../../wallet/ui/walletScreen.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/custom_widgets/custom_appBar.dart';
import '../../../core/utils/custom_widgets/custom_refresh.dart';
import '../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
import '../../../core/utils/theams/color_resource.dart';
import '../model/appointments_model.dart';
import '../viewModel/appointments_viewModel.dart';
import '../widgets/cancelled_appointments_card.dart';
import '../widgets/completed_appointments_card.dart';
import '../widgets/upcoming_Appointments_Card.dart';

// class AppointmentScreen extends StatefulWidget {
//   final bool? isBack;
//
//   const AppointmentScreen({super.key, this.isBack});
//
//   @override
//   State<AppointmentScreen> createState() =>
//       _AppointmentScreenState();
// }
//
// class _AppointmentScreenState extends State<AppointmentScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//
//     // Delay execution until after build completes
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final viewModel = Provider.of<AppointmentViewModel>(context, listen: false);
//       viewModel.fetchUpcomingAppointments();   // For Upcoming Tab
//       viewModel.fetchCompletedAppointments();  // For Completed Tab
//       viewModel.fetchCancelledAppointments();  // For Cancelled Tab
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorResource.white,
//       appBar: CustomAppBar(title: 'Appointments', isBack: widget.isBack ?? true),
//       body: Consumer<AppointmentViewModel>(
//         builder: (context, viewModel, _) {
//           return SafeArea(
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade100,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.1),
//                         spreadRadius: 1,
//                         blurRadius: 3,
//                         offset: const Offset(0, 1),
//                       ),
//                     ],
//                   ),
//                   child: TabBar(
//                     controller: _tabController,
//                     indicator: BoxDecoration(
//                       color: ColorResource.primaryColor,
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: [
//                         BoxShadow(
//                           color: ColorResource.primaryColor.withOpacity(0.2),
//                           spreadRadius: 1,
//                           blurRadius: 4,
//                           offset: const Offset(0, 1),
//                         ),
//                       ],
//                     ),
//                     labelColor: Colors.white,
//                     indicatorColor: Colors.transparent,
//                     dividerColor: Colors.transparent,
//                     unselectedLabelColor: Colors.grey.shade600,
//                     labelStyle: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                     ),
//                     unselectedLabelStyle: const TextStyle(
//                       fontWeight: FontWeight.w500,
//                     ),
//                     tabs: const [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 8),
//                         child: Tab(text: 'Upcoming'),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 8),
//                         child: Tab(text: 'Completed'),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 8),
//                         child: Tab(text: 'Cancelled'),
//                       ),
//                     ],
//                     splashBorderRadius: BorderRadius.circular(8),
//                     overlayColor: MaterialStateProperty.resolveWith<Color?>(
//                           (states) => states.contains(MaterialState.pressed)
//                           ? ColorResource.primaryColor.withOpacity(0.1)
//                           : null,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: TabBarView(
//                     controller: _tabController,
//                     children: [
//                       /// --- UPCOMING TAB ---
//                       viewModel.isLoadingUpcoming
//                           ? const Center(child: ThreeDotsLoader())
//                           : viewModel.upcomingAppointments.isEmpty
//                           ? const Center(
//                         child: Text(
//                           "No upcoming appointments found.",
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                         ),
//                       )
//                           : NotificationListener<ScrollNotification>(
//                         onNotification: (notification) {
//                           if (notification is ScrollEndNotification &&
//                               notification.metrics.pixels == notification.metrics.maxScrollExtent) {
//                             viewModel.loadMoreUpcomingAppointments();
//                           }
//                           return false;
//                         },
//                         child: CustomRefreshIndicator(
//                           onRefresh: ()async{
//                                 await viewModel.fetchUpcomingAppointments();
//                           },
//                           child: ListView.builder(
//                             padding: const EdgeInsets.all(16),
//                             itemCount: viewModel.upcomingAppointments.length +
//                                 (viewModel.isLoadingMoreUpcoming ? 1 : 0),
//                             itemBuilder: (context, index) {
//                               if (index == viewModel.upcomingAppointments.length) {
//                                 return const Center(child: ThreeDotsLoader());
//                               }
//                               final appointment = viewModel.upcomingAppointments[index];
//                               return UpcomingAppointmentsCard(model: appointment);
//                             },
//                           ),
//                         ),
//                       ),
//
//                       /// --- COMPLETED TAB ---
//                       viewModel.isLoadingCompleted
//                           ? const Center(child: ThreeDotsLoader())
//                           : viewModel.completedAppointments.isEmpty
//                           ? const Center(
//                         child: Text(
//                           "No completed appointments found.",
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                         ),
//                       )
//                           : NotificationListener<ScrollNotification>(
//                         onNotification: (notification) {
//                           if (notification is ScrollEndNotification &&
//                               notification.metrics.pixels == notification.metrics.maxScrollExtent) {
//                             viewModel.loadMoreCompletedAppointments();
//                           }
//                           return false;
//                         },
//                         child: CustomRefreshIndicator(
//                           onRefresh: () async {
//                             await viewModel.fetchCompletedAppointments();
//                           },
//                           child: ListView.builder(
//                             padding: const EdgeInsets.all(16),
//                             itemCount: viewModel.completedAppointments.length +
//                                 (viewModel.isLoadingMoreCompleted ? 1 : 0),
//                             itemBuilder: (context, index) {
//                               if (index == viewModel.completedAppointments.length) {
//                                 return const Center(child: ThreeDotsLoader());
//                               }
//                               final appointment = viewModel.completedAppointments[index];
//                               return CompletedAppointmentCard(model: appointment);
//                             },
//                           ),
//                         ),
//                       ),
//
//                       /// --- CANCELLED TAB ---
//                       viewModel.isLoadingCancelled
//                           ? const Center(child: ThreeDotsLoader())
//                           : viewModel.cancelledAppointments.isEmpty
//                           ? const Center(
//                         child: Text(
//                           "No cancelled appointments found.",
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                         ),
//                       )
//                           : NotificationListener<ScrollNotification>(
//                         onNotification: (notification) {
//                           if (notification is ScrollEndNotification &&
//                               notification.metrics.pixels == notification.metrics.maxScrollExtent) {
//                             viewModel.loadMoreCancelledAppointments();
//                           }
//                           return false;
//                         },
//                         child: CustomRefreshIndicator(
//                           onRefresh: () async {
//                             await viewModel.fetchCancelledAppointments();
//                           },
//                           child: ListView.builder(
//                             padding: const EdgeInsets.all(16),
//                             itemCount: viewModel.cancelledAppointments.length +
//                                 (viewModel.isLoadingMoreCancelled ? 1 : 0),
//                             itemBuilder: (context, index) {
//                               if (index == viewModel.cancelledAppointments.length) {
//                                 return const Center(child: ThreeDotsLoader());
//                               }
//                               final appointment = viewModel.cancelledAppointments[index];
//                               return CancelledAppointmentsCard(model: appointment);
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


class AppointmentScreen extends StatefulWidget {
  final bool? isBack;

  const AppointmentScreen({super.key, this.isBack});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<AppointmentViewModel>(context, listen: false);
      viewModel.fetchUpcomingAppointments();
      viewModel.fetchCompletedAppointments();
      viewModel.fetchCancelledAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Appointments', 
        isBack: widget.isBack ?? true,
        action: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen(isToday: false)));
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: ShapeDecoration(
              color: const Color(0xFFF0F4FA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(48),
              ),
            ),
            child: const Icon(Icons.account_balance_wallet, size: 20, color: Color(0xFF006492)),
          ),
        ),
      ),
      body: Consumer<AppointmentViewModel>(
        builder: (context, viewModel, _) {
          return SafeArea(
            child: Column(
              children: [
                Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),

                  decoration: ShapeDecoration(
                    color: const Color(0xFFDFE3E9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),


                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: ShapeDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment(0.48, -0.48),
                        end: Alignment(0.52, 1.48),
                        colors: [
                          Color(0xFF006492), // Dark blue
                          Color(0xFF2D9CDB), // Light blue
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48),
                      ),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),

                    tabs: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Tab(text: 'Upcoming'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Tab(text: 'Completed'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Tab(text: 'Cancelled'),
                      ),
                    ],
                    splashBorderRadius: BorderRadius.circular(8),
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (states) => states.contains(MaterialState.pressed)
                          ? ColorResource.primaryColor.withOpacity(0.1)
                          : null,
                    ),
                  ),
                ),

                /// --- TAB VIEWS ---
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      /// UPCOMING TAB
                      _buildAppointmentList(
                        isLoading: viewModel.isLoadingUpcoming,
                        appointments: viewModel.upcomingAppointments,
                        emptyText: "No upcoming appointments found.",
                        builder: (appointment) => UpcomingAppointmentsCard(model: appointment,provider: viewModel,),
                        onRefresh: viewModel.fetchUpcomingAppointments,
                      ),

                      /// COMPLETED TAB
                      _buildAppointmentList(
                        isLoading: viewModel.isLoadingCompleted,
                        appointments: viewModel.completedAppointments,
                        emptyText: "No completed appointments found.",
                        builder: (appointment) => CompletedAppointmentCard(model: appointment),
                        onRefresh: viewModel.fetchCompletedAppointments,
                      ),

                      /// CANCELLED TAB
                      _buildAppointmentList(
                        isLoading: viewModel.isLoadingCancelled,
                        appointments: viewModel.cancelledAppointments,
                        emptyText: "No cancelled appointments found.",
                        builder: (appointment) => CancelledAppointmentsCard(model: appointment),
                        onRefresh: viewModel.fetchCancelledAppointments,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Reusable builder for all 3 appointment tabs
  Widget _buildAppointmentList({
    required bool isLoading,
    required List appointments,
    required String emptyText,
    required Widget Function(AppointmentsList) builder,
    required Future<void> Function() onRefresh,
  }) {
    if (isLoading) {
      return const Center(child: ThreeDotsLoader());
    }

    if (appointments.isEmpty) {
      return Center(
        child: Text(
          emptyText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    return CustomRefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return builder(appointment);
        },
      ),
    );
  }
}
