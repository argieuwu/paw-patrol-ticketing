import 'package:cloud_firestore/cloud_firestore.dart';
import 'Items.dart';

class UserCheckout {
  final String id;
  final String type;
  final String email;
  final String checkoutURL;
  final String client_key;
  final String description;
  final List<LineItems> items;
  final String status;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  UserCheckout({
    required this.id,
    required this.type,
    required this.email,
    required this.checkoutURL,
    required this.client_key,
    required this.description,
    required this.items,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory UserCheckout.fromJson(Map<String, dynamic> json) {
    final attributes = json['data']['attributes'];
    final lineItemsList = (attributes['line_items'] as List<dynamic>)
        .map((item) => LineItems.fromJson(item))
        .toList();
    return UserCheckout(
      id: json['data']['id'],
      type: json['data']['type'],
      email: attributes['customer_email'] ?? '',
      checkoutURL: attributes['checkout_url'] ?? '',
      client_key: attributes['client_key'] ?? '',
      description: attributes['description'] ?? '',
      items: lineItemsList,
      status: attributes['status'] ?? '',
      createdAt: attributes['created_at'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(
              attributes['created_at'] * 1000)
          : null,
      updatedAt: attributes['updated_at'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(
              attributes['updated_at'] * 1000)
          : null,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'type': type,
      'email': email,
      'checkoutURL': checkoutURL,
      'client_key': client_key,
      'description': description,
      'items': items.map((e) => e.toJson()).toList(),
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
