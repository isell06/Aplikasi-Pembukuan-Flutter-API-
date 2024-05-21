class Transaction {
  final int? id;
  final String? amount;
  final int? categories_id; // Change this to String
  final DateTime? transaction_date;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  Transaction(
      {this.id,
      this.amount,
      this.categories_id,
      this.transaction_date,
      this.description,
      this.createdAt,
      this.updatedAt});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int,
      amount: json['amount'] as String,
      categories_id: int.parse(json['categories_id']), // Convert String to int
      transaction_date: json['transaction_date'] as DateTime,
      description: json['description'] as String,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['categories_id'] =
        this.categories_id.toString(); // Convert int to String
    data['transaction_date'] = this.transaction_date;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
