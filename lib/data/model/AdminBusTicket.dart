class AdminBusTicket{
  final List<String> destination;
  final DateTime departureTime;
  final int totalSeats;
  final int ticketPrice;

  AdminBusTicket({required this.destination, required this.departureTime, required this.totalSeats, required this.ticketPrice});

 Map<String,dynamic> toJson(){
   return {
     "data": {

     }
   };
 }
}