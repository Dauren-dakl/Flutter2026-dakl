import 'package:flutter/material.dart';
import '../models/item.dart';
import '../models/category.dart';

class FormScreen extends StatefulWidget {
  final Item? initialItem;

  const FormScreen({super.key, this.initialItem});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _title;
  late TextEditingController _limit;
  late TextEditingController _location;
  late TextEditingController _description;

  Category _category = Category.tech;
  DateTime _when = DateTime.now().add(const Duration(days: 1));
  bool _mode = false;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final i = widget.initialItem;
    _title = TextEditingController(text: i?.title ?? '');
    _limit = TextEditingController(text: i?.limit.toString() ?? '');
    _location = TextEditingController(text: i?.location ?? '');
    _description = TextEditingController(text: i?.description ?? '');
    if (i != null) {
      _category = i.category;
      _when = i.when;
      _mode = i.mode;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _limit.dispose();
    _location.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _when,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;

    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_when),
    );
    if (time == null) return;

    setState(() {
      _when = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _saving = false);

    final item = Item(
      title: _title.text,
      category: _category,
      when: _when,
      limit: int.parse(_limit.text),
      location: _location.text,
      attendees: widget.initialItem?.attendees ?? [],
      mode: _mode,
      description: _description.text.trim().isEmpty ? null : _description.text,
      favourite: widget.initialItem?.favourite ?? false,
    );
    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_saving && _formKey.currentState?.validate() != false, // simplification for demo
      onPopInvokedWithResult: (didPop, _) {},
      child: Scaffold(
        appBar: AppBar(title: Text(widget.initialItem == null ? 'New Event' : 'Edit Event')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  maxLength: 60,
                  validator: (v) => (v ?? '').trim().length < 3 ? 'Minimum 3 chars' : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<Category>(
                  value: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: Category.values.map((c) => DropdownMenuItem(value: c, child: Text(c.label))).toList(),
                  onChanged: (v) => setState(() => _category = v!),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _limit,
                  decoration: const InputDecoration(labelText: 'Limit'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final n = int.tryParse(v ?? '');
                    if (n == null || n < 1 || n > 500) return '1-500';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _location,
                  decoration: InputDecoration(labelText: _mode ? 'Link (contains ://)' : 'Place'),
                  validator: (v) {
                    final val = v ?? '';
                    if (val.isEmpty) return 'Required';
                    if (_mode && !val.contains('://')) return 'Must contain ://';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _description,
                  decoration: const InputDecoration(labelText: 'Description (optional)'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Online mode'),
                  value: _mode,
                  onChanged: (v) => setState(() => _mode = v),
                ),
                ListTile(
                  title: const Text('Date and time'),
                  subtitle: Text(_when.toString().substring(0, 16)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _pickDateTime,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}