import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF232B55),
          ),
        ),
        cardColor: const Color(0xFFF4EDDB),
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color(0xFFE7626C),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // static const twentyFiveMins = 3;
  static const maxPomodoros = 4;
  static const maxGoals = 12;
  static int totalSeconds_selected = 1500;
  int totalSeconds = totalSeconds_selected;
  int totlaSeconds_rest = 300;
  int totalPomodoros = 0;
  int totalGoals = 0;
  MainAxisAlignment alineScroll = MainAxisAlignment.start;
  bool isResting = false;
  bool isRestingPause = false;
  static List<Map<GlobalKey, String>> timeCollection = [
    {itemKey1: '15'},
    {itemKey2: '20'},
    {itemKey3: '25'},
    {itemKey4: '35'},
    {itemKey4: '40'},
  ];
  static final itemKey1 = GlobalKey();
  static final itemKey2 = GlobalKey();
  static final itemKey3 = GlobalKey();
  static final itemKey4 = GlobalKey();
  static final itemKey5 = GlobalKey();

  final ScrollController _scrollController = ScrollController();

  late Timer timer;
  bool isPlay = false;

  void restBetween() {
    isResting = true;
    timer = Timer.periodic(const Duration(seconds: 1), onTick);
    totalSeconds = totlaSeconds_rest;
  }

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      if (isResting == true) {
        isResting = false;
        timer.cancel();
        setState(() {
          totalSeconds = totalSeconds_selected;
        });
        return;
      }
      timer.cancel();
      restBetween();
      setState(() {
        isPlay = false;
        totalPomodoros = totalPomodoros + 1;
        if (totalPomodoros == maxPomodoros - 1) {
          if (totalGoals < maxGoals) {
            totalGoals = totalGoals + 1;
          } else {
            // 목표를 완료했을때 처리 로직
          }
        }
      });
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(const Duration(seconds: 1), onTick);
    setState(() {
      isPlay = true;
      if (totalPomodoros == maxPomodoros) {
        totalPomodoros = 0;
      }
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isPlay = false;
    });
  }

  void onPauseResting() {
    setState(() {
      timer.cancel();
      isRestingPause = true;
    });
  }

  void onStartResting() {
    setState(() {
      isRestingPause = false;
      timer = Timer.periodic(const Duration(seconds: 1), onTick);
    });
  }

  void onRefreshPressed() {
    setState(() {
      isPlay = false;
      totalSeconds = totalSeconds_selected;
    });
    timer.cancel();
  }

  @override
  void initState() {
    super.initState();
  }

  void setTimePressed(String time, GlobalKey key) {
    final context = key.currentContext!;
    Scrollable.ensureVisible(
      context,
      alignment: 0.5,
    );
    alineScroll = MainAxisAlignment.center;
    setState(() {
      isResting = false;
      isRestingPause = false;
      totalSeconds_selected = int.parse(time) * 60;
      totalSeconds = totalSeconds_selected;
    });
  }

  String format(int seconds) {
    var duration =
    Duration(seconds: seconds).toString().split('.').first.substring(2, 7);
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    print(totalSeconds_selected);
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Column(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(left: 30),
                  alignment: Alignment.centerLeft,
                  // decoration: BoxDecoration(color: Colors.orange[400]),
                  child: Text(
                    'POMOTIMER',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  height: 300,
                  alignment: Alignment.bottomCenter,
                  // decoration: BoxDecoration(color: Colors.green[400]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -11,
                            right: 12,
                            child: Container(
                              width: 117,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 35, horizontal: 6),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .cardColor
                                    .withOpacity(0.5),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                format(totalSeconds).substring(0, 2),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color:
                                  Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -6,
                            right: 6,
                            child: Container(
                              width: 129,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 40, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .cardColor
                                    .withOpacity(0.5),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                format(totalSeconds).substring(0, 2),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color:
                                  Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            child: Container(
                              constraints:
                              const BoxConstraints.tightFor(width: 141),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 40, horizontal: 18),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                format(totalSeconds).substring(0, 2),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 75,
                                  fontWeight: FontWeight.w700,
                                  color:
                                  Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 12, left: 4, right: 4),
                        child: Text(
                          ':',
                          style: TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).cardColor.withOpacity(0.6),
                          ),
                        ),
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -11,
                            right: 12,
                            child: Container(
                              width: 117,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 35, horizontal: 6),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .cardColor
                                    .withOpacity(0.5),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                format(totalSeconds).substring(0, 2),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color:
                                  Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -6,
                            right: 6,
                            child: Container(
                              width: 129,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 40, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .cardColor
                                    .withOpacity(0.5),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                format(totalSeconds).substring(0, 2),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color:
                                  Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            child: Container(
                              constraints:
                              const BoxConstraints.tightFor(width: 141),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 40, horizontal: 18),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Text(
                                format(totalSeconds).substring(3, 5),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 75,
                                  fontWeight: FontWeight.w700,
                                  color:
                                  Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (Rect bound) {
                        return const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromARGB(0, 174, 174, 174),
                              Color.fromARGB(255, 255, 255, 255),
                              Color.fromARGB(255, 255, 255, 255),
                              Color.fromARGB(0, 174, 174, 174)
                            ],
                            stops: [
                              0.0,
                              0.2,
                              0.8,
                              1.0
                            ]).createShader(bound);
                      },
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        child: SizedBox(
                          width: 720,
                          // height: 90,
                          child: Row(
                            mainAxisAlignment: alineScroll,
                            children: [
                              // for (var time in timeCollection)
                              TimeButton(
                                key: itemKey1,
                                totalSeconds: totalSeconds_selected,
                                time: '15',
                                onTimePressed: () =>
                                    setTimePressed('15', itemKey1),
                              ),
                              TimeButton(
                                key: itemKey2,
                                totalSeconds: totalSeconds_selected,
                                time: '20',
                                onTimePressed: () =>
                                    setTimePressed('20', itemKey2),
                              ),
                              TimeButton(
                                key: itemKey3,
                                totalSeconds: totalSeconds_selected,
                                time: '25',
                                onTimePressed: () =>
                                    setTimePressed('25', itemKey3),
                              ),
                              TimeButton(
                                key: itemKey4,
                                totalSeconds: totalSeconds_selected,
                                time: '30',
                                onTimePressed: () =>
                                    setTimePressed('30', itemKey4),
                              ),
                              TimeButton(
                                key: itemKey5,
                                totalSeconds: totalSeconds_selected,
                                time: '35',
                                onTimePressed: () =>
                                    setTimePressed('35', itemKey5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: isResting
                          ? IconButton(
                        icon: Icon(isRestingPause
                            ? Icons.nature_people_sharp
                            : Icons.pause_circle_outline_outlined),
                        color: Theme.of(context).cardColor,
                        onPressed: isRestingPause
                            ? onStartResting
                            : onPauseResting,
                        iconSize: 90,
                      )
                          : IconButton(
                        icon: Icon(isPlay
                            ? Icons.pause_circle_outline_outlined
                            : Icons.play_circle_fill_outlined),
                        color: Theme.of(context).cardColor,
                        onPressed:
                        isPlay ? onPausePressed : onStartPressed,
                        iconSize: 90,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_outlined),
                      color: Theme.of(context).cardColor,
                      onPressed: onRefreshPressed,
                      iconSize: 35,
                    ),
                    isResting
                        ? Text(
                      'RESTING TIME',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).cardColor,
                      ),
                    )
                        : Text(
                      '',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).cardColor,
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(45),
                            topRight: Radius.circular(45))),
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$totalPomodoros/$maxPomodoros',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .cardColor
                                        .withOpacity(0.6),
                                  ),
                                ),
                                Text(
                                  'ROUND',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).cardColor,
                                  ),
                                ),
                              ]),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$totalGoals/$maxGoals',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .cardColor
                                        .withOpacity(0.6),
                                  ),
                                ),
                                Text(
                                  'GOAL',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).cardColor,
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ))
            ],
          )),
    );
  }
}

class TimeButton extends StatelessWidget {
  final int totalSeconds;
  final String time;
  final Function() onTimePressed;

  const TimeButton({
    super.key,
    required this.totalSeconds,
    required this.time,
    required this.onTimePressed,
  });

  void setTime() {
    onTimePressed();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTimePressed,
      child: Container(
        width: 68,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: (totalSeconds ~/ 60).toString() == time
              ? const Color(0xFFF4EDDB)
              : const Color(0xFFE7626C),
          border: Border.all(
            color: const Color(0xFFF4EDDB).withOpacity(0.6),
            width: 3,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Text(
          time,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: (totalSeconds ~/ 60).toString() == time
                ? const Color(0xFFE7626C)
                : const Color(0xFFF4EDDB).withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}