import 'package:flutter/material.dart';
import '../data/models/book.dart';

class AddBookScreen extends StatefulWidget {
  final Function(Book) onAddBook;

  const AddBookScreen({super.key, required this.onAddBook});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _author;
  late String _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Kitap Ekle'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kitap Bilgileri',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Kitap Adı',
                  hintText: 'Kitabın adını giriniz',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.book),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen kitap adını giriniz';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Yazar Adı',
                  hintText: 'Yazarın adını giriniz',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen yazar adını giriniz';
                  }
                  return null;
                },
                onSaved: (value) {
                  _author = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Açıklama',
                  hintText: 'Kitap hakkında açıklama yazınız',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen açıklama giriniz';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Kitabı Ekle'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newBook = Book(
        id: DateTime.now().toString(),
        title: _title,
        author: _author,
        description: _description,
        addedDate: DateTime.now(),
      );

      widget.onAddBook(newBook);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kitap başarıyla eklendi!'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
    }
  }
}
