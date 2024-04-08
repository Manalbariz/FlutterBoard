import 'package:flutter/material.dart';

import './main_style.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 231, 230, 230),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(MainScreenStyle.marginSize),
          child: Stack(
            children: [
              Positioned(
                top: MainScreenStyle.marginSize - 20,
                left: MainScreenStyle.marginSize - 20,
                child: Container(
                  width: MainScreenStyle.circleSize,
                  height: MainScreenStyle.circleSize,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MainScreenStyle.firstcircleColor),
                ),
              ),
              Positioned(
                top: MainScreenStyle.marginSize - 80,
                left: MainScreenStyle.circleSpacing * 1.5,
                child: Container(
                  width: MainScreenStyle.circleSize,
                  height: MainScreenStyle.circleSize,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MainScreenStyle.secondcircleColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
