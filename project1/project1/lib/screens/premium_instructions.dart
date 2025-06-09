import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PremiumInstructionsScreen extends StatelessWidget {
  // Remove const from constructor
  PremiumInstructionsScreen({super.key});

  Future<void> _openWhatsApp() async {
    const phone = '+201141570160';
    final url = 'whatsapp://send?phone=$phone';

    try {
      final canLaunch = await canLaunchUrlString(url);
      if (canLaunch) {
        await launchUrlString(url);
      } else {
        // Fallback to web WhatsApp if app is not installed
        final webUrl = 'https://wa.me/$phone';
        if (await canLaunchUrlString(webUrl)) {
          await launchUrlString(webUrl);
        } else {
          debugPrint('Could not launch WhatsApp');
        }
      }
    } catch (e) {
      debugPrint('Error launching WhatsApp: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xff184c6b), title: const Text('الاشتراك المميز'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'طرق الدفع المتاحة',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff184c6b)),
            ),
            const SizedBox(height: 20),
            _buildPaymentMethod('Vodafone Cash', '01080650178', Icons.phone_android),
            _buildPaymentMethod('Etisalat Cash', '01141570160', Icons.phone_android),
            _buildPaymentMethod('InstaPay', '01141570160', Icons.payments),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.yellow.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.yellow.shade700),
              ),
              child: const Text('بعد التحويل، يرجى التواصل معنا لتفعيل حسابك يدويًا.', style: TextStyle(fontSize: 16), textAlign: TextAlign.right),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openWhatsApp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff25D366),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                // Replace Icons.whatsapp with FaIcon
                icon: const FaIcon(FontAwesomeIcons.whatsapp),
                label: const Text('تم التحويل؟ تواصل معنا الآن', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(String title, String number, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xff184c6b)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff184c6b)),
                ),
                const SizedBox(height: 4),
                Text(
                  number,
                  style: const TextStyle(fontSize: 16, color: Color(0xffc29424)),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
