class UserApp {
  final String? uid;
  final String? organizationName;
  final String? email;
  final String? contactPerson;
  final String? phone;
  final String? password;
  final String? fullName;
  final String? address;
  final String? apartmentName;
  final String? city;
  final String? state;
  final String? country;
  final List<String>? image;

  UserApp({
    this.uid,
    this.organizationName,
    this.email,
    this.contactPerson,
    this.phone,
    this.password,
    this.fullName,
    this.address,
    this.apartmentName,
    this.city,
    this.state,
    this.country,
    this.image,
  });

  UserApp copyWith({
    String? uid,
    String? organizationName,
    String? email,
    String? contactPerson,
    String? phone,
    String? password,
    String? fullName,
    String? address,
    String? apartmentName,
    String? city,
    String? state,
    String? country,
    List<String>? image
  }) {
    return UserApp(
      uid: uid ?? this.uid,
      organizationName: organizationName ?? this.organizationName,
      email: email ?? this.email,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      apartmentName: apartmentName ?? this.apartmentName,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      image: image ?? this.image
    );
  }
}

class donorUser{
  String? uid;
  final String? gender;
  final String? email;

  final String? phone;
  final String? password;
  final String? fullName;
  donorUser({
    this.uid,
   this.password,
   this.email,
   this.phone,this.gender,
   this.fullName
});
  donorUser copyWith({
    String? uid,
     String? gender,
     String? email,
     String? phone,
     String? password,
     String? fullName
  }) {
    return donorUser(
      uid: uid??this.uid,
      password:password ?? this.password,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      gender: gender??this.gender
    );
  }
}
class Member {
  String? fullName;
  String? email;
  String? phone;
  String? gender;
  String? dob;
  String? deviceSerial;
  String? allotDevice;
  String? pinNumber;
  String? userName;
  String? longitude;
  String? latitude;
  String? profileImage;
  String? donationReceived;
  String? walletBalance;
  String? joinDate;

  Member(
      {this.fullName,
        this.email,
        this.phone,
        this.gender,
        this.dob,
        this.allotDevice,
        this.deviceSerial,
        this.pinNumber,
        this.userName,
        this.latitude,
        this.longitude,
        this.profileImage,
        this.walletBalance,
        this.donationReceived,
        this.joinDate
      });
}

class Merchant {
  final String? Name;
  final String? Email;
  final String? Phone;
  final String? ChoosePassword;
  final String? ConfirmPassword;
  //business detail
  final String? BusinessName;
  final String? BusinessCategory;
  final String? StreetAddress;
  final String? AreaSector;
  final int? Pincode;
  final String? State;
  final String? Country;
  final List<String>? images;
  //bank detail
  final String? AccountNumber;
  final String? BankName;
  final String? CityBank;
  final String? StateBank;
  final String? BranchLocation;

  Merchant({
    //
    this.Name,
    this.Email,
    this.Phone,
    this.ChoosePassword,
    this.ConfirmPassword,
    //business
    this.BusinessName,
    this.BusinessCategory,
    this.StreetAddress,
    this.AreaSector,
    this.Pincode,
    this.State,
    this.Country,
    this.images,
    //bank
    this.AccountNumber,
    this.BankName,
    this.CityBank,
    this.StateBank,
    this.BranchLocation,
  });
}
class homeless {
  String? documentId; // Document ID
  String? address;
  String? allotDevice;
  String? deviceSerial;
  DateTime? dob; // Date of Birth
  String? donationReceived;
  String? fullName;
  String? gender;
  String? email;
  DateTime? joinDate;
  double? latitude;
  String? location;
  double? longitude;
  String? organizationId;
  String? phone;
  String? pinNumber;
  String? profileImageUrl;
  String? userName;
  List<String>? usersChats; // Assuming it's a list of chat IDs or similar
  double? walletBalance;

  homeless({
    this.documentId,
    this.address,
    this.allotDevice,
    this.deviceSerial,
    this.dob,
    this.donationReceived,
    this.email,
    this.fullName,
    this.gender,
    this.joinDate,
    this.latitude,
    this.location,
    this.longitude,
    this.organizationId,
    this.phone,
    this.pinNumber,
    this.profileImageUrl,
    this.userName,
    this.usersChats,
    this.walletBalance,
  });
}

