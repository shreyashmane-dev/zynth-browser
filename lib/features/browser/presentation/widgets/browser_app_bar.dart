import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/search_engine.dart';
import '../../browser_controller.dart';
import 'provider_selector_sheet.dart';

/// Top Address and Search Bar for Zynth Browser.
class BrowserAppBar extends StatefulWidget implements PreferredSizeWidget {
  final BrowserController controller;

  const BrowserAppBar({
    super.key,
    required this.controller,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  State<BrowserAppBar> createState() => _BrowserAppBarState();
}

class _BrowserAppBarState extends State<BrowserAppBar> {
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.controller.displayUrl);

    widget.controller.addListener(_onControllerUpdate);
    _focusNode.addListener(() {
      setState(() {
        _isEditing = _focusNode.hasFocus;
        if (_focusNode.hasFocus) {
          _textController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _textController.text.length,
          );
        }
      });
    });
  }

  void _onControllerUpdate() {
    if (!_isEditing && mounted) {
      if (_textController.text != widget.controller.displayUrl) {
        _textController.text = widget.controller.displayUrl;
      }
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdate);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitInput() {
    final query = _textController.text.trim();
    _focusNode.unfocus();
    if (query.isNotEmpty) {
      widget.controller.handleUserInput(query);
    }
  }

  void _openProviderSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProviderSelectorSheet(
        currentEngine: widget.controller.activeEngine,
        onSelect: (engine) {
          widget.controller.setActiveEngine(engine);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHome = widget.controller.isHomeView;
    final isSecure = widget.controller.isSecure;
    final isLoading = widget.controller.isLoading;
    final engine = widget.controller.activeEngine;

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 6,
        bottom: 8,
        left: 12,
        right: 12,
      ),
      child: Row(
        children: [
          // Address / Search Input Container
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.addressBarBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isEditing ? AppColors.primary : AppColors.addressBarBorder,
                  width: _isEditing ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  // Search Provider Selector Badge
                  GestureDetector(
                    onTap: _openProviderSheet,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            engine == SearchEngineType.zynth
                                ? Icons.bolt_rounded
                                : Icons.public_rounded,
                            size: 16,
                            color: engine == SearchEngineType.zynth
                                ? AppColors.primary
                                : AppColors.secondary,
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Security / SSL lock indicator (visible when browsing a site)
                  if (!isHome && !_isEditing) ...[
                    Icon(
                      isSecure ? Icons.lock_outline_rounded : Icons.lock_open_rounded,
                      size: 14,
                      color: isSecure ? AppColors.secureGreen : AppColors.insecureGrey,
                    ),
                    const SizedBox(width: 6),
                  ],

                  // Editable Input Field
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      textInputAction: TextInputAction.go,
                      keyboardType: TextInputType.url,
                      autocorrect: false,
                      enableSuggestions: false,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        hintText: isHome
                            ? 'Search with ${engine.displayName} or type URL'
                            : 'Search or enter address',
                        hintStyle: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      onSubmitted: (_) => _submitInput(),
                    ),
                  ),

                  // Clear button when editing, or Reload/Stop button when not
                  if (_isEditing && _textController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 16),
                      color: AppColors.textSecondary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: () {
                        _textController.clear();
                      },
                    )
                  else if (!isHome)
                    IconButton(
                      icon: Icon(
                        isLoading ? Icons.close_rounded : Icons.refresh_rounded,
                        size: 18,
                      ),
                      color: AppColors.textSecondary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      onPressed: () {
                        if (isLoading) {
                          widget.controller.stopLoading();
                        } else {
                          widget.controller.reload();
                        }
                      },
                    ),
                  const SizedBox(width: 6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
