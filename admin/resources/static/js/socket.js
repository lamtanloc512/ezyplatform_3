/*!
 * Copyright 2022 youngmonkeys.org
 *
 * Licensed under the ezyplatform, Version 1.0.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://youngmonkeys.org/licenses/ezyplatform-1.0.0.txt
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/

EzyLogger.debug = ezyadmin.debugEnabled;

ezyadmin.socket = {
    zoneName: "admin",
    pluginByName: {}
};

ezyadmin.socket.getPlugin = function(name) {
    return ezyadmin.socket.pluginByName[name];
}

ezyadmin.socket.connectionFailedCallbacks = [];
ezyadmin.socket.onConnectionFailed = function(callback) {
    ezyadmin.socket.connectionFailedCallbacks.push(callback);
}

ezyadmin.socket.emitConnectionFailed = function() {
    ezyadmin.socket.connectionFailedCallbacks.forEach(e => e());
}

ezyadmin.socket.disconnectedCallbacks = [];
ezyadmin.socket.onDisconnected = function(callback) {
    ezyadmin.socket.disconnectedCallbacks.push(callback);
}

ezyadmin.socket.emitDisconnected = function() {
    ezyadmin.socket.disconnectedCallbacks.forEach(e => e());
}

ezyadmin.socket.authenticatedCallbacks = [];
ezyadmin.socket.onAuthenticated = function(callback) {
    ezyadmin.socket.authenticatedCallbacks.push(callback);
}

ezyadmin.socket.emitAuthenticated = function() {
    ezyadmin.socket.authenticatedCallbacks.forEach(e => e());
}

ezyadmin.socket.connectionFailureHandler = new EzyConnectionFailureHandler();
ezyadmin.socket.connectionFailureHandler.postHandle = function(event) {
    ezyadmin.socket.emitConnectionFailed();
}

ezyadmin.socket.disconnectionHandler = new EzyDisconnectionHandler();
ezyadmin.socket.disconnectionHandler.preHandle = function(event) {
    ezyadmin.socket.emitDisconnected();
}

ezyadmin.socket.handshakeHandler = new EzyHandshakeHandler();
ezyadmin.socket.handshakeHandler.getLoginRequest = function(context) {
    return [
        ezyadmin.socket.zoneName,
        "ezyplatform",
        "welcome",
        {"adminAccessToken" : ezyadmin.getCookieSocketAccessToken()}
    ];
}

ezyadmin.socket.userLoginHandler = new EzyLoginSuccessHandler();
ezyadmin.socket.userLoginHandler.handleLoginSuccess = function() {
    ezyadmin.socket.emitAuthenticated();
    this.client.send(EzyCommand.APP_ACCESS, ['notification-message']);
}

ezyadmin.socket.pluginInfoHandler = new EzyPluginInfoHandler();
ezyadmin.socket.pluginInfoHandler.postHandle = function (plugin, data) {
    var pluginSetup = ezyadmin.socket.pluginByName[data[1]];
    plugin.on = pluginSetup.on;
    plugin.accessedCallback = pluginSetup.accessedCallback;
    ezyadmin.socket.pluginByName[data[1]] = plugin;
    plugin.accessedCallback();
}

ezyadmin.socket.config = new EzyClientConfig;
ezyadmin.socket.config.zoneName = ezyadmin.socket.zoneName;
ezyadmin.socket.config.reconnect.maxReconnectCount = 32768;

ezyadmin.socketClients = EzyClients.getInstance();
ezyadmin.socket.client = ezyadmin.socketClients.newDefaultClient(
    ezyadmin.socket.config
);
ezyadmin.socket.setup = ezyadmin.socket.client.setup;
ezyadmin.socket.setup.addEventHandler(
    EzyEventType.CONNECTION_FAILURE,
    ezyadmin.socket.connectionFailureHandler
);
ezyadmin.socket.setup.addEventHandler(
    EzyEventType.DISCONNECTION,
    ezyadmin.socket.disconnectionHandler
);
ezyadmin.socket.setup.addDataHandler(
    EzyCommand.HANDSHAKE,
    ezyadmin.socket.handshakeHandler
);
ezyadmin.socket.setup.addDataHandler(
    EzyCommand.LOGIN,
    ezyadmin.socket.userLoginHandler
);
ezyadmin.socket.setup.addDataHandler(
    EzyCommand.PLUGIN_INFO,
    ezyadmin.socket.pluginInfoHandler
);
ezyadmin.socket.setup.setupApp('notification-message')
    .addDataHandler('message', function(app, message) {
        if (ezyadmin.onNewNotificationMessage) {
            ezyadmin.onNewNotificationMessage(message);
        }
    });

ezyadmin.socket.setupPlugin = function(pluginName) {
    var setupHolder = ezyadmin.socket.setup.setupPlugin(pluginName);
    setupHolder.onAccessed = function(callback) {
        setupHolder.accessedCallback = callback;
    }
    setupHolder.on = function(cmd, callback) {
        setupHolder.addDataHandler(cmd, function(plugin, data) {
            callback(data);
        });
    }
    setupHolder.send = function(cmd, data) {
        var plugin = ezyadmin.socket.pluginByName[pluginName];
        if (plugin) {
            plugin.send(cmd, data);
        }
    }
    ezyadmin.socket.pluginByName[pluginName] = setupHolder;
    return setupHolder;
}

ezyadmin.socket.accessPlugin = function(pluginName) {
    var pluginInfoRequest = [pluginName];
    ezyadmin.socket.client.sendRequest(EzyCommand.PLUGIN_INFO, pluginInfoRequest);
}

ezyadmin.socket.connect = function() {
    if (!ezyadmin.socket.connecting) {
        ezyadmin.socket.connecting = true;
        ezyadmin.socket.client.connect(ezyadmin.currentWebsocketUrl);
    }
}

ezyadmin.socket.disconnect = function() {
    ezyadmin.socket.client.disconnect();
    ezyadmin.socket.connecting = false;
}
