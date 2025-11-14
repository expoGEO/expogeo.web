import "package:expogeo/core/theme/app_theme.dart";
import "package:flutter/material.dart";

class CheckboxButton extends StatefulWidget {
  const CheckboxButton({required this.value, required this.onChanged, super.key});

  final bool value;
  final void Function(bool) onChanged;

  @override
  State<CheckboxButton> createState() => _CheckboxButtonState();
}

class _CheckboxButtonState extends State<CheckboxButton> {
  late bool _value = widget.value;

  @override
  void didUpdateWidget(CheckboxButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value) {
      setState(() => _value = widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: _value,
      onChanged: (value) {
        final newValue = value ?? false;

        setState(() => _value = newValue);
        widget.onChanged(newValue);
      },
      activeColor: AppTheme.colors.gray900,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
