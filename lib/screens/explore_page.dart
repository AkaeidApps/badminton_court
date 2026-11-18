import 'package:flutter/material.dart';
import '../models/court.dart';
import '../state/app_state.dart';
import '../utils/constants.dart';
import '../widgets/common_widgets.dart';
import '../widgets/court_card.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final searchController = TextEditingController();
  String category = 'All';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final filtered = courts.where((court) {
          final query = searchController.text.toLowerCase();

          final matchesSearch =
              court.name.toLowerCase().contains(query) ||
                  court.location.toLowerCase().contains(query);

          final matchesCategory = category == 'All' ||
              (category == 'Popular' &&
                  double.parse(court.rating) >= 9) ||
              (category == 'Nearby' && courts.indexOf(court) < 3) ||
              (category == 'Favorites' &&
                  AppState.instance.favorites.contains(court.id));

          return matchesSearch && matchesCategory;
        }).toList();

        return pageContainer(
          context,
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    pageTitle(
                      'Explore Courts',
                      'Discover and book your favorite courts',
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: inputDecoration('Search courts').copyWith(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: primary,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final item in [
                            'All',
                            'Popular',
                            'Nearby',
                            'Favorites',
                          ])
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(item),
                                selected: category == item,
                                selectedColor:
                                const Color(0xFFDDF4E9),
                                onSelected: (_) {
                                  setState(() => category = item);
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 17),
                    Text(
                      '${filtered.length} courts found',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 13),
                  ]),
                ),
              ),
              if (filtered.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('No courts found')),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.crossAxisExtent;
                      final columns = width >= 900
                          ? 3
                          : width >= 560
                          ? 2
                          : 1;

                      return SliverGrid(
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          mainAxisExtent: 300,
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (context, index) => CourtCard(
                            court: filtered[index],
                          ),
                          childCount: filtered.length,
                        ),
                      );
                    },
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 25)),
            ],
          ),
        );
      },
    );
  }
}
