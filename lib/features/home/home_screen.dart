import 'package:event_app/features/saved/saved_screen.dart';
import 'package:flutter/material.dart';
import '../../models/event_model.dart';
import '../../services/api_service.dart';
import '../../widgets/event_card.dart';
import '../event/event_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<Event>> events;

  int selectedIndex = 0;

  final List<String> categories = [
    "All",
    "Music",
    "Sports",
    "Tech",
    "Food",
    "Art"
  ];

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    events = ApiService.fetchEvents();

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  Future<void> refresh() async {
    setState(() {
      events = ApiService.fetchEvents();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover Events"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SavedScreen()),
              );
            },
          )
        ],
      ),

      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E1E1E)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.search,
                        color:
                        isDark ? Colors.white70 : Colors.black54,
                      ),
                      hintText: "Search events...",
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.white54
                            : Colors.black45,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final selected = index == selectedIndex;

                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedIndex = index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin:
                        const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.blue
                              : isDark
                              ? const Color(0xFF1E1E1E)
                              : Colors.grey.shade200,
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : isDark
                                ? Colors.white70
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<Event>>(
                  future: events,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text("Error loading events"));
                    } else if (!snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text("No events found"));
                    }

                    final data = snapshot.data!;

                    return RefreshIndicator(
                      onRefresh: refresh,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return AnimatedOpacity(
                            duration:
                            Duration(milliseconds: 300 + index * 100),
                            opacity: 1,
                            child: Padding(
                              padding:
                              const EdgeInsets.only(bottom: 10),
                              child: EventCard(
                                event: data[index],
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EventDetailScreen(
                                              event: data[index]),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}