import '../formz.dart';

enum RequiredValidationError { empty }

class DefaultValidator extends FormzInput<String, String?> {
  const DefaultValidator.pure([super.value = '']) : super.pure();

  const DefaultValidator.dirty([super.value = '']) : super.dirty();

  @override
  String? validator(String value)=>
    value.trim().isEmpty ? 'Tidak boleh kosong' : null;
}
