import 'dart:ffi';

import 'package:online/core/client/client.dart';
import 'package:online/core/models/attendee_info_model.dart';
import 'package:online/core/models/simple_event_attendee_model.dart';

class AttendeeSorter {
  // Keep track of whether the user is initialized
  bool _userInitialized = false;

  void initState() {
    // Fetch the user ID only once
    if (!_userInitialized) {
      final user = Client.userCache.value;
      if (user != null) {
        _userInitialized = true;
      }
    }
  }

  final Set<int> ids = {};

  Future<List<SimpleEventAttendee>> getUserStatus() async {
    final events = await Client.getAllEventAttendances();
    List<SimpleEventAttendee> userStatuses = []; // To store results

    if (events == null) {
      return userStatuses;
    }

    for (var event in events) {
      String status = 'unknown'; // Default in case of unexpected values
      if (onWaitingList(event)) {
        status = 'waitList';
      } else if (signedUp(event)) {
        status = 'attendee';
      }

      userStatuses.add(SimpleEventAttendee(eventID: event.id, status: status));
    }
    return userStatuses;
  }

  bool onWaitingList(AttendeeInfoModel event) {
    if (event.isOnWaitlist == true) {
      return true;
    }
    return false;
  }

  bool signedUp(AttendeeInfoModel event) {
    if (event.isAttendee == true) {
      return true;
    }
    return false;
  }

  // Helper function to ensure user is initialized
  void _checkUserInitialized() {
    if (!_userInitialized) {
      throw Exception('User not initialized. Call initState() first.');
    }
  }
}
