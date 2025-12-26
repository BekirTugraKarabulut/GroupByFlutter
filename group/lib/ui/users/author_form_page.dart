import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import '../../data/db/app_db.dart';
import '../../data/repositories/authors_repo.dart';

class AuthorFormPage extends StatefulWidget {
  final AuthorsRepo repo;
  final Author? existing;
  const AuthorFormPage({super.key, required this.repo, this.existing});

  @override
  State<AuthorFormPage> createState() => _AuthorFormPageState();
}

class _AuthorFormPageState extends State<AuthorFormPage> {
  final _name = TextEditingController();
  final _bio = TextEditingController();

  @override
  void initState() {
    super.initState();
    final a = widget.existing;
    if (a != null) {
      _name.text = a.fullName;
      _bio.text = a.bio ?? "";
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Author" : "Add Author")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: "Full name")),
            const SizedBox(height: 12),
            TextField(controller: _bio, decoration: const InputDecoration(labelText: "Bio (optional)")),
            const Spacer(),
            FilledButton(
              onPressed: () async {
                final name = _name.text.trim();
                final bio = _bio.text.trim();
                if (name.length < 2) return;

                if (isEdit) {
                  final a = widget.existing!;
                  await widget.repo.update(a.copyWith(fullName: name, bio: Value(bio.isEmpty ? null : bio)));
                } else {
                  await widget.repo.add(name, bio.isEmpty ? null : bio);
                }
                if (mounted) Navigator.pop(context);
              },
              child: Text(isEdit ? "Save" : "Create"),
            )
          ],
        ),
      ),
    );
  }
}
