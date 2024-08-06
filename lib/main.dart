import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 3D Controller',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter 3D controller example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Flutter3DController controller1 = Flutter3DController();
  Flutter3DController controller2 = Flutter3DController();
  String? chosenAnimation;
  String? chosenTexture;

  Offset position1 = Offset(50, 50);
  Offset position2 = Offset(250, 50);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            onPressed: () {
              controller1.playAnimation();
              controller2.playAnimation();
            },
            child: const Icon(Icons.play_arrow),
          ),
          const SizedBox(
            height: 4,
          ),
          FloatingActionButton.small(
            onPressed: () {
              controller1.pauseAnimation();
              controller2.pauseAnimation();
            },
            child: const Icon(Icons.pause),
          ),
          const SizedBox(
            height: 4,
          ),
          FloatingActionButton.small(
            onPressed: () {
              controller1.resetAnimation();
              controller2.resetAnimation();
            },
            child: const Icon(Icons.replay_circle_filled),
          ),
          const SizedBox(
            height: 4,
          ),
          FloatingActionButton.small(
            onPressed: () async {
              List<String> availableAnimations1 =
                  await controller1.getAvailableAnimations();
              List<String> availableAnimations2 =
                  await controller2.getAvailableAnimations();
              print(
                  'Animations (Model 1): $availableAnimations1 -- Length: ${availableAnimations1.length}');
              print(
                  'Animations (Model 2): $availableAnimations2 -- Length: ${availableAnimations2.length}');
              chosenAnimation =
                  await showPickerDialog(availableAnimations1 + availableAnimations2, chosenAnimation);
              controller1.playAnimation(animationName: chosenAnimation);
              controller2.playAnimation(animationName: chosenAnimation);
            },
            child: const Icon(Icons.format_list_bulleted_outlined),
          ),
          const SizedBox(
            height: 4,
          ),
          FloatingActionButton.small(
            onPressed: () async {
              List<String> availableTextures1 =
                  await controller1.getAvailableTextures();
              List<String> availableTextures2 =
                  await controller2.getAvailableTextures();
              print(
                  'Textures (Model 1): $availableTextures1 -- Length: ${availableTextures1.length}');
              print(
                  'Textures (Model 2): $availableTextures2 -- Length: ${availableTextures2.length}');
              chosenTexture =
                  await showPickerDialog(availableTextures1 + availableTextures2, chosenTexture);
              controller1.setTexture(textureName: chosenTexture ?? '');
              controller2.setTexture(textureName: chosenTexture ?? '');
            },
            child: const Icon(Icons.list_alt_rounded),
          ),
          const SizedBox(
            height: 4,
          ),
          FloatingActionButton.small(
            onPressed: () {
              controller1.setCameraOrbit(20, 20, 5);
              controller2.setCameraOrbit(20, 20, 5);
            },
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(
            height: 4,
          ),
          FloatingActionButton.small(
            onPressed: () {
              controller1.resetCameraOrbit();
              controller2.resetCameraOrbit();
            },
            child: const Icon(Icons.cameraswitch_outlined),
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            left: position1.dx,
            top: position1.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  position1 = Offset(position1.dx + details.delta.dx, position1.dy + details.delta.dy);
                });
              },
              child: SizedBox(
                width: 550,
                height: 550,
                child: Flutter3DViewer(
                  controller: controller1,
                  src: 'assets/business_man.glb',
                ),
              ),
            ),
          ),
          Positioned(
            left: position2.dx,
            top: position2.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  position2 = Offset(position2.dx + details.delta.dx, position2.dy + details.delta.dy);
                });
              },
              child: SizedBox(
                width: 550,
                height: 550,
                child: Flutter3DViewer(
                  controller: controller2,
                  src: 'assets/lion.glb',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> showPickerDialog(List<String> inputList,
      [String? chosenItem]) async {
    return await showModalBottomSheet<String>(
        context: context,
        builder: (ctx) {
          return SizedBox(
            height: 250,
            child: ListView.separated(
              itemCount: inputList.length,
              padding: const EdgeInsets.only(top: 16),
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, inputList[index]);
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${index + 1}'),
                        Text(inputList[index]),
                        Icon(chosenItem == inputList[index]
                            ? Icons.check_box
                            : Icons.check_box_outline_blank)
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const Divider(
                  color: Colors.grey,
                  thickness: 0.6,
                  indent: 10,
                  endIndent: 10,
                );
              },
            ),
          );
        });
  }
}
