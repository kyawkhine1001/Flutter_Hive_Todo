import 'package:flutter_hive_todo_bloc_clean_architecture/app/helper/description_field_validator.dart.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/helper/title_field_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  group('Field Validator Test', () {

    group('Title Field Validator Test', () {
      test('return error when input is null', () {
        var expectedValue = 'Please enter a title';
        expect(titleFieldValidator(null),equals(expectedValue));
      });


      test('return error when input have more than 50 characters', () {
        var expectedValue = 'Title cannot be longer than 50 characters';
        expect(titleFieldValidator('a'*51),equals(expectedValue));
      });

      test('return null when input is not empty', () {
        expect(titleFieldValidator("test"),equals(null));
      });
    });

    group('Description Field Validator Test', () {
      test('return error when input is null', () {
        var expectedValue = 'Please enter a description';
        expect(descriptionFieldValidator(null),equals(expectedValue));
      });


      test('return error when input have more than 200 characters', () {
        var expectedValue = 'Description cannot be longer than 200 characters';
        expect(descriptionFieldValidator('a'*201),equals(expectedValue));
      });

      test('return null when input is not empty', () {
        expect(descriptionFieldValidator("test"),equals(null));
      });
    });
  });
}