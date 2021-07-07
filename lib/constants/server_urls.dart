import 'package:flutter/foundation.dart';

// const bool releaseMode = kReleaseMode || true;
const bool releaseMode = kReleaseMode && false;

const String BASE_URL =
    releaseMode ? "https://dzor.in/api/" : "https://dev.dzor.in/api/";
const String PRODUCT_PHOTO_BASE_URL = "${BASE_URL}photos/products";
const String PROMOTION_PHOTO_BASE_URL = "${BASE_URL}photos/promotions";
const String CATEGORY_PHOTO_BASE_URL = "${BASE_URL}photos/categories";
const String SELLER_PHOTO_BASE_URL = "${BASE_URL}photos/sellers";
const String SELLER_PROFILE_PHOTO_BASE_URL = "${BASE_URL}photos/sellers";
const String USER_PROFILE_PHOTO_BASE_URL = "${BASE_URL}photos/users";
const String DESIGNER_PROFILE_PHOTO_BASE_URL = "${BASE_URL}photos/users";

const String APPOINTMENT_URL = releaseMode
    ? "https://appointment.dzor.in/api/appointments/"
    : "https://appointment.dev.dzor.in/api/appointments/";

const String RETURN_POLICY_URL = "https://dzor.in/#/return-policy";
const String CONTACT_US_URL = "https://dzor.in/#/contact-us";
const String TERMS_AND_CONDITIONS_URL = "https://dzor.in/#/terms-of-use";
const String PARTNER_WITH_US_URL = "https://dzor.in/#/contact-us";
const String SUPPORT_EMAIL = "support@dzor.in";
