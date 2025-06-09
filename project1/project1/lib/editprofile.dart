import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isEditing = false;
  bool isLoading = true;
  String? userPhone;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  String userRole = 'user'; // Default role

  bool _hasRequestedSeller = false;
  bool _agreesToTerms = false;
  bool? _sellerRequest;

  // Change late StreamSubscription to nullable
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Remove _setupUserListener() from initState
  }

  Future<void> _loadUserData() async {
    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      userPhone = prefs.getString('phone');

      if (userPhone != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(userPhone).get();

        if (doc.exists) {
          final data = doc.data()!;
          setState(() {
            nameController.text = data['name'] ?? '';
            phoneController.text = data['phone'] ?? '';
            passwordController.text = data['password'] ?? '';
            addressController.text = data['address'] ?? '';
            userRole = data['role'] ?? 'user';
            _sellerRequest = data['sellerRequest'] as bool?;
          });

          // Setup listener after we have the userPhone
          _setupUserListener();
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'حدث خطأ في تحميل البيانات');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _setupUserListener() {
    if (userPhone != null) {
      _userSubscription = FirebaseFirestore.instance.collection('users').doc(userPhone).snapshots().listen((snapshot) {
        if (snapshot.exists) {
          setState(() {
            userRole = snapshot.data()?['role'] ?? 'user';
            _sellerRequest = snapshot.data()?['sellerRequest'] as bool?;
          });
        }
      });
    }
  }

  Future<void> _checkSellerRequest() async {
    if (userPhone == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(userPhone).get();

    if (doc.exists) {
      setState(() {
        _hasRequestedSeller = doc.data()?['role'] == 'pending_seller' || doc.data()?['sellerRequest'] == true;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (userPhone == null) return;

    setState(() => isLoading = true);

    try {
      final updates = <String, dynamic>{
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'password': passwordController.text,
        'address': addressController.text.trim(),
        // Remove gender field, don't update role here
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('users').doc(userPhone).update(updates);

      Fluttertoast.showToast(msg: 'تم حفظ التغييرات بنجاح');
      setState(() => isEditing = false);
    } catch (e) {
      Fluttertoast.showToast(msg: 'حدث خطأ في حفظ البيانات');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildSellerRequestSection() {
    // If user is already a seller, show success message
    if (userRole == 'seller') {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 2))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 24),
            SizedBox(width: 10),
            Text('أنت الآن بائع في التطبيق ✅', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
          ],
        ),
      );
    }

    // If request is pending, show waiting message
    if (_sellerRequest == true) {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 2))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(Icons.hourglass_bottom, color: Color(0xffc29424), size: 24),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'طلبك قيد التنفيذ، يرجى الانتظار حتى تتم مراجعته من قبل الإدارة',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff184c6b)),
              ),
            ),
          ],
        ),
      );
    }

    // Show request UI for regular users
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('هل ترغب في أن تصبح بائعًا في التطبيق؟', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
          const SizedBox(height: 20),
          ...[
                // Requirements list
                'يجب أن يكون الحساب موثقًا باسم ورقم هاتف صحيح.',
                'الالتزام بإدخال بيانات المنتجات بدقة.',
                'الالتزام بسياسات المنصة والتعامل مع العملاء باحترام.',
              ]
              .map(
                (requirement) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xffc29424), size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(requirement, textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 16))),
                    ],
                  ),
                ),
              )
              .toList(),
          const SizedBox(height: 20),
          CheckboxListTile(
            value: _agreesToTerms,
            onChanged: (value) => setState(() => _agreesToTerms = value!),
            title: const Text('أوافق على الشروط', textAlign: TextAlign.end, style: TextStyle(fontSize: 16)),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: const Color(0xffc29424),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _agreesToTerms ? _submitSellerRequest : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff184c6b),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('تقديم الطلب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitSellerRequest() async {
    if (userPhone == null) return;
    setState(() => isLoading = true);

    try {
      // Update user document
      await FirebaseFirestore.instance.collection('users').doc(userPhone).update({
        'sellerRequest': true,
        'requestedAt': FieldValue.serverTimestamp(),
      });

      // Add notification for the user
      await FirebaseFirestore.instance.collection('users').doc(userPhone).collection('notifications').add({
        'title': 'طلب بائع',
        'message': 'تم استلام طلبك، سيتم مراجعته من قبل فريق الإشراف',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      // Notify admins
      final adminsSnapshot = await FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'admin').get();

      for (var adminDoc in adminsSnapshot.docs) {
        await adminDoc.reference.collection('notifications').add({
          'title': 'طلب جديد ليصبح بائعًا',
          'message': '''قام المستخدم التالي بطلب أن يصبح بائعًا:
الاسم: ${nameController.text}
الرقم: ${phoneController.text}
العنوان: ${addressController.text}''',
          'timestamp': FieldValue.serverTimestamp(),
          'isRead': false,
          'type': 'seller_request',
          'requesterId': userPhone,
        });
      }

      setState(() => _sellerRequest = true);
      Fluttertoast.showToast(msg: 'تم إرسال طلبك بنجاح');
    } catch (e) {
      Fluttertoast.showToast(msg: 'حدث خطأ في إرسال الطلب');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: Stack(
        children: [
          if (isLoading)
            const Center(child: CircularProgressIndicator(color: Color(0xffc29424)))
          else
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Center(
                    child: CircleAvatar(radius: 60, backgroundColor: Colors.white, child: Icon(Icons.person, size: 60, color: Color(0xff184c6b))),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        buildEditableRow('الاسم', nameController),
                        const SizedBox(height: 20),
                        buildEditableRow('رقم الجوال', phoneController),
                        const SizedBox(height: 20),
                        buildEditableRow('كلمة المرور', passwordController, isPassword: true),
                        const SizedBox(height: 20),
                        buildEditableRow('العنوان', addressController),
                        const SizedBox(height: 20),
                        buildRoleDisplay(), // Replace buildGenderSelector with buildRoleDisplay
                      ],
                    ),
                  ),
                  _buildSellerRequestSection(), // Add this line
                ],
              ),
            ),
          // Top Actions
          Positioned(
            top: 40,
            right: 20,
            child: TextButton.icon(
              onPressed:
                  isLoading
                      ? null
                      : () {
                        setState(() {
                          if (isEditing) {
                            _saveChanges();
                          } else {
                            isEditing = true;
                          }
                        });
                      },
              icon: Icon(isEditing ? Icons.save : Icons.edit, color: const Color(0xff184c6b)),
              label: Text(isEditing ? 'حفظ' : 'تعديل', style: const TextStyle(color: Color(0xff184c6b), fontSize: 16)),
            ),
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

  Widget buildEditableRow(String label, TextEditingController controller, {bool isPassword = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isEditing)
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              obscureText: isPassword,
              cursorColor: const Color(0xff184c6b),
              decoration: InputDecoration(
                hintText: isPassword ? '••••••' : 'أدخل ${label.toLowerCase()}',
                hintTextDirection: TextDirection.rtl,
                border: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff184c6b))),
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff184c6b))),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffc29424), width: 2)),
              ),
            ),
          )
        else
          Text(
            isPassword ? '••••••' : (controller.text.isEmpty ? 'غير محدد' : controller.text),
            style: TextStyle(fontSize: 18, color: controller.text.isEmpty ? Colors.grey : Colors.black87),
          ),
        const SizedBox(width: 20),
        Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
      ],
    );
  }

  Widget buildRoleDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(switch (userRole) {
          'admin' => 'مشرف',
          'seller' => 'بائع',
          _ => 'مستخدم',
        }, style: const TextStyle(fontSize: 18, color: Colors.black87)),
        const SizedBox(width: 20),
        const Text('نوع الحساب', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
      ],
    );
  }

  @override
  void dispose() {
    // Update disposal to handle nullable subscription
    _userSubscription?.cancel();
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
