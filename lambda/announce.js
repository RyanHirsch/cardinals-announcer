const axios = require('axios');

function lambdaHandler(event, context, callback) {
  return axios.get('http://faker.hook.io')
    .then(({ data }) => {
      console.log(data);
      callback(null);
    });
}

exports.handler = lambdaHandler;
