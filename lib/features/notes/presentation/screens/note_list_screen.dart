import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../i18n/translations.g.dart';
import '../../providers/notes_provider.dart';

class NoteListScreen extends ConsumerWidget {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesListProvider);
    final topInset = MediaQuery.paddingOf(context).top + kToolbarHeight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
              top: 8,
              bottom: 8,
              right: 16,
            ),
            child: Material(
              elevation: 0,
              color: const Color(0xFF2A2448),
              shape: const CircleBorder(),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  onPressed: () => context.push('/settings'),
                  icon: const Icon(Icons.settings),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () => context.go('/note'),
          child: const Icon(Icons.add),
        ),
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const _EmptyNotesView();
          }

          return ListView.separated(
            padding: EdgeInsets.fromLTRB(8, topInset, 8, 8),
            itemCount: notes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final note = notes[index];

              return Dismissible(
                key: ValueKey(note.id),
                direction: DismissDirection.endToStart,
                dismissThresholds: const {DismissDirection.endToStart: 0.32},
                movementDuration: const Duration(milliseconds: 180),
                resizeDuration: const Duration(milliseconds: 160),
                confirmDismiss: (_) async {
                  final confirmed = await _confirmDelete(context);

                  if (confirmed != true) {
                    return false;
                  }

                  await ref.read(notesServiceProvider).delete(note.id);
                  ref.invalidate(notesListProvider);
                  return true;
                },
                background: const ColoredBox(color: Colors.transparent),
                secondaryBackground: const _DeleteSwipeBackground(),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: Text(
                    _plainTitle(note.title),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      _formatUpdatedAt(context, note.updatedAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () => context.go('/note/${note.id}'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(context.t.common.errors.loadFailed),
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: const Color(0xFF171336),
      barrierColor: Colors.black.withValues(alpha: 0.45),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    context.t.notes.delete.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(true),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          context.t.notes.delete.confirm,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: colorScheme.onSurface),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Divider(
                  height: 1,
                  color: colorScheme.onSurface.withValues(alpha: 0.05),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          context.t.notes.delete.cancel,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: colorScheme.onSurface),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatUpdatedAt(BuildContext context, DateTime date) {
    final materialLocalizations = MaterialLocalizations.of(context);
    final mediaQuery = MediaQuery.of(context);

    final datePart = materialLocalizations.formatCompactDate(date);
    final timePart = materialLocalizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(date),
      alwaysUse24HourFormat: mediaQuery.alwaysUse24HourFormat,
    );

    return '$datePart $timePart';
  }

  String _plainTitle(String value) {
    return value
        .replaceAll(RegExp(r'^\s*#{1,6}\s+'), '')
        .replaceAllMapped(
          RegExp(r'\*\*(.*?)\*\*'),
          (match) => match.group(1) ?? '',
        )
        .replaceAllMapped(RegExp(r'\*(.*?)\*'), (match) => match.group(1) ?? '')
        .replaceAllMapped(RegExp(r'~~(.*?)~~'), (match) => match.group(1) ?? '')
        .replaceAll(RegExp(r'^\s*-\s\[(?: |x|X)\]\s+'), '')
        .replaceAll(RegExp(r'^\s*-\s+'), '')
        .replaceAll(RegExp(r'^\s*\d+\.\s+'), '')
        .trim();
  }
}

class _DeleteSwipeBackground extends StatelessWidget {
  const _DeleteSwipeBackground();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 106,
        color: const Color(0xFFB55353),
        alignment: Alignment.center,
        child: Icon(
          Icons.delete_outline,
          size: 30,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

class _EmptyNotesView extends StatelessWidget {
  const _EmptyNotesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(context.t.notes.empty, textAlign: TextAlign.center),
      ),
    );
  }
}
