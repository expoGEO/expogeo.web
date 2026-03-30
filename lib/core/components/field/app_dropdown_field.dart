import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';

class AppDropdownField<T> extends StatefulWidget {
  const AppDropdownField({
    required this.items,
    required this.itemToString,
    required this.hintText,
    this.value,
    this.onChanged,
    this.validator,
    this.isDisabled = false,
    this.canUnselect = false,
    super.key,
  });

  final List<T> items;
  final String Function(T) itemToString;
  final T? value;
  final void Function(String?)? onChanged;

  final String hintText;
  final String? Function(String?)? validator;

  final bool isDisabled;
  final bool canUnselect;

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
  String? _selectedValue;
  List<T?> _items = [];

  @override
  void initState() {
    super.initState();

    _setSelectedValue();
    _setItems();
  }

  @override
  void didUpdateWidget(covariant AppDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value) _setSelectedValue();
    if (widget.items != oldWidget.items) _setItems();
  }

  void _setSelectedValue() {
    _selectedValue = widget.value != null ? widget.itemToString(widget.value as T) : null;
  }

  void _setItems() {
    _items = widget.items.map((item) => item).toList();
    if (widget.canUnselect) _items = [null, ..._items];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isDense: true,
      isExpanded: true,
      hint: Text(
        widget.hintText,
        style: AppTheme.typography.body.medium.copyWith(color: AppTheme.colors.gray300),
      ),
      items: _items.map((item) {
        if (item == null) {
          return DropdownMenuItem<String>(
            value: null,
            child: Text(
              widget.hintText,
              style: AppTheme.typography.body.medium.copyWith(color: AppTheme.colors.gray300),
            ),
          );
        }

        return DropdownMenuItem<String>(
          value: widget.itemToString(item),
          child: Text(
            widget.itemToString(item),
            style: AppTheme.typography.label.big.copyWith(color: AppTheme.colors.darkGray),
          ),
        );
      }).toList(),
      initialValue: _selectedValue,
      onChanged: widget.isDisabled
          ? null
          : (value) {
              setState(() => _selectedValue = value);
              widget.onChanged?.call(value);
            },
      validator: widget.validator,
      borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppTheme.colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppTheme.dimensions.space.small.width,
          vertical: AppTheme.dimensions.space.medium.height,
        ),
        enabledBorder: _buildBorder(AppTheme.colors.lightGray),
        focusedBorder: _buildBorder(AppTheme.colors.lightOrange),
        focusedErrorBorder: _buildBorder(AppTheme.colors.primaryRed),
        disabledBorder: _buildBorder(AppTheme.colors.lightGray),
        errorBorder: _buildBorder(AppTheme.colors.primaryRed),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
    borderSide: BorderSide(width: AppTheme.dimensions.stroke.small, color: color),
  );
}
