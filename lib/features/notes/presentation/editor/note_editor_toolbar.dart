import 'package:flutter/material.dart';

import 'note_save_status.dart';

class NoteEditorToolbar extends StatelessWidget {
  final NoteSaveStatus saveStatus;
  final VoidCallback onBold;
  final VoidCallback onItalic;
  final VoidCallback onBullet;
  final VoidCallback onOrdered;
  final VoidCallback onChecklist;

  final ValueChanged<int> onHeadingSelected;
  final int? currentHeadingLevel;

  final bool isBulletActive;
  final bool isOrderedActive;
  final bool isChecklistActive;

  const NoteEditorToolbar({
    super.key,
    required this.saveStatus,
    required this.onBold,
    required this.onItalic,
    required this.onHeadingSelected,
    required this.currentHeadingLevel,
    required this.onBullet,
    required this.onOrdered,
    required this.onChecklist,
    required this.isBulletActive,
    required this.isOrderedActive,
    required this.isChecklistActive,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF262144),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 10),
              _StatusDot(saveStatus: saveStatus),
              const SizedBox(width: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _ToolbarButton(
                      onTap: onBold,
                      child: const Icon(
                        Icons.format_bold,
                        size: 21,
                        color: Colors.white,
                      ),
                    ),
                    _ToolbarButton(
                      onTap: onItalic,
                      child: const Icon(
                        Icons.format_italic,
                        size: 21,
                        color: Colors.white,
                      ),
                    ),
                    _PopupToolbarButton(
                      isActive: currentHeadingLevel != null,
                      popupBuilder: (context) {
                        return PopupMenuButton<int>(
                          tooltip: '',
                          initialValue: currentHeadingLevel,
                          onSelected: onHeadingSelected,
                          color: const Color(0xFF262144),
                          surfaceTintColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.06),
                            ),
                          ),
                          itemBuilder: (context) {
                            return List.generate(5, (index) {
                              final level = index + 1;

                              return PopupMenuItem<int>(
                                value: level,
                                child: Text(
                                  'Heading $level',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: currentHeadingLevel == level
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              );
                            });
                          },
                          child: const SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Text(
                                'H',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    _ToolbarButton(
                      onTap: onBullet,
                      isActive: isBulletActive,
                      child: const Icon(
                        Icons.format_list_bulleted_rounded,
                        size: 21,
                        color: Colors.white,
                      ),
                    ),
                    _ToolbarButton(
                      onTap: onOrdered,
                      isActive: isOrderedActive,
                      child: const Icon(
                        Icons.format_list_numbered_rounded,
                        size: 21,
                        color: Colors.white,
                      ),
                    ),
                    _ToolbarButton(
                      onTap: onChecklist,
                      isActive: isChecklistActive,
                      child: const Icon(
                        Icons.check_box_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PopupToolbarButton extends StatelessWidget {
  final WidgetBuilder popupBuilder;
  final bool isActive;

  const _PopupToolbarButton({
    required this.popupBuilder,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: isActive
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: popupBuilder(context),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool isActive;

  const _ToolbarButton({
    required this.child,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: isActive
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: SizedBox(width: 40, height: 40, child: Center(child: child)),
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final NoteSaveStatus saveStatus;

  const _StatusDot({required this.saveStatus});

  @override
  Widget build(BuildContext context) {
    final color = switch (saveStatus) {
      NoteSaveStatus.saved => const Color(0xFF5AD13F),
      NoteSaveStatus.saving => const Color(0xFFE2B93B),
      NoteSaveStatus.error => const Color(0xFFE25555),
    };

    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.28),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
