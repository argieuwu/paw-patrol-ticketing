import 'package:flutter/material.dart';
import 'package:capstone2/data/controllers/AdminTicket_data_controller.dart';
import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:capstone2/res/app_style.dart';

class AddBusRouteScreen extends StatefulWidget {
  const AddBusRouteScreen({super.key});

  @override
  State<AddBusRouteScreen> createState() => _AddBusRouteScreenState();
}

class _AddBusRouteScreenState extends State<AddBusRouteScreen> {
  DateTime dateTime = DateTime.now();
  bool isAircon = false;

  final TextEditingController pointAController = TextEditingController();
  final TextEditingController pointBController = TextEditingController();
  final TextEditingController seatsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController plateNumberController =
      TextEditingController(); // Newly added

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Bus Route',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppStyle.textColor3,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppStyle.bgColor2,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              'Create New Route',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppStyle.textColor2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fill all required fields to add a new bus route',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppStyle.textColor,
              ),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInputField(
                      controller: pointAController,
                      label: 'Starting Point',
                      icon: Icons.location_on,
                      hint: 'Enter starting location',
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      controller: pointBController,
                      label: 'Destination',
                      icon: Icons.flag,
                      hint: 'Enter destination',
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      controller: plateNumberController, // Added
                      label: 'Bus Plate Number',
                      icon: Icons.confirmation_number,
                      hint: 'Enter plate number',
                    ),
                    const SizedBox(height: 20),
                    _buildDateTimeField(),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            controller: seatsController,
                            label: 'Number of Seats',
                            icon: Icons.event_seat,
                            keyboardType: TextInputType.number,
                            hint: '20',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInputField(
                              controller: priceController,
                              label: 'Ticket Price',
                              icon: Icons.attach_money,
                              keyboardType: TextInputType.number),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Text(
                        'Air-conditioned Bus',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: AppStyle.textColor2,
                        ),
                      ),
                      subtitle: Text(
                        'Enable for AC buses',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppStyle.textColor,
                        ),
                      ),
                      value: isAircon,
                      onChanged: (value) => setState(() => isAircon = value),
                      contentPadding: EdgeInsets.zero,
                      secondary: Icon(
                        Icons.ac_unit,
                        color: isAircon
                            ? AppStyle.icyTeal
                            : AppStyle.coolLightGray,
                      ),
                      activeColor: AppStyle.icyTeal,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.busrouteBG2Des,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'ADD BUS ROUTE',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.textColor3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(
        color: AppStyle.textColor2,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: AppStyle.textColor,
          fontSize: 14,
        ),
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: AppStyle.coolLightGray,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: AppStyle.icyTeal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppStyle.busrouteBG2Des, width: 2),
        ),
        filled: true,
        fillColor: AppStyle.searchtab3,
      ),
    );
  }

  Widget _buildDateTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Departure Time',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: AppStyle.textColor2,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDateTime,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppStyle.coolLightGray),
              borderRadius: BorderRadius.circular(10),
              color: AppStyle.searchtab3,
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: AppStyle.icyTeal, size: 24),
                const SizedBox(width: 16),
                Text(
                  '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppStyle.textColor2,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('|', style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 12),
                Text(
                  '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppStyle.textColor2,
                  ),
                ),
                const Spacer(),
                Icon(Icons.edit_calendar, color: AppStyle.icyTeal),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppStyle.busrouteBG2Des,
              onPrimary: Colors.white,
              surface: AppStyle.searchtab3,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppStyle.busrouteBG2Des,
              onPrimary: Colors.white,
              surface: AppStyle.searchtab3,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        dateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  void _submitForm() {
    final int? totalSeats = int.tryParse(seatsController.text);
    final int? ticketPrice = int.tryParse(priceController.text);

    if (pointAController.text.isEmpty ||
        pointBController.text.isEmpty ||
        plateNumberController.text.isEmpty ||
        totalSeats == null ||
        ticketPrice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all fields correctly',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    //  Check if total seats exceed the maximum limit (20)
    if (totalSeats > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'The number of seats cannot exceed 20.',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newTicket = AdminBusTicket.noID(
      destination: [pointAController.text, pointBController.text],
      departureTime: dateTime,
      totalSeats: totalSeats,
      ticketPrice: ticketPrice,
      isAircon: isAircon,
      plateNumber: plateNumberController.text,
    );

    AdminTicketController().uploadTicket(newTicket);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Bus Route Added Successfully',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.green,
      ),
    );

    pointAController.clear();
    pointBController.clear();
    seatsController.clear();
    priceController.clear();
    plateNumberController.clear();

    setState(() {
      dateTime = DateTime.now();
      isAircon = false;
    });
  }

  @override
  void dispose() {
    pointAController.dispose();
    pointBController.dispose();
    seatsController.dispose();
    priceController.dispose();
    plateNumberController.dispose(); // Dispose plate number controller
    super.dispose();
  }
}
