// import 'package:animated_digit/animated_digit.dart';
// import 'package:doctors/core/utils/custom_widgets/custom_image_view.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../core/utils/custom_widgets/CustomHomeAppBar.dart';
// import '../../../core/utils/custom_widgets/custom_refresh.dart';
// import '../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
// import '../../../core/utils/theams/color_resource.dart';
// import '../../Profile/view_model/profile_view_model.dart';
// import '../view_model/home_viewModel.dart';
//
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final pro = Provider.of<HomeViewModel>(context, listen: false);
//       pro.fetchHomeData();
//       Provider.of<ProfileViewModel>(context, listen: false).fetchProfile();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return CustomRefreshIndicator(
//       onRefresh: () =>
//           Provider.of<HomeViewModel>(context, listen: false).fetchHomeData(),
//       child: Scaffold(
//         backgroundColor: ColorResource.white,
//         appBar: CustomHomeAppBar(height: screenHeight),
//         body: Consumer<HomeViewModel>(builder: (context, viewModel, child) {
//           if (viewModel.isLoading) {
//             return const Center(child: ThreeDotsLoader());
//           }
//
//           if (viewModel.errorMessage != null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(viewModel.errorMessage!),
//                 ],
//               ),
//             );
//           }
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
//             child: ListView(
//               shrinkWrap: true,
//               physics: const BouncingScrollPhysics(),
//               children: [
//                 DashboardCard(
//                   bgImagePath: 'assets/images/hbgImage1.png',
//                   title: 'Total Appointment',
//                   value: viewModel.totalAppointments.toString(),
//                 ),
//                 DashboardCard(
//                   bgImagePath: 'assets/images/hbgImage2.png',
//                   title: 'This Month Appointments',
//                   value: viewModel.monthlyAppointments.toString(),
//                 ),
//                 DashboardCard(
//                   bgImagePath: 'assets/images/hbgImage3.png',
//                   title: 'Today’s Appointment',
//                   value: viewModel.todayAppointments.toString(),
//                 ),
//                 DashboardCard(
//                   bgImagePath: 'assets/images/hbgImage4.png',
//                   title: 'Profile Completion',
//                   value:
//                   '${(viewModel.profileCompletion * 100).toInt()}%',
//                 ),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
//
// class DashboardCard extends StatelessWidget {
//   final String bgImagePath;
//   final String title;
//   final String value;
//
//   const DashboardCard({
//     super.key,
//     required this.bgImagePath,
//     required this.title,
//     required this.value,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 180,
//       decoration: BoxDecoration(
//        // color: ColorResource.primaryColor,
//         image: DecorationImage(
//           image: AssetImage(bgImagePath),
//           fit: BoxFit.fill,
//         ),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//         child: Row(
//           children: [
//             const SizedBox(width: 8),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   AnimatedDigitWidget(
//                     value: double.tryParse(value) ?? 0,
//                     enableSeparator: false, // set to true if you want 1,000+ separator
//                     textStyle: const TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                     duration: const Duration(milliseconds: 800),
//                     curve: Curves.easeOut,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// // }
// import 'package:animated_digit/animated_digit.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../core/utils/custom_widgets/CustomHomeAppBar.dart';
// import '../../../core/utils/custom_widgets/custom_refresh.dart';
// import '../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
// import '../../Profile/view_model/profile_view_model.dart';
// import '../view_model/home_viewModel.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final pro = Provider.of<HomeViewModel>(context, listen: false);
//       pro.fetchHomeData();
//       Provider.of<ProfileViewModel>(context, listen: false).fetchProfile();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomRefreshIndicator(
//       onRefresh: () =>
//           Provider.of<HomeViewModel>(context, listen: false).fetchHomeData(),
//       child: Scaffold(
//         backgroundColor: const Color(0xffF5F7FB),
//         appBar: const CustomHomeAppBar(height: 100),
//         body: Consumer<HomeViewModel>(
//           builder: (context, viewModel, child) {
//             if (viewModel.isLoading) {
//               return const Center(child: ThreeDotsLoader());
//             }
//
//             if (viewModel.errorMessage != null) {
//               return Center(child: Text(viewModel.errorMessage!));
//             }
//
//             return Padding(
//               padding: const EdgeInsets.all(16),
//               child: GridView.count(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 16,
//                 crossAxisSpacing: 16,
//                 childAspectRatio: 1.1,
//                 children: [
//                   DashboardCard(
//                     title: "Total Appointments",
//                     value: viewModel.totalAppointments.toString(),
//                     color: const Color(0xff4CAF50),
//                     icon: Icons.calendar_month,
//                   ),
//                   DashboardCard(
//                     title: "Monthly",
//                     value: viewModel.monthlyAppointments.toString(),
//                     color: const Color(0xff2196F3),
//                     icon: Icons.bar_chart,
//                   ),
//                   DashboardCard(
//                     title: "Today",
//                     value: viewModel.todayAppointments.toString(),
//                     color: const Color(0xffFF9800),
//                     icon: Icons.today,
//                   ),
//                   DashboardCard(
//                     title: "Profile",
//                     value:
//                     "${(viewModel.profileCompletion * 100).toInt()}%",
//                     color: const Color(0xff9C27B0),
//                     icon: Icons.person,
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class DashboardCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final Color color;
//   final IconData icon;
//
//   const DashboardCard({
//     super.key,
//     required this.title,
//     required this.value,
//     required this.color,
//     required this.icon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(22),
//         gradient: LinearGradient(
//           colors: [
//             color.withOpacity(0.9),
//             color.withOpacity(0.6),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.3),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Icon Circle
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.2),
//               ),
//               child: Icon(icon, color: Colors.white, size: 22),
//             ),
//
//             const Spacer(),
//
//             // Value
//             AnimatedDigitWidget(
//               value: double.tryParse(value.replaceAll('%', '')) ?? 0,
//               suffix: value.contains('%') ? "%" : "",
//               textStyle: const TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//               duration: const Duration(milliseconds: 800),
//             ),
//
//             const SizedBox(height: 6),
//
//             // Title
//             Text(
//               title,
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.9),
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';

import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/api_service/app_url.dart';
import '../../../core/coreServices/socket_service/join_call_provider.dart';
import '../../../core/utils/custom_widgets/CustomHomeAppBar.dart';
import '../../../core/utils/custom_widgets/custom_refresh.dart';
import '../../../core/utils/custom_widgets/custom_threeDots_indecator.dart';
// import '../../../core/utils/custom_widgets/custom_three_dots_indicator.dart';
import '../../../core/utils/helper_functions/helpers_methods.dart';
import '../../../core/utils/navigation_helper.dart';
import '../../Profile/view_model/profile_view_model.dart';
import '../../VideoCall/agoraVideoCall.dart';
import '../../appointments/model/appointments_model.dart';
import '../../appointments/view/appointments_Screen.dart';
import '../../appointments/viewModel/appointments_viewModel.dart';
import '../../wallet/ui/walletScreen.dart';
import '../view_model/home_viewModel.dart';
import 'package:http/http.dart' as http;
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  bool _hasShownReminder = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final pro = Provider.of<HomeViewModel>(context, listen: false);
      pro.fetchHomeData();
      Provider.of<ProfileViewModel>(context, listen: false).fetchProfile();
      final viewModel = Provider.of<AppointmentViewModel>(context, listen: false);
      await viewModel.fetchUpcomingAppointments();
      _checkReminder(viewModel);
    });
  }

  void _checkReminder(AppointmentViewModel viewModel) {
    if (_hasShownReminder || viewModel.upcomingAppointments.isEmpty) return;
    
    final nextAppointment = viewModel.upcomingAppointments.first;
    final dateString = nextAppointment.appointmentDate ?? '';
    final timeString = nextAppointment.timeSlot ?? '';
    if (dateString.isEmpty || timeString.isEmpty) return;

    try {
      final apptDate = DateTime.parse(dateString);
      final timePart = timeString.split(' - ').first.trim();
      int hour = 0;
      int min = 0;
      if (timePart.contains(RegExp(r'[aA][mM]|[pP][mM]'))) {
        final isPm = timePart.toLowerCase().contains('pm');
        final cleanTime = timePart.replaceAll(RegExp(r'[a-zA-Z\s]'), '');
        final parts = cleanTime.split(':');
        if (parts.length == 2) {
          hour = int.tryParse(parts[0]) ?? 0;
          min = int.tryParse(parts[1]) ?? 0;
          if (isPm && hour < 12) hour += 12;
          if (!isPm && hour == 12) hour = 0;
        }
      } else {
        final parts = timePart.split(':');
        if (parts.length == 2) {
          hour = int.tryParse(parts[0]) ?? 0;
          min = int.tryParse(parts[1]) ?? 0;
        }
      }
      final now = DateTime.now();
      final apptTime = DateTime(apptDate.year, apptDate.month, apptDate.day, hour, min);
      
      final diff = apptTime.difference(now);
      
      // If appointment is within the next 15 minutes or just started (up to 30 mins ago)
      if (diff.inMinutes > -30 && diff.inMinutes <= 15) {
        _hasShownReminder = true;
        
        // Enable Join automatically
        Provider.of<JoinCallNotifier>(context, listen: false).enableJoin(nextAppointment.appointmentId ?? '');
        
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Appointment Reminder"),
              content: Text("Your appointment with ${nextAppointment.patientName ?? 'Patient'} is starting soon!"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Dismiss"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // The JoinCallNotifier already enabled it, they can click "Start Consultation" on the card
                  },
                  child: const Text("Okay"),
                ),
              ],
            );
          },
        );
      }
    } catch (_) {
       // Ignore parsing errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Using a modern minimal AppBar setup
      appBar: const CustomHomeAppBar(height: 80),
      body: CustomRefreshIndicator(
        onRefresh: () => Provider.of<HomeViewModel>(context, listen: false).fetchHomeData(),
        child: Consumer2<HomeViewModel,AppointmentViewModel>(
          builder: (context, viewModel,appointmentVM, child) {
            // if (viewModel.isLoading) {
            //   return  Center(child: ThreeDotsLoader());
            // }
            //
            // if (viewModel.errorMessage != null) {
            //   return Center(child: Text(viewModel.errorMessage!));
            // }
            if (viewModel.isLoading || appointmentVM.isLoadingUpcoming) {
              return const Center(child: ThreeDotsLoader());
            }

            final upcomingList = appointmentVM.upcomingAppointments;
            final hasUpcoming = upcomingList.isNotEmpty;
            final nextAppointment = hasUpcoming ? upcomingList.first : null;
            final otherUpcoming = upcomingList.length > 1 ? upcomingList.sublist(1) : [];

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              children: [
                // Welcome Header Card
                if (hasUpcoming)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          'Next Appointment',
                          style: TextStyle(
                            color: Color(0xFF171C20),
                            fontSize: 16,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w700,
                            height: 1.56,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      _buildNextAppointmentCard(context:context,model: nextAppointment! ),
                    ],
                  )
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text("No upcoming appointments")),
                  ),



                if (hasUpcoming && otherUpcoming.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Upcoming Patients',
                        style: TextStyle(
                          color: const Color(0xFF171C20),
                          fontSize: 16,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          navPush(context: context, page: AppointmentScreen());
                        },
                        child: Text(
                          'View All',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF006492),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 1.33,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 90,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: otherUpcoming.length,
                      itemBuilder: (context, index) {
                        final appointment = otherUpcoming[index];
                         return _buildUpcomingPatientCard(model: appointment,context: context);
                      },),
                  ),
                ],

                const SizedBox(height: 10),

                // Grid of Stats
                GridView.count(  padding: EdgeInsets.zero,

                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,

                  children: [
                    _StatCard(
                      title: "Today's Appts",
                      value: viewModel.dashboardModel?.data?.todayAppointmentsCount ?? 0,
                      icon: Icons.calendar_today_rounded,
                      accentColor:  Color(0xFF419CAB),
                      g1: Color(0xffF3E8FF),
                      g2: Color(0xffFAF5FF),
                      iconBgColor: Color(0xffe9e1f5),
                      onTap: (){},

                    ),
                    _StatCard(
                      title: "Pending Requests",
                      value: viewModel.dashboardModel?.data?.pendingRequests ?? 0,
                      icon: Icons.analytics_rounded,
                      accentColor: const Color(0xFF2E83F8),
                      g1: Color(0xffFFF1E6),
                      g2: Color(0xffFFF7F0),
                      iconBgColor: Color(0xffede6df),
                      onTap: (){},
                    ),
                    _StatCard(
                      title: "Total Earning Today",
                      value: viewModel.dashboardModel?.data?.totalEarningsToday ?? 0,
                      icon: Icons.earbuds,
                      accentColor: const Color(0xFFFF9800),
                      g1: Color(0xffE8F5E9),
                      g2: Color(0xffF1FBF3),
                      iconBgColor: Color(0xffe4ede4),
                      onTap: (){
                        navPush(context: context, page: WalletScreen(isToday: true,));
                      },
                    ),
                    _StatCard(
                      title: "Growth",
                      value: viewModel.dashboardModel?.data?.growth ?? 0,
                      icon: Icons.trending_up_rounded,
                      accentColor: const Color(0xFF9C27B0),
                      // accentColor: const Color(0xFF9C27B0),
                      isPercentage: true,
                      g1: Color(0xffEAF2FF),
                      g2: Color(0xffF5F9FF),
                      iconBgColor: Color(0xffe4e9f2),
                      onTap: (){
                        navPush(context: context, page: WalletScreen(isToday: false,));
                      },
                      // iconBgColor: Color(0xffF3E8FF),
                    ),
                  ],
                ),SizedBox(height: 10,),

                // const SizedBox(height: 24),

                // Profile Completion Card
                _ProfileStatusCard(completion: viewModel.profileCompletion),

                const SizedBox(height: 150), // Space for BottomNav
              ],
            );
          },
        ),
      ),
    );
  }
  // ===================== NEXT APPOINTMENT CARD (Dynamic + Video Call) =====================
  Widget _buildNextAppointmentCard(
      {required BuildContext context,required AppointmentsList model}) {
    final canJoin = context.watch<JoinCallNotifier>().canJoin(model.appointmentId ?? '');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.48, -0.48),
          end: Alignment(0.52, 1.48),
          colors: [Color(0xFF006492), Color(0xFF2D9CDB)],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: model.patientImage != null && model.patientImage!.isNotEmpty
                      ? Image.network(
                          model.patientImage!.startsWith('http') 
                                ? model.patientImage! 
                                : '${AppUrl.baseUrl}/${model.patientImage!}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                              Image.asset("assets/icons/balawant.jpg", fit: BoxFit.cover),
                        )
                      : Image.asset("assets/icons/balawant.jpg", fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        canJoin ? 'PATIENT WAITING' : 'STARTING SOON',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      model.patientName ?? 'Patient',
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      model.categoryName ?? 'Follow-up Session',
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time_outlined, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      "${HelperMethods.formatAppointmentDate(model.appointmentDate ?? '')}\n${model.timeSlot ?? '09:00 AM'}",
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700, height: 1.5),
                    ),
                  ],
                ),
              ),

              // Start Consultation Button with Video Call
              GestureDetector(
                onTap: () {
                  if (canJoin) {
                    _handleJoinCall(context, model);
                  } else {
                    HelperMethods.showFloatingToast(context, message: "Patient has not joined or appointment hasn't started yet.");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: canJoin ? Colors.white : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.video_camera_back, color: const Color(0xFF006492)),
                      const SizedBox(width: 8),
                      const Text(
                        'Start\nConsultation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF006492),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===================== UPCOMING PATIENT CARD =====================
  Widget _buildUpcomingPatientCard({required AppointmentsList model ,required BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0x26BEC7D1)),
        boxShadow: const [
          BoxShadow(color: Color(0x0A171C20), blurRadius: 24),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Container(
              width: 48,
              height: 48,
              color: const Color(0xFFE4E8EE),
              child: model.patientImage != null && model.patientImage!.isNotEmpty
                  ? Image.network(
                      model.patientImage!.startsWith('http') ? model.patientImage! : '${AppUrl.baseUrl}/${model.patientImage!}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                          Image.network("https://t4.ftcdn.net/jpg/06/10/87/07/360_F_610870738_xBnYHvfBrRFVpVkUUT3PkVc7TZdukIlx.jpg", fit: BoxFit.cover),
                    )
                  : Image.network("https://t4.ftcdn.net/jpg/06/10/87/07/360_F_610870738_xBnYHvfBrRFVpVkUUT3PkVc7TZdukIlx.jpg", fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.patientName ?? 'Patient',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  model.timeSlot ?? '10:30 AM',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF3F4850)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0x337BF8A1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'In-Clinic',
              style: TextStyle(color: Color(0xFF006D37), fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== VIDEO CALL FUNCTION =====================
  Future<void> _handleJoinCall(BuildContext context, AppointmentsList model) async {
    final appointmentId = model.appointmentId ?? '';
    const uid = 12345; // Replace with actual user ID if needed

    try {
      final response = await http.get(Uri.parse('${AppUrl.videoCall}/$appointmentId/$uid'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final token = json['data']['token'] ?? '';
        final channel = json['data']['channelName'] ?? appointmentId;

        if (token.isEmpty) {
          HelperMethods.showFloatingToast(context, message: "Unable to join. Token not generated.");
          return;
        }

        navSlideFromRight(
          context,
          AgoraVideoCallScreen(
            channelName: channel,
            token: token,
            uid: uid,
            appointmentId: appointmentId, isDoctor: true,
          ),
        );
      } else if (response.statusCode == 400) {
        HelperMethods.showFloatingToast(context, message: "Call has already ended.");
      } else {
        HelperMethods.showFloatingToast(context, message: 'Failed to join call');
      }
    } catch (e) {
      HelperMethods.showFloatingToast(context, message: 'Connection Error');
    }
  }
}

/// Redesigned Stat Card with Modern Glass/White aesthetic
class _StatCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color g1;
  final Color g2;
  final num value;
  final Color iconBgColor;
  final IconData icon;
  final Color accentColor;
  final bool isPercentage;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.g1,
    required this.iconBgColor,
    required this.g2,
    required this.accentColor,
    required this.onTap,

    this.isPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [g1, g2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Color(0xffE2EDEE).withOpacity(0.5),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: accentColor, size: 20),
                ),
                Text(
                  '+4%',
                  style: TextStyle(
                    color: const Color(0xFF006D37),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            AnimatedDigitWidget(
              value: value,
              suffix: isPercentage ? "%" : "",
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222B45),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

/// New Component: Profile Completion with Progress Bar
class _ProfileStatusCard extends StatelessWidget {
  final double completion;

  const _ProfileStatusCard({required this.completion});

  @override
  Widget build(BuildContext context) {
    double normalizedCompletion = completion;
    if (completion > 1.0) {
      normalizedCompletion = completion / 100.0;
    }
    
    // Fallback to local calculation if it is 0
    if (normalizedCompletion == 0.0) {
      try {
        final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
        final data = profileVM.profileData?.data;
        if (data != null) {
          int filled = 0;
          int total = 14;
          if (data.name != null && data.name!.isNotEmpty) filled++;
          if (data.mobile != null && data.mobile!.isNotEmpty) filled++;
          if (data.dob != null && data.dob!.isNotEmpty) filled++;
          if (data.gender != null && data.gender!.isNotEmpty) filled++;
          if (data.email != null && data.email!.isNotEmpty) filled++;
          if (data.specialization != null && data.specialization!.isNotEmpty) filled++;
          if (data.qualification != null && data.qualification!.isNotEmpty) filled++;
          if (data.yearOfExp != null && data.yearOfExp!.isNotEmpty) filled++;
          if (data.licOrRegNumber != null && data.licOrRegNumber!.isNotEmpty) filled++;
          if (data.address != null && data.address!.isNotEmpty) filled++;
          if (data.profileImage != null && data.profileImage!.isNotEmpty) filled++;
          if (data.inClinicFee != null || data.videoConsultFee != null) filled++;
          if (data.openingTime != null && data.openingTime!.isNotEmpty) filled++;
          if (data.closingTime != null && data.closingTime!.isNotEmpty) filled++;
          normalizedCompletion = filled / total;
        }
      } catch (_) {}
    }

    final int percent = (normalizedCompletion * 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: const Color(0xFFF0F4FA),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: const Color(0x19BEC7D1),
          ),
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
        Text(
        'Profile Completion',
        style: TextStyle(
          color: const Color(0xFF171C20),
          fontSize: 14,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          height: 1.43,
        ),
      ),
              Text(
                "$percent%",
                style: TextStyle(
                  color: const Color(0xFF006492),
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  height: 1.50,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: normalizedCompletion,
              backgroundColor: Color(0xFFDFE3E9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF006492)),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Finish adding your clinic address to reach 100%',
            style: TextStyle(
              color: const Color(0xFF3F4850),
              fontSize: 11,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }


}