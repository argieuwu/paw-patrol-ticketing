import 'package:capstone2/data/api/ApiService.dart';
import 'package:capstone2/data/model/Checkout.dart';
import 'package:capstone2/data/model/UserCheckout.dart';

class CheckoutController{
  Future<UserCheckout> createCheckoutController(Map<String,dynamic> userpost) async{
    try{
     return await Apiservice().createCheckout(userpost);
    }
    catch(e){
      throw("Controller error createCheckout: $e");
    }
  }

  Future<UserCheckout> getCheckoutController(String id) async{
    try{
      return await Apiservice().getCheckout(id);
    }
    catch(e){
      throw("Controller error getCheckout: $e");
    }
  }
}