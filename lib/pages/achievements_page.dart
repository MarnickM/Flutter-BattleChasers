import 'package:flutter/material.dart';
import '../database_helper.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  Future<List<String>> fetchAchievements() async {
    return await DatabaseHelper.fetchAchievements();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<String>>(
        future: fetchAchievements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<String> achievements = snapshot.data ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Achievements',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10.0),
                _buildAchievementCard("Dragon A", achievements.contains("dragon_a")),
                _buildAchievementCard("Dragon B", achievements.contains("dragon_b")),
                _buildAchievementCard("Dragon C", achievements.contains("dragon_c")),
              ],
            );
          }
        },
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
