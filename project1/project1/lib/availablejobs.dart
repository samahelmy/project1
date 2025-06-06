import 'package:flutter/material.dart';
import 'models/job.dart';

class AvailableJobs extends StatelessWidget {
  final Job job;

  const AvailableJobs({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      appBar: AppBar(
        backgroundColor: const Color(0xff184c6b),
        title: Text(job.title),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Job Image
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 3))],
              ),
              child: _buildJobImage(job.imageUrl),
            ),

            // Job Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(job.company, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
                  const SizedBox(height: 8),
                  Text(job.location, style: const TextStyle(fontSize: 16, color: Color(0xffc29424))),
                  const SizedBox(height: 24),

                  // Description
                  const Text("الوصف الوظيفي", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
                  const SizedBox(height: 16),
                  Text(job.description, textAlign: TextAlign.right, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87)),
                  const SizedBox(height: 24),

                  // Requirements
                  const Text("المتطلبات", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
                  const SizedBox(height: 16),
                  ...job.requirements.expand((requirement) {
                    // Split requirement by newlines and filter out empty lines
                    final lines = requirement.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();

                    // Convert each line to a bullet point
                    return lines.map((line) => bulletPoint(line));
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement job application
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffc29424),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("التقدم للوظيفة", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Widget bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: Text(text, textAlign: TextAlign.right, style: const TextStyle(fontSize: 18, color: Colors.black87))),
          const SizedBox(width: 8),
          const Icon(Icons.circle, size: 8, color: Color(0xffc29424)),
        ],
      ),
    );
  }

  Widget _buildJobImage(String imageUrl) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3, minHeight: 200),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child:
                imageUrl.isNotEmpty
                    ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
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
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/ServTech.png', fit: BoxFit.contain, width: double.infinity);
                      },
                    )
                    : Image.asset('assets/ServTech.png', fit: BoxFit.contain, width: double.infinity),
          ),
        );
      },
    );
  }
}
