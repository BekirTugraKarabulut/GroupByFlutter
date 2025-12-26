import 'package:flutter/material.dart';
import '../../data/db/app_db.dart';
import '../../data/repositories/sessions_repo.dart';
import '../common/empty_view.dart';
import 'session_form_page.dart';

class SessionsPage extends StatefulWidget {
  final AppDb db;
  const SessionsPage({super.key, required this.db});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  late final SessionsRepo repo;

  @override
  void initState() {
    super.initState();
    repo = SessionsRepo(widget.db);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: repo.watchAll(),
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return Stack(children: [const EmptyView("No sessions. Add one."), _fab()]);
        }

        return Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final s = items[i];
                final date = "${s.session.sessionDate.year}-${s.session.sessionDate.month.toString().padLeft(2, '0')}-${s.session.sessionDate.day.toString().padLeft(2, '0')}";

                return ListTile(
                  tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  title: Text("${s.book.title} • ${s.author.fullName}"),
                  subtitle: Text("${s.user.name} • $date • ${s.session.pagesRead} pages • ${s.session.minutes} min"),
                  trailing: PopupMenuButton(
                    onSelected: (v) async {
                      if (v == "edit") {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SessionFormPage(repo: repo, existing: s.session)),
                        );
                      } else if (v == "delete") {
                        await repo.delete(s.session.id);
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
            MaterialPageRoute(builder: (_) => SessionFormPage(repo: repo)),
          );
        },
        child: const Icon(Icons.add),
      ),
    ),
  );
}
