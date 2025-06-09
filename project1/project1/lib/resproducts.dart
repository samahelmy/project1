import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/sellpro.dart';
import 'availablepro.dart';
import 'models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResProducts extends StatefulWidget {
  const ResProducts({super.key});

  @override
  State<ResProducts> createState() => _ResProductsState();
}

class _ResProductsState extends State<ResProducts> {
  String? _userRole;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      // Conditionally show FloatingActionButton based on user role
      floatingActionButton:
          _userRole == 'seller'
              ? FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const SellPro()));
                  if (result != null && result is Product) {
                    await FirebaseFirestore.instance.collection('equipment').add({
                      'name': result.name,
                      'price': result.price,
                      'description': result.description,
                      'createdAt': FieldValue.serverTimestamp(),
                    });
                  }
                },
                backgroundColor: const Color(0xffc29424),
                tooltip: 'اضافة معدات للبيع',
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
                    child: Text('شراء وتأجير معدات الطعام', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Remove the old button section and its padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("معدات للبيع", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('equipment').orderBy('createdAt', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('حدث خطأ: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('لا توجد معدات حالياً', style: TextStyle(fontSize: 18, color: Color(0xff184c6b))));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];
                        final data = doc.data() as Map<String, dynamic>;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          AvailablePro(product: Product(name: data['name'], price: data['price'], description: data['description'])),
                                ),
                              );
                            },
                            child: Container(
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 2)),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image:
                                              data['imageUrl']?.startsWith('assets/') ?? false
                                                  ? AssetImage(data['imageUrl'])
                                                  : data['imageUrl'] != null
                                                  ? NetworkImage(data['imageUrl'])
                                                  : const AssetImage('assets/ServTech.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            data['name'],
                                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff184c6b)),
                                          ),
                                          const SizedBox(height: 10),
                                          Text('${data['price']} جنيه', style: const TextStyle(fontSize: 20, color: Color(0xffc29424))),
                                          const SizedBox(height: 10),
                                          Text(data['description'], style: const TextStyle(fontSize: 16, color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
    );
  }
}
