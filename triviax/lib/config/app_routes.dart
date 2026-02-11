import 'package:get/get.dart';
import '../screens/home/home_screen.dart';
import '../screens/quiz/quiz_screen.dart';
import '../screens/admin/admin_screen.dart';
import '../screens/result/result_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String quiz = '/quiz';
  static const String admin = '/admin';
  static const String result = '/result';

  static List<GetPage> routes = [
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: quiz, page: () => const QuizScreen()),
    GetPage(name: admin, page: () => const AdminScreen()),
    GetPage(name: result, page: () => const ResultScreen()),
  ];
}
