import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RiveNative.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final File file;
  late final RiveWidgetController controller;
  late final ViewModelInstance viewModelInstance;
  late final ViewModelInstanceNumber poseProperty;
  bool _isInitialized = false;

  @override
  void initState() {
    _initRive();
    super.initState();
  }

  Future<void> _initRive() async {
    file = (await File.asset('assets/rabbits.riv', riveFactory: Factory.rive))!;
    controller = RiveWidgetController(file);
    viewModelInstance = controller.dataBind(DataBind.auto());
    poseProperty = viewModelInstance.number('Pose')!;
    poseProperty.addListener((value) {
      print("Pose changed to: $value");
    });

    print("Properties: ${viewModelInstance.properties}");
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    file.dispose();
    viewModelInstance.dispose();
    poseProperty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Flutter Demo Home Page'),
      ),

      body: Stack(
        children: [
          _isInitialized
              ? RiveWidget(
                  controller: controller,
                  fit: Fit.scaleDown,
                  layoutScaleFactor: 1 / 30,
                )
              : const CircularProgressIndicator(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      poseProperty.value = 1;
                    },
                    child: const Text('1'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      poseProperty.value = 2;
                    },
                    child: const Text('2'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      poseProperty.value = 3;
                    },
                    child: const Text('3'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      poseProperty.value = 4;
                    },
                    child: const Text('4'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      poseProperty.value = 999;
                    },
                    child: const Text('5'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
