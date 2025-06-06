import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_details.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Query<Map<String, dynamic>> _getFilteredQuery() {
    var query = FirebaseFirestore.instance.collection('users');

    switch (_selectedFilter) {
      case 'premium':
        return query.where('isPremium', isEqualTo: true);
      case 'admin':
        return query.where('role', isEqualTo: 'admin');
      default:
        return query;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {
              _selectedFilter =
                  index == 1
                      ? 'premium'
                      : index == 2
                      ? 'admin'
                      : 'all';
            });
          },
          labelColor: const Color(0xffc29424),
          unselectedLabelColor: const Color(0xff184c6b),
          tabs: const [Tab(text: 'الكل'), Tab(text: 'المميزين'), Tab(text: 'المشرفين')],
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _getFilteredQuery().snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('حدث خطأ: ${snapshot.error}'));
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  final data = doc.data() as Map<String, dynamic>;

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      title: Text(data['name'] ?? 'بدون اسم'),
                      subtitle: Text(data['phone'] ?? ''),
                      trailing: Icon(
                        data['isPremium'] == true ? Icons.star : Icons.person,
                        color: data['isPremium'] == true ? const Color(0xffc29424) : const Color(0xff184c6b),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailsPage(userDoc: doc)));
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
