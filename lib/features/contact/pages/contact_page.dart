import 'package:expogeo/core/components/reading/breadcrumbs.dart';
import 'package:expogeo/core/components/reading/page_header.dart';
import 'package:expogeo/core/components/structure/page_content.dart';
import 'package:expogeo/core/components/structure/page_meta_scope.dart';
import 'package:expogeo/core/components/structure/site_scaffold.dart';
import 'package:expogeo/core/navigation/app_router.dart';
import 'package:expogeo/core/theme/app_theme.dart';
import 'package:expogeo/core/utils/browser/page_meta.dart';
import 'package:expogeo/core/utils/constants/site_copy.dart';
import 'package:expogeo/core/utils/screen/screen_utils.dart';
import 'package:expogeo/features/contact/components/contact_form.dart';
import 'package:expogeo/features/contact/components/contact_info_card.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  // A troca entre coluna e linha remontaria o formulário e apagaria o que foi digitado.
  final GlobalKey _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final gap = switch (breakpoint) {
      Breakpoint.mobile => components.contactColumnsGapMobile,
      Breakpoint.tablet => components.contactColumnsGapTablet,
      Breakpoint.desktop => components.contactColumnsGapDesktop,
    };
    // Grupos: a ordem de Tab padrão é geométrica e alternaria entre as duas colunas do desktop.
    final form = FocusTraversalGroup(child: ContactForm(key: _formKey));
    final info = FocusTraversalGroup(child: const ContactInfoCard());

    return PageMetaScope(
      meta: PageMeta.titled(
        title: 'Contato',
        description: SiteCopy.contactLead,
        path: AppRouter.contact,
      ),
      child: SiteScaffold(
        slivers: [
          const SliverToBoxAdapter(
            child: PageHeader(
              breadcrumbs: [
                BreadcrumbItem('Início', route: AppRouter.home),
                BreadcrumbItem('Contato'),
              ],
              title: SiteCopy.contactTitle,
              lead: SiteCopy.contactLead,
            ),
          ),
          SliverToBoxAdapter(
            child: PageContent(
              child: Padding(
                padding: EdgeInsets.only(
                  top: components.contactPaddingTop,
                  bottom: components.contactPaddingBottom,
                ),
                child: breakpoint == Breakpoint.desktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: components.contactFormFlex, child: form),
                          SizedBox(width: gap),
                          Expanded(flex: components.contactInfoFlex, child: info),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          form,
                          SizedBox(height: gap),
                          info,
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
