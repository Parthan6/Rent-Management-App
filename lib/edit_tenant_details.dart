// edit_tenant_details.dart
import 'package:flutter/material.dart';
import 'room_model.dart';

class EditTenantDetails extends StatefulWidget {
  final Room room;
  final Function(Room) onSave;

  EditTenantDetails({required this.room, required this.onSave});

  @override
  _EditTenantDetailsState createState() => _EditTenantDetailsState();
}

class _EditTenantDetailsState extends State<EditTenantDetails> {
  late TextEditingController tenantNameController;
  late TextEditingController tenantContactController;

  @override
  void initState() {
    super.initState();
    tenantNameController = TextEditingController(text: widget.room.tenantName);
    tenantContactController =
        TextEditingController(text: widget.room.tenantContact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Tenant Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: tenantNameController,
              decoration: InputDecoration(labelText: 'Tenant Name'),
            ),
            TextField(
              controller: tenantContactController,
              decoration: InputDecoration(labelText: 'Tenant Contact'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Room updatedRoom = Room(
                  roomNumber: widget.room.roomNumber,
                  tenantName: tenantNameController.text,
                  tenantContact: tenantContactController.text,
                  rentAmount: widget.room.rentAmount,
                  dueAmount: widget.room.dueAmount,
                  paymentHistory: List.from(widget
                      .room.paymentHistory), // Copy current payment history
                );
                widget.onSave(updatedRoom);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    tenantNameController.dispose();
    tenantContactController.dispose();
    super.dispose();
  }
}
