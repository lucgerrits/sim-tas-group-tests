#include "../src/polkadot.h"
#include "helpers/cli.h"
#undef NDEBUG
#include <cassert>

class TestMessageHandler : public IMessageObserver {
public:
    bool done;

    virtual void handleMessage(const string &payload) {
        Json json;
        string err;
        json = Json::parse(payload, err);

        cout << endl << "JSON RPC Version: " << json["jsonrpc"].string_value() << endl;
        cout << "Request ID: " << json["id"].int_value() << endl;
        cout << "Spec Name: " << json["result"]["specName"].string_value() << endl;
        done = true;
    }
};

int main(int argc, char *argv[]) {
    TestMessageHandler tmh;
    EasyLogger log;

    string nodeUrl = getNodeUrlParam(argc, argv);

    IWebSocketClient *ws = CWebSocketClient::getInstance(&log);
    ws->registerMessageObserver(&tmh);
    tmh.done = false;
    int err = ws->connect(nodeUrl);
    if ((err == 0) && (ws->isConnected())) {
        std::string msg = "{\"id\":2,\"jsonrpc\":\"2.0\",\"method\":\"chain_getRuntimeVersion\",\"params\":[]}";
        ws->send(msg);
        while (!tmh.done)
            usleep(10000);
        ws->disconnect();
        cout << "success" << endl;
    } else {
        cout << "Connection error: " << err << endl;
    }

    delete ws;
    return 0;
}
