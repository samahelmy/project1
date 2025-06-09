import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingService {
  final _ratingsCollection = FirebaseFirestore.instance.collection('restaurant_ratings');

  Future<DocumentSnapshot?> getUserRating(String restaurantName) async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('phone');

    if (phone == null) return null;

    final query = await _ratingsCollection.where('restaurantName', isEqualTo: restaurantName).where('createdBy', isEqualTo: phone).limit(1).get();

    return query.docs.isEmpty ? null : query.docs.first;
  }

  Stream<QuerySnapshot> getRestaurantRatings(String restaurantName) {
    return _ratingsCollection.where('restaurantName', isEqualTo: restaurantName).orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> submitRating({required String restaurantName, required double rating, required String comment, String? existingDocId}) async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('phone');

    if (phone == null) throw Exception('User not logged in');

    final data = {
      'restaurantName': restaurantName,
      'rating': rating,
      'comment': comment,
      'createdBy': phone,
      'createdAt': FieldValue.serverTimestamp(),
    };

    if (existingDocId != null) {
      await _ratingsCollection.doc(existingDocId).update(data);
    } else {
      await _ratingsCollection.add(data);
    }
  }
}
