import '../../features/authentication/domain/entities/app_user.dart';
import 'session_status.dart';

class SessionResult {
  final SessionStatus status;
  final AppUser? user;

  const SessionResult({
    required this.status,
    this.user,
  });
}