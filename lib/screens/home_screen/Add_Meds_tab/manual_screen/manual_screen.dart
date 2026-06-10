import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pillsync/api/medication_repository.dart';
import 'package:pillsync/cubit/add_medication/add_medication_cubit.dart';
import 'package:pillsync/cubit/add_medication/add_medication_state.dart';
import 'package:pillsync/cubit/medication/medication_cubit.dart';
import 'package:pillsync/utils/app_colors.dart';

class ManualEntryScreen extends StatefulWidget {
  static const String routeName = '/manual-entry';
  final Map<String, dynamic>? prefilledData;

  const ManualEntryScreen({super.key, this.prefilledData});

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _timeController = TextEditingController();
  final _instructionsController = TextEditingController();

  String _selectedTypeOfDrug = "Medicine Tablets";
  String _selectedFrequency = "Once daily";

  @override
  void initState() {
    super.initState();
    if (widget.prefilledData != null) {
      _nameController.text = widget.prefilledData!["name"] ?? "";
      _dosageController.text = widget.prefilledData!["dosage"] ?? "";
      _startDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _endDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 7)));
      _timeController.text = "08:00 AM";
      _instructionsController.text = widget.prefilledData!["instructions"] ?? "";
      _selectedTypeOfDrug = widget.prefilledData!["typeOfDrug"] ?? "Medicine Tablets";
      _selectedFrequency = widget.prefilledData!["frequency"] ?? "Once daily";
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _timeController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        _timeController.text = DateFormat('hh:mm a').format(dt);
      });
    }
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Validate that end date is after start date
      final start = DateTime.tryParse(_startDateController.text);
      final end = DateTime.tryParse(_endDateController.text);
      if (start != null && end != null && end.isBefore(start)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تاريخ النهاية لا يمكن أن يكون قبل تاريخ البداية."),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      context.read<AddMedicationCubit>().addMedication(
            medicineName: _nameController.text.trim(),
            dosage: _dosageController.text.trim(),
            typeOfDrug: _selectedTypeOfDrug,
            frequency: _selectedFrequency,
            startDate: _startDateController.text,
            endDate: _endDateController.text,
            timeTotake: _timeController.text,
            instructions: _instructionsController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddMedicationCubit>(
      create: (context) => AddMedicationCubit(context.read<MedicationRepository>()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Add Medication",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocConsumer<AddMedicationCubit, AddMedicationState>(
          listener: (context, state) {
            if (state is AddMedicationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("تم إضافة ${state.medicineName} بنجاح!"),
                  backgroundColor: AppColors.success,
                ),
              );
              // Refresh medications list on Home/Schedule page
              context.read<MedicationCubit>().loadMedications();
              // Pop back twice to clear flow
              Navigator.pop(context);
            } else if (state is AddMedicationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      "Medication Name",
                      "e.g., Lisinopril",
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "برجاء إدخال اسم الدواء";
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      "Dosage",
                      "e.g., 25mg",
                      controller: _dosageController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "برجاء إدخال الجرعة";
                        }
                        return null;
                      },
                    ),
                    _buildDropdownField(
                      "Type of Drug",
                      ["Medicine Tablets", "Capsule", "Syrup"],
                      value: _selectedTypeOfDrug,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedTypeOfDrug = value;
                          });
                        }
                      },
                    ),
                    _buildDropdownField(
                      "Frequency",
                      ["Once daily", "Twice daily", "Three times daily"],
                      value: _selectedFrequency,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedFrequency = value;
                          });
                        }
                      },
                    ),
                    _buildTextField(
                      "Start Date",
                      "Select Date",
                      controller: _startDateController,
                      readOnly: true,
                      onTap: () => _selectDate(context, _startDateController),
                      suffixIcon: const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "برجاء اختيار تاريخ البدء";
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      "End Date",
                      "Select Date",
                      controller: _endDateController,
                      readOnly: true,
                      onTap: () => _selectDate(context, _endDateController),
                      suffixIcon: const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "برجاء اختيار تاريخ الانتهاء";
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      "Time to Take Medicine",
                      "Select Time",
                      controller: _timeController,
                      readOnly: true,
                      onTap: () => _selectTime(context),
                      suffixIcon: const Icon(Icons.access_time, size: 18, color: AppColors.primary),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "برجاء اختيار موعد الجرعة";
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      "Instructions (optional)",
                      "e.g., Take with food",
                      controller: _instructionsController,
                      isLongText: true,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: state is AddMedicationLoading ? null : () => _submitForm(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B4D8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: state is AddMedicationLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Add Medication",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    required TextEditingController controller,
    bool isLongText = false,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: isLongText ? 3 : 1,
            readOnly: readOnly,
            onTap: onTap,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: isLongText ? 15 : 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00B4D8), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> items, {
    required String value,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00B4D8), width: 2),
              ),
            ),
            items: items
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e, style: const TextStyle(fontSize: 14)),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
