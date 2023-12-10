import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'LoginPage.dart';
import 'RegisterPage.dart';
import 'SuccessRegister.dart';
import 'DataStorage.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
List<String> listPoint = [];

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    FirstScreen(),
    SecondScreen(),
    ThirdScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Bottom Navigation Example'),
      // ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: '지문목록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내 정보',
          ),
        ],
      ),
    );
  }
}



class FirstScreen extends StatelessWidget {
  final double progressRatio = 0.4;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                            Text(
                                '최근 암기 완성도',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                )
                            ),
                            Text(
                                '${progressRatio * 100}%',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7888FF),
                                )
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                            child: SimpleAnimationProgressBar(
                              height: 8,
                              width: 300,
                              backgroundColor: Color(0x447888FF),
                              foregrondColor: Color(0xFF7888FF),
                              ratio: progressRatio,
                              direction: Axis.horizontal,
                              curve: Curves.fastLinearToSlowEaseIn,
                              duration: const Duration(seconds: 3),
                              borderRadius: BorderRadius.circular(10),
                            )
                        )
                      ]
                  )
              ),
              SizedBox(height: 20),
              Container(
                  width: 350.0,
                  height: 200.0,
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
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                            Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Color(0xFF7888FF),
                            ),
                            SizedBox(width: 20.0),
                            Container(
                                width: 150.0,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget> [
                                      Text(
                                          '촬영하기',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF7888FF),
                                          )
                                      ),
                                      Text(
                                          '원하는 문장을 촬영',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xaa000000),
                                          )
                                      )
                                    ]
                                )
                            ) ,
                            SizedBox(width: 20.0),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Color(0x55000000),
                            ),
                          ]
                      ),
                      Divider(
                        color: Color(0x447888FF),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                            Icon(
                              Icons.text_fields,
                              size: 40,
                              color: Color(0xFF7888FF),
                            ),
                            SizedBox(width: 20.0),
                            Container(
                                width: 150.0,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget> [
                                      Text(
                                          '입력하기',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF7888FF),
                                          )
                                      ),
                                      Text(
                                          '텍스트로 직접 입력',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xaa000000),
                                          )
                                      )
                                    ]
                                )
                            ) ,
                            SizedBox(width: 30.0),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Color(0x55000000),
                            ),
                          ]
                      ),
                    ],
                  )
              ),
              SizedBox(height: 20),
              Container(
                  width: 350.0,
                  height: 150.0,
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
                  )
              ),
            ]
        )
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Container(
                  width: 350.0,
                  height: 150.0,
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
                  )
              ),
              SizedBox(height: 10.0),
              Container(
                  width: 350.0,
                  height: 150.0,
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
                  )
              ),
              SizedBox(height: 10.0),
              Container(
                  width: 350.0,
                  height: 150.0,
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
                  )
              ),
            ]

        )
    );
  }
}

class ThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("You need to login",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => LoginPage()));
          }, child: Text("Login"))
        ],
      ),
    );
  }
}