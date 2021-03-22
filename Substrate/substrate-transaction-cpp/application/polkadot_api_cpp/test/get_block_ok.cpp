#include "../src/polkadot.h"
#include "helpers/mockjsonrpc.h"
#undef NDEBUG
#include <cassert>

int main(int argc, char *argv[]) {

    auto app = polkadot::api::getInstance()->app();
    app->connect();

    cout << endl << endl << "============================ Get Block ============================" << endl;
    unique_ptr<GetBlockParams> par(new GetBlockParams);
    strcpy(par->blockHash, "0x37096ff58d1831c2ee64b026f8b70afab1942119c022d1dcfdbdc1558ebf63fa");
    auto resp3 = app->getBlock(move(par));

    cout << endl << endl << "============================ Get Block Header ============================" << endl;
    unique_ptr<GetBlockParams> par2(new GetBlockParams);
    strcpy(par2->blockHash, "0x37096ff58d1831c2ee64b026f8b70afab1942119c022d1dcfdbdc1558ebf63fa");
    auto resp4 = app->getBlockHeader(move(par2));

    cout << endl << endl << "Parent hash from block  : " << resp3->block.header.parentHash << endl;
    cout << "Parent hash from header : " << resp4->parentHash << endl;

    // Check hash
    assert(strcmp(resp3->block.header.parentHash, resp4->parentHash) == 0);
    assert(strlen(resp4->parentHash) == 66); // "64 bytes with 0x prefix"

    cout << "Received hashes match" << endl << endl;

    app->disconnect();

    cout << "success" << endl;

    return 0;
}
