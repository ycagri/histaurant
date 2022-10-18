import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:historical_restaurants/database/restaurant.dart';
import 'package:injectable/injectable.dart';

@injectable
class RestApi {
  Future<List<Restaurant>> getRestaurants() => FirebaseFirestore.instance
          .collection("restaurants")
          .snapshots()
          .map((event) {
        List<Restaurant> restaurants = <Restaurant>[];
        for (var element in event.docs) {
          var restaurant = Restaurant.fromJson(element.data());
          restaurants.add(restaurant);
        }
        return restaurants;
      }).first;
}
