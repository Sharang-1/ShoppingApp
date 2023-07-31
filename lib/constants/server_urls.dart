// kReleaseMode

const bool releaseMode = true;

const String BASE_URL =
    releaseMode ? "https://www.host.in/api/" : "https://dev.host.in/api/";
const String PRODUCT_PHOTO_BASE_URL = "${BASE_URL}photos/products";
const String PROMOTION_PHOTO_BASE_URL = "${BASE_URL}photos/promotions";
const String CATEGORY_PHOTO_BASE_URL = "${BASE_URL}photos/categories";
const String SELLER_PHOTO_BASE_URL = "${BASE_URL}photos/sellers";
const String SELLER_PROFILE_PHOTO_BASE_URL = "${BASE_URL}photos/sellers";
const String USER_PROFILE_PHOTO_BASE_URL = "${BASE_URL}photos/users";
const String DESIGNER_PROFILE_PHOTO_BASE_URL = "${BASE_URL}photos/users";

const String APPOINTMENT_URL = releaseMode
    ? "https://appointment.host.in/api/appointments/"
    : "https://appointment.dev.host.in/api/appointments/";

const String RETURN_POLICY_URL = "https://host.in/main/return-policy.html";
const String CONTACT_US_URL = "https://host.in/main/contact-us.html";
const String TERMS_AND_CONDITIONS_URL =
    "https://host.in/main/terms-of-use.html";
const String PARTNER_WITH_US_URL = "https://host.in/#/contact-us";
const String SUPPORT_EMAIL = "support@host.in";
