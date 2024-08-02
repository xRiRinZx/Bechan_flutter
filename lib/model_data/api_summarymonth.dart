
class SummaryMonthData{
  final double totalIncome;
  final double totalExpense;
  final double balance;

  SummaryMonthData({required this.totalIncome, required this.totalExpense, required this.balance});

  factory SummaryMonthData.fromJson(Map<String, dynamic>json) {
    return SummaryMonthData(
      totalIncome: json['total_income'].toDouble(),
      totalExpense: json['total_expense'].toDouble(),
      balance: json['balance'].toDouble(),
    );
  }
  @override
  String toString() {
    return 'Summary(totalIncome: $totalIncome, totalExpense: $totalExpense, balance: $balance)';
  }
}

class CategoryData {
  final String name;
  final double amount;

  CategoryData({required this.name, required this.amount});

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      name: json['categorie_name'],
      amount: json['amount'].toDouble(),
    );
  }
}

class TagData {
  final String name;
  final double income;
  final double expense;

  TagData({required this.name, required this.expense, required this.income});

  factory TagData.fromJson(Map<String, dynamic> json) {
    return TagData(
      name: json['tag_name'],
      income: json['income'].toDouble(),
      expense:  json['expense'].toDouble(),
    );
  }
}