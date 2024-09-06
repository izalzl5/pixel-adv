import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/components/jump_button.dart';
import 'package:pixel_adventure/components/level.dart';
import 'package:pixel_adventure/components/player.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late final CameraComponent cam;
  Player player = Player(character: 'Pink Man');

  late JoystickComponent joystick;
  bool showJoystick = true;

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    final world = Level(player: player, levelName: 'Level-01');

    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360)
      ..viewfinder.anchor = Anchor.topLeft
      ..priority = 0;

    addAll([cam, world]);

    if (showJoystick) {
      addJoystick();
      add(JumpButton());
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

 void addJoystick() {
  joystick = JoystickComponent(
    knob: SpriteComponent(
      sprite: Sprite(
        images.fromCache('HUD/Knob.png'),
      ),
      size: Vector2(80, 80), // Adjust size here for a larger knob
    ),
    background: SpriteComponent(
      sprite: Sprite(
        images.fromCache('HUD/Joystick.png'),
      ),
      size: Vector2(130, 130), // Adjust size here for a larger background
    ),
    margin: const EdgeInsets.only(left: 70, bottom: 32),
    priority: 1, // Higher priority than camera
  );

  add(joystick);
}


  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }
}
