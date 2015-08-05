var getWifiInfo = function(win, fail) {
    if (typeof win != 'function') {
        console.log('getWifiInfo first parameter must be a function to handle wifi info');
        return;
    }
    cordova.exec(win, fail, 'WifiInfo', 'getWifiInfo', []);
};

module.exports = {getWifiInfo: getWifiInfo};
