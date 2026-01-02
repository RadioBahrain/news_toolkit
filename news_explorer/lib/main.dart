import 'package:ads_consent_client/ads_consent_client.dart';
import 'package:analytics_repository/analytics_repository.dart';
import 'package:article_repository/article_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:user_repository/user_repository.dart';

// Mock implementations for development
class MockUserRepository extends Mock implements UserRepository {
  @override
  Stream<Uri> get incomingEmailLinks => const Stream.empty();

  @override
  Stream<User> get user => Stream.value(User.anonymous);

  @override
  Future<int> fetchAppOpenedCount() async => 0;

  @override
  Future<void> incrementAppOpenedCount() async {}
}

class MockNewsRepository extends Mock implements NewsRepository {
  Future<List<Category>> fetchCategories() async => const [
        Category(id: 'sports', name: 'Sports'),
        Category(id: 'health', name: 'Health'),
        Category(id: 'technology', name: 'Technology'),
        Category(id: 'science', name: 'Science'),
      ];
}

class MockNotificationsRepository extends Mock implements NotificationsRepository {}

class MockArticleRepository extends Mock implements ArticleRepository {
  @override
  Future<ArticleViews> fetchArticleViews() async => ArticleViews(0, null);

  @override
  Future<void> incrementArticleViews() async {}

  @override
  Future<void> resetArticleViews() async {}
}

class MockInAppPurchaseRepository extends Mock implements InAppPurchaseRepository {}

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {
  @override
  Future<void> setUserId(String? userId) async {}
  
  Future<void> trackEvent(String name, {Map<String, dynamic>? properties}) async {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );

  // Initialize mock repositories
  final userRepository = MockUserRepository();
  final newsRepository = MockNewsRepository();
  final notificationsRepository = MockNotificationsRepository();
  final articleRepository = MockArticleRepository();
  final inAppPurchaseRepository = MockInAppPurchaseRepository();
  final analyticsRepository = MockAnalyticsRepository();
  final adsConsentClient = AdsConsentClient();
  
  const user = User.anonymous;

  runApp(
    App(
      userRepository: userRepository,
      newsRepository: newsRepository,
      notificationsRepository: notificationsRepository,
      articleRepository: articleRepository,
      inAppPurchaseRepository: inAppPurchaseRepository,
      analyticsRepository: analyticsRepository,
      adsConsentClient: adsConsentClient,
      user: user,
    ),
  );
}
