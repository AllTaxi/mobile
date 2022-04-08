import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16))
              ),
              child: Column(
                children: [
                  Text("total".tr(),style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  Image.asset("assets/total.png",width: 100,),
                  const Text("9,500 UZS",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
             itemCount: listName.length,
              itemBuilder: (BuildContext context, int index) {
               return Container(
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${price[index]} UZS"),
                                const SizedBox(height: 8,),
                                Row(
                                  children: [
                                    Image.asset("assets/saved.png",width: 24,),
                                    const SizedBox(width: 8,),
                                    Text("${priceOne[index]} UZS"),
                                  ],
                                ),
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
          ),
        ],
      ),
    );
  }
}
