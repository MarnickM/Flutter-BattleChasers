import 'package:flutter/material.dart';
import '../database_helper.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  String? selectedUsername;
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> allDragons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    allDragons = await DatabaseHelper.fetchAllDragons();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchUserData(String username) async {
    final data = await DatabaseHelper.fetchUserData(username);
    setState(() {
      userData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select User',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: DatabaseHelper.fetchAllUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                      return const Text('No users available.');
                    } else {
                      final users = snapshot.data!;
                      return DropdownButton<String>(
                        value: selectedUsername,
                        isExpanded: true,
                        items: users
                            .map((user) => DropdownMenuItem<String>(
                                  value: user['username'],
                                  child: Text(user['username']),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedUsername = value;
                            userData = null;
                          });
                          if (value != null) {
                            _fetchUserData(value);
                          }
                        },
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                if (userData != null) ...[
                  Text(
                    '${userData!['username']}\'s Achievements',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Text('Score: ${userData!['score']}'),
                  Text('Total Enemies Killed: ${userData!['killcount']}'),
                  const SizedBox(height: 20),
                  const Text(
                    'Dragon Defeat Status:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...allDragons.map((dragon) {
                    final dragonName = dragon['name'];
                    final isDefeated = (userData!['dragonsKilled'] as String)
                        .split(',')
                        .contains(dragon['id']);
                    return _buildAchievementCard(dragonName, isDefeated);
                  }).toList(),
                ],
              ],
            ),
          );
  }

  Widget _buildAchievementCard(String dragonName, bool isAchieved) {
    return Card(
      child: ListTile(
        title: Text(dragonName),
        trailing: isAchieved
            ? const Icon(Icons.check, color: Colors.green)
            : const Icon(Icons.close, color: Colors.red),
      ),
    );
  }
}
