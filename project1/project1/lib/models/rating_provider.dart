import 'package:flutter/material.dart';

class RatingProvider extends ChangeNotifier {
  final Map<String, double> _ratings = {};

  double getRating(String restaurantName) {
    return _ratings[restaurantName] ?? 4.0;
  }

  void updateRating(String restaurantName, double rating) {
    _ratings[restaurantName] = rating;
    notifyListeners();
  }
}
