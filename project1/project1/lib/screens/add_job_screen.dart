import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddJobScreen extends StatefulWidget {
  const AddJobScreen({super.key});

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _requirementsController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitJob() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('jobs').add({
        'title': _titleController.text,
        'company': _companyController.text,
        'location': _locationController.text,
        'description': _descriptionController.text,
        'requirements': _requirementsController.text,
        'imageUrl': 'https://example.com/logo.png', // Replace with your default image
        'createdAt': FieldValue.serverTimestamp(),
        'isAvailable': true,
      });

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate refresh needed
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حدث خطأ. الرجاء المحاولة مرة أخرى')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      appBar: AppBar(backgroundColor: const Color(0xff184c6b), title: const Text('إضافة وظيفة جديدة'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Image Preview
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 3))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child:
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Image.network(
                              'https://example.com/logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                            ),
                  ),
                ),
                const SizedBox(height: 20),

                // Job Title
                TextFormField(
                  controller: _titleController,
                  textAlign: TextAlign.right,
                  decoration: inputDecoration('المسمى الوظيفي'),
                  validator: (value) => value?.isEmpty == true ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 16),

                // Company Name
                TextFormField(
                  controller: _companyController,
                  textAlign: TextAlign.right,
                  decoration: inputDecoration('اسم الشركة'),
                  validator: (value) => value?.isEmpty == true ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 16),

                // Location
                TextFormField(
                  controller: _locationController,
                  textAlign: TextAlign.right,
                  decoration: inputDecoration('الموقع'),
                  validator: (value) => value?.isEmpty == true ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 16),

                // Job Description
                TextFormField(
                  controller: _descriptionController,
                  textAlign: TextAlign.right,
                  maxLines: 5,
                  decoration: inputDecoration('الوصف الوظيفي'),
                  validator: (value) => value?.isEmpty == true ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 16),

                // Requirements
                TextFormField(
                  controller: _requirementsController,
                  textAlign: TextAlign.right,
                  maxLines: 5,
                  decoration: inputDecoration('المتطلبات'),
                  validator: (value) => value?.isEmpty == true ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitJob,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffc29424),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('نشر الوظيفة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      alignLabelWithHint: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }
}
