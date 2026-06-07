import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pillsync/cubit/add_medication/add_medication_cubit.dart';
import 'package:pillsync/cubit/add_medication/add_medication_state.dart';
import 'package:pillsync/cubit/medication/medication_cubit.dart';
import 'package:pillsync/utils/app_colors.dart';

class ManualEntryScreen extends StatefulWidget {
  static const String routeName = 'manual_entry_screen';

  final String? initialMedicineName;

  const ManualEntryScreen({super.key, this.initialMedicineName});

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  final List<String> _drugTypes = const [
    'Medicine Tablets',
    'Capsule',
    'Syrup',
  ];
  final List<String> _frequencies = const [
    'Once daily',
    'Twice daily',
    'Three times daily',
  ];

  String? _selectedDrugType;
  String? _selectedFrequency;
  DateTime? _startDateValue;
  DateTime? _endDateValue;
  TimeOfDay? _timeValue;

  @override
  void initState() {
    super.initState();
    final initialName = widget.initialMedicineName?.trim();
    if (initialName != null && initialName.isNotEmpty) {
      _nameController.text = initialName;
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

  Future<void> _pickDate({required bool isStartDate}) async {
    final now = DateTime.now();
    final initialDate =
    isStartDate
        ? (_startDateValue ?? now)
        : (_endDateValue ?? _startDateValue ?? now);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 10),
      helpText: isStartDate ? 'Select start date' : 'Select end date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme
                .of(
              context,
            )
                .colorScheme
                .copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    setState(() {
      final formatted = DateFormat('yyyy-MM-dd').format(pickedDate);
      if (isStartDate) {
        _startDateValue = pickedDate;
        _startDateController.text = formatted;
        if (_endDateValue != null && _endDateValue!.isBefore(pickedDate)) {
          _endDateValue = null;
          _endDateController.clear();
        }
      } else {
        _endDateValue = pickedDate;
        _endDateController.text = formatted;
      }
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _timeValue ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme
                .of(
              context,
            )
                .colorScheme
                .copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      _timeValue = picked;
      final now = DateTime.now();
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      _timeController.text = DateFormat('hh:mm a').format(dateTime);
    });
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_selectedDrugType == null || _selectedFrequency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select type of drug and frequency'),
          backgroundColor: AppColors.darkRed,
        ),
      );
      return;
    }

    context.read<AddMedicationCubit>().addMedication(
      medicineName: _nameController.text.trim(),
      dosage: _dosageController.text.trim(),
      typeOfDrug: _selectedDrugType!,
      frequency: _selectedFrequency!,
      startDate: _startDateController.text.trim(),
      endDate: _endDateController.text.trim(),
      timeTotake: _timeController.text.trim(),
      instructions: _instructionsController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddMedicationCubit, AddMedicationState>(
      listener: (context, state) {
        if (state is AddMedicationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.darkRed,
            ),
          );
        } else if (state is AddMedicationSuccess) {
          context.read<MedicationCubit>().loadMedications(forceRefresh: true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.medicineName} added successfully'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final isLoading = state is AddMedicationLoading;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "Add Medication",
              style: TextStyle(color: AppColors.black, fontSize: 16),
            ),
            centerTitle: true,
            backgroundColor: AppColors.white,
            elevation: 0,
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildTextField(
                    "Medication Name",
                    "e.g., Lisinopril",
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value
                          .trim()
                          .isEmpty) {
                        return 'Medication name is required';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    "Dosage",
                    "e.g., 25",
                    controller: _dosageController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Dosage is required';
                      if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(text)) {
                        return 'Dosage must be numeric only';
                      }
                      return null;
                    },
                  ),
                  _buildDropdownField(
                    label: "Type of Drug",
                    items: _drugTypes,
                    value: _selectedDrugType,
                    onChanged: (val) => setState(() => _selectedDrugType = val),
                  ),
                  _buildDropdownField(
                    label: "Frequency",
                    items: _frequencies,
                    value: _selectedFrequency,
                    onChanged: (val) =>
                        setState(() => _selectedFrequency = val),
                  ),
                  _buildTextField(
                    "Start Date",
                    "Select Date",
                    controller: _startDateController,
                    isDate: true,
                    readOnly: true,
                    onTap: () => _pickDate(isStartDate: true),
                    validator: (value) {
                      if (value == null || value
                          .trim()
                          .isEmpty) {
                        return 'Start date is required';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    "End Date",
                    "Select Date",
                    controller: _endDateController,
                    isDate: true,
                    readOnly: true,
                    onTap: () => _pickDate(isStartDate: false),
                    validator: (value) {
                      if (value == null || value
                          .trim()
                          .isEmpty) {
                        return 'End date is required';
                      }
                      if (_startDateValue != null &&
                          _endDateValue != null &&
                          _endDateValue!.isBefore(_startDateValue!)) {
                        return 'End date must be after start date';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    "Time to Take Medicine",
                    "Select Time",
                    controller: _timeController,
                    isTime: true,
                    readOnly: true,
                    onTap: _pickTime,
                    validator: (value) {
                      if (value == null || value
                          .trim()
                          .isEmpty) {
                        return 'Time is required';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    "Instructions (optional)",
                    "e.g., Take with food",
                    controller: _instructionsController,
                    isLongText: true,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child:
                      isLoading
                          ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: AppColors.white,
                        ),
                      )
                          : const Text(
                        "Add Medication",
                        style: TextStyle(
                          color: AppColors.white,
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
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
        TextEditingController? controller,
    bool isLongText = false,
    bool isDate = false,
    bool isTime = false,
        bool readOnly = false,
        VoidCallback? onTap,
        TextInputType? keyboardType,
        String? Function(String?)? validator,
        TextInputAction? textInputAction,
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
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction:
            textInputAction ??
                (isLongText ? TextInputAction.newline : TextInputAction.next),
            readOnly: readOnly,
            onTap: onTap,
            maxLines: isLongText ? 3 : 1,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                  color: AppColors.whiteGray, fontSize: 14),
              filled: true,
              fillColor: AppColors.white,
              suffixIcon: isDate
                  ? Icon(Icons.calendar_today, size: 18)
                  : (isTime ? Icon(Icons.access_time, size: 18) : null),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: isLongText ? 15 : 0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.whiteGray_2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.whiteGray_2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
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
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.whiteGray_2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.whiteGray_2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
            items: items
                .map(
                  (e) =>
                  DropdownMenuItem<String>(
                    value: e,
                    child: Text(e, style: const TextStyle(fontSize: 14)),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            validator: (selectedValue) {
              if (selectedValue == null || selectedValue.isEmpty) {
                return '$label is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
