import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/utils/brightness/brightness.dart';
import 'package:reminder/provider/setting/theme/color_picker_provider.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:riverpod_context/riverpod_context.dart';

//ignore: must_be_immutable
class ColorPicker extends StatelessWidget {
  late Function(int, int) onPressed;
  late List<int> colors;
  late int columnCount;
  late double mainAxisSpacing;
  late double crossAxisSpacing;
  late double checkedItemIconSize;
  late double width;

  /*
   * コンストラクタ
   * @param onPressed : 押したときの処理
   * @param colors : ピッカーに表示する色
   * @param checkedItemIndex : 選択されている色のindex
   * @param width : カラーピッカーのwidth
   * @param columnCount : 横に並べるアイテム数
   * @param mainAxisSpacing : 間隔
   * @param crossAxisSpacing : 間隔
   * @param checkedItemIconSize : チェックマークの大きさ
   */
  ColorPicker({
    required this.onPressed,
    required this.colors,
    required this.width,
    int? columnCount,
    double? mainAxisSpacing,
    double? crossAxisSpacing,
    double? checkedItemIconSize,
    Key? key,
  }) : super(key: key) {
    this.columnCount = columnCount ?? 4;
    this.mainAxisSpacing = mainAxisSpacing ?? 0;
    this.crossAxisSpacing = crossAxisSpacing ?? 0;
    this.checkedItemIconSize = checkedItemIconSize ?? 24.0;
  }

  /*
   * RGBエディタのフォーム
   * @param context : BuildContext
   * @param controller : TextEditingController
   * @param name : フォームの名前
   * @param color : nameのテキストカラー
   * @param action : 変更時の処理
   * @return Widget : フォーム
   */
  Widget _textField(
    BuildContext context,
    TextEditingController controller,
    String name,
    Color color,
    Function(int) action,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.bodyLarge?.apply(
                color: color,
                fontSizeFactor: 1,
              ),
        ),
        SizedBox(
          height: 60,
          width: 60,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            minLines: 1,
            maxLines: 1,
            textAlign: TextAlign.center,
            onChanged: (value) {
              context
                  .read(colorPickerProvider.notifier)
                  .checkEditorValue(controller, value, action);
            },
            style: Theme.of(context).textTheme.bodyLarge?.apply(
                  fontSizeFactor: 1,
                ),
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

  /*
   * カラー選択ボタンを作成
   * @param color : ボタンの色
   * @param index : 選択されている色のindex
   * @return Widget : カラー選択ボタン
   */
  Widget _createColorButton(
    Color color,
    int index,
  ) {
    return Consumer(builder: (context, ref, child) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: color,
          minimumSize: const Size(60, 60),
          maximumSize: const Size(60, 60),
        ),
        onPressed: () {
          onPressed(color.value, index);
          ref
              .read(colorPickerProvider.notifier)
              .changeCheckedItemIndex(index, color);
        },
        child: ref.read(colorPickerProvider.notifier).getCheckedItemIndex() ==
                index
            ? Icon(
                Icons.check,
                size: checkedItemIconSize,
                color: judgeBlackWhite(
                  Color(color.value),
                ),
              )
            : null,
      );
    });
  }

  /*
   * カラー選択ボタンのリストを作成
   * @return List<Widget : カラー選択ボタンのリスト
   */
  List<Widget> createButtonsList() {
    return [
      for (int index = 0; index < colors.length; index++)
        _createColorButton(Color(colors[index]), index)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer(builder: (context, ref, child) {
          var watch = ref.watch(colorPickerProvider);

          return Container(
            width: width,
            margin: const EdgeInsets.only(bottom: 30),
            child: GridView.count(
              shrinkWrap: true,
              children: createButtonsList(),
              crossAxisCount: columnCount,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              controller: ScrollController(
                keepScrollOffset: false,
              ),
            ),
          );
        }),
        Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: _textField(
                      context,
                      context.read(colorPickerProvider).rController,
                      "Red",
                      Colors.red,
                      (red) {
                        context
                            .read(colorPickerProvider.notifier)
                            .editRGB(r: red);
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: _textField(
                      context,
                      context.read(colorPickerProvider).gController,
                      "Green",
                      Colors.green,
                      (green) {
                        context
                            .read(colorPickerProvider.notifier)
                            .editRGB(g: green);
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: _textField(
                      context,
                      context.read(colorPickerProvider).bController,
                      "Blue",
                      Colors.blue,
                      (blue) {
                        context
                            .read(colorPickerProvider.notifier)
                            .editRGB(b: blue);
                      },
                    ),
                  ),
                ],
              ),
              Consumer(builder: (context, ref, child) {
                var red = ref.watch(colorPickerProvider).red;
                var blue = ref.watch(colorPickerProvider).blue;
                var green = ref.watch(colorPickerProvider).green;

                return Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _createColorButton(
                        ref.read(colorPickerProvider.notifier).getColor(),
                        ColorPickerProvider.custom,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                              const Size(110, 40),
                            ),
                            maximumSize: MaterialStateProperty.all(
                              const Size(110, 40),
                            ),
                          ),
                          onPressed: () {
                            onPressed(
                              ref
                                  .read(colorPickerProvider.notifier)
                                  .getColor()
                                  .value,
                              ColorPickerProvider.custom,
                            );
                            ref
                                .read(colorPickerProvider.notifier)
                                .changeCheckedItemIndex(
                                    ColorPickerProvider.custom,
                                    ref
                                        .read(colorPickerProvider.notifier)
                                        .getColor());
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: judgeBlackWhite(
                              Theme.of(context).colorScheme.background,
                            ),
                          ),
                          label: Text(
                            AppLocalizations.of(context)!.refresh,
                            style: TextStyle(
                              color: judgeBlackWhite(
                                Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
