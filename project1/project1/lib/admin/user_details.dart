import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserDetailsPage extends StatefulWidget {
  final QueryDocumentSnapshot userDoc;

  const UserDetailsPage({super.key, required this.userDoc});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  bool isEditing = false;
  bool isLoading = true;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  String? role;
  bool isPremium = false;
  int restaurantCount = 0;
  int equipmentCount = 0;
  int jobsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadUserContent();
  }

  Future<void> _loadUserData() async {
    final data = widget.userDoc.data() as Map<String, dynamic>;
    nameController.text = data['name'] ?? '';
    phoneController.text = data['phone'] ?? '';
    addressController.text = data['address'] ?? '';
    role = data['role'] ?? 'user';
    isPremium = data['isPremium'] ?? false;
    setState(() => isLoading = false);
  }

  Future<void> _loadUserContent() async {
    final phone = widget.userDoc['phone'];
    final name = widget.userDoc['name'];

    // Count restaurants
    final restaurants = await FirebaseFirestore.instance.collection('restaurants').where('createdBy', isEqualTo: phone).get();

    // Count equipment
    final equipment = await FirebaseFirestore.instance.collection('equipment').where('createdBy', isEqualTo: phone).get();

    // Count jobs (by phone or company name)
    final jobs = await FirebaseFirestore.instance.collection('jobs').where('createdBy', isEqualTo: phone).get();

    final jobsByCompany = await FirebaseFirestore.instance.collection('jobs').where('company', isEqualTo: name).get();

    if (mounted) {
      setState(() {
        restaurantCount = restaurants.size;
        equipmentCount = equipment.size;
        jobsCount = jobs.size + jobsByCompany.size;
      });
    }
  }

  Future<void> _saveChanges() async {
    setState(() => isLoading = true);

    try {
      final updates = <String, dynamic>{
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'role': role,
        'isPremium': isPremium,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await widget.userDoc.reference.update(updates);

      Fluttertoast.showToast(msg: 'تم تحديث بيانات المستخدم بنجاح');
      setState(() => isEditing = false);
    } catch (e) {
      Fluttertoast.showToast(msg: 'حدث خطأ في حفظ البيانات');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff184c6b),
          title: const Text('تفاصيل المستخدم', style: TextStyle(color: Colors.white)),
          leading: IconButton(icon: const Icon(Icons.arrow_forward_ios, color: Colors.white), onPressed: () => Navigator.pop(context)),
          actions: [
            TextButton.icon(
              onPressed:
                  isLoading
                      ? null
                      : () {
                        if (isEditing) {
                          _saveChanges();
                        } else {
                          setState(() => isEditing = true);
                        }
                      },
              icon: Icon(isEditing ? Icons.save : Icons.edit, color: Colors.white),
              label: Text(isEditing ? 'حفظ' : 'تعديل', style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xffc29424)))
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // User Info Card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildEditableField('الاسم', nameController),
                              const SizedBox(height: 16),
                              _buildEditableField('رقم الجوال', phoneController),
                              const SizedBox(height: 16),
                              _buildEditableField('العنوان', addressController),
                              const SizedBox(height: 16),
                              _buildRoleSelector(),
                              const SizedBox(height: 16),
                              _buildPremiumToggle(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Statistics Card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('إحصائيات النشاط', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
                              const SizedBox(height: 16),
                              _buildStatItem('المطاعم', restaurantCount),
                              _buildStatItem('المعدات', equipmentCount),
                              _buildStatItem('الوظائف', jobsCount),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
        const SizedBox(height: 8),
        if (isEditing)
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'أدخل $label',
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xff184c6b))),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffc29424))),
            ),
          )
        else
          Text(
            controller.text.isEmpty ? 'غير محدد' : controller.text,
            style: TextStyle(color: controller.text.isEmpty ? Colors.grey : Colors.black87),
          ),
      ],
    );
  }

  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('الصلاحية', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
        const SizedBox(height: 8),
        if (isEditing)
          DropdownButton<String>(
            value: role,
            isExpanded: true,
            items:
                ['user', 'seller', 'admin'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(switch (value) {
                      'admin' => 'مشرف',
                      'seller' => 'بائع',
                      _ => 'مستخدم',
                    }),
                  );
                }).toList(),
            onChanged: (newValue) {
              setState(() => role = newValue);
            },
          )
        else
          Text(switch (role) {
            'admin' => 'مشرف',
            'seller' => 'بائع',
            _ => 'مستخدم',
          }, style: const TextStyle(color: Colors.black87)),
      ],
    );
  }

  Widget _buildPremiumToggle() {
    return Row(
      children: [
        const Text('عضوية مميزة', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
        const Spacer(),
        if (isEditing)
          Switch(value: isPremium, onChanged: (value) => setState(() => isPremium = value), activeColor: const Color(0xffc29424))
        else
          Icon(isPremium ? Icons.star : Icons.star_border, color: isPremium ? const Color(0xffc29424) : Colors.grey),
      ],
    );
  }

  Widget _buildStatItem(String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xffc29424).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(count.toString(), style: const TextStyle(color: Color(0xffc29424), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
