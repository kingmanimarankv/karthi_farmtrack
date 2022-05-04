class Fertilizers {
  late int groupId;
  late int fertilizerId;
  late double n;
  late double p;
  late double k;
  late String fertilizerName;

  Fertilizers(this.groupId, this.fertilizerId, this.n, this.p, this.k,
      this.fertilizerName);

  Fertilizers.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    fertilizerId = json['fertilizer_id'];
    n = json['N'];
    p = json['P'];
    k = json['K'];
    fertilizerName = json['fertilizer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.groupId;
    data['fertilizer_id'] = this.fertilizerId;
    data['N'] = this.n;
    data['P'] = this.p;
    data['K'] = this.k;
    data['fertilizer_name'] = this.fertilizerName;
    return data;
  }
}
