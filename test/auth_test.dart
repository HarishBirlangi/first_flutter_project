import 'package:flutter_test/flutter_test.dart';
import 'package:homefinder/services/auth/auth_exceptions.dart';
import 'package:homefinder/services/auth/auth_provider.dart';
import 'package:homefinder/services/auth/auth_user.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('should not be intialized to begin with', () {
      expect(provider.isIntialized, false);
    });

    test('Can not logout if not intialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotIntializedException>()),
      );
    });

    test('Should be able to be intialized', () async {
      await provider.intialize();
      expect(provider.isIntialized, true);
    });

    test('User should be null after intializatiion', () {
      expect(provider.currentUser, null);
    });

    test(
      'should be able to intialize before 2 sec',
      () async {
        await provider.intialize();
        expect(provider.isIntialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('user should delegate to login function', () async {
      final badEmailUser =
          provider.createUser(email: 'foo@bar.com', password: 'anypassword');
      expect(
        badEmailUser,
        throwsA(const TypeMatcher<UserNotFoundExceptoin>()),
      );
      final badPasswordUser =
          provider.createUser(email: 'someone@bar.com', password: 'foobar');
      expect(
        badPasswordUser,
        throwsA(const TypeMatcher<WrongPassword>()),
      );
      final user = await provider.createUser(email: 'foo', password: 'bar');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged in user should be able get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('should be able to logout and login again', () async {
      provider.logOut();
      provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotIntializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isIntialized = false;
  bool get isIntialized => _isIntialized;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isIntialized) throw NotIntializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> intialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isIntialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isIntialized) throw NotIntializedException();
    if (email == 'foo@bar.com') throw UserNotFoundExceptoin();
    if (password == 'foobar') throw WrongPassword();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isIntialized) throw NotIntializedException();
    if (_user == null) throw UserNotFoundExceptoin();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isIntialized) throw NotIntializedException();
    final user = _user;
    if (user == null) throw UserNotFoundExceptoin();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
