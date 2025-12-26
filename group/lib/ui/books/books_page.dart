import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/db/app_db.dart';
import '../../data/repositories/books_repo.dart';
import '../common/empty_view.dart';
import 'book_form_page.dart';

class BooksPage extends StatefulWidget {
  final AppDb db;
  const BooksPage({super.key, required this.db});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  late final BooksRepo repo;

  @override
  void initState() {
    super.initState();
    repo = BooksRepo(widget.db);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: repo.watchAll(),
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return Stack(children: [const EmptyView("No books. Add one."), _fab()]);
        }

        return Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final it = items[i];
                final cover = it.book.coverPath;

                return ListTile(
                  tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  leading: cover == null
                      ? const CircleAvatar(child: Icon(Icons.book))
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(cover),
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(it.book.title),
                  subtitle: Text("${it.author.fullName} • ${it.book.totalPages} pages"),
                  trailing: PopupMenuButton(
                    onSelected: (v) async {
                      if (v == "edit") {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookFormPage(repo: repo, existing: it.book),
                          ),
                        );
                      } else if (v == "delete") {
                        await repo.delete(it.book.id);
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
            MaterialPageRoute(builder: (_) => BookFormPage(repo: repo)),
          );
        },
        child: const Icon(Icons.add),
      ),
    ),
  );
}
