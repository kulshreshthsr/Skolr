import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Handles composing and launching WhatsApp fee reminder messages.
/// Uses the wa.me deep link — opens WhatsApp if installed, browser otherwise.
class WhatsAppService {
  // WhatsApp brand green, used by UI that renders the reminder button.
  static const Color brandGreen = Color(0xFF25D366);

  /// Builds a polite reminder message using fee data.
  /// [instituteName] is fetched from [settingsProvider] by the caller.
  static String buildReminderMessage({
    required String studentName,
    required double dueAmount,
    required DateTime dueDate,
    required String instituteName,
  }) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final dateStr =
        '${dueDate.day} ${months[dueDate.month - 1]} ${dueDate.year}';
    final amountStr = '₹${dueAmount.toStringAsFixed(0)}';

    return 'Dear Parent/Guardian of *$studentName*,\n\n'
        'This is a gentle reminder that a fee of *$amountStr* '
        'is due on *$dateStr*.\n\n'
        'Kindly make the payment at your earliest convenience '
        'to avoid any inconvenience.\n\n'
        'Thank you,\n'
        '*$instituteName*';
  }

  /// Launches WhatsApp with a pre-filled message.
  ///
  /// [phone] should be in international format (e.g. +91 9876543210 or
  /// 919876543210). Non-digit characters are stripped automatically.
  static Future<void> sendReminder({
    required BuildContext context,
    required String phone,
    required String message,
  }) async {
    final sanitized = _sanitize(phone);

    if (sanitized.isEmpty) {
      _dialog(
        context,
        title: 'No Phone Number',
        body: 'This student does not have a phone number on record. '
            'Please add one via the Students page.',
      );
      return;
    }

    final uri = Uri.parse(
      'https://wa.me/$sanitized?text=${Uri.encodeComponent(message)}',
    );

    bool launched = false;
    try {
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      launched = false;
    }

    if (!launched && context.mounted) {
      _dialog(
        context,
        title: 'WhatsApp Not Available',
        body: 'WhatsApp could not be opened. '
            'Please ensure WhatsApp is installed and try again.',
      );
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Strips everything except digits (handles +, spaces, dashes, parentheses).
  static String _sanitize(String phone) =>
      phone.replaceAll(RegExp(r'[^\d]'), '');

  static void _dialog(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
