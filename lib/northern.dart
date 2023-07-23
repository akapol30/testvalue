import 'package:databasetest/addmenu_north.dart';
import 'package:databasetest/class_list_food.dart';
import 'package:databasetest/travel_place_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Northern extends StatefulWidget {
  const Northern({super.key});

  @override
  State<Northern> createState() => _NorthernState();
}

class _NorthernState extends State<Northern> {
  bool isCheckedbook = false;
  bool isCheckedres = false;
  bool isCheckedbtravel = false;
  bool isCheckedpromo = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: const Text("ภาคเหนือ"), actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {},
        ),
      ]),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: Food.call(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: Column(children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isCheckedbook,
                        onChanged: (value) {
                          setState(() {
                            isCheckedbook = value!;
                          });
                        },
                      ),
                      const Text(
                        "สูตรอาหาร",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 20),
                      Checkbox(
                        value: isCheckedres,
                        onChanged: (value) {
                          setState(() {
                            isCheckedres = value!;
                          });
                        },
                      ),
                      const Text(
                        "ร้านอาหาร",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isCheckedbtravel,
                        onChanged: (value) {
                          setState(() {
                            isCheckedbtravel = value!;
                          });
                        },
                      ),
                      const Text(
                        "ท่องเที่ยว",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 32),
                      Checkbox(
                        value: isCheckedpromo,
                        onChanged: (value) {
                          setState(() {
                            isCheckedpromo = value!;
                          });
                        },
                      ),
                      const Text(
                        "โปรโมทร้าน",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Divider(
                      thickness: 2,
                      color: Colors.black54,
                    ),
                  ),
                  if (isCheckedbook == true)
                    hideMenu("สูตรอาหาร", () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (BuildContext context) => AddNorth()))
                          .then((value) {
                        setState(() {});
                      });
                    }, Food())
                  else
                    Container(),
                  if (isCheckedres == true)
                    hideMenu("ร้านอาหาร", () {}, Food())
                  else
                    Container(),
                  if (isCheckedbtravel == true)
                    hideMenu("ท่องเที่ยว", () {}, Food())
                  else
                    Container(),
                  if (isCheckedpromo == true)
                    hideMenu("โปรโมทร้าน", () {}, Food())
                  else
                    Container(),
                ]),
              );
            }),
      ),
    ));
  }

  Widget hideMenu(String name, VoidCallback press, Food food) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mitr',
                ),
              ),
              IconButton(icon: const Icon(Icons.add), onPressed: press),
            ],
          ),
        ),
        bookMenu(food),
        const Padding(
          padding: EdgeInsets.all(15),
          child: Divider(
            thickness: 2,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget bookMenu(Food food) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 25,
          children: [
            ...List.generate(
              Food.foodList.length,
              (index) => PlaceCard(
                menu: Food.foodList[index],
                isFullCard: true,
                press: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
