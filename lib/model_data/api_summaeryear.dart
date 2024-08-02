class MonthlySummary {
  final int month;
  final double income;
  final double expense;
  final double balance;

  MonthlySummary({required this.month, required this.income, required this.expense, required this.balance});

  factory MonthlySummary.fromJson(Map<String, dynamic> json){
    return MonthlySummary(
      month: json['month'],
      income: json['total_income'].toDouble(),
      expense: json['total_expense'].toDouble(),
      balance: json['balance'].toDouble(),
    );
  }
}