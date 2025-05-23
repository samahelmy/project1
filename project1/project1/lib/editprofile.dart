import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String selectedGender = 'ذكر';
  bool isEditing = false;
  final nameController = TextEditingController(text: 'محمد احمد');
  final phoneController = TextEditingController(text: '+966 50 123 4567');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Color(0xff184c6b),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      buildEditableRow('الاسم', nameController),
                      const SizedBox(height: 20),
                      buildEditableRow('رقم الجوال', phoneController),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (isEditing)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F6F2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButton<String>(
                                value: selectedGender,
                                items: ['ذكر', 'انثى'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff184c6b),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedGender = newValue!;
                                  });
                                },
                                underline: Container(),
                              ),
                            )
                          else
                            Text(
                              selectedGender,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                          const SizedBox(width: 20),
                          const Text(
                            'الجنس',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff184c6b),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  if (isEditing) {
                    // Save changes here
                    // You can add API calls or database updates
                  }
                  isEditing = !isEditing;
                });
              },
              icon: Icon(
                isEditing ? Icons.save : Icons.edit,
                color: const Color(0xff184c6b),
              ),
              label: Text(
                isEditing ? 'حفظ' : 'تعديل',
                style: const TextStyle(
                  color: Color(0xff184c6b),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xff184c6b),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEditableRow(String label, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isEditing)
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          )
        else
          Text(
            controller.text,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        const SizedBox(width: 20),
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff184c6b),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
