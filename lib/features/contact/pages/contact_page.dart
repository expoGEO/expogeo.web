import 'package:expogeo/core/utils/extensions/num_extension.dart';
import 'package:expogeo/features/contact/components/contact_banner.dart';
import 'package:expogeo/features/contact/components/contact_form.dart';
import 'package:flutter/material.dart';

import '../../../core/components/structure/footer.dart';
import '../../../core/components/structure/navbar.dart';
import '../../../core/theme/app_theme.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.gradients.primaryGradient),
        child: Column(
          children: [
            const Navbar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const ContactBanner(),
                    const ContactForm(),
                    SizedBox(height: AppTheme.dimensions.space.large.height),
                    const Footer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
