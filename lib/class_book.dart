class Foodsql {
  String? foodname, foodtype, region, recipetype;
  List<dynamic>? ingredient, quantity, uom, step, pic;

  Foodsql({
    required this.foodname,
    required this.foodtype,
    required this.region,
    required this.recipetype,
    required this.ingredient,
    required this.quantity,
    required this.uom,
    required this.step,
    required this.pic,
  });
}
