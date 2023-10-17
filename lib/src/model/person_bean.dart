/// Domain model entity
class PersonBean {
  int? userId;
  String? nickName;
  String? phone;
  int? accountStatus;
  double? totalBalance;
  double? freezeBalance;
  double? groundedBalance;
  String? createTime;
  int? volumeStatus;
  bool selected = false;

//<editor-fold desc="Data Methods">
  PersonBean({
    this.userId,
    this.nickName,
    this.phone,
    this.accountStatus,
    this.totalBalance,
    this.freezeBalance,
    this.groundedBalance,
    this.createTime,
    this.volumeStatus,
    this.selected = false,
  });


  factory PersonBean.fromJson(Map<String, dynamic> json) {
    return PersonBean(
      userId: int.parse(json["userId"]),
      nickName: json["nickName"],
      phone: json["phone"],
      accountStatus: int.parse(json["accountStatus"]),
      totalBalance: double.parse(json["totalBalance"]),
      freezeBalance: double.parse(json["freezeBalance"]),
      groundedBalance: double.parse(json["groundedBalance"]),
      createTime: json["createTime"],
      volumeStatus: int.parse(json["volumeStatus"]),
      selected: json["selected"].toLowerCase() == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": this.userId,
      "nickName": this.nickName,
      "phone": this.phone,
      "accountStatus": this.accountStatus,
      "totalBalance": this.totalBalance,
      "freezeBalance": this.freezeBalance,
      "groundedBalance": this.groundedBalance,
      "createTime": this.createTime,
      "volumeStatus": this.volumeStatus,
      "selected": this.selected,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonBean &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          nickName == other.nickName &&
          phone == other.phone &&
          accountStatus == other.accountStatus &&
          totalBalance == other.totalBalance &&
          freezeBalance == other.freezeBalance &&
          groundedBalance == other.groundedBalance &&
          createTime == other.createTime &&
          volumeStatus == other.volumeStatus &&
          selected == other.selected);

  @override
  int get hashCode =>
      userId.hashCode ^
      nickName.hashCode ^
      phone.hashCode ^
      accountStatus.hashCode ^
      totalBalance.hashCode ^
      freezeBalance.hashCode ^
      groundedBalance.hashCode ^
      createTime.hashCode ^
      volumeStatus.hashCode ^
      selected.hashCode;

  @override
  String toString() {
    return 'PersonBean{ userId: $userId, nickName: $nickName, phone: $phone, accountStatus: $accountStatus, totalBalance: $totalBalance, freezeBalance: $freezeBalance, groundedBalance: $groundedBalance, createTime: $createTime, volumeStatus: $volumeStatus, selected: $selected,}';
  }

  PersonBean copyWith({
    int? userId,
    String? nickName,
    String? phone,
    int? accountStatus,
    double? totalBalance,
    double? freezeBalance,
    double? groundedBalance,
    String? createTime,
    int? volumeStatus,
    bool? selected,
  }) {
    return PersonBean(
      userId: userId ?? this.userId,
      nickName: nickName ?? this.nickName,
      phone: phone ?? this.phone,
      accountStatus: accountStatus ?? this.accountStatus,
      totalBalance: totalBalance ?? this.totalBalance,
      freezeBalance: freezeBalance ?? this.freezeBalance,
      groundedBalance: groundedBalance ?? this.groundedBalance,
      createTime: createTime ?? this.createTime,
      volumeStatus: volumeStatus ?? this.volumeStatus,
      selected: selected ?? this.selected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'nickName': this.nickName,
      'phone': this.phone,
      'accountStatus': this.accountStatus,
      'totalBalance': this.totalBalance,
      'freezeBalance': this.freezeBalance,
      'groundedBalance': this.groundedBalance,
      'createTime': this.createTime,
      'volumeStatus': this.volumeStatus,
      'selected': this.selected,
    };
  }

  factory PersonBean.fromMap(Map<String, dynamic> map) {
    return PersonBean(
      userId: map['userId'] as int,
      nickName: map['nickName'] as String,
      phone: map['phone'] as String,
      accountStatus: map['accountStatus'] as int,
      totalBalance: map['totalBalance'] as double,
      freezeBalance: map['freezeBalance'] as double,
      groundedBalance: map['groundedBalance'] as double,
      createTime: map['createTime'] as String,
      volumeStatus: map['volumeStatus'] as int,
      selected: map['selected'] as bool,
    );
  }

//</editor-fold>
}