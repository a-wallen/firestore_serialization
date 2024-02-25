import 'package:googleapis/firestore/v1.dart';

/// Converts JSON to a Firestore <String, Value> map.
Map<String, Value> convertMapToFirestoreValue(Map<String, dynamic> json) {
  var firestoreMap = <String, Value>{};

  json.forEach((key, value) {
    if (value is String) {
      firestoreMap[key] = Value(stringValue: value);
    } else if (value is int) {
      firestoreMap[key] = Value(integerValue: '$value');
    } else if (value is double) {
      firestoreMap[key] = Value(doubleValue: value);
    } else if (value is bool) {
      firestoreMap[key] = Value(booleanValue: value);
    } else if (value is List) {
      firestoreMap[key] = Value(
        arrayValue: ArrayValue(
          values: value.map(_convertToValue).toList(),
        ),
      );
    } else if (value is Map<String, dynamic>) {
      // Recursive call for nested maps
      firestoreMap[key] =
          Value(mapValue: MapValue(fields: convertMapToFirestoreValue(value)));
    } else if (value is List) {
      // Handle lists, assuming a list of primitives for simplicity
      firestoreMap[key] = Value(
        arrayValue: ArrayValue(
          values: value.map(_convertToValue).toList(),
        ),
      );
    } else {
      // Implement additional type handling as needed
      print('Unsupported type for $key: ${value.runtimeType}');
    }
  });

  return firestoreMap;
}

Value _convertToValue(dynamic item) {
  if (item is String) {
    return Value(stringValue: item);
  } else if (item is int) {
    return Value(integerValue: '$item');
  } else if (item is double) {
    return Value(doubleValue: item);
  } else if (item is bool) {
    return Value(booleanValue: item);
  } else if (item is List) {
    // Recursive call for nested lists
    return Value(
      arrayValue: ArrayValue(
        values: item.map(_convertToValue).toList(),
      ),
    );
  } else if (item is Map<String, dynamic>) {
    // Recursive call for nested maps
    return Value(mapValue: MapValue(fields: convertMapToFirestoreValue(item)));
  } else {
    // Handle other types as needed
    return Value(); // Default empty value, adjust based on your needs
  }
}
