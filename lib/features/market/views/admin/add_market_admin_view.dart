import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/features/market/cubit/admin/market_admin_cubit.dart';
import 'package:gym_management_app/features/market/cubit/admin/market_admin_state.dart';

class AddMarketAdminView extends StatefulWidget {
  const AddMarketAdminView({super.key});

  @override
  State<AddMarketAdminView> createState() => _AddMarketAdminViewState();
}

class _AddMarketAdminViewState extends State<AddMarketAdminView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String _selectedType = 'supplement';

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MarketAdminCubit, MarketAdminState>(
      listener: (context, state) {
        if (state is MarketAdminAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إضافة المنتج بنجاح')),
          );
          Navigator.pop(context);
        } else if (state is MarketAdminError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('إضافة منتج جديد')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(labelText: 'رابط الصورة'),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'اسم المنتج'),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'وصف المنتج'),
                    maxLines: 3,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'السعر (بالجنيه)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'الحقل مطلوب' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    decoration: const InputDecoration(labelText: 'النوع'),
                    items: const [
                      DropdownMenuItem(
                        value: 'supplement',
                        child: Text('مكمل'),
                      ),
                      DropdownMenuItem(value: 'tool', child: Text('أداة')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedType = v);
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onAddProduct,
                      child: const Text('إضافة'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onAddProduct() {
    if (!_formKey.currentState!.validate()) return;
    context.read<MarketAdminCubit>().addProduct(
      name: _nameController.text,
      description: _descriptionController.text,
      image: _imageUrlController.text,
      price: int.parse(_priceController.text),
      type: _selectedType,
    );
  }
}
