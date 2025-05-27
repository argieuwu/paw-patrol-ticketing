class LineItems {
  final String name;
  final String description;
  final int quantity;
  final int amount;
  final String currency;

  LineItems({
    required this.name,
    required this.description,
    required this.quantity,
    required this.amount,
    required this.currency,
  });

  factory LineItems.fromJson(Map<String, dynamic> json) {
    return LineItems(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      quantity: json['quantity'] ?? 0,
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'amount': amount,
      'currency': currency,
    };
  }
}
