// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../repository/patients_repository.dart';
//
// class RescheduleViewModel extends ChangeNotifier {
//   // final BookingRepository _repository = BookingRepository();
//   final AppointmentsRepository _appointmentsRepository = AppointmentsRepository();
//
//   bool isLoading = false;
//   bool isSubmitting = false;
//
//   List<String> availableDates = []; // Format: yyyy-MM-dd
//   // List<AvailableSlotsData> timeSlots = [];
//
//   int selectedDayIndex = 0;
//   int selectedTimeIndex = -1;
//
//   /// Initialize available dates (Today + next 3 days) and fetch today's slots
//   Future<void> initDates(String vendorId) async {
//     availableDates = List.generate(3, (i) {
//       final date = DateTime.now().add(Duration(days: i));
//       return DateFormat('yyyy-MM-dd').format(date);
//     });
//
//     selectedDayIndex = 0;
//     selectedTimeIndex = -1;
//
//     await fetchAvailableSlots(vendorId, availableDates[0]);
//   }
//
//   /// Fetch slots for a specific date
//   Future<void> fetchAvailableSlots(String vendorId, String date) async {
//     isLoading = true;
//     // timeSlots = [];
//     notifyListeners();
//
//     try {
//       // final response = await _repository.getAvailableSlots(
//       //   vendorId: vendorId,
//       //   date: date,
//       // );
//       // timeSlots = response.data ?? [];
//     } catch (e) {
//       debugPrint("❌ Error fetching slots: $e");
//       // timeSlots = [];
//     }
//
//     isLoading = false;
//     notifyListeners();
//   }
//
//   /// Called when user selects a day
//   Future<void> selectDay(int index, String vendorId) async {
//     if (index == selectedDayIndex) return;
//
//     selectedDayIndex = index;
//     selectedTimeIndex = -1;
//     notifyListeners();
//
//     final selectedDate = availableDates[index];
//     await fetchAvailableSlots(vendorId, selectedDate);
//   }
//
//   void selectTime(int index) {
//     // if (timeSlots[index].status?.toLowerCase() == "booked") return;
//     selectedTimeIndex = index;
//     notifyListeners();
//   }
//
//   /// Submit rescheduling request
//   Future<bool> rescheduleAppointment({
//     required String newDate,
//     required String newTime,
//     required String appointmentId,
//   }) async {
//     print("🔁 ViewModel: rescheduleAppointment called");
//     return await _appointmentsRepository.rescheduleAppointment(
//       id: appointmentId,
//       newDate: newDate,
//       newTime: newTime,
//       rescheduleReason: '',
//     );
//   }
//
//   Future<bool> cancelAppointment({
//     required String cancelReason,
//     required String appointmentId,
//   }) async {
//     print("🔁 ViewModel: cancelAppointment called");
//     return await _appointmentsRepository.cancelAppointment(
//       id: appointmentId,
//       cancelReason: cancelReason,
//     );
//   }
//
//
//   void reset() {
//     selectedDayIndex = 0;
//     selectedTimeIndex = -1;
//     // timeSlots = [];
//     availableDates = [];
//     isSubmitting = false;
//     notifyListeners();
//   }
// }
