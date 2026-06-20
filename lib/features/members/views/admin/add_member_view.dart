import 'package:flutter/material.dart';

class AddMemberView extends StatefulWidget {
  const AddMemberView({super.key});

  @override
  State<AddMemberView> createState() => _AddMemberViewState();
}

class _AddMemberViewState extends State<AddMemberView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subscriptionMonthsController = TextEditingController();
  final _priceController = TextEditingController();

  String _selectedGender = 'male';
  String _selectedMembership = 'normal';
  String _selectedType = 'monthly';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _subscriptionMonthsController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة عضو جديد')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'اسم العضو'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedGender,
                decoration: const InputDecoration(labelText: 'النوع'),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('ذكر')),
                  DropdownMenuItem(value: 'female', child: Text('أنثى')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _selectedGender = v);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _subscriptionMonthsController,
                decoration: const InputDecoration(
                  labelText: 'عدد أشهر الاشتراك',
                ),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'السعر'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: const InputDecoration(labelText: 'نوع الاشتراك'),
                items: const [
                  DropdownMenuItem(value: 'monthly', child: Text('شهري')),
                  DropdownMenuItem(value: 'yearly', child: Text('سنوي')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _selectedType = v);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedMembership,
                decoration: const InputDecoration(labelText: 'العضوية'),
                items: const [
                  DropdownMenuItem(value: 'normal', child: Text('عادية')),
                  DropdownMenuItem(value: 'vip', child: Text('VIP')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _selectedMembership = v);
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('إضافة'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
