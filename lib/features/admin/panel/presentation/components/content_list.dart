import 'package:expogeo/core/components/button/app_icon_button.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/date/date.dart';
import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';
import 'package:flutter/material.dart';

class ContentList extends StatefulWidget {
  final List<ContentResponseModel> contents;
  final Function(ContentResponseModel) onEdit;
  final Function(ContentResponseModel) onDelete;

  const ContentList({
    super.key,
    required this.contents,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<ContentList> createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = AppTheme.typography.body.medium.copyWith(
      color: AppTheme.colors.darkGray,
    );
    final contentTextStyle = AppTheme.typography.body.small.copyWith(
      color: AppTheme.colors.gray400,
    );

    return RawScrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('ID', style: titleTextStyle)),
            DataColumn(label: Text('Título', style: titleTextStyle)),
            DataColumn(label: Text('Tipo', style: titleTextStyle)),
            DataColumn(label: Text('Criador', style: titleTextStyle)),
            DataColumn(label: Text('Data de Inserção', style: titleTextStyle)),
            DataColumn(label: Text('Ações', style: titleTextStyle)),
          ],
          rows: widget.contents.map((content) {
            return DataRow(
              cells: [
                DataCell(Text(content.id, style: contentTextStyle)),
                DataCell(
                  Text(
                    content.contentInfo.title,
                    style: contentTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DataCell(Text(content.originInfo.type.value, style: contentTextStyle)),
                DataCell(Text(content.intellectualIndicator.creator, style: contentTextStyle)),
                DataCell(
                  Text(content.originInfo.insertionDate.formattedDate, style: contentTextStyle),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppIconButton(
                        icon: Icons.edit_outlined,
                        label: 'Editar',
                        tooltip: 'Editar a ficha deste objeto',
                        size: AppTheme.dimensions.components.panelActionIcon,
                        onPressed: () => widget.onEdit(content),
                        color: AppTheme.colors.inkSecondary,
                      ),
                      AppIconButton(
                        icon: Icons.delete_outline,
                        label: 'Excluir',
                        tooltip: 'Excluir: pede confirmação antes de apagar',
                        size: AppTheme.dimensions.components.panelActionIcon,
                        onPressed: () => widget.onDelete(content),
                        color: AppTheme.colors.error,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
