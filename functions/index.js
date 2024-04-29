

const functions = require('firebase-functions');
const axios = require('axios')


exports.getDataFromUrl = functions.https.onCall(async (data, context) => {
    const url = data.url;
    try {
        const info = await axios.get(url);
        return info.data;
    } catch (error) {
        return (error);
    }
});