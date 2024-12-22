import 'package:flutter/material.dart';
import '../database_helper.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  Future<List<Map<String, dynamic>>> fetchScores() async {
    return await DatabaseHelper.fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leaderboard',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchScores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final scores = snapshot.data ?? [];

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: scores.length,
              itemBuilder: (context, index) {
                final score = scores[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  color: const Color(0xFF2C3E50),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    leading: Text(
                      '#${index + 1}', // Ranking based on position in the sorted list
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.amberAccent),
                    ),
                    title: Text(
                      score['username'] ?? 'Player',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                    ),
                    trailing: Text(
                      score['score'].toString(),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
