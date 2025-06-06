import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/widgets/smart_image.dart'; // Import the SmartImage widget
import 'content_details.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final collections = ['restaurants', 'jobs', 'equipment'];
  final titles = ['المطاعم', 'الوظائف', 'المعدات'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: const Color(0xffc29424),
          unselectedLabelColor: const Color(0xff184c6b),
          tabs: titles.map((title) => Tab(text: title)).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children:
                collections.map((collection) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection(collection).orderBy('createdAt', descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('حدث خطأ: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Stack(
                        children: [
                          ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final doc = snapshot.data!.docs[index];
                              final data = doc.data() as Map<String, dynamic>;

                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: SmartImage(imageUrl: data['imageUrl'], width: 50, height: 50, borderRadius: BorderRadius.circular(4)),
                                  ),
                                  title: Text(data['name'] ?? data['title'] ?? ''),
                                  subtitle: Text(data['location'] ?? data['description'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ContentDetailsPage(collection: collection, contentDoc: doc)),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: FloatingActionButton(
                              backgroundColor: const Color(0xffc29424),
                              child: const Icon(Icons.add),
                              onPressed: () {
                                // TODO: Implement new content creation
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
