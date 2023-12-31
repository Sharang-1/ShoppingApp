import 'translation_keys.dart';
import 'en_us.dart';

// Hindi Translations
Map<String, String> hiIN = {
  //HomeScreen
  HOMESCREEN_LOCATION: enUS[HOMESCREEN_LOCATION]!,
  HOMESCREEN_SEARCH_DESIGNERS: "डिज़ाइनर्स सर्च करे",

  //Bottom NavBar
  NAVBAR_CATEGORIES: "कैटेगरिस",
  NAVBAR_ORDERS: "ऑर्डर्स",
  NAVBAR_APPOINTMENTS: "अपॉइंटमेंट्स",
  NAVBAR_MAPS: "मैप्स",
  NAVBAR_PROFILE: "प्रोफ़ाइल",
  NAVBAR_WISHLIST: "इच्छा-सूची",

  // LoginScreen
  LOGIN_PHONE_NO_VALIDATION_MSG: "कृप्या १० अंक का योग्य फ़ोन नंबर डाले",
  LOGIN_NAME_VALIDATION_MSG: "कृप्या योग्य नाम डाले",
  LOGIN_OTP_VALIDATION_MSG: "कृप्या ४ अंक का OTP डाले",
  LOGIN_INVALID_DETAILS_TITLE: 'अयोग्य माहिती',
  LOGIN_INVALID_DETAILS_DESCRIPTION: 'योग्य नाम और मोबाइल नंबर डाले!!!',
  LOGIN_INVALID_OTP_TITLE: 'अयोग्य OTP',
  LOGIN_INVALID_OTP_DESCRIPTION: 'योग्य OTP डाले!!!',
  LOGIN_INCORRECT_OTP_TITLE: 'गलत OTP',
  LOGIN_INCORRECT_OTP_DESCRIPTION: 'आपने गलत OTP डाला है, फिर से प्रयास करे।',

  // Product Screen
  PRODUCTS: "प्रोडक्ट्स",
  PRODUCTSCREEN_TAXES_AND_CHARGES: enUS[PRODUCTSCREEN_TAXES_AND_CHARGES]!,
  PRODUCTSCREEN_IN_STOCK: enUS[PRODUCTSCREEN_IN_STOCK]!,
  PRODUCTSCREEN_SOLD_OUT: enUS[PRODUCTSCREEN_SOLD_OUT]!,
  PRODUCTSCREEN_ASSURED: enUS[PRODUCTSCREEN_ASSURED]!,
  PRODUCTSCREEN_COD: enUS[PRODUCTSCREEN_COD]!,
  PRODUCTSCREEN_RETURNS: enUS[PRODUCTSCREEN_RETURNS]!,
  PRODUCTSCREEN_JUST_HERE: enUS[PRODUCTSCREEN_JUST_HERE]!,
  PRODUCTSCREEN_UNSTITCHED: enUS[PRODUCTSCREEN_UNSTITCHED]!,
  PRODUCTSCREEN_HANDCRAFTED: enUS[PRODUCTSCREEN_HANDCRAFTED]!,
  PRODUCTSCREEN_ONE_IN_MARKET: enUS[PRODUCTSCREEN_ONE_IN_MARKET]!,
  PRODUCTSCREEN_AVAILABLE_COUPONS: "अवेलेबल कूपन्स",
  PRODUCTSCREEN_SELECT_SIZE: "साइज सिलेक्ट करे",
  PRODUCTSCREEN_SIZE_CHART: "साइज चार्ट",
  PRODUCTSCREEN_SELECT_COLOR: "कलर सिलेक्ट करे",
  PRODUCTSCREEN_DELIVERY_BY: enUS[PRODUCTSCREEN_DELIVERY_BY]!,
  PRODUCTSCREEN_KNOW_YOUR_DESIGNER: "डिज़ाइनर को जाने",
  PRODUCTSCREEN_ITEM_DETAILS: "डिस्क्रिप्शन",
  PRODUCTSCREEN_RECOMMENDED_PRODUCTS: "रेकमेंडेड प्रोडक्ट्स",
  PRODUCTSCREEN_MORE_FROM_DESIGNER: "इसी डिज़ाइनर के प्रोडक्ट्स",
  PRODUCTSCREEN_SELECT_SIZE_COLOR_QTY:
      "कृप्या साइज कलर और क्वान्टिटी सिलेक्ट करे ",
  PRODUCTSCREEN_SELECTION_GUIDE:
      "*कृप्या साइज चार्ट को देखकर साइज कलर और क्वान्टिटी सिलेक्ट करे।",
  PRODUCTSCREEN_BUY_NOW: "अभी खरीदो",
  PRODUCTSCREEN_ADD_TO_BAG: "बैग में डाले",
  PRODUCTSCREEN_VIEW_BAG: "बैग देखे",
  PRODUCTSCREEN_VIEW_REVIEWS: "रेटिंग्स और रिव्युस",
  PRODUCTSCREEN_ADDED_TO_BAG_TITLE: "बैग में दाल दिया",
  PRODUCTSCREEN_ADDED_TO_BAG_DESCRIPTION:
      "प्रोडक्ट को आपके बैग में दाल दिया गया है।",
  PRODUCTSCREEN_ADD_TO_WISHLIST: 'विशलिस्ट में डाले',
  PRODUCTSCREEN_ADDED_TO_WISHLIST:
      'प्रोडक्ट को आपकी विशलिस्ट में दाल दिया गया है',
  NO_REVIEWS: "कोई रिव्यू नहीं है",
  WRITE_REVIEW: "रिव्यू दीजिये",
  VIEW_ALL: enUS[VIEW_ALL]!,
  NO_DESCRIPTION: enUS[NO_DESCRIPTION]!,
  UNKNOWN_USER: enUS[UNKNOWN_USER]!,
  REVIEWS: "रिव्युस",
  SERVICE_NOT_AVAILABLE_TITLE: "सर्विस अवेलेबल नहीं है",
  SERVICE_NOT_AVAILABLE_DESCRIPTION:
      "आपकी लोकेशन पर हम अभी तक सर्विस नहीं देते।",

  //DesignerScreen
  DESIGNERS: "डिज़ाइनर्स",
  DESIGNER_SCREEN_SPECIALITY: enUS[DESIGNER_SCREEN_SPECIALITY]!,
  DESIGNER_SCREEN_DESIGNES_CREATES: enUS[DESIGNER_SCREEN_DESIGNES_CREATES]!,
  DESIGNER_SCREEN_SERVICES_OFFERED: enUS[DESIGNER_SCREEN_SERVICES_OFFERED]!,
  DESIGNER_SCREEN_WORK_OFFERED: enUS[DESIGNER_SCREEN_WORK_OFFERED]!,
  DESIGNER_SCREEN_TYPE: enUS[DESIGNER_SCREEN_TYPE]!,
  DESIGNER_DETAILS: "डिज़ाइनर की डिटेल्स",
  DESIGNER_DETAILS_KEY: "key",
  DESIGNER_DETAILS_NAME: "name",
  DESIGNER_DETAILS_TYPE: "type",
  DESIGNER_DETAILS_RATTINGS: "रेटिंग्स",
  DESIGNER_DETAILS_LAT: "lat",
  DESIGNER_DETAILS_LON: "lon",
  DESIGNER_DETAILS_APPOINTMENT: "अपॉइंटमेंट",
  DESIGNER_DETAILS_ADDRESS: "एड्रेस",
  DESIGNER_DETAILS_CITY: "शहर",
  DESIGNER_DETAILS_NOTE_FROM_DESIGNER: "Note from Seller",
  DESIGNER_DETAILS_OWNER_NAME: "मालिक का नाम",
  DESIGNER_DETAILS_BOOK_APPOINTMENT: "अपॉइंटमेंट बुक करे",
  DESIGNER_DETAILS_APPOINTMENT_BOOKED: "अपॉइंटमेंट बुक हो गई ह।",
  DESIGNER_EXPLORE_COLLECTION: "कलेक्शन देखे",
  DESIGNER_OPEN_NOW: "ओपन है",
  DESIGNER_CLOSED_NOW: "बंध है",
  DESIGNER_SCREEN_KNOW_THE_DESIGNER: "सृष्टिकर्ता को जानो",
  DESIGNER_SCREEN_LOCATION: "लोकेशन",
  DESIGNER_SCREEN_DIRECTION: "डिरेक्शंस",
  DESIGNER_SCREEN_EXPLORE_DESIGNER_COLLECTION: "संग्रह का अन्वेषण करें",
  DESIGNER_SCREEN_SIMILAR_DESIGNERS: 'सिमिलर डिज़ाइनर्स',
  DESIGNER_SCREEN_REVIEWS: 'रेटिंग्स और रिव्युस',
  RECOMMENDED_DESIGNERS: "रेकमेंडेड डिज़ाइनर्स",
  ORDER_DETAILS: "आर्डर  डिटेल्स",

  //Settings Screen
  SETTINGS_APPBAR_TITLE: "सेटिंग्स",
  SETTINGS_MY_CITY: "मेरा शहर",
  SETTINGS_MY_ORDER: "मेरे ऑर्डर्स",
  SETTINGS_MY_WISHLIST: "मेरी इच्छा सूची",
  SETTINGS_MY_APPOINTMENT: "मेरे अपॉइंटमेंट्स",
  SETTINGS_CONNECT_WITH_US: "हमसे जुड़े",
  SETTINGS_SEND_FEEDBACK: "फीडबैक भेजे",
  SETTINGS_CUSTOMER_SUPPORT: "कस्टमर सपोर्ट",
  SETTINGS_SHARE_WITH_FRIENDS: "दोस्तों को भेजे",
  SETTINGS_LEAVE_REVIEW: "रिव्यु करे",
  SETTINGS_RATE_APP: "रेट करे",
  SETTINGS_ABOUT_US: "हमें जाने",
  SETTINGS_TERMS_AND_CONDITIONS: "नियम और शर्ते",
  SETTINGS_ABOUT_host: "डज़ोर को जाने",
  SETTINGS_LOG_IN: "लोग इन",
  SETTINGS_LOG_OUT: "लोग आउट",
  SETTINGS_PROFILE: "प्रोफाइल",
  SETTINGS_PROFILE_ALERT: "क्या आप सच में सेव नहीं करना चाहते ?",
  SETTINGS_PERSONAL_DETAILS: "पर्सनल डिटेल्स",
  SETTINGS_EDIT: "एडिट",
  SETTINGS_NAME: "नाम",
  SETTINGS_ADD_YOUR_NAME: "नाम ऐड करे",
  SETTINGS_MOBILE: "मोबाइल नंबर",
  SETTINGS_AGE: "उम्र",
  SETTINGS_GENDER: "लिंग",
  SETTINGS_ADDRESS: "एड्रेस",
  SETTINGS_CHANGE: "बदले",
  MY_MEASUREMENTS: "मेरी मेज़रमेंट्स",
  ENTER_VALID_SIZE: "कृपया योग्य साइज डाले",

  // Bottomsheet
  ADD_ADDRESS: "एड्रेस डाले",
  ENTER_PROPER_ADDRESS: "कृप्या योग्य एड्रेस डाले",
  YOUR_LOCATION: 'मेरी लोकेशन',
  CHANGE: "बदले",
  HOUSE_NAME_LABEL: 'घर का नाम, नंबर ....',
  LANDMARK_LABEL: 'लैंडमार्क, सोसाइटी का नाम ....',
  SAVE_AND_PROCEED: "सेव करे",

  // DIALOGS
  CART_ALERT_DIALOG_TITLE: enUS[CART_ALERT_DIALOG_TITLE]!,
  CART_ALERT_DIALOG_DESCRIPTION: enUS[CART_ALERT_DIALOG_DESCRIPTION]!,

  PAYMENT: " पेमेंट",
  PROCEED_TO_PAY: "पेमेंट करे",
  PROCEED_TO_ORDER: "आर्डर करे",
  PLACE_ORDER: "आर्डर करे",
  VIEW_DETAILS: "डिटेल्स देखे",
  MAKE_PAYMENT: "पेमेंट करे",
  MY_ADDRESSES: "मेरे एड्रेसीस",
  MY_ADDRESS: "मेरा एड्रेस: ",
  SELECT_ADDRESS: "एड्रेस सिलेक्ट करे",
  APPLY_COUPON: "कूपन अप्लाई करे",
  SELECT_COUPON: "कूपन सिलेक्ट करे",
  ENTER_COUPON: 'कूपन कोड डाले',
  COUPONS_FOR_YOU: "आपके कूपन्स !",
  COUPON_APPLIED: "कूपन अप्लाई हो गया है!",
  INVALID_COUPON: "अयोग्य कूपन",
  BAG: "बैग",
  MY_BAG: "मेरा बैग",
  ADD_MEASUREMENTS: "मेज़रमेंट्स डाले",
  ITEMS_IN_BAG: "बैग में प्रोडक्ट्स",
  MEASUREMENT_GUIDE: "मेज़रमेंट्स गाइड",
  MY_APPOINTMENTS: "मेरे अपॉइंटमेंट्स",
  CANCEL_APPOINTMENT: 'अपॉइंटमेंट केंसल करे',
  CANCELLATION_REASON: 'केंसल करने का कारन ?',
  WISHLIST: "विशलिस्ट",
  SHOP_NOW: "अभी खरीदो!",
  PAIR_IT_WITH: "साथ में खरीदो",

  USEFUL_LINKS: "उपयोगी लिंक्स!",
  RETURN_POLICY: "रिटर्न पोलिसी",
  EMAIL_US: "ईमेल करे!",
  CALL_US: "कॉल करे!",
  CHAT_WITH_US: "हमारे साथ बात करे",

  YES: "हां",
  NO: "ना",
  SAVE: "सेव",
  OK: "ओके",
  CANCEL: "केंसल",
  APPLY: "अप्लाई",
  SUBMIT: "सबमिट",
};
