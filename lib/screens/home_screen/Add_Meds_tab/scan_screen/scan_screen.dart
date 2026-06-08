import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../utils/app_colors.dart';
import '../manual_screen/manual_screen.dart';

class ScanPrescriptionScreen extends StatefulWidget {
  static const String routeName = 'scan_prescription_screen';

  const ScanPrescriptionScreen({super.key});

  @override
  State<ScanPrescriptionScreen> createState() => _ScanPrescriptionScreenState();
}

class _ScanPrescriptionScreenState extends State<ScanPrescriptionScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  bool _isProcessing = false;

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked == null) return;
    if (!mounted) return;
    setState(() {
      _selectedImage = picked;
    });
  }

  Future<void> _checkAndContinue() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture or choose an image first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final inputImage = InputImage.fromFilePath(_selectedImage!.path);
      final recognizedText = await textRecognizer.processImage(inputImage);
      final medicineName = _extractMedicineName(recognizedText);

      if (!mounted) return;

      if (medicineName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not detect medication name. Please try another image.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ManualEntryScreen(initialMedicineName: medicineName),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to read image text. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      await textRecognizer.close();
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  String? _extractMedicineName(RecognizedText recognizedText) {
    final blockedWords = {
      'rx',
      'dose',
      'dosage',
      'mg',
      'ml',
      'tablet',
      'capsule',
      'take',
      'daily',
      'every',
      'before',
      'after',
      'morning',
      'night',
      'doctor',
      'pharmacy',
      'patient',
    };

    final dosageOrInstructionPattern = RegExp(
      r'\b(\d+(\.\d+)?\s?(mg|mcg|g|ml|iu|%)|tab(lets?)?|caps(ules?)?|syrup|take|daily|every)\b',
      caseSensitive: false,
    );

    String? bestText;
    double bestScore = 0;

    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        final text = line.text.trim();
        if (text.isEmpty) continue;

        final lowered = text.toLowerCase();
        final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(text);
        if (!hasLetters) continue;
        if (text.length < 3 || text.length > 40) continue;

        final words = lowered.split(RegExp(r'\s+'));
        final allBlocked = words.every(blockedWords.contains);
        if (allBlocked) continue;

        final blockedWordCount = words.where(blockedWords.contains).length;
        final blockedRatio = blockedWordCount / words.length;
        if (blockedRatio > 0.6) continue;

        final alphaCount = RegExp(r'[a-zA-Z]').allMatches(text).length;
        final digitCount = RegExp(r'\d').allMatches(text).length;
        if (alphaCount <= digitCount) continue;

        final box = line.boundingBox;
        final height = line.boundingBox.height;
        final width = line.boundingBox.width;
        final areaScore = height * width;

        final hasDosageHint = dosageOrInstructionPattern.hasMatch(text);
        final wordCount = words.length;

        double score = areaScore;
        // Medicine names are usually short titles with mostly letters.
        score *= (1 + (alphaCount / text.length));
        if (wordCount <= 3) score *= 1.18;
        if (hasDosageHint) score *= 0.58;

        // Slightly prefer upper-part labels on most medicine boxes.
        final topBias = (1 / (1 + box.top / 200)).clamp(0.75, 1.15);
        score *= topBias;

        if (score > bestScore) {
          bestScore = score;
          bestText = text;
        }
      }
    }

    return bestText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: const SizedBox(), // عشان نخلي الـ X على اليمين زي الصورة
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // 1. برواز الكاميرا (Camera Frame)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4F8), // لون رمادي فاتح مريح للعين
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFD1D9E6), width: 2),
              ),
              child: _selectedImage == null
                  ? Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 100,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.file(
                        File(_selectedImage!.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
            ),
          ),

          // 2. النصوص التوضيحية
          Padding(
            padding: const EdgeInsets.only(
              top: 40,
              bottom: 20,
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
                const SizedBox(height: 15),
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

          // 3. منطقة الزراير (Retake - Check - Gallery)
          Padding(
            padding: const EdgeInsets.only(bottom: 60, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSideButton(Icons.refresh, "Retake"),
                const SizedBox(width: 25),
                // الزرار الرئيسي اللبني
                GestureDetector(
                  onTap: _isProcessing ? null : _checkAndContinue,
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
                    child: _isProcessing
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.white,
                            ),
                          )
                        : const Icon(
                            Icons.check,
                            color: AppColors.white,
                            size: 35,
                          ),
                  )),
                const SizedBox(width: 25),
                _buildSideButton(
                  Icons.image_outlined,
                  "Gallery",
                  onTap: () => _pickImage(ImageSource.gallery),
                )],
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت للزراير الجانبية الرمادية
  Widget _buildSideButton(IconData icon,
      String label, {
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap ??
              () {
            if (icon == Icons.refresh) {
              setState(() => _selectedImage = null);
              return;
            }
            _pickImage(ImageSource.camera);
          },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
      ),
    );
  }
}
