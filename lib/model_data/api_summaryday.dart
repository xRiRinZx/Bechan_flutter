
class Summary {
  final double totalIncome;
  final double totalExpense;

  Summary({required this.totalIncome, required this.totalExpense});

  factory Summary.fromJson(Map<String, dynamic>json) {
    return Summary(
      totalIncome: json['total_income'].toDouble(),
      totalExpense: json['total_expense'].toDouble(),
    );
  }
  @override
  String toString() {
    return 'Summary(totalIncome: $totalIncome, totalExpense: $totalExpense)';
  }
}

class Transaction {
  final int transactionsId;
  final int categorieId;
  final double amount;
  final String note;
  final String detail;
  final String transactionDatetime;
  final String categoriename;
  final String categorieType;
  final int fav;
  final List<Tag> tags;

  Transaction({
    required this.transactionsId,
    required this.categorieId,
    required this.amount,
    required this.note,
    required this.detail,
    required this.transactionDatetime,
    required this.categorieType,
    required this.categoriename,
    required this.fav,
    required this.tags,
  });

  factory Transaction.fromJson(Map <String, dynamic> json) {
    var tagsList = json['tags'] as List;
    List<Tag> tagList = tagsList.map((i) => Tag.fromJson(i)).toList();
    return Transaction(
      transactionsId: json['transactions_id'],
      categorieId: json['categorie_id'],
      amount:  json['amount'].toDouble(),
      note: json['note'],
      detail: json['detail'] ?? '',
      transactionDatetime: json['transaction_datetime'],
      fav: json['fav'],
      categoriename: json['categorie_name'],
      categorieType: json['categorie_type'],
      tags: tagList,
    );
  }
  @override
  String toString() {
    return 'Transactions(transactionsId: $transactionsId, categorieId: $categorieId, amount:  $amount, note: $note, detail: $detail, transactionDatetime: $transactionDatetime, fav: $fav, categoriename: $categoriename, categorieType: $categorieType, tags: $tags,)';
  }
}

class Tag {
  final int tagId;
  final String tagName;

  Tag({
    required this.tagId,
    required this.tagName,
  });

  factory Tag.fromJson(Map <String, dynamic> json) {
    return Tag(
      tagId: json['tag_id'],
      tagName: json['tag_name'],
    );
  }
}

class Pagination {
  final int page;
  final int pageSize;
  final int pageTotal;
  final int totalTramsactions;

  Pagination({
    required this.page,
    required this.pageSize,
    required this.pageTotal,
    required this.totalTramsactions,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      pageSize: json['page_size'],
      pageTotal: json['page_total'],
      totalTramsactions: json['total_transactions'],
    );
  }

  bool get hasNextPage => page < pageTotal;
}
