import 'dart:convert';
import 'dart:io';
import 'package:capstone2/data/model/UserCheckout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class Apiservice {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  final String secretKey =
      ' ;sk_test_899mPkGNAeddzutaZibPTV4U'; // Yes aware ko haha
  late String basicAuth;
  Apiservice() {
    basicAuth = 'Basic ${base64Encode(utf8.encode('$secretKey:'))}';
  }

  Future<UserCheckout> createCheckout(Map<String, dynamic> userPost) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.paymongo.com/v1/checkout_sessions'),
        headers: <String, String>{
          HttpHeaders.authorizationHeader: basicAuth,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userPost),
      );

      if (response.statusCode == 200) {
        return UserCheckout.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'No internet connection. Please check your connection and try again.');
      }
    } catch (_) {
      throw Exception(
          'No internet connection. Please check your connection and try again.');
    }
  }

  Future<UserCheckout> getCheckout(String id) async {
    final response = await http.get(
        Uri.parse('https://api.paymongo.com/v1/checkout_sessions/$id'),
        headers: {
          HttpHeaders.authorizationHeader: basicAuth,
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200) {
      return UserCheckout.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('API error: ${response.body}');
    }
  }

  Future<String> expireCheckout(String id) async {
    final response = await http.post(
      Uri.parse('https://api.paymongo.com/v1/checkout_sessions/$id/expire'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return "$id : has been Expired";
    } else {
      throw Exception('API error: ${response.body}');
    }
  }
}
