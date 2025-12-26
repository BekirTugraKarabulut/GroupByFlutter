import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/db/app_db.dart';
import '../../services/connectivity_service.dart';
import '../authors/authors_page.dart';
import '../books/books_page.dart';
import '../sessions/session_page.dart';
import '../users/users_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppDb db;
  late final ConnectivityService connectivityService;
  StreamSubscription? _sub;
  String _connText = "Checking...";

  int _index = 0;

  @override
  void initState() {
    super.initState();
    db = AppDb();
    connectivityService = ConnectivityService();
    _initConn();
    _sub = connectivityService.watch().listen((r) {
      setState(() => _connText = r.name);
    });
  }

  Future<void> _initConn() async {
    final r = await connectivityService.current();
    if (mounted) setState(() => _connText = r.name);
  }

  @override
  void dispose() {
    _sub?.cancel();
    db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      UsersPage(db: db),
      AuthorsPage(db: db),
      BooksPage(db: db),
      SessionsPage(db: db),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Tracker'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                ),
                child: Text("Conn: $_connText"),
              ),
            ),
          )
        ],
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: "Users"),
          NavigationDestination(icon: Icon(Icons.edit), label: "Authors"),
          NavigationDestination(icon: Icon(Icons.book), label: "Books"),
          NavigationDestination(icon: Icon(Icons.timer), label: "Sessions"),
        ],
      ),
    );
  }
}
