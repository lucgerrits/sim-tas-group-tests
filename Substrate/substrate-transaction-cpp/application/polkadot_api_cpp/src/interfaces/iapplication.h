/**
 *   Communication with Substrate node assumes establishing a secure WebSocket connection using connect() method,
 * performing all operations as needed using the API calls defined in this interface, and closing connection using
 * disconnect() method.
 *
 *   Connection can be left open for as long as needed, and it will be maintained by the API. For this reason API runs
 * several maintenance threads and the process that established connection needs to be kept in memory and running.
 *
 *   API calls are thread-safe, yet it is not guaranteed for asynchronous operations that commands will finish (and
 * receive response) in the order they were sent. Also, many API methods use callback mechanism for asynchronous
 * operations. Please do not insert blocking code in the callback handlers because it will block other commands from
 * receiving responses. Responses may be lost and application may enter in a deadlock if handlers block. Also, please do
 * not chain API methods by calling other API methond inside response handlers.
 */

class IApplication {
public:
    virtual ~IApplication() {}

    /**
     *   Connects to WebSocket
     *
     * In order to establish successful TLS connection, a root CA certificate needs to be present in pem file configured
     * in CConstants::certificate_file (currently ca-chain.cert.pem). You can put several certificates in this text file
     * one after the other. Currently Polkadot poc-3 server is using DST_Root_CA_X3 CA and Unfrastructure POC-3 server
     * is using Amazon Root CA 1, so the content of these certificate files is added to ca-chain.cert.pem, but in case
     * if this changes, one can find out the issuer certificate by executing following instructions:
     *
     *  1. Execute `curl --insecure -v https://poc3-rpc.polkadot.io:443`
     *  2. Find "issuer" line in the output and download issuer certificate from their website
     *  3. Execute `openssl x509 -in <downloaded_cert_file> -noout -issuer`
     *  4. Check folder /usr/share/ca-certificates/mozilla if it has this CA certificate. If it does, copy content to
     *     ca-chain.cert.pem, otherwise return to step 2
     *
     *
     *   Configuration of Node URL
     *
     *   There are a few options how node URL can be configured. If empty string is provided in parameter and no
     * configuration file is present, the default URL is used. If config file is provided (in the same folder as
     * executable is run from), it overrides default value. If node URL is provided in the parameter, it overrides all
     * other options. Config file has JSON format. Example is provided in config_example.json file in project root on
     * GitHub:
     *
     *  https://github.com/usetech-llc/polkadot_api_cpp
     *
     *
     *   Dealing with Substrate Runtime updates
     *
     *   Client application should subscribe to runtimeVersion and, as soon as it receives an update that indicates that
     * runtime version changed, it should disconnect and connect again to recalculate hashers and method and modlue
     * indexes that are required for correct working of other methods.
     *
     * $param node_url - Node URL to connect to. If set to default value of "", default node URL will be used
     * @return operation result
     */
    virtual int connect(string node_url = "") = 0;

    /**
     *  Disconnects from WebSocket
     */
    virtual void disconnect() = 0;

    /**
     *  This method calls rpc bellow and puts it together:
     *  system_chain
     *  system_name
     *  system_version
     *  system_properties
     *
     * @return SystemInfo struct with result
     */
    virtual unique_ptr<SystemInfo> getSystemInfo() = 0;

    /**
     *  Retreives the block hash for specific block
     *
     *  @param struct with blockNumber block number
     *  @return BlockHash struct with result
     */
    virtual unique_ptr<BlockHash> getBlockHash(unique_ptr<GetBlockHashParams> params) = 0;

    /**
     *  Retreives the runtime metadata for specific block
     *
     *  @param struct with blockHash 64 diget number in hex format
     *  @return Metadata struct with result
     */
    virtual unique_ptr<Metadata> getMetadata(unique_ptr<GetMetadataParams> params) = 0;

    /**
     *  Retreives the runtime version information for specific block
     *
     * @param struct with blockHash 64 diget number in hex format
     * @return RuntimeVersion struct with result
     */
    virtual unique_ptr<RuntimeVersion> getRuntimeVersion(unique_ptr<GetRuntimeVersionParams> params) = 0;

    /**
     * Get header and body of a relay chain block
     *
     * @param struct with blockHash 64 diget number in hex format
     * @return SignedBlock struct with result
     */
    virtual unique_ptr<SignedBlock> getBlock(unique_ptr<GetBlockParams> params) = 0;

    /**
     * Retrieves the header for a specific block
     *
     * @param struct with blockHash 64 diget number in hex format
     * @return BlockHeader struct with result
     */
    virtual unique_ptr<BlockHeader> getBlockHeader(unique_ptr<GetBlockParams> params) = 0;

    /**
     * Returns current state of the network
     *
     * @return NetworkState struct with result
     */
    virtual unique_ptr<NetworkState> getNetworkState() = 0;

    /**
     * Get hash of the last finalized block in the chain
     *
     * @return FinalHead struct with result
     */
    virtual unique_ptr<FinalHead> getFinalizedHead() = 0;

    /**
     * Return health status of the node
     *
     * @return SystemHealth struct with result
     */
    virtual unique_ptr<SystemHealth> getSystemHealth() = 0;

    /**
     * Returns the currently connected peers
     *
     * @return PeersInfo struct with result
     */
    virtual unique_ptr<PeersInfo> getSystemPeers() = 0;

    /**
     *  Retreives the current nonce for specific address
     *
     *  @param address - the address to get nonce for
     *  @return address nonce
     */
    virtual unsigned long getAccountNonce(string address) = 0;

    /**
     *  Generates storage key for a certain Module and State variable defined by parameter and prefix. Parameter is a
     * JSON string representing a value of certain type, which has two fields: type and value. Type should be one of
     * type strings defined above. Value should correspond to the type. Example:
     *
     *    {"type" : "AccountId", "value" : "5ECcjykmdAQK71qHBCkEWpWkoMJY6NXvpdKy8UeMx16q5gFr"}
     *
     *   Information about Modules and State variables (with parameters and their types) is returned by getMetadata
     * method.
     *
     * @param jsonPrm - JSON string that contains parameter and its type
     * @param module - module (as in metadata)
     * @param variable - state variable (as in metadata for given module)
     */
    virtual string getKeys(const string &jsonPrm, const string &module, const string &variable) = 0;

    /**
     *  Reads storage for a certain Module and State variable defined by parameter and prefix. Parameter is a JSON
     * string representing a value of certain type, which has two fields: type and value. Type should be one of type
     * strings defined above. Value should correspond to the type. Example:
     *
     *    {"type" : "AccountId", "value" : "5ECcjykmdAQK71qHBCkEWpWkoMJY6NXvpdKy8UeMx16q5gFr"}
     *
     *   Information about Modules and State variables (with parameters and their types) is returned by getMetadata
     * method.
     *
     * @param jsonPrm - JSON string that contains parameter and its type
     * @param module - module (as in metadata)
     * @param variable - state variable (as in metadata for given module)
     */
    virtual string getStorage(const string &jsonPrm, const string &module, const string &variable) = 0;

    /**
     *  Returns storage hash of given State Variable for a given Module defined by parameter.
     * Parameter is a JSON string representing a value of certain type, which has two fields: type and value. Type
     * should be one of type strings defined above. Value should correspond to the type. Example:
     *
     *    {"type" : "AccountId", "value" : "5ECcjykmdAQK71qHBCkEWpWkoMJY6NXvpdKy8UeMx16q5gFr"}
     *
     *   Information about Modules and State variables (with parameters and their types) is returned by getMetadata
     * method.
     *
     * @param jsonPrm - JSON string that contains parameter and its type
     * @param module - module (as in metadata)
     * @param variable - state variable (as in metadata for given module)
     */
    virtual string getStorageHash(const string &jsonPrm, const string &module, const string &variable) = 0;

    /**
     *  Returns storage size for a given State Variable for a given Module defined by parameter.
     * Parameter is a JSON string representing a value of certain type, which has two fields: type and value. Type
     * should be one of type strings defined above. Value should correspond to the type. Example:
     *
     *    {"type" : "AccountId", "value" : "5ECcjykmdAQK71qHBCkEWpWkoMJY6NXvpdKy8UeMx16q5gFr"}
     *
     *   Information about Modules and State variables (with parameters and their types) is returned by getMetadata
     * method.
     *
     * @param jsonPrm - JSON string that contains parameter and its type
     * @param module - module (as in metadata)
     * @param variable - state variable (as in metadata for given module)
     */
    virtual int getStorageSize(const string &jsonPrm, const string &module, const string &variable) = 0;

    /**
     *  Calls storage_getChildKeys RPC method with given child storage key and storage key
     *
     * @param childStorageKey - string with 0x prefixed child storage key hex value
     * @param storageKey - string with 0x prefixed storage key hex value
     * @return string response from RPC method
     */
    virtual string getChildKeys(const string &childStorageKey, const string &storageKey) = 0;

    /**
     *  Calls storage_getChildStorage RPC method with given child storage key and storage key
     *
     * @param childStorageKey - string with 0x prefixed child storage key hex value
     * @param storageKey - string with 0x prefixed storage key hex value
     * @return string response from RPC method
     */
    virtual string getChildStorage(const string &childStorageKey, const string &storageKey) = 0;

    /**
     *  Calls storage_getChildStorageHash RPC method with given child storage key and storage key
     *
     * @param childStorageKey - string with 0x prefixed child storage key hex value
     * @param storageKey - string with 0x prefixed storage key hex value
     * @return string response from RPC method
     */
    virtual string getChildStorageHash(const string &childStorageKey, const string &storageKey) = 0;

    /**
     *  Calls storage_getChildStorageSize RPC method with given child storage key and storage key
     *
     * @param childStorageKey - string with 0x prefixed child storage key hex value
     * @param storageKey - string with 0x prefixed storage key hex value
     * @return int response from RPC method
     */
    virtual int getChildStorageSize(const string &childStorageKey, const string &storageKey) = 0;

    /**
     *  Calls state_call RPC method
     *
     * @param name - name of call
     * @param data - hex encoded data with 0x prefix
     * @param hash - hex encoded block hash with 0x prefix
     * @return string raw RPC call return
     */
    virtual string stateCall(const string &name, const string &data, const string &hash) = 0;

    /**
     *  Calls state_queryStorage RPC method to get historical information about storage at a key
     *
     * @param key - storage key to query
     * @param startHash - hash of block to start with
     * @param stopHsah - hash of block to stop at
     * @param itemBuf - preallocated array of StorageItem elements
     * @param itemBufSize - size of preallocated array of StorageItem elements
     * @return number of retrieved items
     */
    virtual int queryStorage(const string &key, const string &startHash, const string &stopHash, StorageItem *itemBuf,
                             int itemBufSize) = 0;

    /**
     *  Sign a transfer with provided private key, submit it to blockchain, and wait for completion. Once transaction is
     * accepted, the callback will be called with parameter "ready". Once completed, the callback will be called with
     * completion result string equal to "finalized".
     *
     * @param sender - address of sender (who signs the transaction)
     * @param privateKey - 64 byte private key of signer in hex, 2 symbols per byte (e.g. "0102ABCD...")
     * @param recipient - address that will receive the transfer
     * @param amount - amount (in femto DOTs) to transfer
     * @param callback - functor or lambda expression that will receive operation updates
     */
    virtual void signAndSendTransfer(string sender, string privateKey, string recipient, uint128 amount,
                                     std::function<void(string)> callback) = 0;

    /**
     * Returns all pending extrinsics
     *
     * @param buf - Preallocated array of GenericExtrinsic that will be filled
     * @param bufferSize - size of preallocated array
     * @return Number of extrinsics received from the node (may be greater than buffer size, in which case items with
     * indexes greater than bufferSize are not returned)
     */
    virtual int pendingExtrinsics(GenericExtrinsic *buf, int bufferSize) = 0;

    /**
     * Submit and subscribe a fully formatted extrinsic for block inclusion
     *
     * @param encodedMethodBytes - encoded extrintic parametrs
     * @param encodedMethodBytesSize - parametrs size in bytes
     * @param module - invokable module name
     * @param method - invokable module name
     * @param sender - sender address
     * @param privateKey - sender private key
     * @param callback - functor or lambda expression that will receive operation updates
     */
    virtual void submitAndSubcribeExtrinsic(uint8_t *encodedMethodBytes, unsigned int encodedMethodBytesSize,
                                            string module, string method, string sender, string privateKey,
                                            std::function<void(string)> callback) = 0;

    /**
     * Submit a fully formatted extrinsic for block inclusion
     *
     * @param encodedMethodBytesSize - parametrs size in bytes
     * @param module - invokable module name
     * @param method - invokable module name
     * @param sender - sender address
     * @param privateKey - sender private key
     * @return Extrinsic hash
     */
    virtual string submitExtrinsic(uint8_t *encodedMethodBytes, unsigned int encodedMethodBytesSize, string module,
                                   string method, string sender, string privateKey) = 0;

    /**
     * Remove given extrinsic from the pool and temporarily ban it to prevent reimporting
     *
     * @param extrinsicHash - hash of extrinsic as returned by submitExtrisic
     * @return Operation result
     */
    virtual bool removeExtrinsic(string extrinsicHash) = 0;

    /**
     *  Subscribe to most recent block number. Only one subscription at a time is allowed. If a subscription already
     * exists, old subscription will be discarded and replaced with the new one. Until unsubscribeBlockNumber method is
     * called, the API will be receiving updates and forwarding them to subscribed object/function. Only
     * unsubscribeBlockNumber will physically unsubscribe from WebSocket endpoint updates.
     *
     * @param callback - functor or lambda expression that will receive updates
     * @return operation result
     */
    virtual int subscribeBlockNumber(std::function<void(long long)> callback) = 0;

    /**
     *  Unsubscribe from WebSocket endpoint and stop receiving updates with most recent block number.
     *
     * @return operation result
     */
    virtual int unsubscribeBlockNumber() = 0;

    /**
     *  Subscribe to most recent finalized block. Only one subscription at a time is allowed. If a subscription already
     * exists, old subscription will be discarded and replaced with the new one. Until unsubscribeFinalizedBlock method
     * is called, the API will be receiving updates and forwarding them to subscribed object/function. Only
     * unsubscribeFinalizedBlock will physically unsubscribe from WebSocket endpoint updates.
     *
     * @param callback - functor or lambda expression that will receive updates
     * @return operation result
     */
    virtual int subscribeFinalizedBlock(std::function<void(const BlockHeader &)> callback) = 0;

    /**
     *  Unsubscribe from WebSocket endpoint and stop receiving updates with most recent finalized block.
     *
     * @return operation result
     */
    virtual int unsubscribeFinalizedBlock() = 0;

    /**
     *  Subscribe to most recent runtime version. This subscription is necessary for applications that keep connection
     * for a long time. If update about runtime version arrives, it will be necessary to disconnect and reconnect since
     * module and method indexes might have changed.
     *
     * Only one subscription at a time is allowed. If a subscription already
     * exists, old subscription will be discarded and replaced with the new one. Until unsubscribeRuntimeVersion method
     * is called, the API will be receiving updates and forwarding them to subscribed object/function. Only
     * unsubscribeRuntimeVersion will physically unsubscribe from WebSocket endpoint updates.
     *
     * @param callback - functor or lambda expression that will receive updates
     * @return operation result
     */
    virtual int subscribeRuntimeVersion(std::function<void(const RuntimeVersion &)> callback) = 0;

    /**
     *  Unsubscribe from WebSocket endpoint and stop receiving updates with most recent Runtime Version.
     *
     * @return operation result
     */
    virtual int unsubscribeRuntimeVersion() = 0;

    /**
     *  Subscribe to most recent value updates for a given storage key. Only one subscription at a time per address is
     * allowed. If a subscription already exists for the same storage key, old subscription will be discarded and
     * replaced with the new one. Until unsubscribeStorage method is called with the same storage key, the API will be
     * receiving updates and forwarding them to subscribed object/function. Only unsubscribeStorage will physically
     * unsubscribe from WebSocket endpoint updates.
     *
     * @param key - storage key to receive updates for (e.g. "0x66F795B8D457430EDDA717C3CBA459B9")
     * @param callback - functor or lambda expression that will receive balance updates
     * @return operation result
     */
    virtual int subscribeStorage(string key, std::function<void(const string &)> callback) = 0;

    /**
     *  Unsubscribe from WebSocket endpoint and stop receiving updates for address balance.
     *
     * @param key - storage key to stop receiving updates for
     * @return operation result
     */
    virtual int unsubscribeStorage(string key) = 0;

    /**
     *  Subscribe to most recent balance for a given address. Only one subscription at a time per address is allowed. If
     * a subscription already exists for the same address, old subscription will be discarded and replaced with the new
     * one. Until unsubscribeBalance method is called with the same address, the API will be receiving updates and
     * forwarding them to subscribed object/function. Only unsubscribeBalance will physically unsubscribe from WebSocket
     * endpoint updates.
     *
     * @param address - address to receive balance updates for
     * @param callback - functor or lambda expression that will receive balance updates
     * @return operation result
     */
    virtual int subscribeBalance(string address, std::function<void(uint128)> callback) = 0;

    /**
     *  Unsubscribe from WebSocket endpoint and stop receiving updates for address balance.
     *
     * @param address - address to stop receiving balance updates for
     * @return operation result
     */
    virtual int unsubscribeBalance(string address) = 0;

    /**
     *  Subscribe to era and session. Only one subscription at a time is allowed. If a subscription already
     * exists, old subscription will be discarded and replaced with the new one. Until subscribeEraAndSession method is
     * called, the API will be receiving updates and forwarding them to subscribed object/function. Only
     * unsubscribeBlockNumber will physically unsubscribe from WebSocket endpoint updates.
     *
     * @param callback - functor or lambda expression that will receive updates
     * @return operation result
     */
    virtual int subscribeEraAndSession(std::function<void(Era, Session)> callback) = 0;

    /**
     *  Unsubscribe from WebSocket endpoint and stop receiving updates with era and session.
     *
     * @return operation result
     */
    virtual int unsubscribeEraAndSession() = 0;

    /**
     *  Subscribe to nonce updates for a given address. Only one subscription at a time per address is allowed. If
     * a subscription already exists for the same address, old subscription will be discarded and replaced with the new
     * one. Until unsubscribeNonce method is called with the same address, the API will be receiving updates and
     * forwarding them to subscribed object/function. Only unsubscribeNonce will physically unsubscribe from WebSocket
     * endpoint updates.
     *
     * @param address - address to receive nonce updates for
     * @param callback - functor or lambda expression that will receive nonce updates
     * @return operation result
     */
    virtual int subscribeAccountNonce(string address, std::function<void(unsigned long)> callback) = 0;

    /**
     *  Unsubscribe from WebSocket endpoint and stop receiving updates for address nonce.
     *
     * @param address - address to stop receiving nonce updates for
     * @return operation result
     */
    virtual int unsubscribeAccountNonce(string address) = 0;
};
