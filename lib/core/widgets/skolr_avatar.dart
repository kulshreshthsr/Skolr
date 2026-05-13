import 'package:flutter/material.dart';

import '../design_system/design_system.dart';

/// Avatar size enum.
enum SkolrAvatarSize { sm, md, lg, xl }

/// Round avatar with image support and initials fallback.
///
/// Background color is deterministic per name — the same name always
/// gets the same color, so avatars are consistent across sessions.
///
/// Uses [SkolrColors.avatarFor] for the deterministic color pair,
/// which selects from 6 hand-picked palettes that harmonise with
/// the violet/blue brand.
///
/// Usage:
/// ```dart
/// SkolrAvatar(name: 'Riya Sharma')           // initials, auto color
/// SkolrAvatar(name: 'Riya Sharma', size: SkolrAvatarSize.lg)
/// SkolrAvatar(name: 'Riya', imageUrl: '...') // image with initials fallback
/// ```
class SkolrAvatar extends StatelessWidget {
  const SkolrAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = SkolrAvatarSize.md,
  });

  final String name;
  final String? imageUrl;
  final SkolrAvatarSize size;

  double get _diameter => switch (size) {
        SkolrAvatarSize.sm => 32,
        SkolrAvatarSize.md => 40,
        SkolrAvatarSize.lg => 56,
        SkolrAvatarSize.xl => 80,
      };

  double get _fontSize => switch (size) {
        SkolrAvatarSize.sm => 12,
        SkolrAvatarSize.md => 15,
        SkolrAvatarSize.lg => 20,
        SkolrAvatarSize.xl => 28,
      };

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (bgColor, fgColor) = SkolrColors.avatarFor(name);

    Widget content;

    if (imageUrl != null) {
      content = Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _InitialsContent(
          initials: _initials,
          fontSize: _fontSize,
          color: fgColor,
        ),
        loadingBuilder: (_, child, loadingProgress) => loadingProgress == null
            ? child
            : _InitialsContent(
                initials: _initials,
                fontSize: _fontSize,
                color: fgColor,
              ),
      );
    } else {
      content = _InitialsContent(
        initials: _initials,
        fontSize: _fontSize,
        color: fgColor,
      );
    }

    return Container(
      width: _diameter,
      height: _diameter,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: cs.surfaceContainer,
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: content,
    );
  }
}

class _InitialsContent extends StatelessWidget {
  const _InitialsContent({
    required this.initials,
    required this.fontSize,
    required this.color,
  });

  final String initials;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: SkolrTypography.labelLarge(color: color).copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}