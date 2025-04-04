import 'package:a230_flowly/presentations/bloc/homework_cubit.dart';
import 'package:a230_flowly/presentations/models/hobby_model.dart';
import 'package:a230_flowly/presentations/models/home_work_model_a230.dart';
import 'package:a230_flowly/presentations/pages/home_work/select_hobby_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditHomeworkPage extends StatefulWidget {
  final HomeworkModel? homework; // nullable — жаңы же редакция

  const EditHomeworkPage({super.key, this.homework});

  @override
  State<EditHomeworkPage> createState() => _EditHomeworkPageState();
}

class _EditHomeworkPageState extends State<EditHomeworkPage> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _description;
  DateTime? _startDate;
  DateTime? _endDate;
  HobbyModel? _selectedHobby;

  bool get isEditMode => widget.homework != null;

  @override
  void initState() {
    super.initState();
    final hw = widget.homework;

    _title = hw?.title ?? '';
    _description = hw?.description ?? '';
    _startDate = hw?.startDate;
    _endDate = hw?.endDate;
    _selectedHobby = hw?.hobby;
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _pickHobby() async {
    final hobby = await Navigator.push<HobbyModel>(
      context,
      MaterialPageRoute(builder: (_) => const SelectHobbyPage()),
    );
    if (hobby != null) {
      setState(() => _selectedHobby = hobby);
    }
  }

  bool get _isFormValid =>
      _title.isNotEmpty &&
      _startDate != null &&
      _endDate != null &&
      _selectedHobby != null;

  void _submit() {
    if (!_isFormValid) return;

    if (isEditMode) {
      // Бар тапшырманы жаңыртабыз
      final hw = widget.homework!;
      hw.title = _title;
      hw.description = _description;
      hw.startDate = _startDate!;
      hw.endDate = _endDate!;
      hw.hobby = _selectedHobby!;
      hw.save();

      context.read<HomeworkCubit>().loadHomeworks();
    } else {
      // Жаңы тапшырма кошобуз
      final newHw = HomeworkModel(
        title: _title,
        description: _description,
        startDate: _startDate!,
        endDate: _endDate!,
        hobby: _selectedHobby!,
        status: HomeworkStatus.atWork,
      );

      context.read<HomeworkCubit>().addHomework(newHw);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? "Edit Task" : "New Task")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Task name*'),
                onChanged: (val) => setState(() => _title = val),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(
                  labelText: 'Task description',
                ),
                onChanged: (val) => setState(() => _description = val),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text("Start date*"),
                subtitle: Text(
                  _startDate == null
                      ? "Select date"
                      : _startDate!.toLocal().toString().split(' ')[0],
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _pickDate(isStart: true),
              ),
              ListTile(
                title: const Text("End date*"),
                subtitle: Text(
                  _endDate == null
                      ? "Select date"
                      : _endDate!.toLocal().toString().split(' ')[0],
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _pickDate(isStart: false),
              ),
              ListTile(
                title: const Text("Hobby categorization*"),
                subtitle: Text(
                  _selectedHobby?.name ?? "Select a hobby category",
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _pickHobby,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isFormValid ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade300,
                  disabledBackgroundColor: Colors.blue.shade100,
                ),
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
