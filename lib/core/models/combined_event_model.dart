import '/core/models/attendee_info_model.dart';
import '/core/models/event_model.dart';

class CombinedEventModel {
  final EventModel? eventModel;
  final AttendeeInfoModel? attendeeInfoModel;

  CombinedEventModel({this.eventModel, this.attendeeInfoModel});

  factory CombinedEventModel.combine(EventModel eventModel, AttendeeInfoModel attendeeInfoModel) {
    if (eventModel.id == attendeeInfoModel.id) {
      return CombinedEventModel(eventModel: eventModel, attendeeInfoModel: attendeeInfoModel);
    } else {
      throw Exception('Event ID and Attendee ID do not match');
    }
  }

  @override
  String toString() {
    return 'CombinedEventModel: { EventModel: ${eventModel.toString()}, AttendeeInfoModel: ${attendeeInfoModel.toString()} }';
  }
}
