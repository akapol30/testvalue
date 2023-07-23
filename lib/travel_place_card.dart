import 'package:databasetest/class_list_food.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({
    Key? key,
    required this.menu,
    this.isFullCard = false,
    required this.press,
  }) : super(key: key);

  final Food menu;
  final bool isFullCard;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 158,
        child: GestureDetector(
          onTap: press,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: isFullCard ? 1.09 : 1.29,
                child: Column(
                  children: [
                    Container(
                      width: 150,
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        image: DecorationImage(
                            image: NetworkImage(menu.pic![0]),
                            fit: BoxFit.cover),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 158,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "${menu.foodname}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.w600,
                        fontSize: isFullCard ? 17 : 12,
                      ),
                    ),
                    Text("${menu.foodtype}"),
                    RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      itemSize: 15,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      updateOnDrag: true,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.red,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    Text("Rating : ${5.toStringAsFixed(2)} / 5.00"),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
