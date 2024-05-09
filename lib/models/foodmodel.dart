// To parse this JSON data, do
//
//     final foodData = foodDataFromMap(jsonString);

import 'dart:convert';

FoodData foodDataFromMap(String str) => FoodData.fromMap(json.decode(str));

String foodDataToMap(FoodData data) => json.encode(data.toMap());

class FoodData {
  WweiaFoodCategory wweiaFoodCategory;
  String description;
  List<FoodAttribute> foodAttributes;
  String foodCode;
  List<InputFood> inputFoods;
  String startDate;
  String endDate;
  List<dynamic> foodComponents;
  String foodClass;
  String fdcId;
  String publicationDate;
  List<FoodNutrient> foodNutrients;
  List<FoodPortion> foodPortions;
  String dataType;

  FoodData({
    required this.wweiaFoodCategory,
    required this.description,
    required this.foodAttributes,
    required this.foodCode,
    required this.inputFoods,
    required this.startDate,
    required this.endDate,
    required this.foodComponents,
    required this.foodClass,
    required this.fdcId,
    required this.publicationDate,
    required this.foodNutrients,
    required this.foodPortions,
    required this.dataType,
  });

  FoodData copyWith({
    WweiaFoodCategory? wweiaFoodCategory,
    String? description,
    List<FoodAttribute>? foodAttributes,
    String? foodCode,
    List<InputFood>? inputFoods,
    String? startDate,
    String? endDate,
    List<dynamic>? foodComponents,
    String? foodClass,
    String? fdcId,
    String? publicationDate,
    List<FoodNutrient>? foodNutrients,
    List<FoodPortion>? foodPortions,
    String? dataType,
  }) =>
      FoodData(
        wweiaFoodCategory: wweiaFoodCategory ?? this.wweiaFoodCategory,
        description: description ?? this.description,
        foodAttributes: foodAttributes ?? this.foodAttributes,
        foodCode: foodCode ?? this.foodCode,
        inputFoods: inputFoods ?? this.inputFoods,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        foodComponents: foodComponents ?? this.foodComponents,
        foodClass: foodClass ?? this.foodClass,
        fdcId: fdcId ?? this.fdcId,
        publicationDate: publicationDate ?? this.publicationDate,
        foodNutrients: foodNutrients ?? this.foodNutrients,
        foodPortions: foodPortions ?? this.foodPortions,
        dataType: dataType ?? this.dataType,
      );

  factory FoodData.fromMap(Map<String, dynamic> json) => FoodData(
    wweiaFoodCategory: WweiaFoodCategory.fromMap(json["wweiaFoodCategory"]),
    description: json["description"],
    foodAttributes: List<FoodAttribute>.from(json["foodAttributes"].map((x) => FoodAttribute.fromMap(x))),
    foodCode: json["foodCode"],
    inputFoods: List<InputFood>.from(json["inputFoods"].map((x) => InputFood.fromMap(x))),
    startDate: json["startDate"],
    endDate: json["endDate"],
    foodComponents: List<dynamic>.from(json["foodComponents"].map((x) => x)),
    foodClass: json["foodClass"],
    fdcId: json["fdcId"].toString(),
    publicationDate: json["publicationDate"],
    foodNutrients: List<FoodNutrient>.from(json["foodNutrients"].map((x) => FoodNutrient.fromMap(x))),
    foodPortions: List<FoodPortion>.from(json["foodPortions"].map((x) => FoodPortion.fromMap(x))),
    dataType: json["dataType"],
  );

  Map<String, dynamic> toMap() => {
    "wweiaFoodCategory": wweiaFoodCategory.toMap(),
    "description": description,
    "foodAttributes": List<dynamic>.from(foodAttributes.map((x) => x.toMap())),
    "foodCode": foodCode,
    "inputFoods": List<dynamic>.from(inputFoods.map((x) => x.toMap())),
    "startDate": startDate,
    "endDate": endDate,
    "foodComponents": List<dynamic>.from(foodComponents.map((x) => x)),
    "foodClass": foodClass,
    "fdcId": fdcId,
    "publicationDate": publicationDate,
    "foodNutrients": List<dynamic>.from(foodNutrients.map((x) => x.toMap())),
    "foodPortions": List<dynamic>.from(foodPortions.map((x) => x.toMap())),
    "dataType": dataType,
  };
}

class FoodAttribute {
  int id;
  String value;
  String? name;
  FoodAttributeType foodAttributeType;
  String? sequenceNumber;

  FoodAttribute({
    required this.id,
    required this.value,
    this.name,
    required this.foodAttributeType,
    this.sequenceNumber,
  });

  FoodAttribute copyWith({
    int? id,
    String? value,
    String? name,
    FoodAttributeType? foodAttributeType,
    String? sequenceNumber,
  }) =>
      FoodAttribute(
        id: id ?? this.id,
        value: value ?? this.value,
        name: name ?? this.name,
        foodAttributeType: foodAttributeType ?? this.foodAttributeType,
        sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      );

  factory FoodAttribute.fromMap(Map<String, dynamic> json) => FoodAttribute(
    id: json["id"],
    value: json["value"],
    name: json["name"],
    foodAttributeType: FoodAttributeType.fromMap(json["foodAttributeType"]),
    sequenceNumber: json["sequenceNumber"].toString(),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "value": value,
    "name": name,
    "foodAttributeType": foodAttributeType.toMap(),
    "sequenceNumber": sequenceNumber,
  };
}

class FoodAttributeType {
  int id;
  String name;
  String description;

  FoodAttributeType({
    required this.id,
    required this.name,
    required this.description,
  });

  FoodAttributeType copyWith({
    int? id,
    String? name,
    String? description,
  }) =>
      FoodAttributeType(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
      );

  factory FoodAttributeType.fromMap(Map<String, dynamic> json) => FoodAttributeType(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "description": description,
  };
}

class FoodNutrient {
  Nutrient nutrient;
  Type type;
  String? id;
  String? amount;

  FoodNutrient({
    required this.nutrient,
    required this.type,
    this.id,
    this.amount,
  });

  FoodNutrient copyWith({
    Nutrient? nutrient,
    Type? type,
    String? id,
    String? amount,
  }) =>
      FoodNutrient(
        nutrient: nutrient ?? this.nutrient,
        type: type ?? this.type,
        id: id ?? this.id,
        amount: amount ?? this.amount,
      );

  factory FoodNutrient.fromMap(Map<String, dynamic> json) => FoodNutrient(
    nutrient: Nutrient.fromMap(json["nutrient"]),
    type: typeValues.map[json["type"]]!,
    id: json["id"].toString(),
    amount: json["amount"]?.toString(),
  );

  Map<String, dynamic> toMap() => {
    "nutrient": nutrient.toMap(),
    "type": typeValues.reverse[type],
    "id": id,
    "amount": amount,
  };
}

class Nutrient {
  int id;
  String number;
  String name;
  String rank;
  bool? isNutrientLabel;
  int? indentLevel;
  int? numberOfDecimals;
  String? shortestName;
  String unitName;

  Nutrient({
    required this.id,
    required this.number,
    required this.name,
    required this.rank,
    this.isNutrientLabel,
    this.indentLevel,
    this.numberOfDecimals,
    this.shortestName,
    required this.unitName,
  });

  Nutrient copyWith({
    int? id,
    String? number,
    String? name,
    String? rank,
    bool? isNutrientLabel,
    int? indentLevel,
    int? numberOfDecimals,
    String? shortestName,
    String? unitName,
  }) =>
      Nutrient(
        id: id ?? this.id,
        number: number ?? this.number,
        name: name ?? this.name,
        rank: rank ?? this.rank,
        isNutrientLabel: isNutrientLabel ?? this.isNutrientLabel,
        indentLevel: indentLevel ?? this.indentLevel,
        numberOfDecimals: numberOfDecimals ?? this.numberOfDecimals,
        shortestName: shortestName ?? this.shortestName,
        unitName: unitName ?? this.unitName,
      );

  factory Nutrient.fromMap(Map<String, dynamic> json) => Nutrient(
    id: json["id"],
    number: json["number"],
    name: json["name"],
    rank: json["rank"].toString(),
    isNutrientLabel: json["isNutrientLabel"],
    indentLevel: json["indentLevel"],
    numberOfDecimals: json["numberOfDecimals"],
    shortestName: json["shortestName"],
    unitName: json["unitName"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "number": number,
    "name": name,
    "rank": rank,
    "isNutrientLabel": isNutrientLabel,
    "indentLevel": indentLevel,
    "numberOfDecimals": numberOfDecimals,
    "shortestName": shortestName,
    "unitName": unitNameValues.reverse[unitName],
  };
}

enum UnitName { G, KCAL, MG, UNIT_NAME_G }

final unitNameValues = EnumValues({
  "g": UnitName.G,
  "kcal": UnitName.KCAL,
  "mg": UnitName.MG,
  "µg": UnitName.UNIT_NAME_G
});

enum Type { FOOD_NUTRIENT }

final typeValues = EnumValues({
  "FoodNutrient": Type.FOOD_NUTRIENT
});

class FoodPortion {
  String id;
  String portionDescription;
  String gramWeight;
  String sequenceNumber;
  String modifier;
  MeasureUnit measureUnit;

  FoodPortion({
    required this.id,
    required this.portionDescription,
    required this.gramWeight,
    required this.sequenceNumber,
    required this.modifier,
    required this.measureUnit,
  });

  FoodPortion copyWith({
    String? id,
    String? portionDescription,
    String? gramWeight,
    String? sequenceNumber,
    String? modifier,
    MeasureUnit? measureUnit,
  }) =>
      FoodPortion(
        id: id ?? this.id,
        portionDescription: portionDescription ?? this.portionDescription,
        gramWeight: gramWeight ?? this.gramWeight,
        sequenceNumber: sequenceNumber ?? this.sequenceNumber,
        modifier: modifier ?? this.modifier,
        measureUnit: measureUnit ?? this.measureUnit,
      );

  factory FoodPortion.fromMap(Map<String, dynamic> json) => FoodPortion(
    id: json["id"].toString(),
    portionDescription: json["portionDescription"],
    gramWeight: json["gramWeight"].toString(),
    sequenceNumber: json["sequenceNumber"].toString(),
    modifier: json["modifier"],
    measureUnit: MeasureUnit.fromMap(json["measureUnit"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "portionDescription": portionDescription,
    "gramWeight": gramWeight,
    "sequenceNumber": sequenceNumber,
    "modifier": modifier,
    "measureUnit": measureUnit.toMap(),
  };
}

class MeasureUnit {
  int id;
  String name;
  String abbreviation;

  MeasureUnit({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  MeasureUnit copyWith({
    int? id,
    String? name,
    String? abbreviation,
  }) =>
      MeasureUnit(
        id: id ?? this.id,
        name: name ?? this.name,
        abbreviation: abbreviation ?? this.abbreviation,
      );

  factory MeasureUnit.fromMap(Map<String, dynamic> json) => MeasureUnit(
    id: json["id"],
    name: json["name"],
    abbreviation: json["abbreviation"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "abbreviation": abbreviation,
  };
}

class InputFood {
  String id;
  String foodDescription;
  String ingredientDescription;
  String ingredientWeight;
  String portionCode;
  String portionDescription;
  String sequenceNumber;
  String ingredientCode;
  int retentionCode;
  String unit;
  String amount;

  InputFood({
    required this.id,
    required this.foodDescription,
    required this.ingredientDescription,
    required this.ingredientWeight,
    required this.portionCode,
    required this.portionDescription,
    required this.sequenceNumber,
    required this.ingredientCode,
    required this.retentionCode,
    required this.unit,
    required this.amount,
  });

  InputFood copyWith({
    String? id,
    String? foodDescription,
    String? ingredientDescription,
    String? ingredientWeight,
    String? portionCode,
    String? portionDescription,
    String? sequenceNumber,
    String? ingredientCode,
    int? retentionCode,
    String? unit,
    String? amount,
  }) =>
      InputFood(
        id: id ?? this.id,
        foodDescription: foodDescription ?? this.foodDescription,
        ingredientDescription: ingredientDescription ?? this.ingredientDescription,
        ingredientWeight: ingredientWeight ?? this.ingredientWeight,
        portionCode: portionCode ?? this.portionCode,
        portionDescription: portionDescription ?? this.portionDescription,
        sequenceNumber: sequenceNumber ?? this.sequenceNumber,
        ingredientCode: ingredientCode ?? this.ingredientCode,
        retentionCode: retentionCode ?? this.retentionCode,
        unit: unit ?? this.unit,
        amount: amount ?? this.amount,
      );

  factory InputFood.fromMap(Map<String, dynamic> json) => InputFood(
    id: json["id"].toString(),
    foodDescription: json["foodDescription"],
    ingredientDescription: json["ingredientDescription"],
    ingredientWeight: json["ingredientWeight"].toString(),
    portionCode: json["portionCode"],
    portionDescription: json["portionDescription"],
    sequenceNumber: json["sequenceNumber"].toString(),
    ingredientCode: json["ingredientCode"].toString(),
    retentionCode: json["retentionCode"],
    unit: json["unit"],
    amount: json["amount"].toString(),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "foodDescription": foodDescription,
    "ingredientDescription": ingredientDescription,
    "ingredientWeight": ingredientWeight,
    "portionCode": portionCode,
    "portionDescription": portionDescription,
    "sequenceNumber": sequenceNumber,
    "ingredientCode": ingredientCode,
    "retentionCode": retentionCode,
    "unit": unit,
    "amount": amount,
  };
}

class WweiaFoodCategory {
  int wweiaFoodCategoryCode;
  String wweiaFoodCategoryDescription;

  WweiaFoodCategory({
    required this.wweiaFoodCategoryCode,
    required this.wweiaFoodCategoryDescription,
  });

  WweiaFoodCategory copyWith({
    int? wweiaFoodCategoryCode,
    String? wweiaFoodCategoryDescription,
  }) =>
      WweiaFoodCategory(
        wweiaFoodCategoryCode: wweiaFoodCategoryCode ?? this.wweiaFoodCategoryCode,
        wweiaFoodCategoryDescription: wweiaFoodCategoryDescription ?? this.wweiaFoodCategoryDescription,
      );

  factory WweiaFoodCategory.fromMap(Map<String, dynamic> json) => WweiaFoodCategory(
    wweiaFoodCategoryCode: json["wweiaFoodCategoryCode"],
    wweiaFoodCategoryDescription: json["wweiaFoodCategoryDescription"],
  );

  Map<String, dynamic> toMap() => {
    "wweiaFoodCategoryCode": wweiaFoodCategoryCode,
    "wweiaFoodCategoryDescription": wweiaFoodCategoryDescription,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
