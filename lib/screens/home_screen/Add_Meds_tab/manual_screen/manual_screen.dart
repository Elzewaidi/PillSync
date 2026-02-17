import 'package:flutter/material.dart';

class ManualEntryScreen extends StatelessWidget {
  static const String routeName = 'manual_entry_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Add Medication",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField("Medication Name", "e.g., Lisinopril"),
            _buildTextField("Dosage", "e.g., 25mg"),
            _buildDropdownField("Type of Drug", [
              "Medicine Tablets",
              "Capsule",
              "Syrup",
            ]),
            _buildDropdownField("Frequency", [
              "Once daily",
              "Twice daily",
              "Three times daily",
            ]),
            _buildTextField("Start Date", "Select Date", isDate: true),
            _buildTextField("End Date", "Select Date", isDate: true),
            _buildTextField(
              "Time to Take Medicine",
              "Select Time",
              isTime: true,
            ),
            _buildTextField(
              "Instructions (optional)",
              "e.g., Take with food",
              isLongText: true,
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00BCD4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "Add Medication",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    bool isLongText = false,
    bool isDate = false,
    bool isTime = false,
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
          SizedBox(height: 8),
          TextField(
            maxLines: isLongText ? 3 : 1,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: isDate
                  ? Icon(Icons.calendar_today, size: 18)
                  : (isTime ? Icon(Icons.access_time, size: 18) : null),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: isLongText ? 15 : 0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
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
          SizedBox(height: 8),
          DropdownButtonFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            items: items
                .map(
                  (e) => DropdownMenuItem(
                    child: Text(e, style: TextStyle(fontSize: 14)),
                    value: e,
                  ),
                )
                .toList(),
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }
}
