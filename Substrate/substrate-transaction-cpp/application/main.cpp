#include <fstream>
#include <iostream>
#include <stdio.h>
#include <streambuf>
#include <string.h>
#include <polkacpp/polkacpp.h>

int main()
{
    cout << "Hello World!" << endl;
    auto api = polkadot::api::getInstance()->app();
    api->connect("ws://127.0.0.1:9944");
    auto systemInfo = api->getSystemInfo();
    std::cout << "  Chain ID       : " << systemInfo->chainId << endl
              << "  Chain Name     : " << systemInfo->chainName << endl
              << "  Token Decimals : " << systemInfo->tokenDecimals << endl
              << "  Token Symbol   : " << systemInfo->tokenSymbol << endl; // sometimes malloc error here
    api->disconnect();
    return 0;
}