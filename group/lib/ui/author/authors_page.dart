import 'package:flutter/material.dart';
import '../../data/db/app_db.dart';
import '../../data/repositories/authors_repo.dart';
import '../common/empty_view.dart';
import 'author_form_page.dart';

class AuthorsPage extends StatefulWidget {
  final AppDb db;
  const AuthorsPage({super.key, required this.db});

  @override
  State<AuthorsPage> createState() => _AuthorsPageState();
}

class _AuthorsPageState extends State<AuthorsPage> {
  late final AuthorsRepo repo;

  @override
  void initState() {
    super.initState();
    repo = AuthorsRepo(widget.db);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: repo.watchAll(),
      builder: (context, snapshot) {
        final authors = snapshot.data ?? [];
        if (authors.isEmpty) {
          return Stack(children: [const EmptyView("No authors. Add one."), _fab()]);
        }

        return Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: authors.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final a = authors[i];
                return ListTile(
                  tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  title: Text(a.fullName),
                  subtitle: Text(a.bio ?? "-"),
                  trailing: PopupMenuButton(
                    onSelected: (v) async {
                      if (v == "edit") {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AuthorFormPage(repo: repo, existing: a)),
                        );
                      } else if (v == "delete") {
                        await repo.delete(a.id);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: "edit", child: Text("Edit")),
                      PopupMenuItem(value: "delete", child: Text("Delete")),
                    ],
                  ),
                );
              },
            ),
            _fab(),
          ],
        );
      },
    );
  }

  Widget _fab() => Align(
    alignment: Alignment.bottomRight,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AuthorFormPage(repo: repo)),
          );
        },
        child: const Icon(Icons.add),
      ),
    ),
  );
}
