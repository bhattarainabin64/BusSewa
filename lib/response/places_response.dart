import 'package:json_annotation/json_annotation.dart';

import 'package:roadway_core/model/places_model.dart';
part 'places_response.g.dart';

@JsonSerializable()
class PlacesResponse {
  List<Features>? features;
  PlacesResponse({this.features});
  factory PlacesResponse.fromJson(Map<String, dynamic> json) {
    return _$PlacesResponseFromJson(json);
  }
  Map<String, dynamic> toJson() => _$PlacesResponseToJson(this);
}
