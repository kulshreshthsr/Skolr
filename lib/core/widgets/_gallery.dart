import 'package:flutter/material.dart';

import '../design_system/design_system.dart';
import 'widgets.dart';

// Widget gallery — not shipped in production.
// Set _kShowWidgetGallery = true in main.dart to open this screen.

class WidgetGallery extends StatefulWidget {
  const WidgetGallery({super.key});

  @override
  State<WidgetGallery> createState() => _WidgetGalleryState();
}

class _WidgetGalleryState extends State<WidgetGallery> {
  // ── Local state for interactive demos ───────────────────────────────────
  ThemeMode _themeMode = ThemeMode.light;
  bool _btnLoading = false;
  String? _fieldError;
  int _segmentIndex = 0;
  int _navIndex = 0;
  bool _chip1 = true;
  bool _chip2 = false;
  bool _chip3 = false;
  final _scrollCtrl = ScrollController();
  final _fieldCtrl = TextEditingController();

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _fieldCtrl.dispose();
    super.dispose();
  }

  void _toggleLoading() {
    setState(() => _btnLoading = true);
    Future.delayed(const Duration(seconds: 2),
        () => mounted ? setState(() => _btnLoading = false) : null);
  }

  void _toggleError() {
    setState(() => _fieldError =
        _fieldError == null ? 'Enter a valid 10-digit phone number' : null);
  }

  // ── Theme wrapper ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = _themeMode == ThemeMode.dark
        ? SkolrTheme.dark()
        : SkolrTheme.light();

    return Theme(
      data: theme,
      child: Builder(builder: _buildScaffold),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      body: CustomScrollView(
        controller: _scrollCtrl,
        slivers: [
          SkolrSliverAppBar(
            title: 'Component Gallery',
            subtitle: 'Phase 2 — QA Review',
            actions: [
              IconButton(
                icon: Icon(
                  _themeMode == ThemeMode.dark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: cs.onSurfaceVariant,
                ),
                tooltip: 'Toggle theme',
                onPressed: () => setState(() {
                  _themeMode = _themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                }),
              ),
            ],
          ),
          SliverPadding(
            padding: SkolrSpacing.pagePadding,
            sliver: SliverList.list(
              children: [
                // ── 1. Buttons ─────────────────────────────────────────
                _Section('Buttons', children: [
                  _Label('Variants — full width'),
                  SkolrButton(label: 'Primary', onPressed: () {}),
                  const SkolrGap.sm(),
                  SkolrButton(
                    label: 'Secondary',
                    variant: SkolrButtonVariant.secondary,
                    onPressed: () {},
                  ),
                  const SkolrGap.sm(),
                  SkolrButton(
                    label: 'Tertiary',
                    variant: SkolrButtonVariant.tertiary,
                    onPressed: () {},
                  ),
                  const SkolrGap.sm(),
                  SkolrButton(
                    label: 'Destructive',
                    variant: SkolrButtonVariant.destructive,
                    onPressed: () {},
                  ),
                  const SkolrGap.lg(),
                  _Label('Sizes — hug content'),
                  Wrap(
                    spacing: SkolrSpacing.sm,
                    runSpacing: SkolrSpacing.sm,
                    children: [
                      SkolrButton(
                        label: 'Small',
                        size: SkolrSize.sm,
                        fullWidth: false,
                        onPressed: () {},
                      ),
                      SkolrButton(
                        label: 'Medium',
                        size: SkolrSize.md,
                        fullWidth: false,
                        onPressed: () {},
                      ),
                      SkolrButton(
                        label: 'Large',
                        size: SkolrSize.lg,
                        fullWidth: false,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SkolrGap.lg(),
                  _Label('With icons'),
                  Wrap(
                    spacing: SkolrSpacing.sm,
                    runSpacing: SkolrSpacing.sm,
                    children: [
                      SkolrButton(
                        label: 'Add Student',
                        fullWidth: false,
                        leadingIcon: const Icon(Icons.add_rounded),
                        onPressed: () {},
                      ),
                      SkolrButton(
                        label: 'Next',
                        fullWidth: false,
                        variant: SkolrButtonVariant.secondary,
                        trailingIcon:
                            const Icon(Icons.arrow_forward_rounded),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SkolrGap.lg(),
                  _Label('States'),
                  Row(
                    children: [
                      Expanded(
                        child: SkolrButton(
                          label: 'Loading',
                          isLoading: _btnLoading,
                          onPressed: _toggleLoading,
                        ),
                      ),
                      const SkolrGap.sm(),
                      Expanded(
                        child: SkolrButton(
                          label: 'Disabled',
                          onPressed: null,
                        ),
                      ),
                    ],
                  ),
                ]),

                // ── 2. Text Fields ─────────────────────────────────────
                _Section('Text Fields', children: [
                  SkolrTextField(
                    label: 'Student Name',
                    hint: 'e.g. Riya Sharma',
                    controller: _fieldCtrl,
                    prefixIcon:
                        const Icon(Icons.person_outline_rounded),
                  ),
                  const SkolrGap.lg(),
                  SkolrTextField(
                    label: 'Phone Number',
                    hint: '+91 98765 43210',
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone_outlined),
                    error: _fieldError,
                    helper: _fieldError == null
                        ? 'Used for WhatsApp reminders'
                        : null,
                  ),
                  const SkolrGap.sm(),
                  TextButton(
                    onPressed: _toggleError,
                    child: Text(_fieldError == null
                        ? 'Trigger error state'
                        : 'Clear error'),
                  ),
                  const SkolrGap.md(),
                  const SkolrTextField(
                    label: 'Password',
                    hint: 'Min 8 characters',
                    obscureText: true,
                  ),
                  const SkolrGap.md(),
                  const SkolrTextField(
                    label: 'Disabled field',
                    hint: 'Cannot edit',
                    enabled: false,
                  ),
                ]),

                // ── 3. Cards ───────────────────────────────────────────
                _Section('Cards', children: [
                  SkolrCard(
                    padding: SkolrSpacing.cardPadding,
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded),
                        const SkolrGap.md(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Flat card',
                                  style: SkolrTypography.titleMedium()),
                              Text('Border only, no shadow',
                                  style: SkolrTypography.bodyMedium()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SkolrGap.md(),
                  SkolrCard(
                    variant: SkolrCardVariant.elevated,
                    padding: SkolrSpacing.cardPadding,
                    child: Row(
                      children: [
                        const Icon(Icons.layers_outlined),
                        const SkolrGap.md(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Elevated card',
                                  style: SkolrTypography.titleMedium()),
                              Text('Soft ambient shadow',
                                  style: SkolrTypography.bodyMedium()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SkolrGap.md(),
                  SkolrCard(
                    variant: SkolrCardVariant.interactive,
                    padding: SkolrSpacing.cardPadding,
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Card tapped')),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.touch_app_outlined),
                        const SkolrGap.md(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Interactive card',
                                  style: SkolrTypography.titleMedium()),
                              Text('Tap me — ripple + 0.98 scale',
                                  style: SkolrTypography.bodyMedium()),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ),
                ]),

                // ── 4. Bottom Nav preview ──────────────────────────────
                _Section('Bottom Nav', children: [
                  _Label(
                      'Live demo at bottom of this screen. '
                      'Scroll down to trigger frosted glass.'),
                  const SkolrGap.sm(),
                  // Static preview at fixed height
                  SizedBox(
                    height: 72,
                    child: ClipRRect(
                      borderRadius: SkolrRadius.lg,
                      child: SkolrBottomNav(
                        currentIndex: _navIndex,
                        onTap: (i) => setState(() => _navIndex = i),
                        items: const [
                          SkolrNavItem(
                              icon: Icons.home_rounded,
                              activeIcon: Icons.home_rounded,
                              label: 'Home'),
                          SkolrNavItem(
                              icon: Icons.people_outline_rounded,
                              activeIcon: Icons.people_rounded,
                              label: 'Students'),
                          SkolrNavItem(
                              icon: Icons.check_circle_outline_rounded,
                              activeIcon: Icons.check_circle_rounded,
                              label: 'Attendance'),
                          SkolrNavItem(
                              icon: Icons.currency_rupee_rounded,
                              activeIcon: Icons.currency_rupee_rounded,
                              label: 'Fees'),
                        ],
                      ),
                    ),
                  ),
                ]),

                // ── 5. Empty State ─────────────────────────────────────
                _Section('Empty State', children: [
                  SkolrCard(
                    child: SkolrEmptyState(
                      illustration: Icon(
                        Icons.people_outline_rounded,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      headline: 'No students yet',
                      supportText:
                          'Add your first student to start tracking attendance and fees.',
                      primaryAction: 'Add Student',
                      onPrimaryAction: () {},
                      secondaryAction: 'Import from CSV',
                      onSecondaryAction: () {},
                    ),
                  ),
                ]),

                // ── 6. Skeletons ───────────────────────────────────────
                _Section('Skeletons', children: [
                  _Label('Line'),
                  const SkolrSkeleton.line(),
                  const SkolrGap.sm(),
                  const SkolrSkeleton.line(width: 200),
                  const SkolrGap.sm(),
                  const SkolrSkeleton.line(width: 120),
                  const SkolrGap.lg(),
                  _Label('Block'),
                  const SkolrSkeleton.block(height: 120),
                  const SkolrGap.md(),
                  Row(
                    children: const [
                      Expanded(child: SkolrSkeleton.block(height: 80)),
                      SkolrGap.md(),
                      Expanded(child: SkolrSkeleton.block(height: 80)),
                    ],
                  ),
                  const SkolrGap.lg(),
                  _Label('Circle (avatars)'),
                  Row(
                    children: const [
                      SkolrSkeleton.circle(size: 32),
                      SkolrGap.md(),
                      SkolrSkeleton.circle(size: 40),
                      SkolrGap.md(),
                      SkolrSkeleton.circle(size: 56),
                      SkolrGap.md(),
                      SkolrSkeleton.circle(size: 80),
                    ],
                  ),
                  const SkolrGap.lg(),
                  _Label('Card skeleton (composed)'),
                  SkolrCard(
                    padding: SkolrSpacing.cardPadding,
                    child: Row(
                      children: [
                        const SkolrSkeleton.circle(size: 48),
                        const SkolrGap.md(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SkolrSkeleton.line(width: 140),
                              SkolrGap.sm(),
                              SkolrSkeleton.line(width: 90),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),

                // ── 7. Bottom Sheet ────────────────────────────────────
                _Section('Bottom Sheet', children: [
                  SkolrButton(
                    label: 'Open Bottom Sheet',
                    variant: SkolrButtonVariant.secondary,
                    leadingIcon: const Icon(Icons.expand_less_rounded),
                    onPressed: () => SkolrBottomSheet.show(
                      context,
                      title: 'Filter Students',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Batch',
                              style: SkolrTypography.titleMedium()),
                          const SkolrGap.md(),
                          Wrap(
                            spacing: SkolrSpacing.sm,
                            children: ['All', 'Class 10', 'Class 11', 'Class 12']
                                .map((b) => SkolrChip(
                                      label: b,
                                      selected: b == 'All',
                                      onTap: () {},
                                    ))
                                .toList(),
                          ),
                          const SkolrGap.xl(),
                          SkolrButton(
                            label: 'Apply Filters',
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),

                // ── 8. Chips ───────────────────────────────────────────
                _Section('Chips', children: [
                  _Label('Selectable'),
                  Wrap(
                    spacing: SkolrSpacing.sm,
                    runSpacing: SkolrSpacing.sm,
                    children: [
                      SkolrChip(
                        label: 'Present',
                        selected: _chip1,
                        onTap: () =>
                            setState(() => _chip1 = !_chip1),
                        leading:
                            const Icon(Icons.check_circle_outline_rounded),
                      ),
                      SkolrChip(
                        label: 'Absent',
                        selected: _chip2,
                        onTap: () =>
                            setState(() => _chip2 = !_chip2),
                        leading:
                            const Icon(Icons.cancel_outlined),
                      ),
                      SkolrChip(
                        label: 'Late',
                        selected: _chip3,
                        onTap: () =>
                            setState(() => _chip3 = !_chip3),
                      ),
                    ],
                  ),
                  const SkolrGap.md(),
                  _Label('Display only (sm)'),
                  Wrap(
                    spacing: SkolrSpacing.sm,
                    runSpacing: SkolrSpacing.sm,
                    children: const [
                      SkolrChip(
                          label: 'Class 10-A',
                          size: SkolrChipSize.sm),
                      SkolrChip(
                          label: 'Class 11-B',
                          size: SkolrChipSize.sm),
                      SkolrChip(
                          label: 'Class 12',
                          size: SkolrChipSize.sm),
                    ],
                  ),
                ]),

                // ── 9. Avatars ─────────────────────────────────────────
                _Section('Avatars', children: [
                  _Label('Sizes'),
                  Row(
                    children: const [
                      SkolrAvatar(
                          name: 'Riya Sharma',
                          size: SkolrAvatarSize.sm),
                      SkolrGap.md(),
                      SkolrAvatar(
                          name: 'Arjun Patel',
                          size: SkolrAvatarSize.md),
                      SkolrGap.md(),
                      SkolrAvatar(
                          name: 'Meena Singh',
                          size: SkolrAvatarSize.lg),
                      SkolrGap.md(),
                      SkolrAvatar(
                          name: 'Rohan Kumar',
                          size: SkolrAvatarSize.xl),
                    ],
                  ),
                  const SkolrGap.md(),
                  _Label('Auto-color from name hash'),
                  Wrap(
                    spacing: SkolrSpacing.sm,
                    runSpacing: SkolrSpacing.sm,
                    children: const [
                      SkolrAvatar(name: 'Asha Mehta'),
                      SkolrAvatar(name: 'Vikram Das'),
                      SkolrAvatar(name: 'Priya Nair'),
                      SkolrAvatar(name: 'Suresh Gupta'),
                      SkolrAvatar(name: 'Kiran Reddy'),
                      SkolrAvatar(name: 'Deepa Iyer'),
                    ],
                  ),
                ]),

                // ── 10. Badges ─────────────────────────────────────────
                _Section('Badges', children: [
                  _Label('Variants'),
                  Wrap(
                    spacing: SkolrSpacing.sm,
                    runSpacing: SkolrSpacing.sm,
                    children: const [
                      SkolrBadge(label: 'Neutral'),
                      SkolrBadge(
                          label: 'Paid',
                          variant: SkolrBadgeVariant.success),
                      SkolrBadge(
                          label: 'Pending',
                          variant: SkolrBadgeVariant.warning),
                      SkolrBadge(
                          label: 'Overdue',
                          variant: SkolrBadgeVariant.danger),
                      SkolrBadge(
                          label: 'Info',
                          variant: SkolrBadgeVariant.info),
                    ],
                  ),
                  const SkolrGap.md(),
                  _Label('Dot variant'),
                  Wrap(
                    spacing: SkolrSpacing.lg,
                    children: const [
                      SkolrBadge(size: SkolrBadgeSize.dot),
                      SkolrBadge(
                          size: SkolrBadgeSize.dot,
                          variant: SkolrBadgeVariant.success),
                      SkolrBadge(
                          size: SkolrBadgeSize.dot,
                          variant: SkolrBadgeVariant.warning),
                      SkolrBadge(
                          size: SkolrBadgeSize.dot,
                          variant: SkolrBadgeVariant.danger),
                    ],
                  ),
                  const SkolrGap.md(),
                  _Label('In-context usage'),
                  SkolrCard(
                    padding: SkolrSpacing.cardPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Riya Sharma — ₹5,000'),
                        SkolrBadge(
                          label: 'Paid',
                          variant: SkolrBadgeVariant.success,
                        ),
                      ],
                    ),
                  ),
                  const SkolrGap.sm(),
                  SkolrCard(
                    padding: SkolrSpacing.cardPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Arjun Patel — ₹3,500'),
                        SkolrBadge(
                          label: 'Overdue',
                          variant: SkolrBadgeVariant.danger,
                        ),
                      ],
                    ),
                  ),
                ]),

                // ── 11. Segmented Control ──────────────────────────────
                _Section('Segmented Control', children: [
                  _Label('2 segments'),
                  SkolrSegmentedControl(
                    segments: const ['Students', 'Staff'],
                    selectedIndex: _segmentIndex % 2,
                    onChanged: (i) => setState(() => _segmentIndex = i),
                  ),
                  const SkolrGap.lg(),
                  _Label('3 segments'),
                  SkolrSegmentedControl(
                    segments: const ['Daily', 'Weekly', 'Monthly'],
                    selectedIndex: _segmentIndex % 3,
                    onChanged: (i) => setState(() => _segmentIndex = i),
                  ),
                  const SkolrGap.lg(),
                  _Label('4 segments'),
                  SkolrSegmentedControl(
                    segments: const ['Q1', 'Q2', 'Q3', 'Q4'],
                    selectedIndex: _segmentIndex % 4,
                    onChanged: (i) => setState(() => _segmentIndex = i),
                  ),
                ]),

                // ── 12. Devanagari rendering ───────────────────────────
                _Section('Devanagari', children: [
                  SkolrCard(
                    padding: SkolrSpacing.cardPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('नमस्ते स्कोलर',
                            style: SkolrTypography.headlineMedium()),
                        const SkolrGap.sm(),
                        Text('छात्र • उपस्थिति • फ़ीस',
                            style: SkolrTypography.bodyLarge()),
                        const SkolrGap.xs(),
                        Text('₹ 12,500 बकाया है',
                            style: SkolrTypography.titleMedium(
                              color: Theme.of(context).colorScheme.error,
                            )),
                      ],
                    ),
                  ),
                ]),

                // Bottom padding for nav bar clearance
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SkolrBottomNav(
        currentIndex: _navIndex,
        scrollController: _scrollCtrl,
        onTap: (i) => setState(() => _navIndex = i),
        items: const [
          SkolrNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Home',
          ),
          SkolrNavItem(
            icon: Icons.people_outline_rounded,
            activeIcon: Icons.people_rounded,
            label: 'Students',
          ),
          SkolrNavItem(
            icon: Icons.check_circle_outline_rounded,
            activeIcon: Icons.check_circle_rounded,
            label: 'Attendance',
          ),
          SkolrNavItem(
            icon: Icons.currency_rupee_rounded,
            activeIcon: Icons.currency_rupee_rounded,
            label: 'Fees',
          ),
        ],
      ),
    );
  }
}

// ── Internal helpers ──────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section(this.title, {required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: SkolrSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: SkolrTypography.titleLarge(color: cs.onSurface)),
          const SkolrGap.xs(),
          Divider(color: cs.outlineVariant),
          const SkolrGap.lg(),
          ...children,
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SkolrSpacing.sm),
      child: Text(
        text,
        style: SkolrTypography.labelMedium(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
