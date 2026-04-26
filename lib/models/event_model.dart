class Event {
  final int id;
  final String title;
  final String category;
  final String date;
  final String time;
  final String location;
  final String imageUrl;
  final String distance;
  final String description;

  Event({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.imageUrl,
    required this.distance,
    required this.description,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      title: json['title'] ?? "No Title",
      category: json['category'] ?? "General",
      date: json['date'] ?? "N/A",
      time: json['time'] ?? "N/A",
      location: json['location'] ?? "Unknown",
      imageUrl: json['imageUrl'] ??
          "https://via.placeholder.com/150",
      distance: json['distance'] ?? "0 km",
      description: json['description'] ?? "No description available",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "category": category,
      "date": date,
      "time": time,
      "location": location,
      "imageUrl": imageUrl,
      "distance": distance,
      "description": description,
    };
  }
}