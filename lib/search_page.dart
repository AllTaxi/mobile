import 'dart:async';

import 'package:alltaxi/result_page.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'add_point_page.dart';

class SuggestionsExample extends StatefulWidget {
  final Position position;
  final String title;
  final String text;
  final double long;
  final double lat;
  final bool start;

  const SuggestionsExample(
      {Key? key,
      required this.title,
      required this.long,
      required this.lat,
      required this.text,
        required this.position, this.start = true})
      : super(key: key);

  @override
  _SuggestionsExampleState createState() => _SuggestionsExampleState();
}

class _SuggestionsExampleState extends State<SuggestionsExample> {
  final TextEditingController queryController = TextEditingController();
  List list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(children: <Widget>[
          const SizedBox(height: 10),
          Column(children: <Widget>[
          widget.start ?
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.location_history),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title),
                      Text(
                        widget.text,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ) :
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (s) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  _suggest(s);
                });
              },
              controller: queryController,
              decoration: InputDecoration(
                hintText: 'where_from'.tr(),
                suffixIcon: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddPointPage(
                          title: "choose_location".tr(),
                          long: widget.long,
                          lat: widget.lat,
                          start: widget.title,
                          startSub: widget.text,
                          end: false,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 20,
                        color: Colors.grey,
                        width: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 4),
                        child: Text("map".tr()),
                      ),
                    ],
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
            if (widget.start)
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                onChanged: (s) {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    _suggest(s);
                  });
                },
                controller: queryController,
                decoration: InputDecoration(
                  hintText: 'where_to'.tr(),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddPointPage(
                            title: "choose_location".tr(),
                            long: widget.long,
                            lat: widget.lat,
                            start: widget.title,
                            startSub: widget.text,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 20,
                          color: Colors.grey,
                          width: 1,
                        ),
                         Padding(
                          padding: const EdgeInsets.only(left: 10, right: 4),
                          child: Text("map".tr()),
                        ),
                      ],
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ) else Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.location_history),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width-64,
                          child: Text(widget.title, maxLines: 1,
                            overflow: TextOverflow.ellipsis,)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width-64,
                        child: Text(
                          widget.text,
                          style: const TextStyle(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (c, i) => GestureDetector(
                          onTap: () {
                            _search(list[i].title);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  list[i].tags.first == "house"
                                      ? "assets/house.svg"
                                      : list[i].tags.first == "vegetation"
                                          ? "assets/vegetation.svg"
                                          : list[i].tags.first == "metro"
                                              ? "assets/metro.svg"
                                              : list[i].tags.first == "hydro"
                                                  ? "assets/hydro.svg"
                                                  : list[i].tags.first ==
                                                          "district"
                                                      ? "assets/district.svg"
                                                      : list[i].tags.first ==
                                                              "province"
                                                          ? "assets/province.svg"
                                                          : list[i]
                                                                      .tags
                                                                      .first ==
                                                                  "street"
                                                              ? "assets/street.svg"
                                                              : "assets/street.svg",
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: MediaQuery.of(context).size.width -
                                            76,
                                        child: Text(list[i].title,  maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          76,
                                      child: Text(
                                        list[i].subtitle ?? "",
                                        style:
                                            const TextStyle(color: Colors.grey),
                                        maxLines: 2,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      height: 1,
                                      width: MediaQuery.of(context).size.width -
                                          76,
                                      color: Colors.grey.withOpacity(0.5),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
              ),
            ),
          ])
        ]),
      ),
    );
  }

  Future<void> _search(String text) async {
    final resultWithPoint = YandexSearch.searchByText(
      searchText: text,
      geometry: const Geometry.fromBoundingBox(BoundingBox(
          northEast: Point(longitude: 55.9289172707, latitude: 37.1449940049),
          southWest: Point(longitude: 73.055417108, latitude: 45.5868043076)),
      ),
      searchOptions: const SearchOptions(
        searchType: SearchType.biz,
        suggestWords: true,
      ),
    );

    var lists = await resultWithPoint.result;
    if(widget.start){
      final Placemark start = Placemark(
        mapId: const MapObjectId('start_placemark'),
        point: Point(
          latitude: widget.lat,
          longitude: widget.long,
        ),
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/start.png'),
            scale: 0.5)),
        opacity: 0.9,
      );

      final Placemark stopByPlacemark = Placemark(
        mapId: const MapObjectId('stop_by_placemark'),
        point: Point(
            latitude: lists.items!.first.geometry.first.point!.latitude,
            longitude:
            lists.items!.first.geometry.first.point!.longitude),
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/end.png'),
            scale: 0.5),),
        opacity: 0.9,
      );

      final Placemark end = Placemark(
        mapId: const MapObjectId('end_placemark'),
        point: Point(
            latitude: lists.items!.first.geometry.first.point!.latitude,
            longitude:
            lists.items!.first.geometry.first.point!.longitude),
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/end.png'),
            scale: 0.5)),
        opacity: 0.9,
      );
      var resultWithSession = YandexDriving.requestRoutes(
          points: [
            RequestPoint(
                point: start.point, requestPointType: RequestPointType.wayPoint),
            RequestPoint(
                point: stopByPlacemark.point,
                requestPointType: RequestPointType.viaPoint),
            RequestPoint(
                point: end.point, requestPointType: RequestPointType.wayPoint),
          ],
          drivingOptions: const DrivingOptions(
              initialAzimuth: 0, routesCount: 5, avoidTolls: true));
      await Navigator.push(context, MaterialPageRoute(builder: (_) {
        return ResultPage(
            start,
            end,
            resultWithSession.session,
            resultWithSession.result,
            widget.title,
            lists.items!.first.name,widget.text,lists.items!.first.businessMetadata!.address.formattedAddress.
        substring(0,lists.items!.first.
        businessMetadata!.address.formattedAddress.
        lastIndexOf(",")));
      }));
    }else{
      final Placemark start = Placemark(
        mapId: const MapObjectId('start_placemark'),
        point: Point(
          latitude: lists.items!.first.geometry.first.point!.latitude,
          longitude: lists.items!.first.geometry.first.point!.longitude,
        ),
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/start.png'),
            scale: 0.5)),
        opacity: 0.9,
      );

      final Placemark stopByPlacemark = Placemark(
        mapId: const MapObjectId('stop_by_placemark'),
        point: Point(
            latitude: widget.lat,
            longitude: widget.long),
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/end.png'),
            scale: 0.5)),
        opacity: 0.9,
      );

      final Placemark end = Placemark(
        mapId: const MapObjectId('end_placemark'),
        point: Point(
            latitude: widget.lat,
            longitude: widget.long),
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/end.png'),
            scale: 0.5)),
        opacity: 0.9,
      );
      var resultWithSession = YandexDriving.requestRoutes(
          points: [
            RequestPoint(
                point: start.point, requestPointType: RequestPointType.wayPoint),
            RequestPoint(
                point: stopByPlacemark.point,
                requestPointType: RequestPointType.viaPoint),
            RequestPoint(
                point: end.point, requestPointType: RequestPointType.wayPoint),
          ],
          drivingOptions: const DrivingOptions(
              initialAzimuth: 0, routesCount: 5, avoidTolls: true));
       Navigator.push(context, MaterialPageRoute(builder: (_) {
        return ResultPage(
            start,
            end,
            resultWithSession.session,
            resultWithSession.result,
            widget.title,
            lists.items!.first.name,widget.text,lists.items!.first.businessMetadata!.
        address.formattedAddress.
        substring(0,lists.items!.first.
        businessMetadata!.address.formattedAddress.
        lastIndexOf(",")));
      }));
    }

  }

  Future<void> _suggest(String text) async {
    final resultWithName = YandexSuggest.getSuggestions(
        text: text,
        boundingBox: const BoundingBox(
            northEast: Point(longitude: 55.9289172707, latitude: 37.1449940049),
            southWest: Point(longitude: 73.055417108, latitude: 45.5868043076)),
        suggestOptions:  SuggestOptions(
            suggestType: SuggestType.biz,
            suggestWords: true,
            userPosition: Point(latitude: widget.position.latitude, longitude: widget.position.longitude)));

    var lists = await resultWithName.result;
    list.clear();
    for (var element in lists.items!) {
      list.add(element);
      print(element.title);
    }
    setState(() {});
  }
}

class SearchModel {
  String? title;
  double? lat;
  double? long;

  SearchModel({this.title, this.long, this.lat});
}
