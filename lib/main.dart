import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ios_hours_picker/ios_hours_picker.dart';

const double _kItemExtent = 32.0;
const List<String> _fruitNames = <String>[
  'Apple',
  'Mango',
  'Banana',
  'Orange',
  'Pineapple',
  'Strawberry',
];

void main() => runApp(const CupertinoPickerApp());

class CupertinoPickerApp extends StatelessWidget {
  const CupertinoPickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CupertinoPickerExample(),
    );
  }
}

class CupertinoPickerExample extends StatefulWidget {
  const CupertinoPickerExample({super.key});

  @override
  State<CupertinoPickerExample> createState() => _CupertinoPickerExampleState();
}

class _CupertinoPickerExampleState extends State<CupertinoPickerExample> {
  int _selectedFruit = 0;

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('CupertinoPicker Sample'),
      ),
      child: DefaultTextStyle(
          style: TextStyle(
            color: CupertinoColors.label.resolveFrom(context),
            fontSize: 22.0,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Divider(),
                CupertinoButton(
                  onPressed: () => _showDialog(
                    CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: _kItemExtent,
                      onSelectedItemChanged: (int selectedItem) {
                        setState(() {
                          _selectedFruit = selectedItem;
                        });
                      },
                      children: List<Widget>.generate(_fruitNames.length,
                          (int index) {
                        return Center(
                          child: Text(
                            _fruitNames[index],
                          ),
                        );
                      }),
                    ),
                  ),
                  child: Text(
                    _fruitNames[_selectedFruit],
                    style: const TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
                const Divider(),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _showDialog(
                    CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.dateAndTime,
                      onDateTimeChanged: (DateTime date) {},
                    ),
                  ),
                  child: const Text(
                    'CupertinoDatePicker dateAndTime',
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _showDialog(
                    CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      onDateTimeChanged: (DateTime date) {},
                    ),
                  ),
                  child: const Text(
                    'CupertinoDatePicker time',
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _showDialog(
                    CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (DateTime date) {},
                    ),
                  ),
                  child: const Text(
                    'CupertinoDatePicker date',
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
                const Divider(),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _showDialog(
                    CupertinoTimerPicker(
                      mode: CupertinoTimerPickerMode.hm,
                      onTimerDurationChanged: (Duration duration) {},
                    ),
                  ),
                  child: const Text(
                    'CupertinoTimerPicker hm',
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _showDialog(
                    CupertinoTimerPicker(
                      mode: CupertinoTimerPickerMode.hms,
                      onTimerDurationChanged: (Duration duration) {},
                    ),
                  ),
                  child: const Text(
                    'CupertinoTimerPicker hms',
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _showDialog(
                    CupertinoTimerPicker(
                      mode: CupertinoTimerPickerMode.ms,
                      onTimerDurationChanged: (Duration duration) {},
                    ),
                  ),
                  child: const Text(
                    'CupertinoTimerPicker ms',
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
                const Divider(),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _showDialog(
                    CupertinoHoursPicker(
                      onTimerHoursChanged: (int hour) {},
                    ),
                  ),
                  child: const Text(
                    'CupertinoHoursPicker',
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          child: Wrap(
                            children: <Widget>[
                              Container(
                                height: 216,
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  bottom: 16,
                                ),
                                child: CupertinoHoursPicker(
                                  onTimerHoursChanged: (int hours) {},
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                  bottom: 34,
                                  left: 24,
                                  right: 24,
                                ),
                                child: CupertinoButton(
                                  child: const Text('확인'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  child: const Text(
                    'CupertinoHoursPicker',
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
                const Divider(),
              ],
            ),
          )),
    );
  }
}
