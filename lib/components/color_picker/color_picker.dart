import 'package:flutter/material.dart';
import 'package:reminder/components/color_picker/color_picker_provider.dart';

// ignore: must_be_immutable
class ColorPicker extends StatelessWidget {
  late Function(int, int) onPressed;
  late List<int> colors;
  late int columnCount;
  late int checkedItemIndex;
  late double mainAxisSpacing;
  late double crossAxisSpacing;
  late double checkedItemIconSize;

  ColorPicker({
    required this.onPressed,
    required this.colors,
    required this.checkedItemIndex,
    Key? key,
    int? columnCount,
    double? mainAxisSpacing,
    double? crossAxisSpacing,
    double? checkedItemIconSize,
  }) : super(key: key) {
    this.columnCount = columnCount ?? 4;
    this.mainAxisSpacing = mainAxisSpacing ?? 0;
    this.crossAxisSpacing = crossAxisSpacing ?? 0;
    this.checkedItemIconSize = checkedItemIconSize ?? 24.0;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: colors.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      itemBuilder: (BuildContext context, int index) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            primary: Color(colors[index]),
          ),
          onPressed: () {
            onPressed(colors[index], index);
          },
          child: checkedItemIndex == index
              ? Icon(
                  Icons.check,
                  size: checkedItemIconSize,
                )
              : null,
        );
      },
    );
  }
}
