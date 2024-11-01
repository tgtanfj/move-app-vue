class ApiUrls {
  static const String baseUrl = "https://api.training-move-intern.madlab.tech/";
  static const String signUpEndpoint = "auth/signup/email";
  static const String sendVerificationCodeEndpoint = "auth/send-otp";
  static const String endPointLogin = 'auth/login';
  static const String forgotPasswordEndpoint = 'auth/forgot-password';
  static const String resetPasswordEndpoint = 'auth/reset-password';
  static const String getUserProfileEndPoint = 'user/profile';
  static const String getCountryEndPoint = 'countries';
  static const String editUserProfileEndPoint = 'user/edit-profile';
  static const String endPointLogout = 'auth/log-out';
  static const String loginGoogle = 'auth/login/google';
  static const String loginFacebook = 'auth/login/facebook';
  static const String faqsEndPoint = 'faqs';
  static const String sharingVideoEndPoint = 'video/social-sharing/';
  static const String categoryEndpoint = 'category';
  static const String commentEndpoint = "comment";
  static const String commentReactionEndPoint = "comment-reaction";
  static const String rateVideo = 'watching-video-history/rate';
  static const String searchResultCategory = 'search/categories';
  static const String searchResultChannel = 'search/channels';
  static const String searchResultVideo = 'search/videos';
  static const String suggestionEndpoint = 'search/suggestion';
  static const String searchHistoryEndpoint = 'search/history';
  static const String homeTopCategoriesEndPoint = "home/top-categories";
  static const String homeVideosTrendEndPoint = "home/videos-trend";
  static const String homeVideosYouMayLikeEndPoint = "home/you-may-like";
  static const String homeVideosYouMayLikeNoLoginEndPoint =
      "home/you-may-like-no-login";
  static const String follow = "follow";
  static const String homeCategoriesEndPoint = "home/categories";
  static const String addPaymentEndpoint = "stripe/attach-card";
  static const String homeCategoriesNoLoginEndPoint =
      "home/categories-no-login/";
  static const String homeCategoriesLoginEndPoint = "home/categories/";
  static const String paymentHistory = "payment/history";
  static const String giftListPackageEndPoint = "donation/list-gift-packages";
  static const String donationEndPoint = "donation";
  static const String stripeListCardsEndPoint = "stripe/list-cards";
  static const String viewEndPoint = "view";
  static const String stripeDetachCardEndPoint = "stripe/detach-card";
  static const String refreshTokenEndpoint = "auth/refresh";
}
