import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  RemoteConfig remoteConfig;

  Future<void> init() async {
    remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch();
    await remoteConfig.activateFetched();
  }
}

// Constants

//English

// HomeScreen
const String HOMESCREEN_SECTION_1_TITLE_EN = 'homescreen_section_1_title_en';
const String HOMESCREEN_SECTION_1_SUBTITLE_EN = 'homescreen_section_1_subtitle_en';

const String HOMESCREEN_SECTION_2_TITLE_EN = 'homescreen_section_2_title_en';
const String HOMESCREEN_SECTION_2_SUBTITLE_EN = 'homescreen_section_2_subtitle_en';

const String HOMESCREEN_SECTION_3_TITLE_EN = 'homescreen_section_3_title_en';
const String HOMESCREEN_SECTION_3_SUBTITLE_EN = 'homescreen_section_3_subtitle_en';

const String HOMESCREEN_SECTION_4_TITLE_EN = 'homescreen_section_4_title_en';
const String HOMESCREEN_SECTION_4_SUBTITLE_EN = 'homescreen_section_4_subtitle_en';

const String HOMESCREEN_SECTION_5_TITLE_EN = 'homescreen_section_5_title_en';
const String HOMESCREEN_SECTION_5_SUBTITLE_EN = 'homescreen_section_5_subtitle_en';

const String HOMESCREEN_SECTION_6_TITLE_EN = 'homescreen_section_6_title_en';
const String HOMESCREEN_SECTION_6_SUBTITLE_EN = 'homescreen_section_6_subtitle_en';

const String HOMESCREEN_SECTION_7_TITLE_EN = 'homescreen_section_7_title_en';
const String HOMESCREEN_SECTION_7_SUBTITLE_EN = 'homescreen_section_7_subtitle_en';

const String HOMESCREEN_SECTION_8_TITLE_EN = 'homescreen_section_8_title_en';
const String HOMESCREEN_SECTION_8_SUBTITLE_EN = 'homescreen_section_8_subtitle_en';

const String HOMESCREEN_SECTION_9_TITLE_EN = 'homescreen_section_9_title_en';
const String HOMESCREEN_SECTION_9_SUBTITLE_EN = 'homescreen_section_9_subtitle_en';

const String HOMESCREEN_SECTION_10_TITLE_EN = 'homescreen_section_10_title_en';
const String HOMESCREEN_SECTION_10_SUBTITLE_EN =
    'homescreen_section_10_subtitle_en';

const String HOMESCREEN_SECTION_11_TITLE_EN = 'homescreen_section_11_title_en';
const String HOMESCREEN_SECTION_11_SUBTITLE_EN =
    'homescreen_section_11_subtitle_en';

//Dzor HomePage Appbar text
const String HOMESCREEN_APPBAR_TEXT = "homescreen_appbar_text";
