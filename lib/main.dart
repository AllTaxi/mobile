import 'package:alltaxi/add_point_page.dart';
import 'package:alltaxi/search_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'history.dart';

Position? position;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('es', 'SP')],
      path: 'assets/translate',
      startLocale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      builder: (context, child) => ScrollConfiguration(
        behavior: MyBehavior(),
        child: child!,
      ),
      title: 'All Taxi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'All Taxi'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FocusNode textSecondFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var cameraPositions;
  var lan = 2;
  late YandexMapController controller;
  final MapObjectId cameraMapObjectId = const MapObjectId('camera_placemark');
  late final List<MapObject> mapObjects = [];
  final animation =
      const MapAnimation(type: MapAnimationType.smooth, duration: 2.0);

  Future<void> setLocation() async {
    position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .catchError(
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
    mapObjects.clear();
    mapObjects.add(Placemark(
      mapId: cameraMapObjectId,
      point:
          Point(latitude: position!.latitude, longitude: position!.longitude),
      icon: PlacemarkIcon.single(PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage('assets/destination.png'),
          scale: 0.3)),
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
         key: _scaffoldKey,
        drawer: Drawer(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  const Text("Jamshid Mirzamaxmudov",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  const Text("+998 99 537 56 11"),
                   const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>const HistoryPage()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("history".tr(),style: const TextStyle(fontSize: 18,fontWeight: FontWeight.normal)),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: (){

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("settings".tr(),style: const TextStyle(fontSize: 18,fontWeight: FontWeight.normal)),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: (){

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("support".tr(),style: const TextStyle(fontSize: 18,fontWeight: FontWeight.normal)),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  GestureDetector(
                      onTap: (){

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("info".tr(),style: const TextStyle(fontSize: 18,fontWeight: FontWeight.normal)),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(widget.title,style: const TextStyle(color: Colors.black),),
          leading: IconButton(onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
            }, icon: const Icon(Icons.menu,color: Colors.black,),),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: DropdownButton(
                items: [
                  DropdownMenuItem(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: SvgPicture.asset(
                            "assets/uz.svg",
                            width: 24,
                          ),
                        ),
                        const Text("Uzbek"),
                      ],
                    ),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: SvgPicture.asset("assets/us.svg", width: 24),
                        ),
                        const Text("English"),
                      ],
                    ),
                    value: 2,
                  ),
                ],
                icon: Container(),
                underline: Container(),
                onChanged: (t) {
                  if (t == 1) {
                    lan = 1;
                    context.locale = const Locale('es', 'SP');
                  } else {
                    lan = 2;
                    context.locale = const Locale('en', 'US');
                  }
                  setState(() {});
                },
                value: lan,
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 80,
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 16,
              top: 8,
              right: 16,
              left: 16),
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: AnimationButtonEffect(
            child: GestureDetector(
              onTap: () async {
                final resultWithSession = YandexSearch.searchByPoint(
                  point: cameraPositions.target,
                  zoom: cameraPositions.zoom.toInt(),
                  searchOptions: const SearchOptions(
                    searchType: SearchType.geo,
                    geometry: false,
                  ),
                );
                var list = await resultWithSession.result;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SuggestionsExample(
                              position: position!,
                              long: cameraPositions.target.longitude,
                              title: list.items!.first.name,
                              lat: cameraPositions.target.latitude,
                              text: list.items!.first.toponymMetadata!.address
                                  .formattedAddress
                                  .substring(
                                      0,
                                      list.items!.first.toponymMetadata!.address
                                          .formattedAddress
                                          .lastIndexOf(",")),
                            )));
              },
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  padding: const EdgeInsets.all(8),
                  child: Center(
                      child: Text(
                    "where_to".tr(),
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                  ))),
            ),
          ),
          color: Colors.white,
        ),
        body: Stack(
          children: [
            YandexMap(
              mapObjects: mapObjects,
              onCameraPositionChanged: (CameraPosition cameraPosition,
                  CameraUpdateReason _, bool __) async {
                final placemark =
                    mapObjects.firstWhere((el) => el.mapId == cameraMapObjectId)
                        as Placemark;

                setState(() {
                  mapObjects[mapObjects.indexOf(placemark)] =
                      placemark.copyWith(point: cameraPosition.target);
                });
                cameraPositions = await controller.getCameraPosition();
              },
              onMapCreated: (YandexMapController yandexMapController) async {
                final placemark =
                    mapObjects.firstWhere((el) => el.mapId == cameraMapObjectId)
                        as Placemark;

                controller = yandexMapController;

                await controller.moveCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: placemark.point, zoom: 17)));
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
        ));
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

// ignore: must_be_immutable
class AnimationButtonEffect extends StatefulWidget {
  final bool disabled;
  final bool isGrey;
  final bool isLoading;
  Widget child;

  AnimationButtonEffect(
      {this.disabled = true,
      this.isGrey = false,
      this.isLoading = false,
      required this.child});

  @override
  _AnimationButtonEffectState createState() => _AnimationButtonEffectState();
}

class _AnimationButtonEffectState extends State<AnimationButtonEffect>
    with TickerProviderStateMixin {
  AnimationController? _controllerA;

  var squareScaleA = 0.95;

  @override
  void initState() {
    _controllerA = AnimationController(
      vsync: this,
      lowerBound: 0.95,
      upperBound: 1.0,
      duration: Duration(milliseconds: 80),
    );
    _controllerA!.addListener(() {
      setState(() {
        squareScaleA = _controllerA!.value;
      });
    });

    _controllerA!.forward(from: 0.0);
    super.initState();
  }

  @override
  void dispose() {
    _controllerA!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.disabled
        ? Listener(
            onPointerDown: (_) {
              _controllerA!.reverse();
            },
            onPointerUp: (_) {
              _controllerA!.forward(from: 1.0);
              if (!widget.disabled) {}
            },
            child: Transform.scale(
              scale: squareScaleA,
              child: Stack(
                children: [
                  widget.child,
                  widget.isLoading
                      ? Positioned(
                          left: 0,
                          right: 0,
                          bottom: 5,
                          child: JumpingDotsProgressIndicator(
                            // dotSpacing: 5,
                            numberOfDots: 3,
                            fontSize: 55.0,
                            color: Color(0xff1A1A1A),
                          ),
                        )
                      : SizedBox()
                ],
              ),
            ),
          )
        : widget.child;
  }
}
