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