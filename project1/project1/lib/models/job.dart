import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  final String title;
  final String description;
  final String location;
  final String imageUrl;
  final List<String> requirements;
  final String company;
  final DateTime? createdAt;

  Job({
    required this.title,
    required this.description,
    required this.location,
    this.imageUrl = '',
    this.requirements = const [],
    this.company = '',
    this.createdAt,
  });

  factory Job.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Handle requirements field that might be String or List
    List<String> requirementsList = [];
    var reqData = data['requirements'];
    if (reqData != null) {
      if (reqData is String) {
        // If it's a single string, make it a single-item list
        requirementsList = [reqData];
      } else if (reqData is List) {
        // If it's already a list, convert all items to strings
        requirementsList = reqData.map((item) => item.toString()).toList();
      }
    }

    return Job(
      title: data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      location: data['location']?.toString() ?? '',
      imageUrl: data['imageUrl']?.toString() ?? '',
      requirements: requirementsList,
      company: data['company']?.toString() ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'imageUrl': imageUrl,
      'requirements': requirements,
      'company': company,
      'createdAt': createdAt,
    };
  }
}
