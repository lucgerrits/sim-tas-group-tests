#include <fstream>
#include <iomanip>
#include <iostream>
#include <stdio.h>
#include <streambuf>
#include <string.h>
#include <cassert>

#ifndef _WIN32
#include <unistd.h>
#endif

using namespace std;

#include "polkacpp/polkacpp.h"
// #include "polkadot_api_cpp/src/libs/xxhash/xxhash.h"
#include "polkadot_api_cpp/src/libs/json11/json11.hpp"
using namespace json11;
// #include "xxHash-0.8.0/xxhash.h"

static shared_ptr<polkadot::api> papi;
IApplication *app;

void connectToNode()
{
    cout << "Connecting to node... " << endl;
    papi = polkadot::api::getInstance();
    app = papi->app();
    app->connect("ws://127.0.0.1:9944");
}

void displayInfo()
{
    auto resp = app->getSystemInfo();
    cout << "System Information: " << endl
         << "  Chain ID       : " << resp->chainId << endl
         << "  Chain Name     : " << resp->chainName << endl
         << "  Token Decimals : " << resp->tokenDecimals << endl
         << "  Token Symbol   : " << resp->tokenSymbol << endl;
}

void disconnectNode() { app->disconnect(); }

void crash_callback(string data)
{
}

void displayMetadata()
{
    unique_ptr<GetMetadataParams> par2(new GetMetadataParams);
    unique_ptr<Metadata> resp2;
    resp2 = app->getMetadata(nullptr);
    
    assert(resp2->metadataV0 || resp2->metadataV4 || resp2->metadataV5 || resp2->metadataV6);
    cout << endl << "--- Received metadata ---" << endl;
    if (resp2->metadataV0) {
        cout << "OuterEventWrapperV0.name: " << resp2->metadataV0->oew->name << endl;
        cout << "ModuleV0[0].prefix: " << resp2->metadataV0->module[0]->prefix << endl;
        cout << "ModuleV0[1].prefix: " << resp2->metadataV0->module[1]->prefix << endl;
        cout << "..." << endl;
    }
    if (resp2->metadataV4) {
        cout << "ModuleV4[0].prefix: " << resp2->metadataV4->module[0]->prefix << endl;
        cout << "ModuleV4[1].prefix: " << resp2->metadataV4->module[1]->prefix << endl;
        cout << "..." << endl;
    }
    if (resp2->metadataV5) {
        cout << "ModuleV5[0].prefix: " << resp2->metadataV5->module[0]->prefix << endl;
        cout << "ModuleV5[1].prefix: " << resp2->metadataV5->module[1]->prefix << endl;
        cout << "..." << endl;
    }
    if (resp2->metadataV6) {
        cout << "ModuleV6[0].prefix: " << resp2->metadataV6->module[0]->prefix << endl;
        cout << "ModuleV6[1].prefix: " << resp2->metadataV6->module[1]->prefix << endl;
        cout << "..." << endl;
    }
    cout << endl;
}

void listen_crashes()
{
    string key = "5FLSigC9HGRKVhB9FiEo4Y3koPsNmBmLJbpXg2mp1hXcS59Y";
    bool done = false;
    app->subscribeStorage(key, crash_callback);
    while (!done)
        usleep(100000);
    app->unsubscribeStorage(key);
}

string uint64_tToHex(uint64_t d)
{
    ostringstream m;
    m << setw(16) << setfill('0') << hex << d;
    return m.str();
}

int main()
{
    try
    {
        connectToNode();
        displayInfo();
        // auto final_head = app->getFinalizedHead();
        // cout << "Final Head:" << final_head->blockHash << endl;
        
        // displayMetadata();

        Json prm1 = Json::object{{"type", "AccountId"}, {"value", "5FLSigC9HGRKVhB9FiEo4Y3koPsNmBmLJbpXg2mp1hXcS59Y"}};
        string storage = app->getStorage(prm1.dump(), "Sim", "crashes");
        cout << endl
             << "Storage: " << storage << endl
             << endl;

        // XXH128_hash_t module_name = XXH3_128bits("sim", 4);
        // cout << "module_name:" << uint64_tToHex(module_name.high64) << endl;
        // cout << "module_name:" << uint64_tToHex(module_name.low64) << endl;

        // listen_crashes();

        disconnectNode();
        return 0;
    }
    catch (exception &e)
    {
        cout << endl
             << "ERROR main program: " << e.what() << endl
             << endl;
        return 1;
    }
}