import 'package:flutter/material.dart';

import '../model/patients_model.dart';
import '../repository/patients_repository.dart';

// class PatientsViewModel extends ChangeNotifier {
//   final AppointmentsRepository _repository = AppointmentsRepository();
//
//   // Upcoming
//   List<AppointmentsList> _upcomingAppointments = [];
//   Pagination? _upcomingPagination;
//   int _upcomingPage = 1;
//   bool _isLoadingUpcoming = false;
//   bool _isLoadingMoreUpcoming = false;
//
//   // Completed
//   List<AppointmentsList> _completedAppointments = [];
//   Pagination? _completedPagination;
//   int _completedPage = 1;
//   bool _isLoadingCompleted = false;
//   bool _isLoadingMoreCompleted = false;
//
//   // Cancelled
//   List<AppointmentsList> _cancelledAppointments = [];
//   Pagination? _cancelledPagination;
//   int _cancelledPage = 1;
//   bool _isLoadingCancelled = false;
//   bool _isLoadingMoreCancelled = false;
//
//   // Getters
//   List<AppointmentsList> get upcomingAppointments => _upcomingAppointments;
//   List<AppointmentsList> get completedAppointments => _completedAppointments;
//   List<AppointmentsList> get cancelledAppointments => _cancelledAppointments;
//
//   bool get isLoadingUpcoming => _isLoadingUpcoming;
//   bool get isLoadingCompleted => _isLoadingCompleted;
//   bool get isLoadingCancelled => _isLoadingCancelled;
//
//   bool get isLoadingMoreUpcoming => _isLoadingMoreUpcoming;
//   bool get isLoadingMoreCompleted => _isLoadingMoreCompleted;
//   bool get isLoadingMoreCancelled => _isLoadingMoreCancelled;
//
//   /// Fetch Upcoming Appointments
//   Future<void> fetchUpcomingAppointments({bool isLoadMore = false}) async {
//     if (isLoadMore) {
//       if (_upcomingPagination != null && _upcomingPage >= _upcomingPagination!.totalPages!) return;
//       _isLoadingMoreUpcoming = true;
//     } else {
//       _upcomingPage = 1;
//       _isLoadingUpcoming = true;
//     }
//     notifyListeners();
//
//     try {
//       final model = await _repository.getUpcomingAppointmentsListApi();
//       final newAppointments = model.data?.appointments ?? [];
//       _upcomingPagination = model.data?.pagination;
//
//       if (isLoadMore) {
//         _upcomingAppointments.addAll(newAppointments);
//       } else {
//         _upcomingAppointments = newAppointments;
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching upcoming appointments: $e");
//     }
//
//     _isLoadingUpcoming = false;
//     _isLoadingMoreUpcoming = false;
//     notifyListeners();
//   }
//
//   void loadMoreUpcomingAppointments() {
//     _upcomingPage++;
//     fetchUpcomingAppointments(isLoadMore: true);
//   }
//
//   /// Fetch Completed Appointments
//   Future<void> fetchCompletedAppointments({bool isLoadMore = false}) async {
//     if (isLoadMore) {
//       if (_completedPagination != null && _completedPage >= _completedPagination!.totalPages!) return;
//       _isLoadingMoreCompleted = true;
//     } else {
//       _completedPage = 1;
//       _isLoadingCompleted = true;
//     }
//     notifyListeners();
//
//     try {
//       final model = await _repository.getCompletedAppointmentsListApi();
//       final newAppointments = model.data?.appointments ?? [];
//       _completedPagination = model.data?.pagination;
//
//       if (isLoadMore) {
//         _completedAppointments.addAll(newAppointments);
//       } else {
//         _completedAppointments = newAppointments;
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching completed appointments: $e");
//     }
//
//     _isLoadingCompleted = false;
//     _isLoadingMoreCompleted = false;
//     notifyListeners();
//   }
//
//   void loadMoreCompletedAppointments() {
//     _completedPage++;
//     fetchCompletedAppointments(isLoadMore: true);
//   }
//
//   /// Fetch Cancelled Appointments
//   Future<void> fetchCancelledAppointments({bool isLoadMore = false}) async {
//     if (isLoadMore) {
//       if (_cancelledPagination != null && _cancelledPage >= _cancelledPagination!.totalPages!) return;
//       _isLoadingMoreCancelled = true;
//     } else {
//       _cancelledPage = 1;
//       _isLoadingCancelled = true;
//     }
//     notifyListeners();
//
//     try {
//       final model = await _repository.getCancelledAppointmentsListApi();
//       final newAppointments = model.data?.appointments ?? [];
//       _cancelledPagination = model.data?.pagination;
//
//       if (isLoadMore) {
//         _cancelledAppointments.addAll(newAppointments);
//       } else {
//         _cancelledAppointments = newAppointments;
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching cancelled appointments: $e");
//     }
//
//     _isLoadingCancelled = false;
//     _isLoadingMoreCancelled = false;
//     notifyListeners();
//   }
//
//   void loadMoreCancelledAppointments() {
//     _cancelledPage++;
//     fetchCancelledAppointments(isLoadMore: true);
//   }
//
//   // Future<bool> updateReminder({
//   //   required String id,
//   // }) async {
//   //   print("🔁 ViewModel: updateReminder called");
//     // final success = await _repository.updateReminder(id: id);
//     // if (success) {
//     //   await fetchUpcomingAppointments();
//     // }
//     // return success; // Return the success status
//   // }
// }
import 'package:flutter/material.dart';
import '../model/patients_model.dart';
import '../repository/patients_repository.dart';

class PatientsViewModel extends ChangeNotifier {
  final AppointmentsRepository _repository = AppointmentsRepository();

  // Upcoming
  List<AppointmentsList> _upcomingAppointments = [];
  bool _isLoadingUpcoming = false;

  // Completed
  List<AppointmentsList> _completedAppointments = [];
  bool _isLoadingCompleted = false;

  // Cancelled
  List<AppointmentsList> _cancelledAppointments = [];
  bool _isLoadingCancelled = false;

  // Getters
  List<AppointmentsList> get upcomingAppointments => _upcomingAppointments;
  List<AppointmentsList> get completedAppointments => _completedAppointments;
  List<AppointmentsList> get cancelledAppointments => _cancelledAppointments;

  bool get isLoadingUpcoming => _isLoadingUpcoming;
  bool get isLoadingCompleted => _isLoadingCompleted;
  bool get isLoadingCancelled => _isLoadingCancelled;

  /// Fetch Upcoming Appointments
  Future<void> fetchUpcomingAppointments() async {
    _isLoadingUpcoming = true;
    notifyListeners();
    try {
      final model = await _repository.getUpcomingAppointmentsListApi();
      _upcomingAppointments = (model.data?.appointments ?? [])
          .where((e) => e.status == 'Pending' || e.status == 'Confirmed')
          .toList();
    } catch (e) {
      debugPrint("❌ Error fetching upcoming appointments: $e");
    } finally {
      _isLoadingUpcoming = false;
      notifyListeners();
    }
  }

  /// Fetch Completed Appointments
  Future<void> fetchCompletedAppointments() async {
    _isLoadingCompleted = true;
    notifyListeners();
    try {
      final model = await _repository.getCompletedAppointmentsListApi();
      _completedAppointments = (model.data?.appointments ?? [])
          .where((e) => e.status == 'Completed')
          .toList();
    } catch (e) {
      debugPrint("❌ Error fetching completed appointments: $e");
    } finally {
      _isLoadingCompleted = false;
      notifyListeners();
    }
  }

  /// Fetch Cancelled Appointments
  Future<void> fetchCancelledAppointments() async {
    _isLoadingCancelled = true;
    notifyListeners();
    try {
      final model = await _repository.getCancelledAppointmentsListApi();
      _cancelledAppointments = (model.data?.appointments ?? [])
          .where((e) => e.status == 'Cancelled')
          .toList();
    } catch (e) {
      debugPrint("❌ Error fetching cancelled appointments: $e");
    } finally {
      _isLoadingCancelled = false;
      notifyListeners();
    }
  }
}
