class Profile {
  User? user;
  String? token;
  bool? isLogin;
  String? loginAccount;
  bool? isAuthentication;

  Profile(
      {this.user,
        this.token,
        this.isLogin,
        this.loginAccount,
        this.isAuthentication});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    user: User.fromJson(json["user"]),
    token: json['token'] as String?,
    isLogin: json['isLogin'] as bool?,
    loginAccount: json['loginAccount'] as String?,
    isAuthentication: json['isAuthentication'] as bool?,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'user': user?.toJson(),
    "token": token,
    "isLogin": isLogin,
    'loginAccount': loginAccount,
    "isAuthentication": isAuthentication
  };

  @override
  String toString() {
    return 'Profile{user: $user, isLogin: $isLogin, isAuthentication: $isAuthentication}';
  }
}

class User {
  String? avatar;
  String? phone;
  int? placeOrderNum;
  String? status;
  int? successOrderNum;
  String? userCode;
  String? username;
  String? realName;
  String? idCard;
  bool? isBindPaymentCard;

//<editor-fold desc="Data Methods">
  User({
    this.avatar,
    this.phone,
    this.placeOrderNum,
    this.status,
    this.successOrderNum,
    this.userCode,
    this.username,
    this.realName,
    this.idCard,
    this.isBindPaymentCard,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      avatar: json["avatar"],
      phone: json["phone"],
      placeOrderNum: json["placeOrderNum"] as int?,
      status: json["status"],
      successOrderNum: json["successOrderNum"] as int?,
      userCode: json["userCode"],
      username: json["username"],
      realName: json["realName"],
      idCard: json["idCard"],
      isBindPaymentCard: json["isBindPaymentCard"] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "avatar": this.avatar,
      "phone": this.phone,
      "placeOrderNum": this.placeOrderNum,
      "status": this.status,
      "successOrderNum": this.successOrderNum,
      "userCode": this.userCode,
      "username": this.username,
      "realName": this.realName,
      "idCard": this.idCard,
      "isBindPaymentCard": this.isBindPaymentCard,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is User &&
              runtimeType == other.runtimeType &&
              avatar == other.avatar &&
              phone == other.phone &&
              placeOrderNum == other.placeOrderNum &&
              status == other.status &&
              successOrderNum == other.successOrderNum &&
              userCode == other.userCode &&
              username == other.username &&
              realName == other.realName &&
              idCard == other.idCard &&
              isBindPaymentCard == other.isBindPaymentCard);

  @override
  int get hashCode =>
      avatar.hashCode ^
      phone.hashCode ^
      placeOrderNum.hashCode ^
      status.hashCode ^
      successOrderNum.hashCode ^
      userCode.hashCode ^
      username.hashCode ^
      realName.hashCode ^
      idCard.hashCode ^
      isBindPaymentCard.hashCode;

  @override
  String toString() {
    return 'UserInfoBean{ avatar: $avatar, phone: $phone, placeOrderNum: $placeOrderNum, status: $status, successOrderNum: $successOrderNum, userCode: $userCode, username: $username, isBindPaymentCard: $isBindPaymentCard,}';
  }

  User copyWith({
    String? avatar,
    String? phone,
    int? placeOrderNum,
    String? status,
    int? successOrderNum,
    String? userCode,
    String? username,
    String? realName,
    String? idCard,
    bool? isBindPaymentCard,
  }) {
    return User(
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      placeOrderNum: placeOrderNum ?? this.placeOrderNum,
      status: status ?? this.status,
      successOrderNum: successOrderNum ?? this.successOrderNum,
      userCode: userCode ?? this.userCode,
      username: username ?? this.username,
      realName: realName ?? this.realName,
      idCard: idCard ?? this.idCard,
      isBindPaymentCard: isBindPaymentCard ?? this.isBindPaymentCard,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'avatar': this.avatar,
      'phone': this.phone,
      'placeOrderNum': this.placeOrderNum,
      'status': this.status,
      'successOrderNum': this.successOrderNum,
      'userCode': this.userCode,
      'username': this.username,
      "realName": this.realName,
      "idCard": this.idCard,
      'isBindPaymentCard': this.isBindPaymentCard,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      avatar: map['avatar'] as String?,
      phone: map['phone'] as String?,
      placeOrderNum: map['placeOrderNum'] as int?,
      status: map['status'] as String?,
      successOrderNum: map['successOrderNum'] as int?,
      userCode: map['userCode'] as String?,
      username: map['username'] as String?,
      realName: map['realName'] as String?,
      idCard: map['idCard'] as String?,
      isBindPaymentCard: map['isBindPaymentCard'] as bool?,
    );
  }
}