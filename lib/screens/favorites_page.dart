import 'package:flutter/material.dart';

import '../repositories/favorites_repository.dart';

class FavoritesPage extends StatefulWidget {
  final FavoritesRepository repository;

  const FavoritesPage({super.key, required this.repository});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<FavoriteItem>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = widget.repository.getAllFavorites();
  }

  Future<void> _removeFavorite(int itemId) async {
    try {
      await widget.repository.removeFavorite(itemId);

      if (!mounted) return;

      setState(() {
        _favoritesFuture = widget.repository.getAllFavorites();
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ลบออกจากรายการโปรดแล้ว')));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ไม่สามารถลบรายการโปรดได้: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายการโปรด')),
      body: FutureBuilder<List<FavoriteItem>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          // กำลังโหลด
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // เกิดข้อผิดพลาด
          if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          }

          final favorites = snapshot.data ?? [];

          // ไม่มีรายการโปรด
          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'ยังไม่มีรายการโปรด\nลองกดหัวใจที่หน้าหลักดูสิ',
                textAlign: TextAlign.center,
              ),
            );
          }

          // มีรายการโปรด
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];

              return ListTile(
                leading: Image.network(
                  favorite.imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                ),
                title: Text(favorite.title),
                subtitle: Text('${favorite.price} บาท'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'ลบออกจากรายการโปรด',
                  onPressed: () {
                    _removeFavorite(favorite.itemId);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
