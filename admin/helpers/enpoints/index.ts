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
  GET_WITHDRAW_HISTORIES: `/payment/admin/cashout-histories`,
  GET_REVENUE_DATA: `/admin/revenue`,
  GET_TOTAL_REVENUE: `/stripe/revenue`,
  GET_BALANCE: `/stripe/balance`,
  GET_TOTAL_WITHDRAW: `/payment/admin/total-withdraw`
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
