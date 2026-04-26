import 'package:flutter/material.dart';
import '../../models/event_model.dart';
import '../../services/saved_service.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen>
    with SingleTickerProviderStateMixin {
  bool isSaved = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    checkSaved();

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  void checkSaved() async {
    final saved = await SavedService.isSaved(widget.event.id);
    setState(() => isSaved = saved);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: event.id,
                  child: Image.network(
                    event.imageUrl,
                    height: 260,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            event.category,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          event.title,
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 6),
                            Text("${event.date} • ${event.time}"),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16),
                            const SizedBox(width: 6),
                            Text(event.location),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          event.description,
                          style: const TextStyle(fontSize: 15, height: 1.5),
                        ),

                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text("Get Tickets"),
                          ),
                        ),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 40,
            left: 10,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 10,
            child: GestureDetector(
              onTap: () async {
                if (isSaved) {
                  await SavedService.removeEvent(event.id);
                } else {
                  await SavedService.saveEvent(event);
                }
                checkSaved();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                    )
                  ],
                ),
                child: Icon(
                  isSaved ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}