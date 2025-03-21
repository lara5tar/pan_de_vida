class Event {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String location;
  final String image;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.image,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      location: json['location'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'location': location,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'Event{title: $title, description: $description, date: $date, time: $time, location: $location, image: $image}';
  }
}
