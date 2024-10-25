const endpointAuth = {
  SIGN_IN: `/auth/login/`,
  GET_INFO: `/user/profile`
};

const endpointUser = {
  GET_ALL: `/user/admin`
};

const endpointVideo = {
  GET_ALL: `/video/admin`
};

const endpointPayment = {
  GET_PAYMENT_HISTORIES: `/payment/admin/payment-histories`,
  GET_WITHDRAW_HISTORIES: `/payment/admin/cashout-histories`
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
