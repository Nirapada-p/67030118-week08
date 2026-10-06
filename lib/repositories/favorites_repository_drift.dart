import 'package:drift/drift.dart';
import '../database/app_database.dart';
import 'favorites_repository.dart';

class FavoritesRepositoryDrift implements FavoritesRepository {
  final AppDatabase _db;

  // รับ AppDatabase เข้ามาทาง Constructor
  FavoritesRepositoryDrift(this._db);

  @override
  Future<void> addFavorite(
    int itemId,
    String title,
    double price,
    String imageUrl,
  ) async {
    // ใช้ InsertMode.insertOrIgnore เพื่อป้องกัน Error กดถูกใจซ้ำ
    await _db
        .into(_db.favoriteItems)
        .insert(
          FavoriteItemsCompanion(
            itemId: Value(itemId),
            title: Value(title),
            price: Value(price),
            imageUrl: Value(imageUrl),
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  @override
  Future<List<FavoriteItem>> getAllFavorites() async {
    // ดึงข้อมูลและเรียงลำดับตาม addedAt จากใหม่ไปเก่า (desc)
    return await (_db.select(_db.favoriteItems)..orderBy([
          (t) => OrderingTerm(expression: t.addedAt, mode: OrderingMode.desc),
        ]))
        .get();
  }

  @override
  Future<void> removeFavorite(int itemId) async {
    // ลบข้อมูลโดยอ้างอิงจาก itemId
    await (_db.delete(
      _db.favoriteItems,
    )..where((t) => t.itemId.equals(itemId))).go();
  }
}
