import 'package:cura_frontend/screens/Listings/models/listings.dart';

class AddListingArguments {
  final String uid;
  final String type;
  final Listing? listing;

  AddListingArguments({required this.uid, required this.type, this.listing});
}
