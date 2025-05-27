import 'package:flutter/material.dart';
import 'models/job.dart';
import 'availablejobs.dart';

class Jobs extends StatelessWidget {
  Jobs({super.key});

  final List<Job> jobs = [
    Job(
      title: 'شيف مطبخ رئيسي',
      description: 'خبرة 5 سنوات في المطاعم العالمية',
      location: 'الرياض - حي النخيل',
    ),
    Job(
      title: 'نادل / مضيف',
      description: 'خبرة سنتين في خدمة العملاء',
      location: 'الرياض - حي العليا',
    ),
    Job(
      title: 'كاشير',
      description: 'خبرة في التعامل مع نظم نقاط البيع',
      location: 'الرياض - حي الورود',
    ),
    Job(
      title: 'مساعد طباخ',
      description: 'خبرة سنة في المطابخ العالمية',
      location: 'الرياض - حي النخيل',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xff184c6b),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.8, // Added width
            padding: const EdgeInsets.symmetric(
                horizontal: 30, vertical: 15), // Increased padding
            decoration: BoxDecoration(
              color: const Color(0xff184c6b), // Changed to blue color
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Center( // Added Center widget
              child: Text(
                'وظائف شاغرة',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Keeping text white
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: jobs.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AvailableJobs(job: jobs[index]),
                        ),
                      );
                    },
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl, // Add RTL direction
                        children: [
                          Container(
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              image: const DecorationImage(
                                image: AssetImage('assets/ServTech.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  jobs[index].title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff184c6b),
                                  ),
                                ),
                                
                                const SizedBox(height: 12),
                                Text(
                                  jobs[index].location,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xffc29424),
                                  ),
                                ),
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
          ),
        ],
      ),
    );
  }
}