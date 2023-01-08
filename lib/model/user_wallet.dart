class Khaltiwallet {
  String? amount;

  Khaltiwallet({
    this.amount,
  });

  Map<String, dynamic> toJson() => {
        'amount': amount,
      };
}
