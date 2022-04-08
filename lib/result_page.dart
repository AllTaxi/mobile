import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:alltaxi/search_page.dart';
import "package:easy_localization/src/public_ext.dart";
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class ResultPage extends StatefulWidget {
  final String startPlace;
  final String startPlaceSub;
  final String endPlace;
  final String endPlaceSub;
  final Future<DrivingSessionResult> result;
  final DrivingSession session;
  final Placemark startPlacemark;
  final Placemark endPlacemark;

  ResultPage(this.startPlacemark, this.endPlacemark, this.session, this.result,
      this.startPlace, this.endPlace, this.startPlaceSub, this.endPlaceSub);

  @override
  _SessionState createState() => _SessionState();
}

class _SessionState extends State<ResultPage> {
  late final List<MapObject> mapObjects = [
    widget.startPlacemark,
    widget.endPlacemark
  ];
  YandexMapController? controller;
  int carIndex = 1;
  int carPrice = 1;
  List<CarPriceModel> list = <CarPriceModel>[];
  List<CarPriceModel> listTwo = <CarPriceModel>[];

  final List<DrivingSessionResult> results = [];
  bool _progress = true;
  var data;
  double? inDriver;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    _close();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          height: 80,
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 16,
              top: 8,
              right: 32,
              left: 32),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: AnimationButtonEffect(
            child: GestureDetector(
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (_) {
                  return FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 5)),
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.done) {
                          Navigator.pop(context);
                        }
                        return Dialog(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children:  [
                                  const SizedBox(height: 8),
                                  Text(
                                    "request_failed".tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 24,color: Colors.black),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "unfortunately".tr(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16,color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                );
              },
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.all(Radius.circular(16))
                  ),
                  padding: const EdgeInsets.all(8),
                  child:  Center(child: Text("order".tr(),style:
                  const TextStyle(color: Colors.black,fontSize: 18),))),
            ),
          ),
          color: const Color(0xffF3F3F3).withOpacity(0.5),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              YandexMap(
                  mapObjects: mapObjects,
                  onMapCreated:
                      (YandexMapController yandexMapController) async {
                    controller = yandexMapController;
                    await controller!.moveCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          zoom: 14,
                          target: Point(
                              latitude: widget.startPlacemark.point.latitude,
                              longitude:
                                  widget.startPlacemark.point.longitude)),
                    ));
                  }),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SuggestionsExample(
                                      position: position!,
                                      long: widget.endPlacemark.point.longitude,
                                      title: widget.endPlace,
                                      lat: widget.endPlacemark.point.latitude, text: widget.endPlaceSub,
                                      start: false,
                                    )));
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_history,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(widget.startPlace)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SuggestionsExample(
                                      position: position!,
                                      long: widget.startPlacemark.point.longitude,
                                      title: widget.startPlace,
                                      lat: widget.startPlacemark.point.latitude, text: widget.startPlaceSub,
                                    )));
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.location_history),
                              const SizedBox(width: 8),
                              Expanded(child: Text(widget.endPlace)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            GestureDetector(
                              child: Container(
                                child: Image.asset("assets/yandex.png"),
                                width: 56,
                                height: 56,
                                decoration:  BoxDecoration(
                                  border: Border.all(color: carIndex == 1 ? Colors.black : Colors.transparent,width: 2),
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(16))),
                              ),
                              onTap: () => _changeCar(1),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () => _changeCar(2),
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration:  BoxDecoration(
                                    image: const DecorationImage(
                                        image: AssetImage("assets/mytaxi.png")),
                                    border: Border.all(color: carIndex == 2 ? Colors.black : Colors.transparent,width: 2),
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(16))),
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () => _changeCar(3),
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration:  BoxDecoration(
                                    image: const DecorationImage(
                                        image: AssetImage("assets/millenium1.png")),
                                    border: Border.all(color: carIndex == 3 ? Colors.black : Colors.grey,width:  carIndex == 3 ? 2 :1 ),
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(16))),
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () => _changeCar(4),
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration:  BoxDecoration(
                                    image: const DecorationImage(
                                        image: AssetImage("assets/indriver.png")),
                                    border: Border.all(color: carIndex == 4 ? Colors.black : Colors.transparent,width: 2),
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(16))),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: carIndex != 4 ? double.infinity : 140,
                          height: 70,
                          child: _progress ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (con, index) => GestureDetector(
                              onTap: (){
                                carPrice = index;
                                setState(() {});
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 16),
                                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                                decoration: BoxDecoration(
                                    color: carPrice == index ? Colors.grey.withOpacity(0.5) : Colors.grey.withOpacity(0.1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(16))),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Image.asset(
                                          "assets/car3.png"),
                                      height: 24,
                                    ),
                                    const Text(
                                      "",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    const Text(
                                      "",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ) : carIndex != 4 ?
                          ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: carIndex == 1 ? data["options"].length : carIndex == 2 ? list.length : listTwo.length,
                            itemBuilder: (con, index) => GestureDetector(
                              onTap: (){
                                carPrice = index;
                                setState(() {});
                              },
                              child: Container(
                              margin: const EdgeInsets.only(right: 16),
                              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                              decoration: BoxDecoration(
                                  color: carPrice == index ? Colors.grey.withOpacity(0.5) : Colors.grey.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16))),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Image.asset(
                                        "assets/car3.png"),
                                    height: 24,
                                  ),
                                  Text(
                                    carIndex == 1 ? "${data["options"][index]["class_name"].toUpperCase().substring(0,1)}"
                                        "${data["options"][index]["class_name"].substring(1).toLowerCase()}" : (carIndex == 2) ? list[index].name! : listTwo[index].name!,
                                    style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                  ),
                                   Text(
                                     carIndex == 1 ?  NumberFormat.simpleCurrency(locale: 'uz',
                                         name: "so`m",decimalDigits: 0).format(data["options"][index]["price"]).toString()
                                         : NumberFormat.simpleCurrency(locale: 'uz',
                                         name: "so`m",decimalDigits: 0).format((carIndex == 2) ? list[index].price : listTwo[index].price).toString(),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                                ),
                            ),
                          ) :
                          GestureDetector(
                            onTap: (){},
                            child: Container(
                              margin: const EdgeInsets.only(right: 16),
                              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                              decoration: BoxDecoration(
                                  color:  Colors.grey.withOpacity(0.5),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16))),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Image.asset(
                                        "assets/car3.png"),
                                    height: 24,
                                  ),
                                  const Text(
                                    "Avarage taxi fare",
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    NumberFormat.simpleCurrency(locale: 'uz',
                                        name: "so`m",decimalDigits: 0).format(inDriver).toString(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _getList() {
    final list = [];


    for (var r in results) {
      // list.add(Container(height: 20));

      r.routes!.asMap().forEach((i, route) {
        // list.add(
        //     Text('Route $i: ${route.metadata.weight.distance.text}'));
        print("distance ${route.metadata.weight.distance.text}");
        print("time ${route.metadata.weight.timeWithTraffic.text}");
      });

      // list.add(Container(height: 20));
    }

    // return list;
  }

  Future<void> _changeCar(int index) async {
    carIndex = index;
    setState(() {});
  }

  Future<void> _cancel() async {
    await widget.session.cancel();
  }

  Future<void> _close() async {
    await widget.session.close();
  }

  int randomPrice(){
    var rng =  Random();
   var code = rng.nextInt(30)+10;
  if(code%2==0){
  return code *= 100;
  }else{
    return code *= (-100);
  }
  }

  Future<void> _init() async {
    await _handleResult(await widget.result);
    setState(() {
      _progress = true;
    });
    var url = Uri.parse('https://taxi-routeinfo.taxi.yandex.net/taxi_info?clid='
        'ak220315&apikey=FdzIEDCkYjEyoDQVUIookJkZsMfLISIp&rll='
        '${widget.startPlacemark.point.longitude},${widget.startPlacemark.point.latitude}~${widget.endPlacemark.point.longitude},${widget.endPlacemark.point.latitude}&class='
        'econom,business,comfortplus,minivan,vip');
    var response = await http.get(url,headers: { 'Content-type': 'application/json',},);
    data = jsonDecode(utf8.decode(response.bodyBytes));
    carPrice = data["options"].length;
    var price = randomPrice();
    for(int index=0 ;index < data["options"].length ; index++){
      list.add(CarPriceModel(price: data["options"][index]["price"]+price.toDouble(),name: "${data["options"][index]["class_name"].toUpperCase().substring(0,1)}"
          "${data["options"][index]["class_name"].substring(1).toLowerCase()}"));
    }
    var priceTwo = randomPrice();
    for(int index=0 ;index < data["options"].length ; index++){
      listTwo.add(CarPriceModel(price: data["options"][index]["price"]+priceTwo.toDouble(),name: "${data["options"][index]["class_name"].toUpperCase().substring(0,1)}"
          "${data["options"][index]["class_name"].substring(1).toLowerCase()}"));
    }
    inDriver = data["options"][0]["price"]+randomPrice().toDouble();
    setState(() {
      _progress = false;
    });
    // Future.delayed(Duration(seconds: 1),(){
    //
    // });
  }

  Future<void> _handleResult(DrivingSessionResult result) async {

    if (result.error != null) {
      print('Error: ${result.error}');
      return;
    }

    setState(() {
      results.add(result);
    });
    setState(() {
      result.routes!.asMap().forEach((i, route) {
        mapObjects.add(Polyline(
          mapId: MapObjectId('route_${i}_polyline'),
          coordinates: route.geometry,
          strokeColor:
              Colors.primaries[Random().nextInt(Colors.primaries.length)],
          strokeWidth: 3,
        ));
      });
    });
    _getList();
  }

}

class CarPriceModel{
  final String? name;
  final double? price;

  CarPriceModel({this.name, this.price});
}

class ControlButton extends StatelessWidget {
  const ControlButton({Key? key, required this.onPressed, required this.title})
      : super(key: key);

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title, textAlign: TextAlign.center),
      ),
    );
  }
}

