class qrInfo_khalti{
  String? khalti_pic;
  
  
  qrInfo_khalti({
    this.khalti_pic,
  });

  Map<String, dynamic> toJson() => {
    'khalti_pic': khalti_pic,
  };
}