import 'package:expogeo/core/components/button/primary_button.dart';
import 'package:expogeo/core/components/button/secondary_button.dart';
import 'package:expogeo/core/components/card/rounded_card.dart';
import 'package:expogeo/core/components/field/app_dropdown_field.dart';
import 'package:expogeo/core/components/field/app_text_field.dart';
import 'package:expogeo/core/models/content_model.dart';
import 'package:expogeo/core/models/theme_data_model.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/date/date.dart';
import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/core/utils/messenger/messenger.dart';
import 'package:expogeo/core/utils/validators/validators.dart';
import 'package:expogeo/features/admin/panel/infra/models/content_response_model.dart';
import 'package:expogeo/features/admin/panel/presentation/stores/content_store.dart';
import 'package:flutter/material.dart';

class ContentFormDialog extends StatefulWidget {
  final ContentStore contentStore;
  final ThemeEnum theme;
  final SubthemeEnum? subtheme;
  final ContentResponseModel? content;

  const ContentFormDialog({
    super.key,
    required this.contentStore,
    required this.theme,
    this.subtheme,
    this.content,
  });

  @override
  State<ContentFormDialog> createState() => _ContentFormDialogState();
}

class _ContentFormDialogState extends State<ContentFormDialog> {
  late TextEditingController idController;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController creatorController;
  late TextEditingController collaboratorController;
  late TextEditingController locationController;
  late TextEditingController languageController;
  late TextEditingController subjectsController;
  late TextEditingController contentNoteController;
  late TextEditingController requirementsController;
  late TextEditingController rightsController;
  late TextEditingController issueYearController;
  late TextEditingController registrationRulesController;
  late TextEditingController preservationOperationController;

  late ContentType? selectedType;
  late ContentFormat? selectedFormat;
  late DateTime insertionDate;
  late DateTime? updateDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final content = widget.content;

    if (content != null) {
      idController = TextEditingController(text: content.id);
      titleController = TextEditingController(text: content.contentInfo.title);
      descriptionController = TextEditingController(text: content.contentInfo.description);
      creatorController = TextEditingController(text: content.intellectualIndicator.creator);
      collaboratorController = TextEditingController(
        text: content.intellectualIndicator.collaborator ?? '',
      );
      locationController = TextEditingController(text: content.registrationInfo.location);
      languageController = TextEditingController(text: content.originInfo.language);
      subjectsController = TextEditingController(text: content.contentInfo.subjects.join(', '));
      contentNoteController = TextEditingController(text: content.contentInfo.contentNote ?? '');
      requirementsController = TextEditingController(text: content.originInfo.requirements ?? '');
      rightsController = TextEditingController(text: content.rightsInfo.rights);
      issueYearController = TextEditingController(
        text: content.registrationInfo.issueYear?.toString() ?? '',
      );
      registrationRulesController = TextEditingController(
        text: content.registrationInfo.registrationRules ?? '',
      );
      preservationOperationController = TextEditingController(
        text: content.preservationAction?.operation ?? '',
      );

      selectedType = content.originInfo.type;
      selectedFormat = content.originInfo.format;
      insertionDate = content.originInfo.insertionDate;
      updateDate = content.preservationAction?.updateDate;
    } else {
      idController = TextEditingController();
      titleController = TextEditingController();
      descriptionController = TextEditingController();
      creatorController = TextEditingController();
      collaboratorController = TextEditingController();
      locationController = TextEditingController();
      languageController = TextEditingController();
      subjectsController = TextEditingController();
      contentNoteController = TextEditingController();
      requirementsController = TextEditingController();
      rightsController = TextEditingController();
      issueYearController = TextEditingController();
      registrationRulesController = TextEditingController();
      preservationOperationController = TextEditingController();

      selectedType = ContentType.site;
      selectedFormat = ContentFormat.html;
      insertionDate = DateTime.now();
      updateDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    idController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    creatorController.dispose();
    collaboratorController.dispose();
    locationController.dispose();
    languageController.dispose();
    subjectsController.dispose();
    contentNoteController.dispose();
    requirementsController.dispose();
    rightsController.dispose();
    issueYearController.dispose();
    registrationRulesController.dispose();
    preservationOperationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(AppTheme.dimensions.space.small.scale),
      child: SingleChildScrollView(
        child: RoundedCard(
          padding: EdgeInsets.all(AppTheme.dimensions.space.large.scale),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.content == null ? 'Novo Conteúdo' : 'Editar Conteúdo',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: AppTheme.dimensions.space.large.height),
                // ID
                AppTextField(
                  controller: idController,
                  labelText: 'ID do Conteúdo*',
                  hintText: 'ex: RE_CG_01',
                  validator: Validators.isNotEmpty,
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.height),
                // // Título
                AppTextField(
                  controller: titleController,
                  labelText: 'Título*',
                  validator: Validators.isNotEmpty,
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.height),
                // Descrição
                AppTextField(
                  controller: descriptionController,
                  labelText: 'Descrição*',
                  maxLines: 3,
                  validator: Validators.isNotEmpty,
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.height),
                // Assuntos
                AppTextField(
                  controller: subjectsController,
                  labelText: 'Assuntos (separados por vírgula)*',
                  maxLines: 2,
                  validator: Validators.isNotEmpty,
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.height),
                // Nota de Conteúdo
                AppTextField(
                  controller: contentNoteController,
                  labelText: 'Nota do Conteúdo',
                  maxLines: 2,
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.height),
                // Creator e Collaborator
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: creatorController,
                        labelText: 'Criador*',
                        validator: Validators.isNotEmpty,
                      ),
                    ),
                    SizedBox(width: AppTheme.dimensions.space.medium.width),
                    Expanded(
                      child: AppTextField(
                        controller: collaboratorController,
                        labelText: 'Colaborador',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.height),
                // Tipo e Formato
                Row(
                  spacing: AppTheme.dimensions.space.medium.width,
                  children: [
                    Expanded(
                      child: AppDropdownField<ContentType>(
                        items: ContentType.values,
                        itemToString: (type) => type.value,
                        hintText: 'Selecione um tipo',
                        value: selectedType,
                        onChanged: (type) {
                          if (type == null) return;

                          setState(() => selectedType = ContentType.fromString(type));
                        },
                        validator: Validators.isNotEmpty,
                      ),
                    ),
                    Expanded(
                      child: AppDropdownField<ContentFormat>(
                        items: ContentFormat.values,
                        itemToString: (format) => format.value,
                        hintText: 'Selecione um formato',
                        value: selectedFormat,
                        onChanged: (format) {
                          if (format == null) return;

                          setState(() => selectedFormat = ContentFormat.fromString(format));
                        },
                        validator: Validators.isNotEmpty,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.height),
                // URL e Idioma
                Row(
                  spacing: AppTheme.dimensions.space.medium.width,
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: locationController,
                        labelText: 'URL/Localização*',
                        validator: Validators.isNotEmpty,
                      ),
                    ),
                    Expanded(
                      child: AppTextField(
                        controller: languageController,
                        labelText: 'Idioma*',
                        validator: Validators.isNotEmpty,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.height),
                // Requisitos
                AppTextField(
                  controller: requirementsController,
                  labelText: 'Requisitos',
                  maxLines: 2,
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.height),
                // Ano de Emissão e Regras de Registro
                Row(
                  spacing: AppTheme.dimensions.space.medium.width,
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: issueYearController,
                        labelText: 'Ano de Emissão',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Expanded(
                      child: AppTextField(
                        controller: registrationRulesController,
                        labelText: 'Regras de Registro',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.height),
                // Direitos
                AppTextField(
                  controller: rightsController,
                  labelText: 'Direitos*',
                  maxLines: 2,
                  validator: Validators.isNotEmpty,
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.height),
                // Operação de Preservação
                AppTextField(
                  controller: preservationOperationController,
                  labelText: 'Operação de Preservação*',
                  maxLines: 2,
                  validator: Validators.isNotEmpty,
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.height),
                // Data de Atualização de Preservação
                if (updateDate != null)
                  AppTextField(
                    controller: TextEditingController(text: updateDate!.formattedDate),
                    labelText: 'Data de Atualização',
                    isDisabled: true,
                    suffixIcon: Icon(Icons.calendar_today),
                  ),

                SizedBox(height: AppTheme.dimensions.space.large.height),
                // Botões
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: AppTheme.dimensions.space.medium.width,
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        onPressed: () => Navigator.pop(context),
                        label: 'Cancelar',
                      ),
                    ),
                    Expanded(
                      child: PrimaryButton(onPressed: _saveContent, label: 'Salvar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveContent() {
    if (!_formKey.currentState!.validate()) {
      Messenger.showError(context, 'Por favor, preencha todos os campos obrigatórios');
      return;
    }

    final subtheme = widget.subtheme ?? widget.content?.subtheme;
    if (subtheme == null) {
      Messenger.showError(context, 'Subtema é obrigatório para criar um conteúdo');
      return;
    }

    final intelligentIndicator = IntellectualIndicator(
      creator: creatorController.text,
      collaborator: collaboratorController.text.isNotEmpty ? collaboratorController.text : null,
    );

    final contentInfo = ContentInfo(
      title: titleController.text,
      description: descriptionController.text,
      subjects: subjectsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
      contentNote: contentNoteController.text.isNotEmpty ? contentNoteController.text : null,
    );

    final originInfo = OriginInfo(
      insertionDate: insertionDate,
      language: languageController.text,
      type: selectedType!,
      format: selectedFormat!,
      requirements: requirementsController.text.isNotEmpty ? requirementsController.text : null,
    );

    final registrationInfo = RegistrationInfo(
      location: locationController.text,
      issueYear: issueYearController.text.isNotEmpty
          ? int.tryParse(issueYearController.text)
          : null,
      registrationRules: registrationRulesController.text.isNotEmpty
          ? registrationRulesController.text
          : null,
    );

    final PreservationAction? preservationAction = preservationOperationController.text.isNotEmpty
        ? PreservationAction(
            operation: preservationOperationController.text,
            updateDate: updateDate,
          )
        : null;

    final rightsInfo = RightsInfo(
      rights: rightsController.text.isNotEmpty ? rightsController.text : 'Não especificado',
    );

    final contentModel = ContentResponseModel(
      docId: widget.content?.docId ?? '',
      id: idController.text,
      theme: widget.theme,
      subtheme: subtheme,
      intellectualIndicator: intelligentIndicator,
      contentInfo: contentInfo,
      originInfo: originInfo,
      registrationInfo: registrationInfo,
      rightsInfo: rightsInfo,
      preservationAction: preservationAction,
    );

    if (widget.content != null) {
      widget.contentStore.updateContent(
        subtheme: subtheme,
        contentId: widget.content!.docId,
        content: contentModel,
      );
    } else {
      widget.contentStore.createContent(subtheme: subtheme, content: contentModel);
    }

    Navigator.pop(context);
  }
}
