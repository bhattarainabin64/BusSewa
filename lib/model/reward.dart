class Reward {
  int ? point;

  Reward({
    this.point,
  });

  Map<String, dynamic> toJson() => {
        'point': point,
      };
}
