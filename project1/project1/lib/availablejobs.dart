import 'package:flutter/material.dart';
import 'models/job.dart';

class AvailableJobs extends StatelessWidget {
  final Job job;

  const AvailableJobs({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xff184c6b),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "ويتر",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24, // Increased from 20
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // For alignment
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xffc29424),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "وظيفة شاغرة",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "مطعم المذاق الشهي",
                          style: TextStyle(
                            fontSize: 24, // Increased from 20
                            fontWeight: FontWeight.bold,
                            color: Color(0xff184c6b),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.restaurant,
                            color: Color(0xff184c6b),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "21 ابريل 2024",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.calendar_today, color: Colors.grey[600]),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "الوصف الوظيفي",
                      style: TextStyle(
                        fontSize: 24, // Increased from 20
                        fontWeight: FontWeight.bold,
                        color: Color(0xff184c6b),
                      ),
                    ),
                    const SizedBox(height: 16),
                    bulletPoint("تقديم خدمة الطعام والشراب للمائدة"),
                    bulletPoint("تلقي الطلبات وتقديمها بشكل دقيق وسريع"),
                    const SizedBox(height: 30),
                    const Text(
                      "المتطلبات",
                      style: TextStyle(
                        fontSize: 24, // Increased from 20
                        fontWeight: FontWeight.bold,
                        color: Color(0xff184c6b),
                      ),
                    ),
                    const SizedBox(height: 16),
                    bulletPoint("خبرة سابقة في تقديم الطعام"),
                    bulletPoint("مهارات تواصل ممتازة وقدرة العمل ضمن فريق"),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle job application
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffc29424),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "التقدم للوظيفة",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12), // Increased from 8
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 18, // Increased from 16
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.circle, size: 8, color: Color(0xffc29424)),
        ],
      ),
    );
  }
}
