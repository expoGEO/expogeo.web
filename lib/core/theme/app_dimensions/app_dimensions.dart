part of '../app_theme.dart';

class AppDimensions {
  AppDimensions._();
  static AppDimensions get instance => AppDimensions._();

  DimensionStyle space = const DimensionStyle._(
    mini: 4.0,
    small: 8.0,
    medium: 16.0,
    large: 24.0,
    huge: 32.0,
    massive: 48.0,
    immense: 64.0,
    gigantic: 96.0,
  );

  DimensionStyle radius = const DimensionStyle._(
    mini: 2.0,
    small: 4.0,
    medium: 8.0,
    large: 12.0,
    huge: 24.0,
    massive: 48.0,
    immense: 64.0,
    gigantic: double.infinity,
  );

  DimensionStyle stroke = const DimensionStyle._(
    mini: 0.5,
    small: 1.0,
    medium: 2.0,
    large: 3.0,
    huge: 4.0,
    massive: 5.0,
    immense: 6.0,
    gigantic: 7.0,
  );

  double environmentBannerHeight = 32.0;

  SpacingScale spacing = const SpacingScale._();
  RadiiScale radii = const RadiiScale._();
  ShadowStyle shadows = const ShadowStyle._();
  FocusStyle focus = const FocusStyle._();
  ComponentSizes components = const ComponentSizes._();
}

class DimensionStyle {
  const DimensionStyle._({
    required this.mini,
    required this.small,
    required this.medium,
    required this.large,
    required this.huge,
    required this.massive,
    required this.immense,
    required this.gigantic,
  });

  final double mini;
  final double small;
  final double medium;
  final double large;
  final double huge;
  final double massive;
  final double immense;
  final double gigantic;
}

class SpacingScale {
  const SpacingScale._();

  final double s4 = 4.0;
  final double s8 = 8.0;
  final double s12 = 12.0;
  final double s16 = 16.0;
  final double s20 = 20.0;
  final double s24 = 24.0;
  final double s32 = 32.0;
  final double s40 = 40.0;
  final double s48 = 48.0;
  final double s64 = 64.0;
  final double s96 = 96.0;
}

class RadiiScale {
  const RadiiScale._();

  final double r6 = 6.0;
  final double r8 = 8.0;
  final double r10 = 10.0;
  final double r12 = 12.0;
  final double r14 = 14.0;
  final double r16 = 16.0;
  final double r18 = 18.0;
  final double r20 = 20.0;

  final double pill = 999.0;
}

class ShadowStyle {
  const ShadowStyle._();

  List<BoxShadow> get soft => const [
    BoxShadow(color: Color(0x141F1B18), blurRadius: 26, offset: Offset(0, 10)),
  ];

  List<BoxShadow> get elevated => const [
    BoxShadow(color: Color(0x241F1B18), blurRadius: 36, offset: Offset(0, 14)),
  ];

  /// [shadows] com a opacidade multiplicada por [opacity], para acompanhar uma animação.
  List<BoxShadow> fade(List<BoxShadow> shadows, double opacity) => [
    for (final shadow in shadows)
      shadow.copyWith(color: shadow.color.withValues(alpha: shadow.color.a * opacity)),
  ];
}

class FocusStyle {
  const FocusStyle._();

  final double width = 3.0;
  final double offset = 2.0;

  Color get color => AppColors.instance.accent;
}

class ComponentSizes {
  const ComponentSizes._();

  final double navbarHeight = 68.0;

  /// Abaixo dessa largura os itens da navbar não cabem ao lado da marca e viram o menu lateral.
  final double navbarCollapseWidth = 900.0;

  final double stripMinHeight = 34.0;
  final double stripText = 13.0;

  final double buttonMinHeightRegular = 44.0;
  final double buttonMinHeightSmall = 40.0;
  final double buttonTextRegular = 16.0;
  final double buttonTextSmall = 14.0;
  final double buttonIconScale = 1.15;
  final double buttonBorder = 1.5;
  final double disabledOpacity = 0.5;

  final double brandMark = 38.0;
  final double brandMarkZoom = 1.45;
  final double brandName = 19.0;
  final double brandTagline = 11.5;

  final double navItemText = 15.5;
  final double navIcon = 20.0;
  final double navUnderline = 2.0;
  final double navItemPaddingH = 14.0;
  final double navItemPaddingV = 10.0;

  final double menuMinWidth = 320.0;
  final double menuMaxWidth = 360.0;
  final double menuMedallion = 30.0;
  final double menuIconSize = 24.0;
  final double menuOptionText = 15.0;
  final double menuOptionPaddingV = 9.0;
  final double menuCountText = 13.0;
  final double mobileMenuMaxWidth = 420.0;
  final double scrimOpacity = 0.4;
  final Duration menuAnimation = const Duration(milliseconds: 160);
  final Duration menuCloseDelay = const Duration(milliseconds: 150);

  final double minTapTarget = 44.0;

  final double footerPaddingTop = 56.0;
  final double footerPaddingBottom = 28.0;
  final double footerGap = 36.0;
  final double footerText = 15.0;
  final double footerBottomText = 13.5;
  final double socialButton = 40.0;

  final Duration skeletonShimmer = const Duration(milliseconds: 1400);

  final double heroPaddingMobile = 44.0;
  final double heroPaddingTablet = 64.0;
  final double heroPaddingDesktop = 88.0;
  final double heroColumnGap = 40.0;
  final double heroStackGap = 24.0;
  final double heroTitleGap = 14.0;
  final double heroLeadGap = 20.0;
  final double heroActionsGap = 30.0;
  final double heroLeadMaxWidth = 620.0;

  /// Círculos concêntricos do fundo do hero: centro (fração da largura e da altura) e passo.
  final Offset heroCirclesAccentCenter = const Offset(0.86, 0.18);
  final Offset heroCirclesInkCenter = const Offset(0.08, 1.10);
  final double heroCirclesAccentStep = 27.0;
  final double heroCirclesInkStep = 35.0;
  final double heroCirclesAccentOpacity = 0.11;
  final double heroCirclesInkOpacity = 0.06;
  final double heroCirclesFadeStart = 0.55;

  final double heroCountNumber = 30.0;
  final double heroCountLineHeight = 1.1;

  /// Espaçamento entre letras do número, em fração do tamanho da fonte.
  final double heroCountLetterSpacing = -0.03;
  final double heroCountsTop = 34.0;
  final double heroCountsPaddingTop = 20.0;
  final double heroCountsGapH = 36.0;
  final double heroCountsGapV = 12.0;
  final double heroCountSkeletonWidth = 56.0;

  final double orbitMaxMobile = 230.0;
  final double orbitMaxTablet = 300.0;
  final double orbitMaxDesktop = 440.0;

  /// Proporções do anel em relação ao lado do quadrado.
  final double orbitRingInset = 0.14;
  final double orbitDashedInset = 0.31;
  final double orbitCoreInset = 0.38;
  final double orbitMedallion = 0.30;
  final double orbitMedallionPadding = 0.03;
  final double orbitRingStroke = 9.0;
  final double orbitRingOpacity = 0.9;
  final double orbitDashedStroke = 1.5;
  final double orbitDashLength = 5.0;
  final double orbitDashGap = 4.0;
  final double orbitHoverScale = 1.06;
  final Duration hoverAnimation = const Duration(milliseconds: 200);

  final double sectionPaddingMobile = 48.0;
  final double sectionPaddingTablet = 72.0;
  final double sectionPaddingDesktop = 96.0;
  final double sectionHeadGap = 28.0;
  final double sectionLabelGap = 6.0;

  /// Largura de conteúdo a partir da qual os cartões dos temas ficam em duas colunas.
  final double themeGridTwoColumnsWidth = 760.0;
  final double themeGridGap = 20.0;
  final double themeCardMedallion = 116.0;
  final double themeCardMedallionCompact = 56.0;
  final double themeCardGap = 22.0;
  final double themeCardGapCompact = 14.0;
  final double themeCardHeaderGapCompact = 12.0;
  final EdgeInsets themeCardPadding = const EdgeInsets.fromLTRB(24, 26, 24, 24);
  final EdgeInsets themeCardPaddingCompact = const EdgeInsets.fromLTRB(18, 22, 18, 18);
  final double themeCardStrip = 4.0;
  final double themeCardTitle = 22.0;
  final double themeCardTitleCompact = 19.0;
  final double themeCardDescription = 15.5;
  final double themeCardDescriptionCompact = 14.5;
  final double themeCardDescriptionGap = 6.0;
  final double themeCardStatsGap = 12.0;
  final double themeCardHoverLift = 3.0;

  /// Giro do medalhão no hover do cartão, em graus.
  final double themeCardMedallionTurn = -8.0;
  final double miniChipsGap = 14.0;
  final double miniChipSpacing = 6.0;
  final double miniChipText = 13.0;
  final EdgeInsets miniChipPadding = const EdgeInsets.symmetric(vertical: 3, horizontal: 10);

  final double stepsGap = 24.0;
  final double stepRule = 2.0;
  final double stepPaddingTop = 18.0;
  final double stepGap = 8.0;
  final double stepNumber = 30.0;
  final double stepNumberText = 14.0;
  final double stepTitle = 20.0;
  final double stepExampleText = 14.0;
  final double stepExampleTop = 6.0;
  final EdgeInsets stepExamplePadding = const EdgeInsets.symmetric(vertical: 8, horizontal: 12);
  final double stepExampleSkeletonCount = 64.0;
  final double stepExampleSkeletonTitle = 140.0;

  final double recentGridGap = 16.0;

  final int partnerColumnsMobile = 2;
  final int partnerColumnsTablet = 3;
  final int partnerColumnsDesktop = 6;
  final double partnerGap = 12.0;
  final double partnerPadding = 12.0;
  final double partnerPaddingMobile = 8.0;
  final double partnerLogoMaxWidth = 150.0;

  /// Proporção da caixa de cada logo, a da maioria das imagens (512 × 216); as outras cabem inteiras.
  final double partnerLogoAspectRatio = 512 / 216;
  final double partnerRestOpacity = 0.55;
  final double partnerHoverLift = 3.0;
  final double partnerHoverScale = 1.05;

  final double breadcrumbGap = 6.0;
  final double breadcrumbIcon = 16.0;

  final double pageHeadPaddingTop = 28.0;
  final double pageHeadPaddingBottomMobile = 32.0;
  final double pageHeadPaddingBottomTablet = 44.0;
  final double pageHeadPaddingBottomDesktop = 56.0;
  final double pageHeadTitleGap = 22.0;
  final double pageHeadLeadGap = 14.0;
  final double pageHeadMedallion = 180.0;
  final double pageHeadMedallionCompact = 96.0;
  final double pageHeadColumnGap = 40.0;
  final double pageHeadStackGap = 20.0;

  final double themeStatsTop = 18.0;
  final double themeStatsText = 15.0;
  final double themeStatsGapH = 24.0;
  final double themeStatsGapV = 8.0;
  final double themeStatsSkeletonWidth = 28.0;

  final double subthemeSectionTop = 40.0;
  final double subthemeSectionHeadGap = 24.0;
  final int subthemeColumnsMobile = 2;
  final int subthemeColumnsTablet = 3;
  final int subthemeColumnsDesktop = 4;
  final double subthemeGridGap = 20.0;
  final double subthemeGridGapMobile = 12.0;
  final EdgeInsets subthemeCardPadding = const EdgeInsets.symmetric(vertical: 22, horizontal: 18);
  final EdgeInsets subthemeCardPaddingMobile = const EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 10,
  );
  final double subthemeCardGap = 10.0;
  final double subthemeCardNameTop = 4.0;
  final double subthemeCardMedallionDesktop = 140.0;
  final double subthemeCardMedallionTablet = 120.0;
  final double subthemeCardMedallionMobile = 104.0;
  final double subthemeCardName = 18.4;
  final double subthemeCardNameMobile = 16.0;
  final double subthemeCardNameHeight = 1.2;
  final double subthemeCardCountSkeletonWidth = 64.0;
  final double subthemeCardHoverScale = 1.03;

  final double otherThemesPaddingTop = 48.0;
  final double otherThemesPaddingBottom = 72.0;
  final double otherThemesLabelGap = 12.0;
  final double otherThemesGap = 10.0;
  final EdgeInsets themeChipPadding = const EdgeInsets.fromLTRB(8, 7, 14, 7);
  final double themeChipMedallion = 22.0;
  final double themeChipGap = 6.0;
  final double themeChipText = 14.0;

  final double readingMaxWidth = 720.0;
  final double readingPaddingTop = 48.0;
  final double readingPaddingBottom = 24.0;
  final double readingParagraphGap = 20.0;
  final double readingSectionGap = 44.0;
  final double readingHeadingGap = 12.0;
  final double readingBlockGap = 22.0;

  final double aboutColumnGap = 72.0;
  final double aboutTitleTop = 10.0;
  final double aboutTitleBottom = 16.0;
  final double aboutLinkTop = 20.0;
  final double aboutLinkGap = 6.0;
  final double aboutAudienceIcon = 44.0;
  final double aboutAudienceGlyph = 20.0;
  final double aboutAudiencePadding = 18.0;
  final double aboutAudienceGap = 16.0;
  final double aboutAudienceTitle = 18.0;
  final double aboutAudienceText = 15.5;
  final double aboutAudienceTextGap = 2.0;

  final double observatoryPaddingMobile = 26.0;
  final double observatoryPadding = 44.0;
  final double observatoryRowGap = 28.0;
  final double observatoryStackGap = 18.0;
  final double observatorySymbol = 64.0;
  final double observatoryTextMaxWidth = 560.0;
  final double observatoryTitleGap = 6.0;
  final double observatoryTextGap = 8.0;

  final double observatoryCirclesStep = 31.0;
  final int observatoryCirclesCount = 9;
  final double observatoryCirclesOpacity = 0.13;

  final double codeExampleText = 24.0;
  final EdgeInsets codeExamplePadding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16);
  final double codeExampleGap = 10.0;
  final double codeExampleCaptionGap = 4.0;

  final double objectCardPadding = 20.0;
  final double objectCardGap = 10.0;
  final double objectCardIconBox = 40.0;
  final double objectCardIconRadius = 11.0;
  final double objectCardIcon = 19.0;
  final double objectCardTypeText = 12.5;

  /// Espaçamento entre letras do rótulo do tipo, em fração do tamanho da fonte.
  final double objectCardTypeLetterSpacing = 0.06;
  final double objectCardTitle = 18.0;
  final double objectCardTitleHeight = 1.3;
  final int objectCardTitleLines = 3;
  final double objectCardDescription = 15.0;
  final int objectCardDescriptionLines = 2;
  final double objectCardFooterText = 13.5;
  final double objectCardFooterPaddingTop = 10.0;
  final double objectCardFooterGap = 8.0;
  final double objectCardMedallion = 22.0;
  final double objectCardHoverLift = 2.0;
  final double objectCardSkeletonTypeWidth = 96.0;
  final double objectCardSkeletonFooterWidth = 160.0;

  /// Largura da última linha de cada bloco de texto no esqueleto, em fração da largura do cartão.
  final double objectCardSkeletonShortLine = 0.6;

  /// Parte da altura de cada linha de texto ocupada pela barra do esqueleto; o resto é o vão.
  final double objectCardSkeletonBarFill = 0.75;

  final double pageHeadTopGap = 12.0;
}
