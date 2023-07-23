import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:json_annotation/json_annotation.dart';
part 'class_list_food.g.dart';

@JsonSerializable(explicitToJson: true)
class MyCard {
  String? foodname, foodtype, region, recipetype;
  List<dynamic>? ingredient, quantity, uom, step, pic;

  MyCard({
    required this.foodname,
    required this.foodtype,
    required this.ingredient,
    required this.quantity,
    required this.uom,
    required this.step,
    required this.pic,
    required this.region,
    required this.recipetype,
  });

  factory MyCard.fromJson(Map<String, String> json) => _$MyCardFromJson(json);

  Map<String, dynamic> toJson() => _$MyCardToJson(this);
}

@JsonSerializable()
class Food extends MyCard {
  @override
  String? foodname, foodtype, region, recipetype;

  @override
  final List<dynamic>? ingredient, quantity, uom, step, pic;

  Food({
    this.foodname,
    this.foodtype,
    this.ingredient,
    this.quantity,
    this.uom,
    this.step,
    this.pic,
    this.region,
    this.recipetype,
  }) : super(
          foodname: foodname,
          foodtype: foodtype,
          ingredient: ingredient,
          quantity: quantity,
          uom: uom,
          step: step,
          pic: pic,
          region: region,
          recipetype: recipetype,
        );

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);

  Map<String, dynamic> foodtoJson() => _$FoodToJson(this);

  static List<Food> foodList = [];

  static Future<List<Food>> call() async {
    final foodRef = FirebaseFirestore.instance
        .collection('ListRecipesNorth')
        .withConverter<Food>(
          fromFirestore: (snapshot, _) => Food.fromJson(snapshot.data()!),
          toFirestore: (food, _) => food.foodtoJson(),
        );

    await foodRef.get().then((QuerySnapshot snapshot) => {
          if (foodList.length != snapshot.docs.length)
            {
              snapshot.docs.forEach((doc) {
                foodList.add(Food(
                  foodname: doc["Bfoodname"],
                  foodtype: doc["Bfoodtype"],
                  ingredient: doc["Bingredient"],
                  quantity: doc["Bquantity"],
                  uom: doc["Buom"],
                  step: doc["Bstep"],
                  pic: doc["Bpicfood"],
                  region: doc["Bregion"],
                  recipetype: doc["Brecipetype"],
                ));
              })
            }
        });

    return foodList;
  }
}
/*
@JsonSerializable()
class Beverage extends MyCard {
  @override
  final String id,
      foodname,
      foodtype,
      namepro,
      picpro,
      time,
      favorite,
      dianamepro,
      diapicpro,
      diatime,
      note,
      desc,
      flav,
      region,
      recipetype;
  @override
  final List<String> ingredient, quantity, uom, step, pic, dianote;

  @override
  final double rating;
  @override
  Beverage(
      {required this.id,
      required this.foodname,
      required this.foodtype,
      required this.namepro,
      required this.picpro,
      required this.time,
      required this.favorite,
      required this.dianamepro,
      required this.diapicpro,
      required this.diatime,
      required this.note,
      required this.ingredient,
      required this.quantity,
      required this.uom,
      required this.step,
      required this.pic,
      required this.dianote,
      required this.region,
      required this.recipetype,
      required this.desc,
      required this.flav,
      required this.rating})
      : super(
            id: id,
            foodname: foodname,
            foodtype: foodtype,
            namepro: namepro,
            picpro: picpro,
            time: time,
            favorite: favorite,
            dianamepro: dianamepro,
            diapicpro: diapicpro,
            diatime: diatime,
            note: note,
            ingredient: ingredient,
            quantity: quantity,
            uom: uom,
            step: step,
            pic: pic,
            dianote: dianote,
            region: region,
            recipetype: recipetype,
            desc: desc,
            flav: flav,
            rating: rating);

  factory Beverage.fromJson(Map<String, dynamic> json) =>
      _$BeverageFromJson(json);

  Map<String, dynamic> foodtoJson() => _$BeverageToJson(this);
  static var beverageList = [];
}
*/
