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

const endpointFAQs = {
  CREATE: `/faqs/`,
  READ: `/faqs/`,
  READ_BY_ID: `/faqs/:id`,
  UPDATE: `/faqs/`,
  DELETE: `/faqs/`
};

const endpointOther = {};

export { endpointAuth, endpointFAQs, endpointUser, endpointVideo };
