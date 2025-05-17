class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final String urlImage;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  bool isRecurrent;
  bool isAllDay;
  final String endDateRecurrence;
  final String daysOfWeek;
  bool isDesactivated;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.urlImage,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.isRecurrent,
    required this.isAllDay,
    required this.endDateRecurrence,
    required this.daysOfWeek,
    this.isDesactivated = false,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      urlImage: json['urlImage'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      isRecurrent: json['isRecurrent'] ?? false,
      isAllDay: json['isAllDay'] ?? false,
      endDateRecurrence: json['endDateRecurrence'] ?? '',
      daysOfWeek: json['daysOfWeek'] ?? '',
      isDesactivated: json['isDesactivated'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'urlImage': urlImage,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'isRecurrent': isRecurrent,
      'isAllDay': isAllDay,
      'endDateRecurrence': endDateRecurrence,
      'daysOfWeek': daysOfWeek,
      'isDesactivated': isDesactivated,
    };
  }

  @override
  String toString() {
    return 'Event(id: $id, title: $title, description: $description, location: $location, urlImage: $urlImage, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, isRecurrent: $isRecurrent, isAllDay: $isAllDay, endDateRecurrence: $endDateRecurrence)';
  }

  //copyWith method
  Event copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? urlImage,
    String? startDate,
    String? endDate,
    String? startTime,
    String? endTime,
    bool? isRecurrent,
    bool? isAllDay,
    String? endDateRecurrence,
    String? daysOfWeek,
    bool? isDesactivated,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      urlImage: urlImage ?? this.urlImage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isRecurrent: isRecurrent ?? this.isRecurrent,
      isAllDay: isAllDay ?? this.isAllDay,
      endDateRecurrence: endDateRecurrence ?? this.endDateRecurrence,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      isDesactivated: isDesactivated ?? this.isDesactivated,
    );
  }
}
