import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive/home/size_config.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool isPinned = false;
  double visiblePercentage = 0;
  String value = '';
  bool isHover = false;
  bool isSearchEnable = false;
  bool? isMobile;
  String? isFast = 'Fast';

  Animation<double>? catAnimation;
  AnimationController? catController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    catController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    catAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: catController!,
      curve: Curves.easeIn,
    ));
  }

  performAnimation() {
    if (catController!.status == AnimationStatus.completed) {
      catController!.reverse();
    } else if (catController!.status == AnimationStatus.dismissed) {
      catController!.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            children: [
              IconButton(
                onPressed: () {
                  if (_scaffoldKey.currentState!.isDrawerOpen) {
                    Get.back();
                  }
                },
                icon: const Icon(Icons.clear),
                alignment: Alignment.centerRight,
              ),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            isMobile = false;
          } else {
            isMobile = true;
          }
          return Stack(
            children: [
              CustomScrollView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        switch (index) {
                          case 0:
                            return appBarWithHeader(index);
                          case 1:
                            return announce();
                          case 2:
                            return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      commonFastButton(message: 'Fast'),
                                      commonFastButton(message: 'Productive'),
                                      commonFastButton(message: 'Flexible'),
                                    ],
                                  ),
                                ),
                                fast(),
                              ],
                            );
                        }
                      },
                      childCount: 3,
                    ),
                  ),
                ],
              ),
              Card(
                color: isPinned ? Colors.white : Colors.transparent,
                elevation: isPinned ? 5 : 0,
                margin: const EdgeInsets.all(0),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const FlutterLogo(
                            size: 30.0,
                          ),
                          Text(
                            " Flutter",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: isPinned ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isMobile!) ...[
                              IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  _scaffoldKey.currentState!.openDrawer();
                                },
                              ),
                            ] else ...[
                              if (isSearchEnable == false)
                                Flexible(
                                  child: Wrap(
                                    children: [
                                      titleText(title: "Multi-Platform"),
                                      titleText(title: "Development"),
                                      titleText(title: "Ecosystem"),
                                      titleText(title: "Showcase"),
                                      titleText(title: "Docs"),
                                    ],
                                  ),
                                ),
                              if (isSearchEnable == true) ...[
                                Flexible(
                                  child: SizedBox(
                                    width: SizeConfig.blockSizeHorizontal! * 30,
                                    child: TextFormField(
                                      expands: false,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        filled: isPinned,
                                        fillColor: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isSearchEnable = !isSearchEnable;
                                  });
                                },
                                icon: Icon(
                                  Icons.search,
                                  size: 20.0,
                                  color: isPinned ? Colors.blue : Colors.white,
                                ),
                                padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                              ),
                              MaterialButton(
                                onPressed: () {},
                                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                child: Text(
                                  "Get started",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    letterSpacing: 0.5,
                                    color: isPinned ? Colors.white : const Color(0XFF0468d7),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                color: isPinned ? const Color(0XFF0468d7) : Colors.white,
                              )
                            ],
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget commonFastButton({required String message}) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal! * 5, vertical: SizeConfig.blockSizeHorizontal! * 1.2),
      onPressed: () {
        performAnimation();
        setState(() {
          isFast = message;
        });
      },
      child: Text(
        message,
        style: TextStyle(
          color: isFast == message ? Colors.white : const Color(0XFF0468d7),
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
        ),
      ),
      color: isFast == message ? const Color(0XFF0468d7) : null,
      hoverColor: Colors.grey.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }

  Widget appBarWithHeader(int index) {
    return VisibilityDetector(
      key: ValueKey("$index"),
      onVisibilityChanged: (VisibilityInfo visibilityInfo) {
        value = visibilityInfo.key.toString().replaceAll("[", '').replaceAll("]", '').replaceAll("<", '').replaceAll(">", '').replaceAll("'", '');
        if (int.parse(value.toString()) <= 0) {
          visiblePercentage = visibilityInfo.visibleFraction * 100;
          debugPrint(visiblePercentage.toString());
          if (visiblePercentage >= 10) {
            setState(() {
              isPinned = false;
            });
          } else {
            setState(() {
              isPinned = true;
            });
          }
        }
        debugPrint('Widget $value ');
      },
      child: index == 0
          ? header1()
          : Container(
              height: 250,
              margin: const EdgeInsets.all(8.0),
              color: Colors.blueAccent,
            ),
    );
  }

  Widget announce() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal! * 10,
            vertical: SizeConfig.blockSizeVertical! * 10,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0XFF0468d7),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            children: [
              Image.network(
                "https://storage.googleapis.com/cms-storage-bucket/a40ceb6e5d342207de7b.png",
                height: SizeConfig.blockSizeVertical! * 10,
                width: SizeConfig.blockSizeHorizontal! * 10,
              ),
              const SizedBox(
                width: 20.0,
              ),
              Flexible(
                child: TextButton(
                  child: const Text(
                    "Flutter Puzzle Hack submissions close on March 14. Don't forget to submit. ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              const Icon(
                Icons.arrow_forward,
                size: 20.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16),
          child: Text(
            "Flutter is an open source framework by Google for building beautiful, natively compiled, multi-platform applications from a single codebase.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget titleText({
    required String title,
    bool isButton = false,
    bool isSearch = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextButton(
        child: Text(
          title,
          style: TextStyle(
            color: isPinned ? Colors.black : Colors.white,
            fontSize: 16.0,
            letterSpacing: .5,
            overflow: TextOverflow.ellipsis,
          ),
          softWrap: true,
        ),
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.grey),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget header1() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF9c9af1),
                Color(0xFF5d85e3),
                Color(0xFF2372d5),
                Color(0xFF69bfeb),
              ],
              begin: FractionalOffset(0, -1),
              end: FractionalOffset(1, 0),
              stops: [0, 0.4, -.9, 1],
              tileMode: TileMode.mirror,
            ),
          ),
          padding: EdgeInsets.only(top: kToolbarHeight * 2.5, bottom: kToolbarHeight * 1.5, left: Get.width * .05, right: Get.width * .05),
          child: Column(
            children: [
              const Text(
                "Build apps for any screen",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Image.network(
                "https://storage.googleapis.com/cms-storage-bucket/90e34daecca082eb9b28.png",
                height: SizeConfig.blockSizeVertical! * 80,
                width: SizeConfig.blockSizeHorizontal! * 80,
              ),
              const SizedBox(
                height: 50.0,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal! * 10,
                  right: SizeConfig.blockSizeHorizontal! * 10,
                  bottom: 30.0,
                ),
                child: const Text(
                  "Flutter transforms the app development process. Build, test, and deploy beautiful mobile, web, desktop, and embedded apps from a single codebase.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              MouseRegion(
                onHover: (va) {
                  isHover = true;
                  setState(() {});
                },
                onExit: (va) {
                  isHover = false;
                  setState(() {});
                },
                child: MaterialButton(
                  onPressed: () {},
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  child: Text(
                    "Get started",
                    style: TextStyle(
                      fontSize: 16.0,
                      letterSpacing: 0.5,
                      color: isHover ? Colors.white : const Color(0XFF0468d7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: isHover ? const Color(0XFF0468d7) : Colors.white,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget fast() {
    return AnimatedBuilder(
      animation: catAnimation!,
      builder: (context, child) {
        return Positioned(
          child: child!,
          bottom: catAnimation!.value,
          right: 0.0,
          left: 0.0,
        );
      },
      child: Container(
        color: Colors.grey,
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal! * 10),
        child: isMobile! == true
            ? Wrap(
                direction: Axis.horizontal,
                children: imageAndText(),
              )
            : Row(
                children: imageAndText(),
              ),
      ),
    );
  }

  List<Widget> imageAndText() {
    return [
      Expanded(
        flex: isMobile! ? 0 : 7,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal! * 5,
            vertical: SizeConfig.blockSizeVertical! * 5,
          ),
          child: Image.network(
            "https://storage.googleapis.com/cms-storage-bucket/a667e994fc2f3e85de36.png",
          ),
        ),
      ),
      Expanded(
        flex: isMobile! ? 0 : 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Fast",
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Flutter code compiles to ARM or Intel machine code as well as JavaScript, for fast performance on any device.",
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      )
    ];
  }
}
