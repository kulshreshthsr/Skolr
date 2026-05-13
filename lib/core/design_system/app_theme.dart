import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_motion.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

// ---------------------------------------------------------------------------
// SkolrTheme v2 — premium dark-first + polished light
//
// Both themes share the same brand identity (violet→blue gradient, glass
// surfaces, generous radii). Dark is the canonical mode; light is the
// translation. Neither mode should ever feel "incomplete" — light mode
// gets just as much love as dark.
//
// Key choices:
//   • All cards: transparent fill — relies on parent (SkolrCard widget)
//     for the actual glass treatment. ThemeData.cardTheme just defines
//     the default border/shape so unstyled `Card()` widgets still look right.
//   • All buttons via theme are SOLID (filled) — gradient buttons come from
//     the PrimaryButton widget (Wave 2). Theme buttons are the fallback.
//   • Input fields use `surfaceContainer` for fill — sits naturally on
//     both midnight (dark) and pale violet (light) backgrounds.
//   • System UI overlay style is set per-mode so the status bar icons
//     are always readable.
// ---------------------------------------------------------------------------

abstract final class SkolrTheme {
  static ThemeData light() => _build(SkolrColors.light);
  static ThemeData dark() => _build(SkolrColors.dark);

  static ThemeData _build(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: scheme.brightness,
      textTheme: SkolrTypography.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),

      // Splash — InkSparkle on Android, default elsewhere
      splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
      splashColor: scheme.primary.withValues(alpha: 0.08),
      highlightColor: scheme.primary.withValues(alpha: 0.04),

      // Scaffold — transparent so the gradient background can show through
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,

      // ── AppBar ────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: SkolrTypography.titleLarge(color: scheme.onSurface),
        toolbarHeight: 64,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: SkolrColors.midnight900,
                systemNavigationBarIconBrightness: Brightness.light,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: SkolrColors.lightBg,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
        iconTheme: IconThemeData(color: scheme.onSurface, size: 22),
        actionsIconTheme: IconThemeData(color: scheme.onSurface, size: 22),
      ),

      // ── Card ──────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark
            ? SkolrColors.midnight600.withValues(alpha: 0.6)
            : SkolrColors.lightSurface,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: SkolrRadius.xl,
          side: BorderSide(
            color: isDark
                ? SkolrColors.glassBorder
                : SkolrColors.lightBorder,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      // ── ElevatedButton (solid primary fallback) ──────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: scheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: SkolrSpacing.xl,
            vertical: SkolrSpacing.lg,
          ),
          minimumSize: const Size(double.infinity, 56),
          shape: const RoundedRectangleBorder(borderRadius: SkolrRadius.lg),
          textStyle: SkolrTypography.labelLarge(),
          animationDuration: SkolrMotion.fast,
        ),
      ),

      // ── FilledButton ──────────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: SkolrSpacing.xl,
            vertical: SkolrSpacing.lg,
          ),
          minimumSize: const Size(64, 52),
          shape: const RoundedRectangleBorder(borderRadius: SkolrRadius.lg),
          textStyle: SkolrTypography.labelLarge(),
        ),
      ),

      // ── OutlinedButton ────────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(
            color: isDark
                ? SkolrColors.glassBorderStrong
                : SkolrColors.lightBorderStrong,
            width: 1.2,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: SkolrSpacing.xl,
            vertical: SkolrSpacing.lg,
          ),
          minimumSize: const Size(64, 52),
          shape: const RoundedRectangleBorder(borderRadius: SkolrRadius.lg),
          textStyle: SkolrTypography.labelLarge(),
        ),
      ),

      // ── TextButton ────────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: SkolrSpacing.md,
            vertical: SkolrSpacing.sm,
          ),
          minimumSize: const Size(48, 44),
          shape: const RoundedRectangleBorder(borderRadius: SkolrRadius.md),
          textStyle: SkolrTypography.labelLarge(),
        ),
      ),

      // ── IconButton ────────────────────────────────────────────────────────
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: scheme.onSurface,
          padding: const EdgeInsets.all(SkolrSpacing.sm),
          minimumSize: const Size(44, 44),
          shape: const RoundedRectangleBorder(borderRadius: SkolrRadius.md),
        ),
      ),

      // ── InputDecoration ───────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? SkolrColors.midnight700.withValues(alpha: 0.6)
            : SkolrColors.lightSurface,
        hintStyle: SkolrTypography.bodyLarge(
          color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        labelStyle: SkolrTypography.bodyMedium(
          color: scheme.onSurfaceVariant,
        ),
        floatingLabelStyle: SkolrTypography.labelMedium(
          color: scheme.primary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SkolrSpacing.lg,
          vertical: SkolrSpacing.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: SkolrRadius.lg,
          borderSide: BorderSide(
            color: isDark
                ? SkolrColors.glassBorder
                : SkolrColors.lightBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: SkolrRadius.lg,
          borderSide: BorderSide(
            color: isDark
                ? SkolrColors.glassBorder
                : SkolrColors.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: SkolrRadius.lg,
          borderSide: BorderSide(color: scheme.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: SkolrRadius.lg,
          borderSide: BorderSide(color: scheme.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: SkolrRadius.lg,
          borderSide: BorderSide(color: scheme.error, width: 1.8),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: SkolrRadius.lg,
          borderSide: BorderSide(
            color: scheme.onSurface.withValues(alpha: 0.08),
          ),
        ),
        errorStyle: SkolrTypography.labelMedium(color: scheme.error),
        isDense: false,
      ),

      // ── BottomNavigationBar (legacy) ──────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurfaceVariant,
        selectedLabelStyle: SkolrTypography.labelMedium(),
        unselectedLabelStyle: SkolrTypography.labelMedium(),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),

      // ── NavigationBar (M3) ────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark
            ? SkolrColors.midnight800.withValues(alpha: 0.85)
            : SkolrColors.lightSurface.withValues(alpha: 0.92),
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.primary.withValues(alpha: 0.16),
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: SkolrRadius.full,
        ),
        height: 72,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: scheme.primary, size: 24);
          }
          return IconThemeData(color: scheme.onSurfaceVariant, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final base = SkolrTypography.labelMedium();
          if (states.contains(WidgetState.selected)) {
            return base.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
            );
          }
          return base.copyWith(color: scheme.onSurfaceVariant);
        }),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),

      // ── SnackBar ──────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark
            ? SkolrColors.midnight500
            : SkolrColors.textPrimaryLight,
        contentTextStyle: SkolrTypography.bodyMedium(
          color: isDark ? SkolrColors.textPrimaryDark : Colors.white,
        ),
        actionTextColor: scheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: SkolrRadius.lg),
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: SkolrSpacing.lg,
          vertical: SkolrSpacing.md,
        ),
      ),

      // ── Dialog ────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: isDark
            ? SkolrColors.midnight600
            : SkolrColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: SkolrRadius.xxl,
          side: BorderSide(
            color: isDark
                ? SkolrColors.glassBorder
                : SkolrColors.lightBorder,
            width: 1,
          ),
        ),
        titleTextStyle: SkolrTypography.headlineMedium(
          color: scheme.onSurface,
        ),
        contentTextStyle: SkolrTypography.bodyMedium(
          color: scheme.onSurfaceVariant,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          SkolrSpacing.xl,
          0,
          SkolrSpacing.xl,
          SkolrSpacing.xl,
        ),
      ),

      // ── BottomSheet ───────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark
            ? SkolrColors.midnight700
            : SkolrColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: SkolrRadius.topXxxl),
        modalBarrierColor: Colors.black.withValues(alpha: 0.6),
        dragHandleColor: scheme.onSurfaceVariant.withValues(alpha: 0.4),
        dragHandleSize: const Size(40, 4),
        showDragHandle: true,
        constraints: const BoxConstraints(maxWidth: 640),
      ),

      // ── Divider ───────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: isDark
            ? SkolrColors.glassBorder
            : SkolrColors.lightBorder,
        thickness: 1,
        space: 1,
      ),

      // ── Chip ──────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? SkolrColors.midnight600.withValues(alpha: 0.6)
            : SkolrColors.lightSurfaceAlt,
        selectedColor: scheme.primary.withValues(alpha: 0.2),
        labelStyle: SkolrTypography.labelMedium(color: scheme.onSurface),
        secondaryLabelStyle: SkolrTypography.labelMedium(
          color: scheme.primary,
        ),
        side: BorderSide(
          color: isDark
              ? SkolrColors.glassBorder
              : SkolrColors.lightBorder,
        ),
        shape: const RoundedRectangleBorder(borderRadius: SkolrRadius.full),
        padding: const EdgeInsets.symmetric(
          horizontal: SkolrSpacing.md,
          vertical: SkolrSpacing.xs,
        ),
      ),

      // ── FloatingActionButton ──────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: SkolrRadius.xl),
        extendedTextStyle: SkolrTypography.labelLarge(),
        extendedPadding: const EdgeInsets.symmetric(horizontal: SkolrSpacing.xl),
      ),

      // ── ListTile ──────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding: SkolrSpacing.tilePadding,
        minLeadingWidth: 0,
        minVerticalPadding: SkolrSpacing.md,
        tileColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: SkolrRadius.lg),
        titleTextStyle: SkolrTypography.bodyLarge(color: scheme.onSurface),
        subtitleTextStyle: SkolrTypography.bodyMedium(
          color: scheme.onSurfaceVariant,
        ),
        leadingAndTrailingTextStyle: SkolrTypography.labelMedium(
          color: scheme.onSurfaceVariant,
        ),
        iconColor: scheme.onSurfaceVariant,
      ),

      // ── Switch ────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return scheme.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return scheme.surfaceContainerHigh;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.transparent;
          return scheme.outline.withValues(alpha: 0.4);
        }),
      ),

      // ── Checkbox ──────────────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(scheme.onPrimary),
        side: BorderSide(
          color: scheme.onSurfaceVariant,
          width: 1.5,
        ),
        shape: const RoundedRectangleBorder(borderRadius: SkolrRadius.sm),
      ),

      // ── Radio ─────────────────────────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return scheme.onSurfaceVariant;
        }),
      ),

      // ── ProgressIndicator ─────────────────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.primary.withValues(alpha: 0.16),
        circularTrackColor: scheme.primary.withValues(alpha: 0.16),
      ),

      // ── Tooltip ───────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark
              ? SkolrColors.midnight500
              : SkolrColors.textPrimaryLight,
          borderRadius: SkolrRadius.md,
        ),
        textStyle: SkolrTypography.labelMedium(
          color: isDark ? Colors.white : Colors.white,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: SkolrSpacing.md,
          vertical: SkolrSpacing.sm,
        ),
      ),

      // ── PopupMenu ─────────────────────────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color: isDark
            ? SkolrColors.midnight600
            : SkolrColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: SkolrRadius.lg,
          side: BorderSide(
            color: isDark
                ? SkolrColors.glassBorder
                : SkolrColors.lightBorder,
          ),
        ),
        textStyle: SkolrTypography.bodyMedium(color: scheme.onSurface),
      ),

      // ── DropdownMenu ──────────────────────────────────────────────────────
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(
            isDark
                ? SkolrColors.midnight600
                : SkolrColors.lightSurface,
          ),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: SkolrRadius.lg,
              side: BorderSide(
                color: isDark
                    ? SkolrColors.glassBorder
                    : SkolrColors.lightBorder,
              ),
            ),
          ),
        ),
        textStyle: SkolrTypography.bodyLarge(color: scheme.onSurface),
      ),

      // ── SegmentedButton ───────────────────────────────────────────────────
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: isDark
              ? SkolrColors.midnight700.withValues(alpha: 0.6)
              : SkolrColors.lightSurfaceAlt,
          foregroundColor: scheme.onSurfaceVariant,
          selectedBackgroundColor: scheme.primary.withValues(alpha: 0.16),
          selectedForegroundColor: scheme.primary,
          textStyle: SkolrTypography.labelMedium(),
          side: BorderSide(
            color: isDark
                ? SkolrColors.glassBorder
                : SkolrColors.lightBorder,
          ),
          shape: const RoundedRectangleBorder(borderRadius: SkolrRadius.full),
        ),
      ),

      // ── TabBar ────────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        labelStyle: SkolrTypography.labelLarge(),
        unselectedLabelStyle: SkolrTypography.labelLarge(),
        indicatorColor: scheme.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
      ),
    );
  }
}