List<Map<String, dynamic>> ticketList = [
  {
    'from': {'code': "TGM", 'name': "Tagum City"},
    'to': {'code': "DVO", 'name': "Davao City"},
    'flying_time': '04:00 PM',
    'date': "1 MAY",
    'departure_time': "08:00 AM",
    "number": 24
  },
  {
    'from': {'code': "DK", 'name': "Dhaka"},
    'to': {'code': "SH", 'name': "Shanghai"},
    'flying_time': '4H 20M',
    'date': "10 MAY",
    'departure_time': "09:00 AM",
    "number": 45
  },
  {
    'from': {'code': "DK", 'name': "Dhaka"},
    'to': {'code': "SH", 'name': "Shanghai"},
    'flying_time': '4H 20M',
    'date': "10 MAY",
    'departure_time': "09:00 AM",
    "number": 45
  },
  {
    'from': {'code': "DK", 'name': "Dhaka"},
    'to': {'code': "SH", 'name': "Shanghai"},
    'flying_time': '4H 20M',
    'date': "10 MAY",
    'departure_time': "09:00 AM",
    "number": 45
  },
  {
    'from': {'code': "DK", 'name': "Dhaka"},
    'to': {'code': "SH", 'name': "Shanghai"},
    'flying_time': '4H 20M',
    'date': "10 MAY",
    'departure_time': "09:00 AM",
    "number": 45
  },
];

List<Map<String, dynamic>> routeList = [
  {
    'image': 'bus1.jpg',
    'route': 'Route 1',
    'detail_1': 'Non-Stop',
    'destination': 'Davao City',
    'price': 90
  },
  {
    'image': 'bus2.jpg',
    'route': 'Route 2',
    'detail_1': 'Non-Stop',
    'destination': 'Mati City',
    'price': 60
  },
  {
    'image': 'bus3.jpg',
    'route': 'Route3',
    'detail_1': 'Non-Stop',
    'destination': 'Pantukan',
    'price': 40
  },
];

class AppRoutes {
  static const homePage = "/";

  static const allTickets = "/all_tickets";

  static const ticketScreen = "/ticket_screen";

  static const allHotels = "/all_hotels";

  static const hotelDetail = "/hotel_detail";
}
