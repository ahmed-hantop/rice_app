// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:rice_delivery/features/home/data/models/products_model.dart';

// class ProductService {
//   Future<List<Products>> fetchProducts() async {
//     final response = await http.get(
//       Uri.parse('https://fakestoreapi.com/products'),
//     );

//     if (response.statusCode == 200) {
//       final List data = json.decode(response.body);
//       return data.map((e) => Products.fromJson(e)).toList();
//     } else {
//       throw Exception('Failed to load products');
//     }
//   }
// }
