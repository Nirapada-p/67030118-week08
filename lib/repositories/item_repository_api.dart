import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/item.dart';
import 'item_repository.dart';

class ItemRepositoryApi implements ItemRepository {
  static const _baseUrl = 'https://fakestoreapi.com/products';

  @override
  Future<List<Item>> getItems() async {
    final uri = Uri.parse(_baseUrl);

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data
            .map((e) => Item.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      // ถ้า API ใช้งานไม่ได้ ให้ใช้ข้อมูลสำรอง
      return _fallbackItems;
    } on TimeoutException {
      return _fallbackItems;
    } on http.ClientException {
      return _fallbackItems;
    } on FormatException {
      return _fallbackItems;
    } catch (e) {
      return _fallbackItems;
    }
  }

  static const List<Item> _fallbackItems = [
    Item(
      id: 1,
      title: 'กระเป๋านักศึกษา',
      price: 350.0,
      description:
          'กระเป๋าสำหรับนักศึกษา เหมาะสำหรับใส่หนังสือและอุปกรณ์การเรียน',
      category: 'กระเป๋า',
      imageUrl: 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
    ),
    Item(
      id: 2,
      title: 'เสื้อแจ็กเก็ตแฟชั่น',
      price: 890.0,
      description: 'เสื้อแจ็กเก็ตสำหรับใส่ในชีวิตประจำวัน',
      category: 'เสื้อผ้า',
      imageUrl: 'https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg',
    ),
    Item(
      id: 3,
      title: 'เสื้อแขนสั้นผู้ชาย',
      price: 490.0,
      description: 'เสื้อแขนสั้นใส่สบาย เหมาะสำหรับนักศึกษา',
      category: 'เสื้อผ้า',
      imageUrl: 'https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_.jpg',
    ),
    Item(
      id: 4,
      title: 'แหวนแฟชั่น',
      price: 299.0,
      description: 'แหวนแฟชั่นสำหรับใส่ในชีวิตประจำวัน',
      category: 'เครื่องประดับ',
      imageUrl:
          'https://fakestoreapi.com/img/61sbMiUnoGL._AC_UL640_QL65_ML3_.jpg',
    ),
    Item(
      id: 5,
      title: 'สร้อยคอแฟชั่น',
      price: 599.0,
      description: 'สร้อยคอแฟชั่นดีไซน์เรียบง่าย',
      category: 'เครื่องประดับ',
      imageUrl: 'https://fakestoreapi.com/img/71YAIFU48IL._AC_UY879_.jpg',
    ),
  ];
}
