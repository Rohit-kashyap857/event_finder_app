import 'package:flutter/material.dart';
import '../../models/event_model.dart';
import '../../services/saved_service.dart';
import '../../widgets/event_card.dart';
import '../event/event_detail_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<Event> savedEvents = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSaved();
  }

  void loadSaved() async {
    final data = await SavedService.getSavedEvents();
    setState(() {
      savedEvents = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Events")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : savedEvents.isEmpty
          ? const Center(child: Text("No saved events"))
          : ListView.builder(
        itemCount: savedEvents.length,
        itemBuilder: (context, index) {
          final event = savedEvents[index];
          return EventCard(
            event: event,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EventDetailScreen(event: event),
                ),
              ).then((_) => loadSaved());
            },
          );
        },
      ),
    );
  }
}