import 'package:alltaxi/result_page.dart';
import 'package:alltaxi/search_page.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'main.dart';

class AddPointPage extends StatefulWidget {
  const AddPointPage({Key? key, required this.title, required this.long,
    required this.lat, required this.start,
    required this.startSub, this.end = true}) : super(key: key);
  final String start;
  final String startSub;
  final String title;
  final double long;
  final double lat;
  final bool end;

  @override
  State<AddPointPage> createState() => _AddPointPageState();
}

class _AddPointPageState extends State<AddPointPage> {
  FocusNode textSecondFocusNode = FocusNode();
  Position? position;
  var cameraPositions;
  late YandexMapController controller;
  final MapObjectId cameraMapObjectId = const MapObjectId('camera_placemark');
  late final List<MapObject> mapObjects = [];
  final animation =
  const MapAnimation(type: MapAnimationType.smooth, duration: 2.0);

  Future<void> setLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high).catchError(
          (e) => Position(
          longitude: 69.2480567,
          latitude: 41.3513455,
          timestamp: DateTime.now(),
          accuracy: 14.13700008392334,
          altitude: 416.1999816894531,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0),
    );
    mapObjects.add( Placemark(
      mapId: cameraMapObjectId,
      point: Point(latitude: position!.latitude, longitude: position!.longitude),
      icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage('assets/destination.png'),
              scale: 0.3
          )
      ),
      opacity: 0.8,
    ));
  }

  @override
  void initState() {
    setLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(widget.title,style: const TextStyle(color: Colors.black),),
        ),
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
                if(widget.end){
                  final resultWithSearch = YandexSearch.searchByPoint(
                    point: cameraPositions.target,
                    zoom: cameraPositions.zoom.toInt(),
                    searchOptions: const SearchOptions(
                      searchType: SearchType.geo,
                      geometry: false,
                    ),
                  );
                  var list = await resultWithSearch.result;

                  final Placemark start = Placemark(
                    mapId: const MapObjectId('start_placemark'),
                    point: Point(latitude: widget.lat, longitude: widget.long,),
                    icon: PlacemarkIcon.single(PlacemarkIconStyle(
                        image: BitmapDescriptor.fromAssetImage('assets/start.png'),
                        scale: 0.5)),
                    opacity: 0.8,
                  );

                  final Placemark stopByPlacemark = Placemark(
                    mapId: const MapObjectId('stop_by_placemark'),
                    point: Point(latitude: cameraPositions.target.latitude, longitude: cameraPositions.target.longitude),
                    icon: PlacemarkIcon.single(PlacemarkIconStyle(
                        image: BitmapDescriptor.fromAssetImage('assets/end.png'),
                        scale: 0.5)),
                    opacity: 0.9,
                  );

                  final Placemark end =  Placemark(
                    mapId: const MapObjectId('end_placemark'),
                    point: Point(latitude: cameraPositions.target.latitude, longitude: cameraPositions.target.longitude),
                    icon: PlacemarkIcon.single(PlacemarkIconStyle(
                        image: BitmapDescriptor.fromAssetImage('assets/end.png'),
                        scale: 0.5)),
                    opacity: 0.9,
                  );
                  var resultWithSession = YandexDriving.requestRoutes(
                      points: [
                        RequestPoint(
                            point: start.point,
                            requestPointType: RequestPointType.wayPoint),
                        RequestPoint(
                            point: stopByPlacemark.point,
                            requestPointType: RequestPointType.viaPoint),
                        RequestPoint(
                            point: end.point,
                            requestPointType: RequestPointType.wayPoint),
                      ],
                      drivingOptions: const DrivingOptions(
                          initialAzimuth: 0, routesCount: 5, avoidTolls: true));

                  await Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return ResultPage(
                        start,
                        end,
                        resultWithSession.session,
                        resultWithSession.result,
                        widget.start,
                        list.items!.first.name,
                        widget.startSub,
                        list.items!.first.toponymMetadata!.address.formattedAddress.
                        substring(0,list.items!.first.toponymMetadata!.address.
                        formattedAddress.lastIndexOf(","))
                    );
                  }));
                }else{
                  final resultWithSearch = YandexSearch.searchByPoint(
                    point: cameraPositions.target,
                    zoom: cameraPositions.zoom.toInt(),
                    searchOptions: const SearchOptions(
                      searchType: SearchType.geo,
                      geometry: false,
                    ),
                  );
                  var list = await resultWithSearch.result;

                  final Placemark start = Placemark(
                    mapId: const MapObjectId('start_placemark'),
                    point: Point(latitude: cameraPositions.target.latitude, longitude: cameraPositions.target.longitude,),
                    icon: PlacemarkIcon.single(PlacemarkIconStyle(
                        image: BitmapDescriptor.fromAssetImage('assets/start.png'),
                        scale: 0.5)),
                    opacity: 0.9,
                  );

                  final Placemark stopByPlacemark = Placemark(
                    mapId: const MapObjectId('stop_by_placemark'),
                    point: Point(latitude: widget.lat, longitude:  widget.long),
                    icon: PlacemarkIcon.single(PlacemarkIconStyle(
                        image: BitmapDescriptor.fromAssetImage('assets/end.png'),
                        scale: 0.5)),
                    opacity: 0.9,
                  );

                  final Placemark end =  Placemark(
                    mapId: const MapObjectId('end_placemark'),
                    point: Point(latitude:  widget.lat, longitude:  widget.long),
                    icon: PlacemarkIcon.single(PlacemarkIconStyle(
                        image: BitmapDescriptor.fromAssetImage('assets/end.png'),
                        scale: 0.5)),
                    opacity: 0.9,
                  );
                  var resultWithSession = YandexDriving.requestRoutes(
                      points: [
                        RequestPoint(
                            point: start.point,
                            requestPointType: RequestPointType.wayPoint),
                        RequestPoint(
                            point: stopByPlacemark.point,
                            requestPointType: RequestPointType.viaPoint),
                        RequestPoint(
                            point: end.point,
                            requestPointType: RequestPointType.wayPoint),
                      ],
                      drivingOptions: const DrivingOptions(
                          initialAzimuth: 0, routesCount: 5, avoidTolls: true));

                  await Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return ResultPage(
                      start,
                      end,
                      resultWithSession.session,
                      resultWithSession.result,
                      list.items!.first.name,
                      widget.start,
                      list.items!.first.toponymMetadata!.address.formattedAddress.
                      substring(0,list.items!.first.toponymMetadata!.address.
                      formattedAddress.lastIndexOf(",")),
                      widget.startSub,
                    );
                  }));
                }
              },
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.all(Radius.circular(16))
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Center(child: Text("result".tr(),style:
                  TextStyle(color: Colors.black,fontSize: 18),))),
            ),
          ),
          color: Colors.white,
        ),
        body: Stack(
          children: [
            YandexMap(
              mapObjects: mapObjects,
              onCameraPositionChanged: (CameraPosition cameraPosition, CameraUpdateReason _, bool __) async {
                final placemark = mapObjects.firstWhere((el) => el.mapId == cameraMapObjectId) as Placemark;

                setState(() {
                  mapObjects[mapObjects.indexOf(placemark)] = placemark.copyWith(point: cameraPosition.target);
                });
                cameraPositions = await controller.getCameraPosition();
              },
              onMapCreated: (YandexMapController yandexMapController) async {
                final placemark = mapObjects.firstWhere((el) => el.mapId == cameraMapObjectId) as Placemark;

                controller = yandexMapController;

                await controller.moveCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(target: placemark.point, zoom: 17))
                );
              },
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: GestureDetector(
                onTap: () async {
                  await controller.moveCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                          zoom: 17,
                          target: Point(
                              latitude: position!.latitude,
                              longitude: position!.longitude))),
                      animation: animation);
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration:  BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: const Offset(0, 2), // changes position of shadow
                        ),
                      ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset("assets/navigate.svg"),
                  ),
                ),
              ),
            )
          ],
        )
    );
  }
}