import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import '../../data/db/app_db.dart';
import '../../data/repositories/books_repo.dart';
import '../../services/image_service.dart';

class BookFormPage extends StatefulWidget {
  final BooksRepo repo;
  final Book? existing;
  const BookFormPage({super.key, required this.repo, this.existing});

  @override
  State<BookFormPage> createState() => _BookFormPageState();
}

class _BookFormPageState extends State<BookFormPage> {
  final _title = TextEditingController();
  final _pages = TextEditingController();
  final imageService = ImageService();

  int? _authorId;
  String? _coverPath;
  List<Author> _authors = [];

  @override
  void initState() {
    super.initState();
    _loadAuthors();
    final b = widget.existing;
    if (b != null) {
      _title.text = b.title;
      _pages.text = b.totalPages.toString();
      _authorId = b.authorId;
      _coverPath = b.coverPath;
    }
  }

  Future<void> _loadAuthors() async {
    final list = await widget.repo.authors();
    if (mounted) {
      setState(() {
        _authors = list;
        _authorId ??= list.isNotEmpty ? list.first.id : null;
      });
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _pages.dispose();
    super.dispose();
  }

  Future<void> _pickCoverFromGallery() async {
    final p = await imageService.pickFromGallery();
    if (!mounted) return;
    if (p != null) setState(() => _coverPath = p);
  }

  Future<void> _pickCoverFromCamera() async {
    final p = await imageService.pickFromCamera();
    if (!mounted) return;
    if (p != null) setState(() => _coverPath = p);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Book" : "Add Book")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Cover preview container
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Theme.of(context).colorScheme.outline),
              ),
              child: Center(
                child: _coverPath == null
                    ? const Text("Choose a cover image")
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(
                    File(_coverPath!),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Gallery + Camera actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickCoverFromGallery,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text("Gallery"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickCoverFromCamera,
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: const Text("Camera"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            TextField(controller: _title, decoration: const InputDecoration(labelText: "Title")),
            const SizedBox(height: 12),
            TextField(
              controller: _pages,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Total pages"),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: _authorId,
              items: _authors.map((a) => DropdownMenuItem(value: a.id, child: Text(a.fullName))).toList(),
              onChanged: (v) => setState(() => _authorId = v),
              decoration: const InputDecoration(labelText: "Author"),
            ),

            const Spacer(),
            FilledButton(
              onPressed: _authors.isEmpty
                  ? null
                  : () async {
                final title = _title.text.trim();
                final pages = int.tryParse(_pages.text.trim()) ?? 0;
                final authorId = _authorId;

                if (title.isEmpty || authorId == null) return;

                if (isEdit) {
                  final b = widget.existing!;
                  await widget.repo.update(
                    b.copyWith(
                      title: title,
                      authorId: authorId,
                      totalPages: pages,
                      coverPath: Value(_coverPath),
                    ),
                  );
                } else {
                  await widget.repo.add(
                    title: title,
                    authorId: authorId,
                    totalPages: pages,
                    coverPath: _coverPath,
                  );
                }
                if (mounted) Navigator.pop(context);
              },
              child: Text(isEdit ? "Save" : "Create"),
            ),
            if (_authors.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text("Add at least one author first."),
              ),
          ],
        ),
      ),
    );
  }
}
