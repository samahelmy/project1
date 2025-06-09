import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sellres.dart';
import 'models/restaurant.dart';
import 'availableres.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Buying extends StatefulWidget {
  const Buying({super.key});

  @override
  State<Buying> createState() => _BuyingState();
}

class _BuyingState extends State<Buying> {
  // Add role state variable
  String? _userRole;
  final _restaurantsStream = FirebaseFirestore.instance.collection('restaurants').orderBy('createdAt', descending: true).snapshots();

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('role');
    });
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator(color: Color(0xff184c6b)));
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(fontSize: 18, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.store_outlined, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('لا توجد مطاعم حالياً', style: TextStyle(fontSize: 18, color: Color(0xff184c6b))),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AvailableRes(restaurant: Restaurant.fromFirestore(doc)))),
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
              textDirection: TextDirection.rtl,
              children: [
                // Restaurant Image
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      data['imageUrl'] ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/ServTech.png', fit: BoxFit.cover);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                            color: const Color(0xff184c6b),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Restaurant Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(data['name'] ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
                      const SizedBox(height: 10),
                      Text('${_formatPrice(data['price'] ?? '')} جنيه', style: const TextStyle(fontSize: 20, color: Color(0xffc29424))),
                      const SizedBox(height: 10),
                      Text(data['location'] ?? '', style: const TextStyle(fontSize: 16, color: Colors.grey)),
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

  String _formatPrice(String price) {
    if (price.isEmpty) return '';
    // Remove any non-digit characters
    final cleanPrice = price.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPrice.isEmpty) return price;
    // Convert to number and format with commas
    final number = int.tryParse(cleanPrice);
    if (number == null) return price;
    return number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      // Conditionally show FloatingActionButton
      floatingActionButton:
          _userRole == 'seller'
              ? FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const SellRes()));
                  if (result != null && result is Restaurant) {
                    // Optional: Handle the result if needed
                  }
                },
                backgroundColor: const Color(0xffc29424),
                tooltip: 'إضافة منتج جديد',
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
      body: Stack(
        children: [
          Column(
            children: [
              // Header container
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
                    child: Text('بيع وشراء وتأجير المطعم', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Title section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("مطعم للبيع", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
                ),
              ),
              // Restaurant list
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _restaurantsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return _buildErrorState('حدث خطأ في تحميل البيانات');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingState();
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => _buildRestaurantCard(snapshot.data!.docs[index]),
                    );
                  },
                ),
              ),
            ],
          ),
          // Back button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Color(0xff184c6b)), onPressed: () => Navigator.pop(context)),
          ),
        ],
      ),
    );
  }
}
