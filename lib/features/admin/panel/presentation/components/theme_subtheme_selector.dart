import 'package:expogeo/core/components/button/secondary_button.dart';
import 'package:expogeo/core/components/field/app_dropdown_field.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:flutter/material.dart';

class ThemeSubthemeSelector extends StatefulWidget {
  final Function(ThemeEnum theme) onThemeSelected;
  final Function(ThemeEnum theme, SubthemeEnum subtheme) onSubthemeSelected;

  final ThemeEnum? initialTheme;
  final SubthemeEnum? initialSubtheme;

  const ThemeSubthemeSelector({
    super.key,
    required this.onThemeSelected,
    required this.onSubthemeSelected,
    this.initialTheme,
    this.initialSubtheme,
  });

  @override
  State<ThemeSubthemeSelector> createState() => _ThemeSubthemeSelectorState();
}

class _ThemeSubthemeSelectorState extends State<ThemeSubthemeSelector> {
  ThemeEnum? _selectedTheme;
  SubthemeEnum? _selectedSubtheme;

  @override
  void didUpdateWidget(covariant ThemeSubthemeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSelected();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelected();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Selecione um Tema e Subtema', style: AppTheme.typography.title.medium),
        SizedBox(height: AppTheme.dimensions.space.medium.height),
        Row(
          spacing: AppTheme.dimensions.space.medium.width,
          children: [
            Expanded(
              child: AppDropdownField<ThemeEnum>(
                items: ThemeEnum.values,
                itemToString: (theme) => theme.name,
                value: _selectedTheme,
                hintText: 'Selecione um tema',
                onChanged: (theme) {
                  if (theme == null) return;

                  final themeEnum = ThemeEnum.fromName(theme);

                  setState(() {
                    _selectedTheme = themeEnum;
                    _selectedSubtheme = null;
                  });
                  widget.onThemeSelected(themeEnum);
                },
              ),
            ),
            Expanded(
              child: AppDropdownField<SubthemeEnum>(
                items: SubthemeEnum.values,
                itemToString: (subtheme) => subtheme.name,
                value: _selectedSubtheme,
                hintText: 'Selecione um subtema',
                onChanged: (subtheme) {
                  if (subtheme == null) return;

                  final subthemeEnum = SubthemeEnum.fromName(subtheme);

                  setState(() {
                    _selectedSubtheme = subthemeEnum;
                  });
                  widget.onSubthemeSelected(_selectedTheme!, subthemeEnum);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: AppTheme.dimensions.space.medium.height),
        if (_selectedTheme != null && _selectedSubtheme != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IntrinsicWidth(
                child: SecondaryButton(
                  onPressed: () {
                    widget.onThemeSelected(_selectedTheme!);
                    setState(() => _selectedSubtheme = null);
                  },
                  label: 'Limpar Filtro',
                ),
              ),
            ],
          ),
      ],
    );
  }

  void _updateSelected() {
    if (widget.initialTheme != null) {
      _selectedTheme = widget.initialTheme;
    }
    if (widget.initialSubtheme != null) {
      _selectedSubtheme = widget.initialSubtheme;
    }
  }
}
