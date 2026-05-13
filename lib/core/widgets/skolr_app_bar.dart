import 'package:flutter/material.dart';

import '../design_system/design_system.dart';

/// A large-to-small collapsing app bar built on [SliverAppBar.large].
///
/// Use inside a [CustomScrollView]'s `slivers` list. The large title
/// collapses to the small title as content scrolls up, using Material 3's
/// standard large app bar motion.
///
/// Usage:
/// ```dart
/// Scaffold(
///   body: CustomScrollView(
///     slivers: [
///       SkolrSliverAppBar(
///         title: 'Students',
///         subtitle: '24 enrolled',
///         actions: [
///           IconButton(icon: Icon(Icons.add), onPressed: _add),
///         ],
///       ),
///       SliverPadding(
///         padding: SkolrSpacing.pageHorizontal,
///         sliver: SliverList.builder(
///           itemCount: students.length,
///           itemBuilder: (_, i) => StudentCard(student: students[i]),
///         ),
///       ),
///     ],
///   ),
/// )
/// ```
class SkolrSliverAppBar extends StatelessWidget {
  const SkolrSliverAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
  });

  final String title;

  /// Optional one-liner shown below the large title. Hidden in the
  /// collapsed small-title state.
  final String? subtitle;

  final Widget? leading;
  final List<Widget>? actions;

  /// Whether the app bar remains visible at the top when scrolled.
  final bool pinned;
  final bool floating;
  final bool snap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Large title — shown when expanded
    Widget largeTitle = Text(
      title,
      style: SkolrTypography.headlineLarge(color: cs.onSurface),
    );

    if (subtitle != null) {
      largeTitle = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          largeTitle,
          const SizedBox(height: SkolrSpacing.xs),
          Text(
            subtitle!,
            style: SkolrTypography.bodyMedium(color: cs.onSurfaceVariant),
          ),
        ],
      );
    }

    return SliverAppBar.large(
      pinned: pinned,
      floating: floating,
      snap: snap,
      backgroundColor: cs.surface,
      foregroundColor: cs.onSurface,
      surfaceTintColor: Colors.transparent,
      shadowColor: cs.shadow.withValues(alpha: 0.08),
      leading: leading,
      actions: actions,
      // Small title (collapsed state)
      title: Text(
        title,
        style: SkolrTypography.titleLarge(color: cs.onSurface),
      ),
      // Large title (expanded state)
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.fromSTEB(
          SkolrSpacing.lg,
          0,
          SkolrSpacing.lg,
          SkolrSpacing.lg,
        ),
        title: largeTitle,
        collapseMode: CollapseMode.pin,
      ),
    );
  }
}

/// Convenience widget that wraps a [CustomScrollView] with [SkolrSliverAppBar]
/// and one content sliver. For screens that just need the standard shell
/// without needing direct [CustomScrollView] access.
///
/// Usage:
/// ```dart
/// SkolrPageShell(
///   title: 'Fees',
///   subtitle: '₹2.4L collected',
///   actions: [IconButton(...)],
///   sliver: SliverList.builder(...),
/// )
/// ```
class SkolrPageShell extends StatelessWidget {
  const SkolrPageShell({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    required this.sliver,
    this.scrollController,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget sliver;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SkolrSliverAppBar(
          title: title,
          subtitle: subtitle,
          leading: leading,
          actions: actions,
        ),
        sliver,
      ],
    );
  }
}
