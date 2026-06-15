import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: _colorScheme,
        scaffoldBackgroundColor: AppColors.creamBackground,
        textTheme: AppTypography.textTheme,
        appBarTheme: _appBarTheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        outlinedButtonTheme: _outlinedButtonTheme,
        textButtonTheme: _textButtonTheme,
        inputDecorationTheme: _inputDecorationTheme,
        cardTheme: _cardTheme,
        bottomNavigationBarTheme: _bottomNavTheme,
        chipTheme: _chipTheme,
        dividerTheme: _dividerTheme,
        snackBarTheme: _snackBarTheme,
        dialogTheme: _dialogTheme,
        bottomSheetTheme: _bottomSheetTheme,
        floatingActionButtonTheme: _fabTheme,
        navigationBarTheme: _navigationBarTheme,
      );

  static ColorScheme get _colorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.oliveGreen,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.oliveLight,
        onPrimaryContainer: AppColors.oliveGreen,
        secondary: AppColors.terracotta,
        onSecondary: AppColors.white,
        secondaryContainer: AppColors.terracottaLight,
        onSecondaryContainer: AppColors.terracotta,
        tertiary: AppColors.warmGold,
        onTertiary: AppColors.white,
        tertiaryContainer: AppColors.goldLight,
        onTertiaryContainer: AppColors.warmGold,
        error: AppColors.errorRed,
        onError: AppColors.white,
        errorContainer: Color(0xFFFBE9E7),
        onErrorContainer: AppColors.errorRed,
        surface: AppColors.creamBackground,
        onSurface: AppColors.charcoal,
        surfaceContainerHighest: AppColors.softBeige,
        onSurfaceVariant: AppColors.mutedText,
        outline: AppColors.lightBorder,
        outlineVariant: AppColors.softBeige,
        shadow: AppColors.cardShadow,
        inverseSurface: AppColors.charcoal,
        onInverseSurface: AppColors.white,
        inversePrimary: AppColors.sageGreen,
      );

  static AppBarTheme get _appBarTheme => AppBarTheme(
        backgroundColor: AppColors.creamBackground,
        foregroundColor: AppColors.charcoal,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.dmSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.charcoal,
          size: 22,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      );

  static ElevatedButtonThemeData get _elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.oliveGreen,
          foregroundColor: AppColors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.lg,
          ),
          textStyle: AppTypography.buttonText,
          minimumSize: const Size(double.infinity, 52),
        ),
      );

  static OutlinedButtonThemeData get _outlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.oliveGreen,
          side: const BorderSide(color: AppColors.oliveGreen, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.lg,
          ),
          textStyle: AppTypography.buttonText.copyWith(color: AppColors.oliveGreen),
          minimumSize: const Size(double.infinity, 52),
        ),
      );

  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.oliveGreen,
          textStyle: AppTypography.labelLg.copyWith(color: AppColors.oliveGreen),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      );

  static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.lightBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.lightBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.oliveGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
        ),
        labelStyle: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
        hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
        errorStyle: AppTypography.bodySm.copyWith(color: AppColors.errorRed),
        prefixIconColor: AppColors.mutedText,
        suffixIconColor: AppColors.mutedText,
      );

  static CardThemeData get _cardTheme => CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      );

  static BottomNavigationBarThemeData get _bottomNavTheme =>
      BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.oliveGreen,
        unselectedItemColor: AppColors.mutedText,
        selectedLabelStyle: AppTypography.navLabel,
        unselectedLabelStyle: AppTypography.navLabel,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      );

  static NavigationBarThemeData get _navigationBarTheme =>
      NavigationBarThemeData(
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.oliveLight,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.oliveGreen, size: 22);
          }
          return const IconThemeData(color: AppColors.mutedText, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.navLabel.copyWith(color: AppColors.oliveGreen);
          }
          return AppTypography.navLabel.copyWith(color: AppColors.mutedText);
        }),
        elevation: 8,
        shadowColor: AppColors.cardShadow,
        surfaceTintColor: Colors.transparent,
      );

  static ChipThemeData get _chipTheme => ChipThemeData(
        backgroundColor: AppColors.softBeige,
        selectedColor: AppColors.oliveLight,
        disabledColor: AppColors.softBeige,
        labelStyle: AppTypography.labelMd,
        secondaryLabelStyle: AppTypography.labelMd.copyWith(
          color: AppColors.oliveGreen,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.chip),
          side: const BorderSide(color: AppColors.lightBorder),
        ),
        side: const BorderSide(color: AppColors.lightBorder),
      );

  static DividerThemeData get _dividerTheme => const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
        space: 1,
      );

  static SnackBarThemeData get _snackBarTheme => SnackBarThemeData(
        backgroundColor: AppColors.charcoal,
        contentTextStyle: AppTypography.bodyMd.copyWith(color: AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      );

  static DialogThemeData get _dialogTheme => DialogThemeData(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.modal),
        ),
        elevation: 0,
        titleTextStyle: AppTypography.headingMd,
        contentTextStyle: AppTypography.bodyMd,
      );

  static BottomSheetThemeData get _bottomSheetTheme => const BottomSheetThemeData(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.bottomSheet),
          ),
        ),
        elevation: 0,
        dragHandleColor: AppColors.lightBorder,
        dragHandleSize: Size(40, 4),
      );

  static FloatingActionButtonThemeData get _fabTheme =>
      FloatingActionButtonThemeData(
        backgroundColor: AppColors.oliveGreen,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      );
}
