import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import '../../data/db/app_db.dart';
import '../../data/repositories/sessions_repo.dart';

class SessionFormPage extends StatefulWidget {
  final SessionsRepo repo;
  final ReadingSession? existing;
  const SessionFormPage({super.key, required this.repo, this.existing});

  @override
  State<SessionFormPage> createState() => _SessionFormPageState();
}

class _SessionFormPageState extends State<SessionFormPage> {
  final _pages = TextEditingController();
  final _minutes = TextEditingController();
  final _note = TextEditingController();

  int? _userId;
  int? _bookId;
  DateTime _date = DateTime.now();

  List<User> _users = [];
  List<Book> _books = [];

  @override
  void initState() {
    super.initState();
    _load();
    final s = widget.existing;
    if (s != null) {
      _pages.text = s.pagesRead.toString();
      _minutes.text = s.minutes.toString();
      _note.text = s.note ?? "";
      _userId = s.userId;
      _bookId = s.bookId;
      _date = s.sessionDate;
    }
  }

  Future<void> _load() async {
    final users = await widget.repo.users();
    final books = await widget.repo.books();
    if (mounted) {
      setState(() {
        _users = users;
        _books = books;
        _userId ??= users.isNotEmpty ? users.first.id : null;
        _bookId ??= books.isNotEmpty ? books.first.id : null;
      });
    }
  }

  @override
  void dispose() {
    _pages.dispose();
    _minutes.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Session" : "Add Session")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              value: _userId,
              items: _users.map((u) => DropdownMenuItem(value: u.id, child: Text(u.name))).toList(),
              onChanged: (v) => setState(() => _userId = v),
              decoration: const InputDecoration(labelText: "User"),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: _bookId,
              items: _books.map((b) => DropdownMenuItem(value: b.id, child: Text(b.title))).toList(),
              onChanged: (v) => setState(() => _bookId = v),
              decoration: const InputDecoration(labelText: "Book"),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pages,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Pages read"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _minutes,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Minutes"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(controller: _note, decoration: const InputDecoration(labelText: "Note (optional)")),
            const SizedBox(height: 12),
            Row(
              children: [
                Text("Date: ${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}"),
                const Spacer(),
                OutlinedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialDate: _date,
                    );
                    if (picked != null) setState(() => _date = picked);
                  },
                  child: const Text("Pick date"),
                )
              ],
            ),
            const Spacer(),
            FilledButton(
              onPressed: (_users.isEmpty || _books.isEmpty)
                  ? null
                  : () async {
                final userId = _userId;
                final bookId = _bookId;
                if (userId == null || bookId == null) return;

                final pages = int.tryParse(_pages.text.trim()) ?? 0;
                final minutes = int.tryParse(_minutes.text.trim()) ?? 0;
                final note = _note.text.trim();

                if (isEdit) {
                  final s = widget.existing!;
                  await widget.repo.update(
                    s.copyWith(
                      userId: userId,
                      bookId: bookId,
                      pagesRead: pages,
                      minutes: minutes,
                      sessionDate: _date,
                      note: Value(note.isEmpty ? null : note),
                    ),
                  );
                } else {
                  await widget.repo.add(
                    userId: userId,
                    bookId: bookId,
                    sessionDate: _date,
                    pagesRead: pages,
                    minutes: minutes,
                    note: note.isEmpty ? null : note,
                  );
                }
                if (mounted) Navigator.pop(context);
              },
              child: Text(isEdit ? "Save" : "Create"),
            ),
            if (_users.isEmpty || _books.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text("Add at least one user and one book first."),
              ),
          ],
        ),
      ),
    );
  }
}
