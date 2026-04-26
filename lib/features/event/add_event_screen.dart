import 'package:flutter/material.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String category = "Music";
  String location = "";
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final List<String> categories = [
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

    // 🎞 Animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Event")),

      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Title"),
                    onChanged: (val) => title = val,
                  ),

                  const SizedBox(height: 15),

                  DropdownButtonFormField(
                    value: category,
                    items: categories
                        .map((e) => DropdownMenuItem(
                        value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {
                      setState(() => category = val!);
                    },
                    decoration:
                    const InputDecoration(labelText: "Category"),
                  ),

                  const SizedBox(height: 15),

                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    tileColor: Colors.grey.withOpacity(0.1),
                    title: Text(
                      selectedDate == null
                          ? "Select Date"
                          : selectedDate
                          .toString()
                          .split(" ")[0],
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: pickDate,
                  ),

                  const SizedBox(height: 10),
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    tileColor: Colors.grey.withOpacity(0.1),
                    title: Text(
                      selectedTime == null
                          ? "Select Time"
                          : selectedTime!.format(context),
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: pickTime,
                  ),

                  const SizedBox(height: 15),
                  TextFormField(
                    decoration:
                    const InputDecoration(labelText: "Location"),
                    onChanged: (val) => location = val,
                  ),

                  const SizedBox(height: 30),

                  GestureDetector(
                    onTapDown: (_) => setState(() {}),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                              Text("Event Added (UI Only)"),
                            ),
                          );
                        },
                        child: const Center(
                          child: Text(
                            "Add Event",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}