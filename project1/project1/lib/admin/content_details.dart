
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ContentDetailsPage extends StatefulWidget {
  final String collection;
  final QueryDocumentSnapshot contentDoc;

  const ContentDetailsPage({super.key, required this.collection, required this.contentDoc});

  @override
  State<ContentDetailsPage> createState() => _ContentDetailsPageState();
}

class _ContentDetailsPageState extends State<ContentDetailsPage> {
  bool isEditing = false;
  bool isLoading = false;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final priceController = TextEditingController();
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadContentData();
  }

  void _loadContentData() {
    final data = widget.contentDoc.data() as Map<String, dynamic>;
    nameController.text = data['name'] ?? data['title'] ?? '';
    descriptionController.text = data['description'] ?? '';
    locationController.text = data['location'] ?? '';
    priceController.text = (data['price'] ?? '').toString();
    imageUrl = data['imageUrl'];
  }

  Future<void> _saveChanges() async {
    setState(() => isLoading = true);

    try {
      final updates = <String, dynamic>{
        if (widget.collection == 'restaurants' || widget.collection == 'equipment')
          'name': nameController.text.trim()
        else
          'title': nameController.text.trim(),
        'description': descriptionController.text.trim(),
        'location': locationController.text.trim(),
        if (priceController.text.isNotEmpty) 'price': double.tryParse(priceController.text) ?? 0,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await widget.contentDoc.reference.update(updates);

      Fluttertoast.showToast(msg: 'تم تحديث البيانات بنجاح');
      setState(() => isEditing = false);
    } catch (e) {
      Fluttertoast.showToast(msg: 'حدث خطأ في حفظ البيانات');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteContent() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: const Text('هل أنت متأكد من حذف هذا المحتوى؟'),
            actions: [
              TextButton(child: const Text('إلغاء'), onPressed: () => Navigator.pop(context, false)),
              TextButton(child: const Text('حذف', style: TextStyle(color: Colors.red)), onPressed: () => Navigator.pop(context, true)),
            ],
          ),
    );

    if (confirmed == true) {
      setState(() => isLoading = true);
      try {
        await widget.contentDoc.reference.delete();
        if (mounted) {
          Navigator.pop(context);
        }
        Fluttertoast.showToast(msg: 'تم حذف المحتوى بنجاح');
      } catch (e) {
        Fluttertoast.showToast(msg: 'حدث خطأ في حذف المحتوى');
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff184c6b),
          title: Text(
            'تفاصيل ${widget.collection == 'restaurants'
                ? 'المطعم'
                : widget.collection == 'jobs'
                ? 'الوظيفة'
                : 'المعدات'}',
            style: const TextStyle(color: Colors.white),
          ),
          leading: IconButton(icon: const Icon(Icons.arrow_forward_ios, color: Colors.white), onPressed: () => Navigator.pop(context)),
          actions: [
            if (!isEditing) IconButton(icon: const Icon(Icons.delete, color: Colors.white), onPressed: _deleteContent),
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
                      // Image Preview
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image:
                                imageUrl?.startsWith('assets/') ?? false
                                    ? AssetImage(imageUrl!)
                                    : imageUrl != null
                                    ? NetworkImage(imageUrl!)
                                    : const AssetImage('assets/ServTech.png') as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Content Details
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildEditableField(widget.collection == 'jobs' ? 'عنوان الوظيفة' : 'الاسم', nameController),
                              const SizedBox(height: 16),
                              _buildEditableField('الوصف', descriptionController, maxLines: 3),
                              const SizedBox(height: 16),
                              _buildEditableField('الموقع', locationController),
                              const SizedBox(height: 16),
                              if (widget.collection != 'jobs') _buildEditableField('السعر', priceController, keyboardType: TextInputType.number),
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

  Widget _buildEditableField(String label, TextEditingController controller, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
        const SizedBox(height: 8),
        if (isEditing)
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
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

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    priceController.dispose();
    super.dispose();
  }
}
