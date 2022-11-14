import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/components/brightness/brightness.dart';
import 'package:reminder/components/color_picker/color_picker_provider.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

// ignore: must_be_immutable
class ColorPicker extends StatelessWidget {
  late Function(int, int) onPressed;
  late List<int> colors;
  late int columnCount;
  late double mainAxisSpacing;
  late double crossAxisSpacing;
  late int checkedItemIndex;
  late double checkedItemIconSize;
  late double width;

  /// コンストラクタ
  /// * `onPressed` : 押したときの処理
  /// * `colors` : ピッカーに表示する色
  /// * `checkedItemIndex` : 選択されている色のindex
  /// * `width` : カラーピッカーのwidth
  /// * `columnCount` : 横に並べるアイテム数
  /// * `mainAxisSpacing` : 間隔
  /// * `crossAxisSpacing` : 間隔
  /// * `checkedItemIconSize` : チェックマークの大きさ
  ColorPicker({
    required this.onPressed,
    required this.colors,
    required this.checkedItemIndex,
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

  /// RGBエディタのフォーム
  /// * `context` : BuildContext
  /// * `controller` : TextEditingController
  /// * `name` : フォームの名前
  /// * `color` : nameのテキストカラー
  /// * `action` : 変更時の処理
  /// * `provider` : ColorPickerProvider
  /// * @return `Widget` : フォーム
  Widget _textField(
    BuildContext context,
    TextEditingController controller,
    String name,
    Color color,
    Function(int) action,
    ColorPickerProvider provider,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.bodyText1?.apply(
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
              provider.checkEditorValue(controller, value, action);
            },
            style: Theme.of(context).textTheme.bodyText1?.apply(
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

  /// カラー選択ボタンを作成
  /// * `provider` : ColorPickerProvider
  /// * `color` : ボタンの色
  /// * `index` : 選択されている色のindex
  /// * @return `Widget` : カラー選択ボタン
  Widget _createColorButton(
    ColorPickerProvider provider,
    Color color,
    int index,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: color,
        minimumSize: const Size(60, 60),
        maximumSize: const Size(60, 60),
      ),
      onPressed: () {
        onPressed(color.value, index);
        provider.changeCheckedItemIndex(index, color);
      },
      child: provider.getCheckedItemIndex() == index
          ? Icon(
              Icons.check,
              size: checkedItemIconSize,
              color: judgeBlackWhite(
                Color(color.value),
              ),
            )
          : null,
    );
  }

  /// カラー選択ボタンのリストを作成
  /// * `provider` : ColorPickerProvider
  /// * @return `List<Widget` : カラー選択ボタンのリスト
  List<Widget> createButtonsList(ColorPickerProvider provider) {
    return [
      for (int index = 0; index < colors.length; index++)
        _createColorButton(provider, Color(colors[index]), index)
    ];
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return ChangeNotifierProvider(
      create: (context) => ColorPickerProvider(checkedItemIndex, primaryColor),
      child: Consumer<ColorPickerProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Container(
                width: width,
                margin: const EdgeInsets.only(bottom: 30),
                child: GridView.count(
                  shrinkWrap: true,
                  children: createButtonsList(provider),
                  crossAxisCount: columnCount,
                  mainAxisSpacing: mainAxisSpacing,
                  crossAxisSpacing: crossAxisSpacing,
                  controller: ScrollController(
                    keepScrollOffset: false,
                  ),
                ),
              ),
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
                            provider.rController,
                            "Red",
                            Colors.red,
                            (red) {
                              provider.editRGB(r: red);
                            },
                            provider,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: _textField(
                            context,
                            provider.gController,
                            "Green",
                            Colors.green,
                            (green) {
                              provider.editRGB(g: green);
                            },
                            provider,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: _textField(
                            context,
                            provider.bController,
                            "Blue",
                            Colors.blue,
                            (blue) {
                              provider.editRGB(b: blue);
                            },
                            provider,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _createColorButton(provider, provider.getColor(), -1),
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
                                onPressed(provider.getColor().value, -1);
                                provider.changeCheckedItemIndex(
                                    -1, provider.getColor());
                              },
                              icon: Icon(
                                Icons.refresh,
                                color: judgeBlackWhite(
                                  Theme.of(context).backgroundColor,
                                ),
                              ),
                              label: Text(
                                AppLocalizations.of(context)!.refresh,
                                style: TextStyle(
                                  color: judgeBlackWhite(
                                    Theme.of(context).backgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
