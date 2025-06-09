import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:project1/rateinfo.dart';
import 'services/rating_service.dart';
import 'screens/submit_rating_screen.dart';
import 'screens/add_restaurant_screen.dart';
import 'widgets/smart_image.dart';

class Rate extends StatelessWidget {
  const Rate({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F6F2),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddRestaurantScreen())),
          backgroundColor: const Color(0xffc29424),
          label: const Text('إضافة مطعم'),
          icon: const Icon(Icons.add),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                // Header Container
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  decoration: BoxDecoration(
                    color: const Color(0xffc29424),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))],
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Text('التقييمات والمراجعات', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Restaurant List
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('restaurant_ratings').orderBy('createdAt', descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('حدث خطأ: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xffc29424)));
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('لا يوجد مطاعم مدرجة في القائمة', style: TextStyle(fontSize: 18, color: Color(0xff184c6b))));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                          return _buildRestaurantCard(
                            context,
                            data['restaurantName'] ?? '',
                            (data['rating'] as num).toDouble(),
                            data['address'] ?? '',
                            data['imageUrl'],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Color(0xff184c6b)), onPressed: () => Navigator.pop(context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, String name, double rating, String address, String? imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RateInfo(restaurantName: name, rating: rating, address: address)));
        },
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 2))],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                SmartImage(imageUrl: imageUrl, width: 150, height: 150, borderRadius: BorderRadius.circular(10)),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
                      const SizedBox(height: 8),
                      Text(address, style: const TextStyle(fontSize: 16, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xffc29424), size: 28),
                          const SizedBox(width: 8),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff184c6b)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
