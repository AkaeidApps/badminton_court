import 'package:flutter/material.dart';
import '../models/court.dart';
import '../state/app_state.dart';
import '../utils/constants.dart';
import '../widgets/common_widgets.dart';
import '../widgets/court_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController bannerController = PageController();
  int bannerIndex = 0;

  final bannerImages = [
    'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=1200',
    'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?w=1200',
    'https://images.unsplash.com/photo-1613918431703-aa50889e3be1?w=1200',
  ];

  @override
  void dispose() {
    bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return pageContainer(
      context,
      CustomScrollView(
        key: const PageStorageKey('home'),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                AnimatedBuilder(
                  animation: AppState.instance,
                  builder: (context, _) {
                    return Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Welcome back 👋',
                                style: TextStyle(
                                  color: muted,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                AppState.instance.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => message(
                            context,
                            'You are all caught up!',
                          ),
                          icon: const Icon(
                            Icons.notifications_none,
                            color: primary,
                            size: 26,
                          ),
                        ),
                        const CircleAvatar(
                          backgroundColor: Color(0xFFDDF4E9),
                          child: Icon(Icons.person, color: primary),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 22),

                // RESPONSIVE BANNER
                LayoutBuilder(
                  builder: (context, constraints) {
                    final ratio = constraints.maxWidth < 380
                        ? 1.65
                        : constraints.maxWidth < 600
                        ? 1.95
                        : 2.6;

                    return AspectRatio(
                      aspectRatio: ratio,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: bannerController,
                              itemCount: bannerImages.length,
                              onPageChanged: (i) {
                                setState(() => bannerIndex = i);
                              },
                              itemBuilder: (context, index) {
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      bannerImages[index],
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          Container(color: darkGreen),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xE6006349),
                                            Color(0x55006349),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            index == 0
                                                ? 'Big Promo 50%'
                                                : index == 1
                                                ? 'Play More, Pay Less'
                                                : 'Find Your Court',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          const Text(
                                            'Book your favorite badminton court',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            height: 34,
                                            child: OutlinedButton(
                                              onPressed: () => openCourt(
                                                context,
                                                courts[index],
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                side: const BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              child: const Text('Book Now'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Positioned(
                              bottom: 10,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  bannerImages.length,
                                      (i) => AnimatedContainer(
                                    duration:
                                    const Duration(milliseconds: 250),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    width: bannerIndex == i ? 20 : 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
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
                ),
                const SizedBox(height: 23),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Recommended Courts',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => message(
                        context,
                        'Open Explore to view all courts',
                      ),
                      child: const Text(
                        'View All',
                        style: TextStyle(color: primary),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),

          // Responsive court grid
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

                final itemWidth =
                    (width - (columns - 1) * 14) / columns;

                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: itemWidth < 330 ? 285 : 310,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => CourtCard(court: courts[index]),
                    childCount: 3,
                  ),
                );
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Nearby Courts',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
            ),
          ),
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: 300,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => CourtCard(
                      court: courts[index + 2],
                    ),
                    childCount: 3,
                  ),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 25)),
        ],
      ),
    );
  }
}
