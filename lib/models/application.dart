class Application {
  final String id;
  final String jobId;
  final String applicantId;
  final String message;
  final DateTime appliedAt;
  final String status; // 'pending', 'accepted', 'rejected', 'hired'

  Application({
    required this.id,
    required this.jobId,
    required this.applicantId,
    required this.message,
    required this.appliedAt,
    this.status = 'pending',
  });

  factory Application.fromMap(Map<String, dynamic> map) {
    return Application(
      id: map['id'],
      jobId: map['jobId'],
      applicantId: map['applicantId'],
      message: map['message'],
      appliedAt: DateTime.parse(map['appliedAt']),
      status: map['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobId': jobId,
      'applicantId': applicantId,
      'message': message,
      'appliedAt': appliedAt.toIso8601String(),
      'status': status,
    };
  }
}