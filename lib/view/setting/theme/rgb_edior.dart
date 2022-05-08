import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/components/brightness.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/setting/theme/rgb_provider.dart';
import 'package:reminder/provider/setting/theme/theme_provider.dart';

class RGBEditor extends StatelessWidget {
  const RGBEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return ChangeNotifierProvider(
      create: (context) => RGBProvider(primaryColor),
      child: Consumer<RGBProvider>(
        builder: (context, rgbProvider, child) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).hintColor,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 60,
                      color: rgbProvider.getColor(),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: _textField(
                        context,
                        rgbProvider.rController,
                        "Red",
                        Colors.red,
                        (red) {
                          rgbProvider.editRGB(r: red);
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: _textField(
                        context,
                        rgbProvider.gController,
                        "Green",
                        Colors.green,
                        (green) {
                          rgbProvider.editRGB(g: green);
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: _textField(
                        context,
                        rgbProvider.bController,
                        "Blue",
                        Colors.blue,
                        (blue) {
                          rgbProvider.editRGB(b: blue);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _textField(BuildContext context, TextEditingController controller,
      String name, Color color, Function(int) action) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.bodyText1?.apply(
                color: color,
                fontSizeDelta: 5,
              ),
        ),
        SizedBox(
          height: 80,
          width: 80,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            minLines: 1,
            maxLines: 1,
            textAlign: TextAlign.center,
            onChanged: (value) {
              if (RegExp(r'[^0-9]').hasMatch(value)) {
                value = value.replaceAll(RegExp(r'[^0-9]'), "");
                controller.text = value;
                moveCursor(controller);
              }
              if (RegExp(r'^0+[0-9]+').hasMatch(value)) {
                value = value.replaceAll(RegExp(r'^0+'), '');
                controller.text = value;
                moveCursor(controller);
              }

              int code = int.tryParse(value) ?? 0;
              if (code <= 0) {
                controller.text = "0";
                code = 0;
                moveCursor(controller);
              }
              if (code > 255) {
                controller.text = "255";
                code = 255;
                moveCursor(controller);
              }
              action(code);
            },
            style:
                Theme.of(context).textTheme.bodyText1?.apply(fontSizeDelta: 10),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).hintColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).hintColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void moveCursor(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }
}
