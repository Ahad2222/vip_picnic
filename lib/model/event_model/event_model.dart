class EventModel {
  String userID;
  String userEmail;
  String userName;
  String packType;
  String eventType;
  int noOfPersons;
  String foodPref;
  String drinkPref;
  String startTime;
  String duration;
  String eventDate;
  String details;

  String bookerName;
  String bookerEmail;
  String bookerPhone;
  String city;
  String state;
  String zip;
  String address;
  Map<String, int>? addons;

  EventModel({
    this.userID = '',
    this.userEmail = '',
    this.userName = '',
    this.packType = '',
    this.eventType = '',
    this.noOfPersons = 0,
    this.foodPref = '',
    this.drinkPref = '',
    this.startTime = '',
    this.duration = '',
    this.eventDate = '',
    this.details = '',
    // this.flowers = 0,
    // this.champagne = 0,
    // this.wine = 0,
    // this.cake = 0,
    // this.candles = 0,
    this.addons,
    this.bookerName = '',
    this.bookerEmail = '',
    this.bookerPhone = '',
    this.city = '',
    this.state = '',
    this.zip = '',
    this.address = '',
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        userID: json['userID'],
        userEmail: json['userEmail'],
        userName: json['userName'],
        packType: json['packType'],
        eventType: json['eventType'],
        noOfPersons: json['noOfPersons'],
        foodPref: json['foodPref'],
        drinkPref: json['drinkPref'],
        startTime: json['startTime'],
        duration: json[' duration'],
        eventDate: json['eventDate'],
        details: json['details'],
        addons: json['addons'],
        // flowers: json['flowers'],
        // champagne: json['champagne'],
        // wine: json['wine'],
        // cake: json['cake'],
        // candles: json['candles'],
        bookerName: json['bookerName'],
        bookerEmail: json['bookerEmail'],
        bookerPhone: json['bookerPhone'],
        city: json['city'],
        state: json['state'],
        zip: json['zip'],
        address: json['address'],
      );

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'userEmail': userEmail,
        'userName': userName,
        'packType': packType,
        'eventType': eventType,
        'noOfPersons': noOfPersons,
        'foodPref': foodPref,
        'drinkPref': drinkPref,
        'startTime': startTime,
        'duration': duration,
        'eventDate': eventDate,
        'details': details,
        'addons': addons,
        // 'flowers': flowers,
        // 'champagne': champagne,
        // 'wine': wine,
        // 'cake': cake,
        // 'candles': candles,
        'bookerName': bookerName,
        'bookerEmail': bookerEmail,
        'bookerPhone': bookerPhone,
        'city': city,
        'state': state,
        'zip': zip,
        'address': address,
      };
}
