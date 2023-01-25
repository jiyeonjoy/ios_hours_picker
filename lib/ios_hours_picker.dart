import 'package:flutter/cupertino.dart';

const double _kItemExtent = 32.0;
const double _kPickerWidth = 320.0;
const double _kPickerHeight = 216.0;
const double _kSqueeze = 1.25;
const double _kTimerPickerHalfColumnPadding = 2;
const double _kTimerPickerLabelPadSize = 4.5;
const double _kTimerPickerLabelFontSize = 17.0;
const double _kTimerPickerColumnIntrinsicWidth = 106;
const double _kTimerPickerNumberLabelFontSize = 23;

class CupertinoHoursPicker extends StatefulWidget {
  const CupertinoHoursPicker({
    super.key,
    this.initialTimerDuration = Duration.zero,
    this.alignment = Alignment.center,
    this.backgroundColor,
    required this.onTimerHoursChanged,
  })  : assert(initialTimerDuration >= Duration.zero),
        assert(initialTimerDuration < const Duration(days: 1));

  final Duration initialTimerDuration;
  final ValueChanged<int> onTimerHoursChanged;
  final AlignmentGeometry alignment;
  final Color? backgroundColor;

  @override
  State<StatefulWidget> createState() => _CupertinoHoursPickerState();
}

class _CupertinoHoursPickerState extends State<CupertinoHoursPicker> {
  late TextDirection textDirection;
  late CupertinoLocalizations localizations;
  int get textDirectionFactor {
    switch (textDirection) {
      case TextDirection.ltr:
        return 1;
      case TextDirection.rtl:
        return -1;
    }
  }

  int? selectedHour;
  int? lastSelectedHour;

  final TextPainter textPainter = TextPainter();
  final List<String> numbers = List<String>.generate(10, (int i) => '${9 - i}');
  late double numberLabelWidth;
  late double numberLabelHeight;
  late double numberLabelBaseline;

  @override
  void initState() {
    super.initState();
    selectedHour = 0;
    PaintingBinding.instance.systemFonts.addListener(_handleSystemFontsChange);
  }

  void _handleSystemFontsChange() {
    setState(() {
      textPainter.markNeedsLayout();
      _measureLabelMetrics();
    });
  }

  @override
  void dispose() {
    PaintingBinding.instance.systemFonts
        .removeListener(_handleSystemFontsChange);
    super.dispose();
  }

  @override
  void didUpdateWidget(CupertinoHoursPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    textDirection = Directionality.of(context);
    localizations = CupertinoLocalizations.of(context);
    _measureLabelMetrics();
  }

  void _measureLabelMetrics() {
    textPainter.textDirection = textDirection;
    final TextStyle textStyle = _textStyleFrom(context);
    double maxWidth = double.negativeInfinity;
    String? widestNumber;
    for (final String input in numbers) {
      textPainter.text = TextSpan(
        text: input,
        style: textStyle,
      );
      textPainter.layout();

      if (textPainter.maxIntrinsicWidth > maxWidth) {
        maxWidth = textPainter.maxIntrinsicWidth;
        widestNumber = input;
      }
    }

    textPainter.text = TextSpan(
      text: '$widestNumber$widestNumber',
      style: textStyle,
    );

    textPainter.layout();
    numberLabelWidth = textPainter.maxIntrinsicWidth;
    numberLabelHeight = textPainter.height;
    numberLabelBaseline =
        textPainter.computeDistanceToActualBaseline(TextBaseline.alphabetic);
  }

  Widget _buildLabel(String text, EdgeInsetsDirectional pickerPadding) {
    final EdgeInsetsDirectional padding = EdgeInsetsDirectional.only(
      start: numberLabelWidth +
          100 +
          _kTimerPickerLabelPadSize +
          pickerPadding.start,
    );

    return IgnorePointer(
      child: Container(
        alignment: AlignmentDirectional.centerStart.resolve(textDirection),
        padding: padding.resolve(textDirection),
        child: SizedBox(
          height: numberLabelHeight,
          child: Baseline(
            baseline: numberLabelBaseline,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: _kTimerPickerLabelFontSize,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              softWrap: false,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPickerNumberLabel(String text, EdgeInsetsDirectional padding) {
    return Container(
      width: _kTimerPickerColumnIntrinsicWidth + padding.horizontal,
      padding: padding.resolve(textDirection),
      alignment: AlignmentDirectional.centerStart.resolve(textDirection),
      child: Container(
        width: numberLabelWidth,
        alignment: AlignmentDirectional.centerEnd.resolve(textDirection),
        child: Text(text,
            softWrap: false, maxLines: 1, overflow: TextOverflow.visible),
      ),
    );
  }

  Widget _buildHourPicker(EdgeInsetsDirectional additionalPadding) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: 0),
      offAxisFraction: 0.0,
      itemExtent: _kItemExtent,
      backgroundColor: widget.backgroundColor,
      squeeze: _kSqueeze,
      onSelectedItemChanged: (int index) {
        setState(() {
          selectedHour = index;
          widget.onTimerHoursChanged(index);
        });
      },
      children: List<Widget>.generate(24, (int index) {
        final String semanticsLabel = textDirectionFactor == 1
            ? localizations.timerPickerHour(index) +
                (localizations.timerPickerHourLabel(index) ?? '')
            : (localizations.timerPickerHourLabel(index) ?? '') +
                localizations.timerPickerHour(index);
        return Semantics(
          label: semanticsLabel,
          excludeSemantics: true,
          child: _buildPickerNumberLabel('$index', additionalPadding),
        );
      }),
    );
  }

  Widget _buildHourColumn(EdgeInsetsDirectional additionalPadding) {
    return Stack(
      children: <Widget>[
        NotificationListener<ScrollEndNotification>(
          onNotification: (ScrollEndNotification notification) {
            setState(() {
              lastSelectedHour = selectedHour;
            });
            return false;
          },
          child: _buildHourPicker(additionalPadding),
        ),
        _buildLabel(
          localizations
                  .timerPickerHourLabel(lastSelectedHour ?? selectedHour!) ??
              '',
          additionalPadding,
        ),
      ],
    );
  }

  TextStyle _textStyleFrom(BuildContext context) {
    return CupertinoTheme.of(context).textTheme.pickerTextStyle.merge(
          const TextStyle(
            fontSize: _kTimerPickerNumberLabelFontSize,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columns;
    const double paddingValue = _kPickerWidth -
        2 * _kTimerPickerColumnIntrinsicWidth -
        2 * _kTimerPickerHalfColumnPadding;
    double totalWidth = _kPickerWidth;
    assert(paddingValue >= 0);
    columns = <Widget>[
      _buildHourColumn(const EdgeInsetsDirectional.only(
          start: 50, end: _kTimerPickerHalfColumnPadding)),
    ];
    final CupertinoThemeData themeData = CupertinoTheme.of(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: CupertinoTheme(
        data: themeData.copyWith(
          textTheme: themeData.textTheme.copyWith(
            pickerTextStyle: _textStyleFrom(context),
          ),
        ),
        child: Align(
          alignment: widget.alignment,
          child: Container(
            color: CupertinoDynamicColor.maybeResolve(
                widget.backgroundColor, context),
            width: totalWidth,
            height: _kPickerHeight,
            child: DefaultTextStyle(
              style: _textStyleFrom(context),
              child: Row(
                  children: columns
                      .map((Widget child) => Expanded(child: child))
                      .toList(growable: false)),
            ),
          ),
        ),
      ),
    );
  }
}
