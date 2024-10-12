// room_details_screen.dart
import 'package:flutter/material.dart';
import 'room_model.dart';
import 'edit_tenant_details.dart';
import 'pdf_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RoomDetailsScreen extends StatefulWidget {
  final Room room;
  final List<Room> rooms; // Add rooms parameter

  RoomDetailsScreen({required this.room, required this.rooms});

  @override
  _RoomDetailsScreenState createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  Future<void> saveRooms() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> roomData =
        widget.rooms.map((room) => jsonEncode(room.toJson())).toList();
    await prefs.setStringList('rooms', roomData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room ${widget.room.roomNumber} Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () => generatePdf(widget.room),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Tenant Name: ${widget.room.tenantName}'),
            Text('Contact: ${widget.room.tenantContact}'),
            Text('Rent: ₹${widget.room.rentAmount}'),
            Text('Due Amount: ₹${widget.room.dueAmount}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTenantDetails(
                      room: widget.room,
                      onSave: (updatedRoom) {
                        setState(() {
                          widget.room.tenantName = updatedRoom.tenantName;
                          widget.room.tenantContact = updatedRoom.tenantContact;
                          saveRooms(); // Save changes
                        });
                      },
                    ),
                  ),
                );
              },
              child: Text('Edit Details'),
            ),
            SizedBox(height: 20),
            Text('Payment History:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.room.paymentHistory.length,
                itemBuilder: (context, index) {
                  final payment = widget.room.paymentHistory[index];
                  return ListTile(
                    title: Text('Paid: ₹${payment.amountPaid}'),
                    subtitle: Text('Date: ${payment.date}'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.room.markAsPaid(widget.room.rentAmount);
                  saveRooms();
                });
              },
              child: Text('Mark as Paid'),
            ),
          ],
        ),
      ),
    );
  }
}
