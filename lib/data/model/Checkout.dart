class Checkout {
  final int amount;
  final String item_description;
  final String name;
  final int quantity;
  final String description;

  Checkout(
      {required this.amount,
      required this.item_description,
      required this.name,
      required this.quantity,
      required this.description});

Map<String,dynamic> toJson(){
  return{
    "data": {
      "attributes": {
        "send_email_receipt": true,
        "show_description": true,
        "show_line_items": true,
        "line_items": [
          {
            "currency": "PHP",
            "amount": amount,
            "description": item_description,
            "name": name,
            "quantity": quantity
          }
        ],
        "description": description,
        "payment_method_types": [
          "qrph"
        ]
      }
    }
  };
}
}
