

class qrInfo{
  String? qr_pic;
  
  
  qrInfo({
    this.qr_pic,
  });

  Map<String, dynamic> toJson() => {
    'qr_pic': qr_pic,
  };
}