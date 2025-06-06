import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage;
import 'models/job.dart';
import 'availablejobs.dart';
import 'screens/add_job_screen.dart';
import 'widgets/animated_page_wrapper.dart';

class Jobs extends StatefulWidget {
  const Jobs({super.key});

  @override
  State<Jobs> createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  // Add this method to handle refresh
  Future<void> _handleRefresh() async {
    // Wait for a moment to show the refresh indicator
    await Future.delayed(const Duration(milliseconds: 1500));
    // The StreamBuilder will automatically refresh when Firestore data changes
    return;
  }

  // Add this method to the _JobsState class
  Future<String> _getImageUrl(String path) async {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;

    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error getting download URL: $e');
      return '';
    }
  }

  void _navigateToJobDetails(DocumentSnapshot doc) {
    final job = Job.fromFirestore(doc);
    Navigator.push(context, MaterialPageRoute(builder: (context) => AvailableJobs(job: job)));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPageWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F6F2),
        body: Column(
          children: [
            // Header section
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Color(0xff184c6b)), onPressed: () => Navigator.pop(context)),
              ),
            ),
            const SizedBox(height: 10),

            // Title container
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xff184c6b),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))],
              ),
              child: const Center(child: Text('وظائف شاغرة', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))),
            ),
            const SizedBox(height: 20),

            // Jobs list with StreamBuilder
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('jobs').orderBy('createdAt', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _buildErrorWidget();
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingWidget();
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyWidget();
                  }

                  // Wrap ListView with RefreshIndicator
                  return RefreshIndicator(
                    onRefresh: _handleRefresh,
                    color: const Color(0xff184c6b),
                    backgroundColor: Colors.white,
                    strokeWidth: 3,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator
                      itemCount: snapshot.data!.docs.length,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];
                        final job = Job.fromFirestore(doc);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            onTap: () => _navigateToJobDetails(doc),
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))],
                              ),
                              child: Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  // Image container
                                  Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                      child: _buildJobImage(job.imageUrl),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  // Job details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(job.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
                                        const SizedBox(height: 12),
                                        Text(job.location, style: const TextStyle(fontSize: 14, color: Color(0xffc29424))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddJobScreen()),
            );
          },
          backgroundColor: const Color(0xffc29424),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // Extract widgets for better readability
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text('الرجاء التحقق من اتصال الإنترنت', style: TextStyle(fontSize: 18, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xff184c6b)),
          SizedBox(height: 16),
          Text('جاري التحميل...', style: TextStyle(fontSize: 18, color: Color(0xff184c6b))),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_off, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('لا توجد وظائف متاحة حالياً', style: TextStyle(fontSize: 18, color: Color(0xff184c6b))),
        ],
      ),
    );
  }

  Widget _buildJobImage(String imageUrl) {
    if (kIsWeb) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        headers: const {'Access-Control-Allow-Origin': '*', 'Cache-Control': 'max-age=3600'},
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/ServTech.png', fit: BoxFit.cover);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
              color: const Color(0xff184c6b),
            ),
          );
        },
      );
    } else {
      return FadeInImage.assetNetwork(
        placeholder: 'assets/ServTech.png',
        image: imageUrl,
        fit: BoxFit.cover,
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/ServTech.png', fit: BoxFit.cover);
        },
      );
    }
  }
}
