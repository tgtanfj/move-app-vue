const endpointAuth = {
  SIGN_IN: `/auth/login/`,
  GET_INFO: `/user/profile`
};

const endpointUser = {
  GET_ALL: `/admin/users`
};

const endpointVideo = {
  GET_ALL: `/admin/videos`
};

const endpointPayment = {
  GET_PAYMENT_HISTORIES: `/admin/payment-histories`,
  GET_WITHDRAW_HISTORIES: `/admin/cashout-histories`,
  GET_REVENUE_DATA: `/admin/revenue`
};

const endpointFAQs = {
  CREATE: `/faqs/`,
  READ: `/faqs/`,
  READ_BY_ID: `/faqs/:id`,
  UPDATE: `/faqs/`,
  DELETE: `/faqs/`
};

const endpointOther = {};

export {
  endpointAuth,
  endpointFAQs,
  endpointPayment,
  endpointUser,
  endpointVideo
};
