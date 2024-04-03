import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online/pages/games/bits/game_over_page.dart';
import 'package:online/services/app_navigator.dart';

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  SnakeGameState createState() => SnakeGameState();
}

class SnakeGameState extends State<SnakeGame> {
  final int squaresPerRow = 16;
  final int squaresPerCol = 16;

  final double squareSize = 20.0;

  List<int> snakePosition = [45, 65, 85, 105, 125];
  int foodPosition = 100;

  Direction direction = Direction.right;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 300), (Timer timer) {
      moveSnake();
    });
  }

  // void gameOver() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Game Over'),
  //         content: Text('Your score: ${snakePosition.length - 5}'), // Initial length of snake is 5
  //         actions: <Widget>[
  //           ElevatedButton(
  //             child: Text('Play Again'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               resetGame();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  Widget cupertionDeleteDialog() {
    return CupertinoAlertDialog(
      title: const Text('Bekreft sletting'),
      content: const Text('Er du sikker på at du vil slette brukerdataene dine?'),
      actions: [
        CupertinoDialogAction(
          child: const Text('Avbryt'),
          onPressed: () {
            AppNavigator.pop();
          },
        ),
        // CupertinoDialogAction(
        //   isDestructiveAction: true,
        //   onPressed: delete,
        //   child: const Text('Slett'),
        // ),
      ],
    );
  }

  Widget materialDeleteDialog() {
    return AlertDialog(
      title: const Text('Bekreft sletting'),
      content: const Text('Er du sikker på at du vil slette brukerdataene dine?'),
      actions: [
        TextButton(
          onPressed: () {
            AppNavigator.pop();
          },
          child: const Text('Avbryt'),
        ),
        // TextButton(
        //   onPressed: delete,
        //   child: const Text('Slett'),
        // ),
      ],
    );
  }

  void gameOver(BuildContext context) {
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIOS) {
      showCupertinoDialog(context: context, builder: (context) => cupertionDeleteDialog());
    } else {
      showDialog(context: context, builder: (context) => materialDeleteDialog());
    }
  }

  void resetGame() {
    setState(() {
      snakePosition = [45, 65, 85, 105, 125];
      foodPosition = 100;
      direction = Direction.right;
    });
  }

  void moveSnake() {
    setState(() {
      // Calculate new head position
      int newHeadPosition;
      switch (direction) {
        case Direction.right:
          newHeadPosition = snakePosition.last + 1;
          break;
        case Direction.left:
          newHeadPosition = snakePosition.last - 1;
          break;
        case Direction.up:
          newHeadPosition = snakePosition.last - squaresPerRow;
          break;
        case Direction.down:
          newHeadPosition = snakePosition.last + squaresPerRow;
          break;
      }

      // Check for collisions with the wall
      bool hitWall = newHeadPosition < 0 ||
          newHeadPosition >= squaresPerRow * squaresPerCol ||
          (direction == Direction.left && newHeadPosition % squaresPerRow == squaresPerRow - 1) ||
          (direction == Direction.right && newHeadPosition % squaresPerRow == 0);

      // Check for collisions with itself
      bool hitSelf = snakePosition.contains(newHeadPosition);

      if (hitWall || hitSelf) {
        gameOver(context);
      } else {
        snakePosition.add(newHeadPosition);
        if (newHeadPosition == foodPosition) {
          generateNewFood();
        } else {
          snakePosition.removeAt(0);
        }
      }
    });
  }

  void generateNewFood() {
    foodPosition = Random().nextInt(squaresPerRow * squaresPerCol);
    while (snakePosition.contains(foodPosition)) {
      foodPosition = Random().nextInt(squaresPerRow * squaresPerCol);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Ensure that swipes are significant enough to count as movement.
        if (details.primaryDelta! > 0 && direction != Direction.left) {
          setState(() => direction = Direction.right);
        } else if (details.primaryDelta! < 0 && direction != Direction.right) {
          setState(() => direction = Direction.left);
        }
      },
      onVerticalDragUpdate: (details) {
        // Ensure that swipes are significant enough to count as movement.
        if (details.primaryDelta! > 0 && direction != Direction.up) {
          setState(() => direction = Direction.down);
        } else if (details.primaryDelta! < 0 && direction != Direction.down) {
          setState(() => direction = Direction.up);
        }
      },
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(), // This line disables the GridView's scrolling.
          itemCount: squaresPerRow * squaresPerCol,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: squaresPerRow),
          itemBuilder: (BuildContext context, int index) {
            var color;
            if (snakePosition.contains(index)) {
              color = Colors.green; // Snake color
            } else if (index == foodPosition) {
              color = Colors.red; // Food color
            } else {
              color = Colors.grey[800]; // Board color
            }

            return Container(
              padding: EdgeInsets.all(2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: color,
                ),
              ),
            );
          }),
    );
  }
}

enum Direction { up, down, left, right }
