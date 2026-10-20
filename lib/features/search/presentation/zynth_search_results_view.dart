import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/om_search_result.dart';
import '../../../models/search_engine.dart';
import '../../browser/browser_controller.dart';
import '../search_provider_factory.dart';

/// Native dark-first Search Results UI displaying live results from OM Search on Render.
class ZynthSearchResultsView extends StatefulWidget {
  final String query;
  final BrowserController controller;

  const ZynthSearchResultsView({
    super.key,
    required this.query,
    required this.controller,
  });

  @override
  State<ZynthSearchResultsView> createState() => _ZynthSearchResultsViewState();
}

class _ZynthSearchResultsViewState extends State<ZynthSearchResultsView> {
  bool _isLoading = true;
  String? _errorMessage;
  OmSearchResponse? _response;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  @override
  void didUpdateWidget(covariant ZynthSearchResultsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      _currentPage = 1;
      _fetchResults();
    }
  }

  Future<void> _fetchResults({int page = 1}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentPage = page;
    });

    try {
      final response = await SearchProviderFactory.zynthProvider.search(
        widget.query,
        page: page,
        size: 10,
      );
      if (mounted) {
        setState(() {
          _response = response;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString().contains('timed out')
              ? 'Render instance is waking up (cold start). Please retry in a few seconds.'
              : 'Failed to fetch search results from OM Search: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              'Searching OM Search for "${widget.query}"...',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Querying https://omsearch.onrender.com',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              const Text(
                'Search Request Failed',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _fetchResults(page: _currentPage),
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text('Retry'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                      side: const BorderSide(color: AppColors.secondary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      await widget.controller.setActiveEngine(
                        SearchEngineType.google,
                      );
                      widget.controller.handleUserInput(
                        '@google ${widget.query}',
                      );
                    },
                    icon: const Icon(Icons.public_rounded, size: 16),
                    label: const Text('Search with Google'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final results = _response?.results ?? [];

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 48,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found for "${widget.query}"',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try different keywords or search using Google.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                widget.controller.handleUserInput('@google ${widget.query}');
              },
              child: const Text('Search with Google'),
            ),
          ],
        ),
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // Stats bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.bolt_rounded,
                size: 14,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Found ${_response?.total ?? 0} results in ${(_response?.tookMs ?? 0).toStringAsFixed(1)}ms via OM Search',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                'Page $_currentPage of ${_response?.totalPages ?? 1}',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Results Cards
        ...results.map((item) => _buildResultCard(item)),

        const SizedBox(height: 16),

        // Pagination row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton.icon(
              onPressed: _currentPage > 1
                  ? () => _fetchResults(page: _currentPage - 1)
                  : null,
              icon: const Icon(Icons.chevron_left_rounded, size: 18),
              label: const Text('Previous'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
              ),
            ),
            Text(
              'Page $_currentPage',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            OutlinedButton.icon(
              onPressed:
                  (_response != null && _currentPage < _response!.totalPages)
                  ? () => _fetchResults(page: _currentPage + 1)
                  : null,
              icon: const Icon(Icons.chevron_right_rounded, size: 18),
              label: const Text('Next'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildResultCard(OmSearchResultItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () {
          // Open target website in WebView!
          widget.controller.navigateTo(item.url);
        },
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Domain & URL Header
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primaryMuted,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.public_rounded,
                      size: 12,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.domain.isNotEmpty ? item.domain : item.url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_outward_rounded,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Title
              Text(
                item.title.isNotEmpty ? item.title : item.url,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.primaryHover,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 6),

              // Snippet
              Text(
                item.snippet,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),

              if (item.score > 0) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Score: ${item.score.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
