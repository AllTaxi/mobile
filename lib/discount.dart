import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Discount extends StatefulWidget {
  const Discount({Key? key}) : super(key: key);

  @override
  State<Discount> createState() => _DiscountState();
}

class _DiscountState extends State<Discount> {
  List listName = [
    "Mahtumquli ko`chasi, 45",
    "Mahtumquli ko`chasi, 45",
    "Yangi Olmazor ko`chasi, 51",
  ];
  List listNameTwo = [
    "Yangi Olmazor ko`chasi, 51",
    "Amir Temur Avenue, 97A",
    "Bunyodkor Avenue, 52",
  ];

  List price = [
    "16,400",
    "17,200",
    "20,700",
  ];

  List priceOne = [
    "1,600",
    "4,100",
    "3,800",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text("my_order".tr(),style: const TextStyle(color: Colors.black),),
      ),
      body: ListView.builder(
        itemCount: listName.length,
        itemBuilder: (BuildContext context, int index) { return Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Text(listName[index],style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                      Text(listNameTwo[index],style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                      Row(
                        children: [
                          Text("${price[index]} UZS"),
                          const SizedBox(width: 64,),
                          Image.asset("assets/saved.png"),
                          const SizedBox(width: 8,),
                          Text("${priceOne[index]} UZS"),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: Image.asset(
                      "assets/car3.png"),
                  height: 24,
                ),
              ],
            ),
          ),
        ); },
      ),
    );
  }
}
