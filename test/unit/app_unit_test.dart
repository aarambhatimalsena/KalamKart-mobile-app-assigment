import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartz/dartz.dart';

import 'package:kalamkart_mobileapp/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/use_case/use_register_usecase.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/entity/user_entity.dart';
import 'package:kalamkart_mobileapp/features/auth/domain/repository/user_repository.dart';
import 'package:kalamkart_mobileapp/app/shared_pref/token_shared_prefs.dart';
import 'package:kalamkart_mobileapp/core/error/failure.dart';

/// Mocks
class MockUserRepository extends Mock implements IUserRepository {}

class MockSharedPrefs extends Mock implements SharedPreferences {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MockUserRepository userRepo;
  late UserLoginUseCase loginUseCase;
  late UserRegisterUseCase registerUseCase;

  final testUser = UserEntity(
    id: '1',
    username: 'Sangit Pokhrel',
    email: 'sangit@email.com',
    password: '123456',
    role: '9812345678',
    profileImage: 'Kathmandu',
    token: 'user_token_123',
  );

  setUpAll(() {
    userRepo = MockUserRepository();
    loginUseCase = UserLoginUseCase(userRepo);
    registerUseCase = UserRegisterUseCase(userRepo);
  });

  group('LoginUseCase', () {
    test('returns UserEntity on success', () async {
      when(() => userRepo.login(testUser.email, testUser.password!))
          .thenAnswer((_) async => testUser);

      final result = await loginUseCase(testUser.email!, testUser.password!);


      expect(result, isA<UserEntity>());
      expect(result.username, 'Sangit Pokhrel');
      verify(() => userRepo.login(testUser.email, testUser.password!)).called(1);
    });

    test('throws on login failure', () async {
      when(() => userRepo.login(testUser.email, testUser.password!))
          .thenThrow(Exception('Invalid credentials'));

      expect(() => loginUseCase(testUser.email, testUser.password!), throwsA(isA<Exception>()));
    });
  });

  group('RegisterUseCase', () {
    test('returns UserEntity on success', () async {
      when(() => userRepo.register(testUser.username, testUser.email, testUser.password!))
          .thenAnswer((_) async => testUser);

      final result = await registerUseCase(testUser.username, testUser.email, testUser.password!);

      expect(result.email, testUser.email);
      expect(result.username, 'Sangit Pokhrel');
      verify(() => userRepo.register(testUser.username, testUser.email, testUser.password!)).called(1);
    });

    test('throws on register failure', () async {
      when(() => userRepo.register(testUser.username, testUser.email, testUser.password!))
          .thenThrow(Exception('Email already exists'));

      expect(() => registerUseCase(testUser.username, testUser.email, testUser.password!), throwsA(isA<Exception>()));
    });
  });

  group('TokenSharedPrefs', () {
    late MockSharedPrefs mockPrefs;
    late TokenSharedPrefs tokenPrefs;

    setUp(() {
      mockPrefs = MockSharedPrefs();
      tokenPrefs = TokenSharedPrefs(sharedPreferences: mockPrefs);
    });

    test('saves token successfully', () async {
      when(() => mockPrefs.setString('token', 'abcd1234')).thenAnswer((_) async => true);

      final result = await tokenPrefs.saveToken('abcd1234');

      expect(result.isRight(), true);
    });

    test('fails to save token', () async {
      when(() => mockPrefs.setString('token', any())).thenThrow(Exception('write failed'));

      final result = await tokenPrefs.saveToken('fail-token');

      expect(result.isLeft(), true);
    });

    test('retrieves token successfully', () async {
      when(() => mockPrefs.getString('token')).thenReturn('xyz987');

      final result = await tokenPrefs.getToken();

      expect(result, Right('xyz987'));
    });

    test('fails to retrieve token', () async {
      when(() => mockPrefs.getString('token')).thenThrow(Exception('read failed'));

      final result = await tokenPrefs.getToken();

      expect(result.isLeft(), true);
    });

    test('save and then get token returns same value', () async {
  when(() => mockPrefs.setString('token', 'myToken')).thenAnswer((_) async => true);
  when(() => mockPrefs.getString('token')).thenReturn('myToken');

  final saveResult = await tokenPrefs.saveToken('myToken');
  final getResult = await tokenPrefs.getToken();

  expect(saveResult.isRight(), true);
  expect(getResult, Right('myToken'));
});


test('throws error if registering with empty password', () async {
  when(() => userRepo.register(testUser.username, testUser.email, ''))
      .thenThrow(Exception('Password required'));

  expect(() => registerUseCase(testUser.username, testUser.email, ''), throwsA(isA<Exception>()));
});

  });



}
