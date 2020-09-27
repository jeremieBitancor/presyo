class ProductPrice {
  final double retail;
  final double wholesale;

  ProductPrice({this.retail, this.wholesale});
  factory ProductPrice.fromMap(Map data) {
    data = data;
    return ProductPrice(retail: data['retail'], wholesale: data['wholesale']);
  }
  Map<String, dynamic> toJson() => {'retail': retail, 'wholesale': wholesale};
}
