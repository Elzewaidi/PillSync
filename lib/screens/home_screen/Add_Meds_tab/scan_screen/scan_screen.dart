import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pillsync/screens/home_screen/Add_Meds_tab/manual_screen/manual_screen.dart';
import 'package:pillsync/utils/app_colors.dart';

class ScanPrescriptionScreen extends StatefulWidget {
  static const String routeName = '/scan';

  const ScanPrescriptionScreen({super.key});

  @override
  State<ScanPrescriptionScreen> createState() => _ScanPrescriptionScreenState();
}

class _ScanPrescriptionScreenState extends State<ScanPrescriptionScreen> {
  File? _imageFile;
  bool _isScanning = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("عذرًا، فشل فتح الكاميرا أو معرض الصور: $e"),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _startOcrScan() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("الرجاء التقاط صورة أو اختيارها من المعرض أولاً."),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isScanning = true;
    });

    try {
      final inputImage = InputImage.fromFile(_imageFile!);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      final rawText = recognizedText.text;
      
      await textRecognizer.close();

      if (rawText.trim().isEmpty) {
        setState(() {
          _isScanning = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("لم نتمكن من قراءة أي نصوص في هذه الصورة. يرجى المحاولة بصورة أوضح."),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final parsedData = _parseRecognizedText(rawText);

      setState(() {
        _isScanning = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم قراءة علبة الدواء (${parsedData['name']}) بنجاح وجاري ملء البيانات!"),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Navigate to ManualEntryScreen with the parsed data
      context.push(ManualEntryScreen.routeName, extra: parsedData);

    } catch (e) {
      setState(() {
        _isScanning = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("عذرًا، حدث خطأ أثناء التعرف على النصوص: $e"),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Map<String, dynamic> _parseRecognizedText(String text) {
    final lines = text.split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    String name = "Unknown Medication";
    String dosage = "10mg";
    String typeOfDrug = "Medicine Tablets";
    String frequency = "Once daily";
    String instructions = "";

    // 1. Find Name (first non-empty line containing alphabetic characters)
    for (var line in lines) {
      if (line.length >= 3 && RegExp(r'[a-zA-Z]').hasMatch(line)) {
        name = line.replaceAll(RegExp(r'\b\d+\s*(mg|g|mcg|ml)\b', caseSensitive: false), '').trim();
        name = name.replaceAll(RegExp(r'[#@$_%^&*(){}\[\]\\|;<>?]'), '').trim();
        name = name.split(' ')
            .where((w) => w.isNotEmpty)
            .map((w) => w[0].toUpperCase() + w.substring(1))
            .join(' ');
        if (name.isNotEmpty) break;
      }
    }
    if (name.isEmpty || name == "Unknown Medication") {
      name = "Prescription Med";
    }

    // 2. Find Dosage
    final dosageRegex = RegExp(r'\b(\d+\s*(mg|g|mcg|ml))\b', caseSensitive: false);
    for (var line in lines) {
      final match = dosageRegex.firstMatch(line);
      if (match != null) {
        dosage = match.group(1)!.trim().toLowerCase();
        break;
      }
    }

    // 3. Find Drug Type
    final textLower = text.toLowerCase();
    if (textLower.contains("capsule") || textLower.contains("cap")) {
      typeOfDrug = "Capsule";
    } else if (textLower.contains("syrup") || textLower.contains("suspension") || textLower.contains("liquid") || textLower.contains("solution")) {
      typeOfDrug = "Syrup";
    } else {
      typeOfDrug = "Medicine Tablets";
    }

    // 4. Find Frequency
    if (textLower.contains("twice") || textLower.contains("2 times") || textLower.contains("bid") || textLower.contains("b.i.d")) {
      frequency = "Twice daily";
    } else if (textLower.contains("three") || textLower.contains("3 times") || textLower.contains("tid") || textLower.contains("t.i.d")) {
      frequency = "Three times daily";
    } else {
      frequency = "Once daily";
    }

    // 5. Find Instructions
    final instructionKeywords = ["take", "use", "with", "after", "before", "meals", "food", "water", "hours", "hrs", "every"];
    final instrLines = <String>[];
    for (var line in lines) {
      final lineLower = line.toLowerCase();
      for (var word in instructionKeywords) {
        if (lineLower.contains(word) && !instrLines.contains(line)) {
          instrLines.add(line);
          break;
        }
      }
    }
    if (instrLines.isNotEmpty) {
      instructions = instrLines.join(' ');
      if (instructions.length > 150) {
        instructions = "${instructions.substring(0, 147)}...";
      }
    } else {
      instructions = "Take as prescribed by doctor.";
    }

    return {
      "name": name,
      "dosage": dosage,
      "typeOfDrug": typeOfDrug,
      "frequency": frequency,
      "instructions": instructions,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const SizedBox(),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              // 1. برواز الكاميرا / عرض الصورة
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F4F8),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFFD1D9E6), width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: _imageFile != null
                        ? Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 100,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "لم يتم اختيار صورة بعد",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                  ),
                ),
              ),

              // 2. النصوص التوضيحية
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  bottom: 15,
                  left: 40,
                  right: 40,
                ),
                child: Column(
                  children: [
                    const Text(
                      "Scan your prescription",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Place your prescription within the frame and hold steady.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // 3. منطقة الزراير (Retake - Check/Scan - Gallery)
              Padding(
                padding: const EdgeInsets.only(bottom: 60, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // زر الكاميرا / إعادة الالتقاط
                    GestureDetector(
                      onTap: () => _pickImage(ImageSource.camera),
                      child: _buildSideButton(Icons.camera_alt_outlined, "Camera"),
                    ),
                    const SizedBox(width: 20),
                    // الزرار الرئيسي لبدء قراءة الصورة ضوئياً
                    GestureDetector(
                      onTap: _startOcrScan,
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B4D8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00B4D8).withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 35),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // زر اختيار من الألبوم
                    GestureDetector(
                      onTap: () => _pickImage(ImageSource.gallery),
                      child: _buildSideButton(Icons.image_outlined, "Gallery"),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // ويدجت التحميل لقراءة الصورة ضوئياً (OCR Processing Overlay)
          if (_isScanning)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B4D8)),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "جاري معالجة وقراءة علبة الدواء ضوئياً...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "OCR processing in progress...",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSideButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEF5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF5D6778)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5D6778),
            ),
          ),
        ],
      ),
    );
  }
}
