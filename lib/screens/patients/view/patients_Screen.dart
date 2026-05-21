// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../core/utils/custom_widgets/custom_appBar.dart';
// import '../../../core/utils/custom_widgets/custom_refresh.dart';
// import '../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
// import '../../../core/utils/theams/color_resource.dart';
// import '../model/patients_model.dart';
// import '../viewModel/appointments_viewModel.dart';
// import '../widgets/completed_appointments_card.dart';
// import '../widgets/upcoming_Appointments_Card.dart';
//
// class PatientsScreen extends StatefulWidget {
//   final bool? isBack;
//
//   const PatientsScreen({super.key, this.isBack});
//
//   @override
//   State<PatientsScreen> createState() => _PatientsScreenState();
// }
//
// class _PatientsScreenState extends State<PatientsScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final viewModel = Provider.of<PatientsViewModel>(context, listen: false);
//       viewModel.fetchUpcomingAppointments();
//       viewModel.fetchCompletedAppointments();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorResource.white,
//       appBar: CustomAppBar(title: 'Patient', isBack: widget.isBack ?? true),
//       body: Consumer<PatientsViewModel>(
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
//                     labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//                     unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
//                     tabs: const [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 50),
//                         child: Tab(text: 'New'),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 50),
//                         child: Tab(text: 'Regular'),
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
//
//                 /// --- TAB VIEWS ---
//                 Expanded(
//                   child: TabBarView(
//                     controller: _tabController,
//                     children: [
//                       /// New TAB
//                       _buildAppointmentList(
//                         isLoading: viewModel.isLoadingUpcoming,
//                         appointments: viewModel.upcomingAppointments,
//                         emptyText: "No New appointments found.",
//                         builder: (appointment) => NewAppointmentsCard(model: appointment),
//                         onRefresh: viewModel.fetchUpcomingAppointments,
//                       ),
//
//                       /// COMPLETED TAB
//                       _buildAppointmentList(
//                         isLoading: viewModel.isLoadingCompleted,
//                         appointments: viewModel.completedAppointments,
//                         emptyText: "No completed appointments found.",
//                         builder: (appointment) => CompletedAppointmentCard(model: appointment),
//                         onRefresh: viewModel.fetchCompletedAppointments,
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
//
//   /// Reusable builder for all 2 appointment tabs
//   Widget _buildAppointmentList({
//     required bool isLoading,
//     required List appointments,
//     required String emptyText,
//     required Widget Function(AppointmentsList) builder,
//     required Future<void> Function() onRefresh,
//   }) {
//     if (isLoading) {
//       return const Center(child: ThreeDotsLoader());
//     }
//
//     if (appointments.isEmpty) {
//       return Center(
//         child: Text(
//           emptyText,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//       );
//     }
//
//     return CustomRefreshIndicator(
//       onRefresh: onRefresh,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: appointments.length,
//         itemBuilder: (context, index) {
//           final appointment = appointments[index];
//           return builder(appointment);
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // Add shimmer to pubspec.yaml
import '../../../core/utils/custom_widgets/custom_appBar.dart';
import '../../../core/utils/custom_widgets/custom_refresh.dart';
import '../../../core/utils/theams/color_resource.dart';
import '../model/patients_model.dart';
import '../viewModel/appointments_viewModel.dart';
import '../widgets/completed_appointments_card.dart';
import '../widgets/upcoming_Appointments_Card.dart';

class PatientsScreen extends StatefulWidget {
  final bool? isBack;
  const PatientsScreen({super.key, this.isBack});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<PatientsViewModel>(context, listen: false);
      viewModel.fetchUpcomingAppointments();
      viewModel.fetchCompletedAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Modern Medical Palette
    const primaryBlue =  Color(0xFF419CAB); // Soft Medical Green/Teal
    const bgColor = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar(
        title: 'My Patients',
        isBack: widget.isBack ?? true,
      ),
      body: Consumer<PatientsViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            children: [
              const SizedBox(height: 16),
              // --- MODERN PILL TAB BAR ---
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(6),
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.circular(16),
                //   boxShadow: [
                //     BoxShadow(
                //       color: Colors.black.withOpacity(0.04),
                //       blurRadius: 12,
                //       offset: Offset(0, 6),
                //     ),
                //     BoxShadow(
                //       color: Colors.black.withOpacity(0.02),
                //       blurRadius: 4,
                //       offset: Offset(0, 2),
                //     ),
                //   ],
                // ),
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
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Completed'),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAppointmentList(
                      isLoading: viewModel.isLoadingUpcoming,
                      appointments: viewModel.upcomingAppointments,
                      emptyText: "No upcoming appointments",
                      builder: (appointment) => NewAppointmentsCard(model: appointment),
                      onRefresh: viewModel.fetchUpcomingAppointments,
                    ),
                    _buildAppointmentList(
                      isLoading: viewModel.isLoadingCompleted,
                      appointments: viewModel.completedAppointments,
                      emptyText: "No history found",
                      builder: (appointment) => CompletedAppointmentCard(model: appointment),
                      onRefresh: viewModel.fetchCompletedAppointments,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppointmentList({
    required bool isLoading,
    required List appointments,
    required String emptyText,
    required Widget Function(AppointmentsList) builder,
    required Future<void> Function() onRefresh,
  }) {
    if (isLoading) return _buildSkeletonLoader();

    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              emptyText,
              style: TextStyle(fontSize: 16, color: Colors.grey[500], fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return CustomRefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        itemCount: appointments.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => builder(appointments[index]),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 5,
        itemBuilder: (_, __) => Container(
          height: 120,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
