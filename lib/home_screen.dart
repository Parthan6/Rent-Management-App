import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'room_model.dart';
import 'room_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Room> rooms = [];
  String searchQuery = '';
  int? filterDueAmount;

  @override
  void initState() {
    super.initState();
    loadRooms();
  }

  Future<void> loadRooms() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? roomData = prefs.getStringList('rooms');
    // if (roomData != null) {
    //   setState(() {
    //     rooms =
    //         roomData.map((data) => Room.fromJson(jsonDecode(data))).toList();
    //   });
    // } else {
    // Initialize with 25 rooms if not found
    setState(() {
      rooms = List.generate(
          23,
          (index) => Room(
                roomNumber: (index + 1).toString(),
                tenantName: 'Tenant ${index + 1}',
                tenantContact: '9876543210',
                rentAmount: 2000,
                dueAmount: 2000,
                paymentHistory: [],
              ));
      saveRooms();
    });
    //}
  }

  Future<void> saveRooms() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> roomData =
        rooms.map((room) => jsonEncode(room.toJson())).toList();
    await prefs.setStringList('rooms', roomData);
  }

  void markPaymentAsDone(Room room, int amountPaid) {
    setState(() {
      room.markAsPaid(amountPaid as double);
      saveRooms();
    });
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Room> filteredRooms = rooms
        .where((room) =>
            room.roomNumber.contains(searchQuery) ||
            room.tenantName.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    if (filterDueAmount != null) {
      filteredRooms = filteredRooms.where((room) {
        switch (filterDueAmount) {
          case 0:
            return room.dueAmount == 0;
          case 2000:
            return room.dueAmount == 2000;
          case 4000:
            return room.dueAmount == 4000;
          case 6000:
            return room.dueAmount > 6000;
          case -1:
            return room.dueAmount >= 0;
          default:
            return true;
        }
      }).toList();
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 201, 140),
      appBar: AppBar(
        title: Text('Rooms'),
        actions: [
          ElevatedButton(
            child: Text(
              'Add Rent',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
            ),
            onPressed: () {
              setState(() {
                rooms.forEach((room) {
                  room.dueAmount += room.rentAmount;
                });
                saveRooms();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration:
                  InputDecoration(labelText: 'Search by Room or Tenant'),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            DropdownButton<int>(
              value: filterDueAmount,
              hint: Text('Filter by Due Amount'),
              items: [
                DropdownMenuItem(child: Text('Due 0'), value: 0),
                DropdownMenuItem(child: Text('Due 2000'), value: 2000),
                DropdownMenuItem(child: Text('Due 4000'), value: 4000),
                DropdownMenuItem(child: Text('Due > 6000'), value: 6000),
                DropdownMenuItem(child: Text('Clear Filter'), value: -1),
              ],
              onChanged: (value) {
                setState(() {
                  filterDueAmount = value;
                });
              },
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    rooms.forEach((room) {
                      room.dueAmount = 0;
                    });
                  });
                },
                child: const Text('Remove Rent')),
            Expanded(
              child: ListView.builder(
                itemCount: filteredRooms.length,
                itemBuilder: (context, index) {
                  Room room = filteredRooms[index];
                  return Card(
                    color: Color.fromARGB(255, 229, 229, 229),
                    child: ListTile(
                      title: Text('Room ${room.roomNumber}'),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tenant: ${room.tenantName} '),
                          Text(
                            'Due: ₹${room.dueAmount}',
                            style: TextStyle(
                                color: room.dueAmount == 0
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoomDetailsScreen(
                              room: rooms[index],
                              rooms: rooms,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
