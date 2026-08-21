import 'package:auth_katalog_app/core/network/errors/failure.dart';
import 'package:auth_katalog_app/features/auth/application/auth_controller.dart';
import 'package:auth_katalog_app/features/auth/application/auth_state.dart';
import 'package:auth_katalog_app/features/auth/auth_provider.dart';
import 'package:auth_katalog_app/features/auth/domain/entities/user.dart';
import 'package:auth_katalog_app/features/auth/domain/params/login_params.dart';
import 'package:auth_katalog_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(
      const LoginParams(username: 'test', password: 'password'),
    );
  });

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  final dummyUser = User.skeleton().copyWith(id: 1, username: 'emilys');

  group('AuthController', () {
    test('initial state is AuthState.initial()', () {
      final container = makeProviderContainer();
      final state = container.read(authControllerProvider);
      expect(state, equals(const AuthState.initial()));
    });

    test('login updates state to success on repository success', () async {
      const params = LoginParams(username: 'emilys', password: 'password');
      when(() => mockRepository.login(params))
          .thenAnswer((_) async => (null, dummyUser));

      final container = makeProviderContainer();
      final controller = container.read(authControllerProvider.notifier);

      await controller.login(params);

      final state = container.read(authControllerProvider);
      expect(state, equals(AuthState.success(dummyUser)));
      verify(() => mockRepository.login(params)).called(1);
    });

    test('login updates state to failure on repository failure', () async {
      const params = LoginParams(username: 'emilys', password: 'password');
      when(() => mockRepository.login(params)).thenAnswer(
        (_) async => (const ServerFailure('Invalid password'), null),
      );

      final container = makeProviderContainer();
      final controller = container.read(authControllerProvider.notifier);

      await controller.login(params);

      final state = container.read(authControllerProvider);
      expect(state, equals(const AuthState.failure('Invalid password')));
      verify(() => mockRepository.login(params)).called(1);
    });

    test('checkAuth updates state to success on repository success', () async {
      when(() => mockRepository.checkAuth())
          .thenAnswer((_) async => (null, dummyUser));

      final container = makeProviderContainer();
      final controller = container.read(authControllerProvider.notifier);

      await controller.checkAuth();

      final state = container.read(authControllerProvider);
      expect(state, equals(AuthState.success(dummyUser)));
      verify(() => mockRepository.checkAuth()).called(1);
    });

    test('logout clears user state', () async {
      when(() => mockRepository.logout())
          .thenAnswer((_) async => (null, null));

      final container = makeProviderContainer();
      final controller = container.read(authControllerProvider.notifier);

      await controller.logout();

      final state = container.read(authControllerProvider);
      expect(state, equals(const AuthState.success(null)));
      verify(() => mockRepository.logout()).called(1);
    });
  });
}
