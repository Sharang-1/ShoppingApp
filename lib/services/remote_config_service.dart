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

//product section 
const String HOMESCREEN_PRODUCT_SECTION_1_TITLE_EN = 'homescreen_product_section_1_title_en';
const String HOMESCREEN_PRODUCT_SECTION_1_SUBTITLE_EN = 'homescreen_product_section_1_subtitle_en';

const String HOMESCREEN_PRODUCT_SECTION_2_TITLE_EN = 'homescreen_product_section_2_title_en';
const String HOMESCREEN_PRODUCT_SECTION_2_SUBTITLE_EN = 'homescreen_product_section_2_subtitle_en';

const String HOMESCREEN_PRODUCT_SECTION_3_TITLE_EN = 'homescreen_product_section_3_title_en';
const String HOMESCREEN_PRODUCT_SECTION_3_SUBTITLE_EN = 'homescreen_product_section_3_subtitle_en';

const String HOMESCREEN_PRODUCT_SECTION_4_TITLE_EN = 'homescreen_product_section_4_title_en';
const String HOMESCREEN_PRODUCT_SECTION_4_SUBTITLE_EN = 'homescreen_product_section_4_subtitle_en';

const String HOMESCREEN_PRODUCT_SECTION_5_TITLE_EN = 'homescreen_product_section_5_title_en';
const String HOMESCREEN_PRODUCT_SECTION_5_SUBTITLE_EN = 'homescreen_product_section_5_subtitle_en';

const String HOMESCREEN_PRODUCT_SECTION_6_TITLE_EN = 'homescreen_product_section_6_title_en';
const String HOMESCREEN_PRODUCT_SECTION_6_SUBTITLE_EN = 'homescreen_product_section_6_subtitle_en';

const String HOMESCREEN_PRODUCT_SECTION_7_TITLE_EN = 'homescreen_product_section_7_title_en';
const String HOMESCREEN_PRODUCT_SECTION_7_SUBTITLE_EN = 'homescreen_product_section_7_subtitle_en';

const String HOMESCREEN_PRODUCT_SECTION_8_TITLE_EN = 'homescreen_product_section_8_title_en';
const String HOMESCREEN_PRODUCT_SECTION_8_SUBTITLE_EN = 'homescreen_product_section_8_subtitle_en';

//designer section 
const String HOMESCREEN_DESIGNER_SECTION_1_TITLE_EN = 'homescreen_designer_section_1_title_en';
const String HOMESCREEN_DESIGNER_SECTION_1_SUBTITLE_EN = 'homescreen_designer_section_1_subtitle_en';

const String HOMESCREEN_DESIGNER_SECTION_2_TITLE_EN = 'homescreen_designer_section_2_title_en';
const String HOMESCREEN_DESIGNER_SECTION_2_SUBTITLE_EN = 'homescreen_designer_section_2_subtitle_en';

const String HOMESCREEN_DESIGNER_SECTION_3_TITLE_EN = 'homescreen_designer_section_3_title_en';
const String HOMESCREEN_DESIGNER_SECTION_3_SUBTITLE_EN = 'homescreen_designer_section_3_subtitle_en';

const String HOMESCREEN_DESIGNER_SECTION_4_TITLE_EN = 'homescreen_designer_section_4_title_en';
const String HOMESCREEN_DESIGNER_SECTION_4_SUBTITLE_EN = 'homescreen_designer_section_4_subtitle_en';

//category section 1
const String HOMESCREEN_CATEGORY_SECTION_1_TITLE_EN = 'homescreen_category_section_1_title_en';
const String HOMESCREEN_CATEGORY_SECTION_1_SUBTITLE_EN = 'homescreen_category_section_1_subtitle_en';

//Dzor Explore 
const String DZOR_EXPLORE_TAG_1_EN = "dzor_explore_tag_1_en";
const String DZOR_EXPLORE_TAG_2_EN = "dzor_explore_tag_2_en";

//Dzor HomePage Appbar text
const String HOMESCREEN_APPBAR_TEXT = "homescreen_appbar_text";