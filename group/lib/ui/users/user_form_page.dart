import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import '../../data/db/app_db.dart';
import '../../data/repositories/users_repo.dart';

class UserFormPage extends StatefulWidget {
  final UsersRepo repo;
  final User? existing;
  const UserFormPage({super.key, required this.repo, this.existing});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();

  @override
  void initState() {
    super.initState();
    final u = widget.existing;
    if (u != null) {
      _name.text = u.name;
      _email.text = u.email ?? "";
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit User" : "Add User")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: "Name")),
            const SizedBox(height: 12),
            TextField(controller: _email, decoration: const InputDecoration(labelText: "Email (optional)")),
            const Spacer(),
            FilledButton(
              onPressed: () async {
                final name = _name.text.trim();
                final email = _email.text.trim();
                if (name.length < 2) return;

                if (isEdit) {
                  final u = widget.existing!;
                  await widget.repo.update(u.copyWith(name: name, email: Value(email.isEmpty ? null : email)));
                } else {
                  await widget.repo.add(name, email.isEmpty ? null : email);
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
