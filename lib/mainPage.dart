import 'package:flutter/material.dart';
import 'package:fluttertest/settingsPage.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'ParagraphPage.dart';

class MainScreen extends StatefulWidget {

  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<MainScreen> {
  double progressRatio = 0.4;
  Map<String, int> recentResult = {
    'correctCount': 12,
    'totalCount': 16,
  };

  String exampleText = "An important advantage of disclosure, as apposed to more aggressive forms of regulation, it its flexibility and respect for the operation of free markets. Regulatory mandates are blunt words; they tend to neglect diversity and may have serious unintended adverse effects. For example, energy efficiency requirements for applicances may produce goods that work less well or that have characteristics that consumers do not want. Information provision, by contrast, respects freedom of choice. If automobile manufacturers are required to measure and publicize the safety characteristics of cars, potential car purchasers can trade safety concerns against other attributes, such as price and styling. If restaurant customers are informed tof the calories in their meals, those who want to lose weight can make use of the information, leaving those who are unconcerned about calories unaffected. Disclosure does not interfere with, and should even promote, the autonomy (and quality) of individual decision-making.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell (
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParagraphPage(
                      paragraph: exampleText,
                    ),
                  ),
                );
              },
              child: Container(
                width: 350.0,
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.3),
                      offset: const Offset(0, 3),
                      blurRadius: 5.0
                    )
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Text(
                      '최근 지문',
                      style: TextStyle(
                        fontSize: 25,
                        color: Color(0xFF7888FF),
                        fontWeight: FontWeight.w900,
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        exampleText,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        )
                      ),
                    )
                  ],
                )
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 350.0,
              height: 100.0,
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.3),
                    offset: const Offset(0, 3),
                    blurRadius: 5.0)
                ],
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Recent Test Result',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        )
                      ),
                      Text(
                        '${(recentResult['correctCount']?.toDouble() ?? 0) / (recentResult['totalCount']?.toDouble() ?? 1) * 100}%',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7888FF),
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: SimpleAnimationProgressBar(
                      height: 8,
                      width: 300,
                      backgroundColor: const Color(0x447888FF),
                      foregrondColor: const Color(0xFF7888FF),
                      ratio: (recentResult['correctCount']?.toDouble() ?? 0) / (recentResult['totalCount']?.toDouble() ?? 1),
                      direction: Axis.horizontal,
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: const Duration(seconds: 3),
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget> [
                  //     ElevatedButton(
                  //       onPressed: () => setState(() => progressRatio -= 0.1),
                  //       child: Text("-"),
                  //     ),
                  //     ElevatedButton(
                  //       onPressed: () => setState(() => progressRatio += 0.1),
                  //       child: Text("+"),
                  //     ),
                  //   ],
                  // ),
                ]
              )
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('시험 결과')
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('재시험')
                    ),
                  )
                ],
              ),
            )
          ]
        ),
      
      ),
      floatingActionButton: PopupMenuTheme(
        data: PopupMenuThemeData(
          // Customize your popup menu theme here
          color: Colors.white, // Example: change the background color
          textStyle: TextStyle(color: Colors.white), // Example: change text color
        ),
        child: Builder(
          builder: (context) => FloatingActionButton(
            backgroundColor: Color(0xFF7888FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  MediaQuery.of(context).size.width - 130.0,
                  MediaQuery.of(context).size.height - 250.0,
                  MediaQuery.of(context).size.width - 30.0,
                  0.0,
                ),
                items: [
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        const Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: Color(0xFF7888FF),
                        ),
                        const SizedBox(width: 20.0),
                        Container(
                          width: 100.0,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget> [
                              Text(
                                '촬영하기',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF7888FF),
                                )
                              ),
                              Text(
                                '원하는 문장을 촬영',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xaa000000),
                                )
                              )
                            ]
                          )
                        ) ,
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0x55000000),
                        ),
                      ]
                    ),
                    value: 'item1',
                  ),
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        const Icon(
                          Icons.text_fields,
                          size: 30,
                          color: Color(0xFF7888FF),
                        ),
                        const SizedBox(width: 20.0),
                        Container(
                          width: 100.0,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget> [
                              Text(
                                '입력하기',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF7888FF),
                                )
                              ),
                              Text(
                                '텍스트로 직접 입력',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0x55000000),
                                )
                              )
                            ]
                          )
                        ) ,
                        const SizedBox(width: 10.0),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0x55000000),
                        ),
                      ]
                    ),
                    value: 'item2',
                  ),
                  // Add more menu items as needed
                ],
              );
            },
            child: Icon(Icons.menu, color: Colors.white,),
          ),
        ),
      ),
    );
  }
}

