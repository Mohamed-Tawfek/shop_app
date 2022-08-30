class BannerModel {
  late String image;
  BannerModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }
}

class BannerDataModel {
  bool? status;
  late List<BannerModel> banners = [];
  BannerDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    json['data'].forEach((e) {
      banners.add(BannerModel.fromJson(e));
    });
  }
}
