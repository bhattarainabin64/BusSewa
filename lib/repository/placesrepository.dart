import 'package:roadway_core/api/getplacesapi.dart';
import 'package:roadway_core/response/places_response.dart';

class PlacesRepository {
  Future<PlacesResponse?> getplaces({required String keyword}) async {
    return PlacesAPI().fetchplacesfromapi(search: keyword);
  }
}
