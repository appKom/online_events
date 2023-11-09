import 'package:online_events/components/online_scaffold.dart';

abstract class PageNavigator {
  /// Replace scaffold content with widget
  static void navigateTo(OnlinePage page) => OnlineScaffold.page.value = page;
}
