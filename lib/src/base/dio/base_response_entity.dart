import 'dart:convert';

class BaseResponseEntity {
  late Object? data;
  late String errCode;
  late String errMessage;
  late bool? success;

  BaseResponseEntity(
      {this.data,
      this.errMessage = "",
      this.errCode = "",
      this.success = false});

  factory BaseResponseEntity.fromJson(Map<String, dynamic> json) {
    final BaseResponseEntity baseResponseEntity = BaseResponseEntity();
    final String? errorCode = json['errCode'];
    if (errorCode != null) {
      baseResponseEntity.errCode = errorCode;
    }
    final String? errorMsg = json['errMessage'];
    if (errorMsg != null) {
      baseResponseEntity.errMessage = errorMsg;
    }
    final bool? isSuccess = json['success'];
    baseResponseEntity.success = isSuccess;
    if (isSuccess ?? false) {
      baseResponseEntity.data = json['data'];
    }
    return baseResponseEntity;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data;
    data['errCode'] = this.errCode;
    data['errMessage'] = this.errMessage;
    data['success'] = this.success;
    return data;
  }

  BaseResponseEntity copyWith(
      {Object? data, String? errorCode, String? errorMsg, bool? isSuccess}) {
    return BaseResponseEntity()
      ..data = data ?? this.data
      ..errCode = errorCode ?? this.errCode
      ..errMessage = errorMsg ?? this.errMessage
      ..success = isSuccess ?? this.success;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
