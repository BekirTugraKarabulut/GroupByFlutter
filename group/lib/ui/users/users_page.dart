import 'package:flutter/material.dart';
import '../../data/db/app_db.dart';
import '../../data/repositories/users_repo.dart';
import '../common/empty_view.dart';
import 'user_form_page.dart';

class UsersPage extends StatefulWidget {
  final AppDb db;
  const UsersPage({super.key, required this.db});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late final UsersRepo repo;

  @override
  void initState() {
    super.initState();
    repo = UsersRepo(widget.db);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: repo.watchAll(),
      builder: (context, snapshot) {
        final users = snapshot.data ?? [];
        if (users.isEmpty) {
          return Stack(
            children: [
              const EmptyView("No users. Add one."),
              _fab(),
            ],
          );
        }

        return Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final u = users[i];
                return ListTile(
                  tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  title: Text(u.name),
                  subtitle: Text(u.email ?? "-"),
                  trailing: PopupMenuButton(
                    onSelected: (v) async {
                      if (v == "edit") {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => UserFormPage(repo: repo, existing: u)),
                        );
                      } else if (v == "delete") {
                        await repo.delete(u.id);
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

  Widget _fab() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UserFormPage(repo: repo)),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
