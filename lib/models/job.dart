class Job {
  final String id;
  final String posterId;
  final String title;
  final String description;
  final String category; // e.g., 'tuition', 'part-time', 'technician', 'maid'
  final String location;
  final double? latitude;
  final double? longitude;
  final double? salary;
  final String salaryType; // 'hourly', 'daily', 'monthly', 'fixed'
  final bool isUrgent;
  final bool appHandlesHiring;
  final List<String> images;
  final DateTime createdAt;
  final DateTime? deadline;
  final bool isActive;
  final bool isFeatured;

  Job({
    required this.id,
    required this.posterId,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    this.latitude,
    this.longitude,
    this.salary,
    required this.salaryType,
    this.isUrgent = false,
    this.appHandlesHiring = false,
    this.images = const [],
    required this.createdAt,
    this.deadline,
    this.isActive = true,
    this.isFeatured = false,
  });

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'],
      posterId: map['posterId'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      location: map['location'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      salary: map['salary']?.toDouble(),
      salaryType: map['salaryType'],
      isUrgent: map['isUrgent'] ?? false,
      appHandlesHiring: map['appHandlesHiring'] ?? false,
      images: List<String>.from(map['images'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
      deadline: map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
      isActive: map['isActive'] ?? true,
      isFeatured: map['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'posterId': posterId,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'salary': salary,
      'salaryType': salaryType,
      'isUrgent': isUrgent,
      'appHandlesHiring': appHandlesHiring,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'isActive': isActive,
      'isFeatured': isFeatured,
    };
  }
}