import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (project.projectImageUrl.isNotEmpty) ...[
            Image.network(
              project.projectImageUrl,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            project.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text('Tech stack: ${project.techStack}'),
          const SizedBox(height: 12),
          Text(project.description),
          const SizedBox(height: 16),
          const Text('Project URL'),
          SelectableText(project.projectUrl),
        ],
      ),
    );
  }
}
