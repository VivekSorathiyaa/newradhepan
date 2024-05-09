import 'package:get/get.dart';
import 'package:radhe/app/app.dart';

class TutorialController {
  // video feed screen
  static String keyVirtualTourStart = 'keyVirtualTourStart';
  static String keyVideoFeedTab = 'keyVideoFeedTab';
  static String keyObsFeedTab = 'keyObsFeedTab';

  //obs feed screen
  static String keyMainFabButton = 'keyMainFabButton';
  static String keyCommunityFabButton = 'keyCommunityFabButton';
  static String keyObsSearchFabButton = 'keyObsSearchFabButton';
  static String keyPostObsFabButton = 'keyPostObsFabButton';

  //obs map screen
  static String keyMapCommunityFabButton = 'keyMapCommunityFabButton';
  static String keyMapPostCommunityFabButton = 'keyMapPostCommunityFabButton';
  static String keyMapFilterObsFabButton = 'keyMapFilterObsFabButton';
  static String keyMapFilterCommunityFabButton =
      'keyMapFilterCommunityFabButton';

// post obs feed screen
  static String keyPostObsFeedButton = 'keyPostObsFeedButton';
  static String keyPostCommunityFeedButton = 'keyPostCommunityFeedButton';

  // community feed screen
  static String keyComFeedStatisticsFabButton = 'keyComFeedStatisticsFabButton';
  static String keyComFeedInviteFabButton = 'keyComFeedInviteFabButton';
  static String keyComFeedAddFeedObsFabButton = 'keyComFeedAddFeedObsFabButton';
  static String keyComFeedList = 'keyComFeedList';

  // gig screen
  static String keySearchGigButton = 'keySearchGigButton';
  static String keySearchLongTermGigButton = 'keySearchLongTermGigButton';

  // profile screen
  static String keyProfileVideoFeedTabButton = 'keyProfileVideoFeedTabButton';
  static String keyProfileJobStatButton = 'keyProfileJobStatButton';

  // job stat screen
  static String keyJobStatsButton = 'keyJobStatsButton';

  static bool getData(String key) {
    return dataStorage.read(key) ?? true;
  }

  static void setData(String key, bool value) {
    dataStorage.write(key, value);
  }

  static Future restartVirtualTour() async {
    setData(keyVirtualTourStart, true);
    setData(keyVideoFeedTab, true);
    setData(keyObsFeedTab, true);
    setData(keyMainFabButton, true);
    setData(keyCommunityFabButton, true);
    setData(keyObsSearchFabButton, true);
    setData(keyPostObsFabButton, true);
    setData(keyMapCommunityFabButton, true);
    setData(keyMapPostCommunityFabButton, true);
    setData(keyMapFilterObsFabButton, true);
    setData(keyMapFilterCommunityFabButton, true);
    setData(keyPostObsFeedButton, true);
    setData(keyPostCommunityFeedButton, true);
    setData(keyComFeedStatisticsFabButton, true);
    setData(keyComFeedInviteFabButton, true);
    setData(keyComFeedAddFeedObsFabButton, true);
    setData(keyComFeedList, true);
    setData(keySearchGigButton, true);
    setData(keySearchLongTermGigButton, true);
    setData(keyProfileVideoFeedTabButton, true);
    setData(keyProfileJobStatButton, true);
    setData(keyJobStatsButton, true);
  }
}
