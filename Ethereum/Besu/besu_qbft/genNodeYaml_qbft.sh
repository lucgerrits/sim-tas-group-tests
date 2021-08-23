#!/bin/bash
# Gas Limit: 715000000
# Gas for Accident Transaction = 55844
# Ratio of 12000 txs
#For Besu we count boot node as a validator as well
# Nodes = 4, 9, 19, 24
NBNODES=24
#list of validators available
accountArrayAddress=("0x033c007add93008949e50420cb8cb719f1437b3d" "0x1adc1efb2e45e4465f1d7dbe861fe108377d0d64" "0x279e295979c94b3a6f4602f35cad8660bff762db"
"0x3ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e" "0x5ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5" "0x5ee364876ad13587ac27ee3b2b1251147c3797ca" "0x704340fb15e92cb0850b490ad1ee72ee1fa06a5e" "0x77ddc945a34a09d9b3f598bb84df9a47326c0514" "0x7f9c49ebb106e62d1bfdf305212a8e3a618e5541" "0x80863526c055f767a2840ec6fd029ecbefb91203" "0x8460ba423ced5cb2f8618f3c0402779750996b6c" "0x8656c932ec452b56dc30d7520411c609cef37be8" "0x8f142be32db4ba3e39980488217ab182d9764b10" "0x976b206e4ab8a620bc60c7cfdd5bdae24122188f" "0x9e0cc13250ced5c7dc887c3002fda9ee716c865b" "0xa6244cdb6695c3ba1ec1b755191dde1918fb3a0a" "0xa9179cb6dc3d9a72120cc33be8d04070318c396f" "0xaf485edc5e3945931bf3dd97f236bee3288c5da9" "0xafab35a28c17797182cb32d3b4322227b5f29052" "0xb10a8dab74e7f1d4c055bb04ace0e2dfe1d9cc46" "0xd653532ef4937ec9b6e5ac84963d4ce2eaa8eb1f" "0xe127a86fd1ca1436c0beea839bde9c2d1a283844" "0xea8578b7bfebcd1f28667eec27230db7a9b3a678" "0xf605b41d896d9031ca9390d3211f02bbe8fd9e26" "0x90cF18fE951c1464f62A73AfAcB364989b4aB4a5")
accountArrayPublic=("0x80492727fe2e43dfa991496b6bfa7cedd28d7a48a6582350226cf96a5157073cff1543a4689342d364b6fb0f671e5bf9b9fdecf44cb099ffe3e75d2719e199fc" "0xc9484af02dd1a6ac85dd9a901379022643326f7381cf3a1b96585ca938dc2d33806dbbd30c625a059d6b503e503a49693230d7ea87d15b8830b49ce9e1e79704" "0x065f502c4bcccec05e5922aa10742f442a65b4e5ab07fa117b56c94b79b2b3b152826f53a1e973379ec56a1783f43796250f649e0936ad7c9fea33837c142942" "0x194e72c0cecb7d4e4fe2c0430d792ba8fdfc45db7f170fc058453ed53af21fd0584d1467ccce74e62bffc3c5178550d11a34c5de8194aba3230cca00c7d05b7f" "0x3925fd1a1f1bd7c8e1d609435413ee5aa337d189b34b60faa72fdf4d184e6f7d61ca7f290f1087a291400135d755a07f286c51ed7e5a3b73f67ba2e81f9dc48f" "0x6d11979919e31a7eb937839b7e8a2290af3005d135cde24f71e63a83a51a11e4e7792ec5ddb63f25036df7e9a69e35fc2fdf77ef9102cfc895cdb294ff595043" "0x550ceb3053bf8308e86830873441aab7fcf7beb0b58af36aafe1d1f329f10319a26164118b2809639c08ae88bd292914f654b01da8a18ac6026f989f3f82fc63" "0xb7b030cdb71c270a5c68176e3c72826a0d4e68dc1d27fa7d755a878bfcd0ad4c999d468f2ce1390bfcaa06f24898765750bfe9781c6b4296b671a98dbb376b05" "0xd2b50fdd2e06b4ed363837a91eed6d32e2bbd930f8cad162f9aee1402b6b4191242587f6b61913ae3bfc9d42bbcba7c14071ce8882b6599a1bb10665fb93bc55" "0xfc9f4dd47257d66a0eab48adfcc5451c55d2220298d8679961179140ca65d61088cc501d5987f49226e436a883afddf5d3ee6e7615ff673afa9eee056555e607" "0xab942517e8fdead57e7d54c7067d4d9e1ab4501e2826bc82332510f4e6eb1e19939d8e67932703a3cc44b7b4a2c2976fd611307cebb0eb80ffe2c3348884e323" "0x4f1ac9caf4d4bf4f937564312f77c463f8a086a1d2f5e992495a73cd1f33f21689842c4f120c6f90f6aad9c08d5af33694cffd58a31df1b12f9f53ac18b4b3e3" "0xa26c56f1e7f97123d530eac8554e0b604af5f383ee6bd27276c7b24515ffcdb564ca12b2c293f0d0022eb0bc8d667a70858b28b6716c29e6fd1957bba1c92a55" "0x40cdde4a2945ac89cefc978a8dc79dcf13e52ffac0d1e2ce386be83d6db844a823b721965207ae42ad6bdc627f353d48e20fd643f31a5fe1f36d471b39f0255a" "0x03755223ff03e29bb05b27d7daf2d5dc06052ad5ad5107c6fc492c28b0af095c908bf82f34b5d03e682ea21f12a6f3aaf1d4fd770b897cc16029fa2952eaf309" "0x4f4f251ce3e4faf6262988fdf28c8bea2a6f0228d526c2cf6fb515a26ac55b7bc7f9944c7e94668cf4f16a5608d0a7391facb01a06836e3fbd94f5f0fb684e8f" "0x4836b57c0f9499839dbf492301bf5d990a82f14285cbce6c249b8720ad503e785ed7a3f70d840b23692f64378c8021242410c160ab2032c069c15200030cd56d" "0xb17afd9c578af03c5df3f73f3788b26c5bd3de085a5efcbec6238f77bff7e86bd5219644ff11374191a6b5f8aa30802d95e517db7042e98c49b7cc4679d70e27" "0x2a0994cf1d2337ce360809206c9ea69608beb68f7d9d2407adaae051425c4dead86e97ea256a66deb88ca261ae4eb4e0eb964574112290c8fb7c4097a1d92abb" "0x9599b9e2ffba798c4930837d6e7f2f67acc24c406a6710b4d4cedb196124935180a23bbcacd6436bd29a69c109cd0c1b575d33206b45385b7eaa3cc9d0066feb" "0xd808d371595ca25d8b9b4f5641e3fee4a82f68808b56ba4a9c4e729a514fdf79828cb2cf564822ff584140f58dbd23e2b8dce9858bc9b4e992fac2d2c7d20438" "0x9fc5e834ed67ba922d650edfe9ec4ad3578ee3e17204e74c7d51fb889be0acc433b08cfa8aa5ba3f4bde7b7671b3de4f512702f0aacb44f3520f53855ae4d762" "0xc6181e55e2a01d1d94e0bdf5ae32daa2759501aebac9bee0d80782b21f5860c5f81551fc29b1900c043f6f8830f7faa675339b7ac1996bb74453d3a15c1ee18c" "0x45bc0cdc01c98465055a6aea1016084fb699368b7c2397f2bf19b186ca26cfa12ffcd1dc84fd556c42360f0da69864fdd14fffc8fe946ee53c8aa0eb94e1f5f1" "0x1bbda5469e6296199f21c35b655ba13f5e94da3fe1b0fd3d2136aa2d0f480885131449d5706dd8978eac2cc45ef65d5f60def5317cb027ccfbffa5fad2fae7d9")
accountArrayPrivate=("0xe68dcb483578c71ec83dabfb6bd5084c8da683d82571f3543a278c6dc5520c89" "0x1d8af7e6361ff3b825f32cb5292b6522113aca560a446e0954d093b61df753d7" "0xd55f8e64fead16448851ade549eb6157fd893aff50e94905753ca2e5790ea029" "0xa01c08526930d4bd61040788c393f9f1e76ebc1fb3b78993b3a4ea2969689771" "0x2b42885b157248b018ec95effb57bb2df3d94e85d03a571c5f0ac8a38c4aaea8" "0x7cc45fff7c7238c3d02fc92fe8de27226f264a2ea614083363e3bb2dbf5a42d3"
"0x04c5d4f1dd2a42e765cc8df8125b9f6b27b3df43e87c936c6518968c48d55b48" "0x930816f42d23b6c931439760532bde1769445719c8f8afa2670a3604926b3dce"
"0xf232046a344d99c38e21dec5578e7a9c86a9379bb0eeeb5595803ebe3824f676" "0xb798bd4abfe2790dc9eaa0cf85e2d813572f4fa8272e9ef953e6c234963b5757" "0xd2e07ec94dc623a00d4ee5637efab895918482d4c8fc54273344f8cd7f8f8b81" "0x05950e0dd95818e2662788547185b1c68e2ec669b6b43e1916fcadab16a17176"
"0x7a5c9250b39e573c7909c859bf4b05a50a5dc9cc0e668e9a8c1ab9de1c7ef071" "0xadb01031fa941e938e3c38e0338f44a0225589bae25910becd18d539aee8c60f"
"0x86ecfc743d5efa912506db412d2f83eda6d63971fa0f5203b70d8aaec61a30a2" "0x315e04dbffbf37938e0442f6fea7fbbff34c99d98a4fa1c904ed239295ec25dc"
"0x7a084d1ff1e19243c36e8ee03aa832fc56ec05a3047992de7a397157cb05935b" "0xbbd05e615425e2db4493b54ee2445fa7e56041bd83007353089a1513d841db89"
"0x895d049e94a6bb3d02293213853e389b4c13f053bafdd1a1e48f597edc6e86f3" "0x18dd9012778e383758b2adaba9383732b38173781be1c243d31a4b16d6a9d399"
"0x9f9be07afff4ad468f1cb15170dc00893454b21d2fb75aa46844354be6211383" "0xbe2572369208ca08e8f959fed902cfffba5ba265554b7c6162cf37562d9f26f0"
"0x61dcd9580af184a9e4947be0aed699f301a880dd6b8dce51e7b2a46b83c3f7df" "0x1f8dfd194471b7ec894ba67faeea58303711150c16c4942a1e89d2ec4f53d67e" "0x9b833e0a315a88032cd757a4d3b777461da15fed0aeae5ac4bbbf3a4e6e47d4b")

# Check README to Generate ExtraData
extraDataArray=("0xf87aa00000000000000000000000000000000000000000000000000000000000000000f85494033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8ec080c0" "0xf88fa00000000000000000000000000000000000000000000000000000000000000000f86994033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5c080c0" "0xf8a4a00000000000000000000000000000000000000000000000000000000000000000f87e94033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797cac080c0" "0xf8b9a00000000000000000000000000000000000000000000000000000000000000000f89394033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5ec080c0" "0xf8cea00000000000000000000000000000000000000000000000000000000000000000f8a894033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5e9477ddc945a34a09d9b3f598bb84df9a47326c0514c080c0" "0xf8e3a00000000000000000000000000000000000000000000000000000000000000000f8bd94033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5e9477ddc945a34a09d9b3f598bb84df9a47326c0514947f9c49ebb106e62d1bfdf305212a8e3a618e5541c080c0" "0xf8f8a00000000000000000000000000000000000000000000000000000000000000000f8d294033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5e9477ddc945a34a09d9b3f598bb84df9a47326c0514947f9c49ebb106e62d1bfdf305212a8e3a618e55419480863526c055f767a2840ec6fd029ecbefb91203c080c0" "0xf9010da00000000000000000000000000000000000000000000000000000000000000000f8e794033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5e9477ddc945a34a09d9b3f598bb84df9a47326c0514947f9c49ebb106e62d1bfdf305212a8e3a618e55419480863526c055f767a2840ec6fd029ecbefb91203948460ba423ced5cb2f8618f3c0402779750996b6cc080c0" "0xf90122a00000000000000000000000000000000000000000000000000000000000000000f8fc94033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5e9477ddc945a34a09d9b3f598bb84df9a47326c0514947f9c49ebb106e62d1bfdf305212a8e3a618e55419480863526c055f767a2840ec6fd029ecbefb91203948460ba423ced5cb2f8618f3c0402779750996b6c948656c932ec452b56dc30d7520411c609cef37be8c080c0" "0xf90138a00000000000000000000000000000000000000000000000000000000000000000f9011194033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5e9477ddc945a34a09d9b3f598bb84df9a47326c0514947f9c49ebb106e62d1bfdf305212a8e3a618e55419480863526c055f767a2840ec6fd029ecbefb91203948460ba423ced5cb2f8618f3c0402779750996b6c948656c932ec452b56dc30d7520411c609cef37be8948f142be32db4ba3e39980488217ab182d9764b10c080c0" "0xf9014da00000000000000000000000000000000000000000000000000000000000000000f9012694033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5e9477ddc945a34a09d9b3f598bb84df9a47326c0514947f9c49ebb106e62d1bfdf305212a8e3a618e55419480863526c055f767a2840ec6fd029ecbefb91203948460ba423ced5cb2f8618f3c0402779750996b6c948656c932ec452b56dc30d7520411c609cef37be8948f142be32db4ba3e39980488217ab182d9764b1094976b206e4ab8a620bc60c7cfdd5bdae24122188fc080c0" "0xf90162a00000000000000000000000000000000000000000000000000000000000000000f9013b94033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5e9477ddc945a34a09d9b3f598bb84df9a47326c0514947f9c49ebb106e62d1bfdf305212a8e3a618e55419480863526c055f767a2840ec6fd029ecbefb91203948460ba423ced5cb2f8618f3c0402779750996b6c948656c932ec452b56dc30d7520411c609cef37be8948f142be32db4ba3e39980488217ab182d9764b1094976b206e4ab8a620bc60c7cfdd5bdae24122188f949e0cc13250ced5c7dc887c3002fda9ee716c865bc080c0" "0xf90177a00000000000000000000000000000000000000000000000000000000000000000f9015094033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5e9477ddc945a34a09d9b3f598bb84df9a47326c0514947f9c49ebb106e62d1bfdf305212a8e3a618e55419480863526c055f767a2840ec6fd029ecbefb91203948460ba423ced5cb2f8618f3c0402779750996b6c948656c932ec452b56dc30d7520411c609cef37be8948f142be32db4ba3e39980488217ab182d9764b1094976b206e4ab8a620bc60c7cfdd5bdae24122188f949e0cc13250ced5c7dc887c3002fda9ee716c865b94a6244cdb6695c3ba1ec1b755191dde1918fb3a0ac080c0" "0xf9018ca00000000000000000000000000000000000000000000000000000000000000000f9016594033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5e9477ddc945a34a09d9b3f598bb84df9a47326c0514947f9c49ebb106e62d1bfdf305212a8e3a618e55419480863526c055f767a2840ec6fd029ecbefb91203948460ba423ced5cb2f8618f3c0402779750996b6c948656c932ec452b56dc30d7520411c609cef37be8948f142be32db4ba3e39980488217ab182d9764b1094976b206e4ab8a620bc60c7cfdd5bdae24122188f949e0cc13250ced5c7dc887c3002fda9ee716c865b94a6244cdb6695c3ba1ec1b755191dde1918fb3a0a94a9179cb6dc3d9a72120cc33be8d04070318c396fc080c0" "0xf901a1a00000000000000000000000000000000000000000000000000000000000000000f9017a94033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5e9477ddc945a34a09d9b3f598bb84df9a47326c0514947f9c49ebb106e62d1bfdf305212a8e3a618e55419480863526c055f767a2840ec6fd029ecbefb91203948460ba423ced5cb2f8618f3c0402779750996b6c948656c932ec452b56dc30d7520411c609cef37be8948f142be32db4ba3e39980488217ab182d9764b1094976b206e4ab8a620bc60c7cfdd5bdae24122188f949e0cc13250ced5c7dc887c3002fda9ee716c865b94a6244cdb6695c3ba1ec1b755191dde1918fb3a0a94a9179cb6dc3d9a72120cc33be8d04070318c396f94af485edc5e3945931bf3dd97f236bee3288c5da9c080c0" "0xf901b6a00000000000000000000000000000000000000000000000000000000000000000f9018f94033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5e9477ddc945a34a09d9b3f598bb84df9a47326c0514947f9c49ebb106e62d1bfdf305212a8e3a618e55419480863526c055f767a2840ec6fd029ecbefb91203948460ba423ced5cb2f8618f3c0402779750996b6c948656c932ec452b56dc30d7520411c609cef37be8948f142be32db4ba3e39980488217ab182d9764b1094976b206e4ab8a620bc60c7cfdd5bdae24122188f949e0cc13250ced5c7dc887c3002fda9ee716c865b94a6244cdb6695c3ba1ec1b755191dde1918fb3a0a94a9179cb6dc3d9a72120cc33be8d04070318c396f94af485edc5e3945931bf3dd97f236bee3288c5da994afab35a28c17797182cb32d3b4322227b5f29052c080c0" "0xf901cba00000000000000000000000000000000000000000000000000000000000000000f901a494033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5e9477ddc945a34a09d9b3f598bb84df9a47326c0514947f9c49ebb106e62d1bfdf305212a8e3a618e55419480863526c055f767a2840ec6fd029ecbefb91203948460ba423ced5cb2f8618f3c0402779750996b6c948656c932ec452b56dc30d7520411c609cef37be8948f142be32db4ba3e39980488217ab182d9764b1094976b206e4ab8a620bc60c7cfdd5bdae24122188f949e0cc13250ced5c7dc887c3002fda9ee716c865b94a6244cdb6695c3ba1ec1b755191dde1918fb3a0a94a9179cb6dc3d9a72120cc33be8d04070318c396f94af485edc5e3945931bf3dd97f236bee3288c5da994afab35a28c17797182cb32d3b4322227b5f2905294b10a8dab74e7f1d4c055bb04ace0e2dfe1d9cc46c080c0" "0xf901e0a00000000000000000000000000000000000000000000000000000000000000000f901b994033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5e9477ddc945a34a09d9b3f598bb84df9a47326c0514947f9c49ebb106e62d1bfdf305212a8e3a618e55419480863526c055f767a2840ec6fd029ecbefb91203948460ba423ced5cb2f8618f3c0402779750996b6c948656c932ec452b56dc30d7520411c609cef37be8948f142be32db4ba3e39980488217ab182d9764b1094976b206e4ab8a620bc60c7cfdd5bdae24122188f949e0cc13250ced5c7dc887c3002fda9ee716c865b94a6244cdb6695c3ba1ec1b755191dde1918fb3a0a94a9179cb6dc3d9a72120cc33be8d04070318c396f94af485edc5e3945931bf3dd97f236bee3288c5da994afab35a28c17797182cb32d3b4322227b5f2905294b10a8dab74e7f1d4c055bb04ace0e2dfe1d9cc4694d653532ef4937ec9b6e5ac84963d4ce2eaa8eb1fc080c0" "0xf901f5a00000000000000000000000000000000000000000000000000000000000000000f901ce94033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5e9477ddc945a34a09d9b3f598bb84df9a47326c0514947f9c49ebb106e62d1bfdf305212a8e3a618e55419480863526c055f767a2840ec6fd029ecbefb91203948460ba423ced5cb2f8618f3c0402779750996b6c948656c932ec452b56dc30d7520411c609cef37be8948f142be32db4ba3e39980488217ab182d9764b1094976b206e4ab8a620bc60c7cfdd5bdae24122188f949e0cc13250ced5c7dc887c3002fda9ee716c865b94a6244cdb6695c3ba1ec1b755191dde1918fb3a0a94a9179cb6dc3d9a72120cc33be8d04070318c396f94af485edc5e3945931bf3dd97f236bee3288c5da994afab35a28c17797182cb32d3b4322227b5f2905294b10a8dab74e7f1d4c055bb04ace0e2dfe1d9cc4694d653532ef4937ec9b6e5ac84963d4ce2eaa8eb1f94e127a86fd1ca1436c0beea839bde9c2d1a283844c080c0" "0xf9020aa00000000000000000000000000000000000000000000000000000000000000000f901e394033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5e9477ddc945a34a09d9b3f598bb84df9a47326c0514947f9c49ebb106e62d1bfdf305212a8e3a618e55419480863526c055f767a2840ec6fd029ecbefb91203948460ba423ced5cb2f8618f3c0402779750996b6c948656c932ec452b56dc30d7520411c609cef37be8948f142be32db4ba3e39980488217ab182d9764b1094976b206e4ab8a620bc60c7cfdd5bdae24122188f949e0cc13250ced5c7dc887c3002fda9ee716c865b94a6244cdb6695c3ba1ec1b755191dde1918fb3a0a94a9179cb6dc3d9a72120cc33be8d04070318c396f94af485edc5e3945931bf3dd97f236bee3288c5da994afab35a28c17797182cb32d3b4322227b5f2905294b10a8dab74e7f1d4c055bb04ace0e2dfe1d9cc4694d653532ef4937ec9b6e5ac84963d4ce2eaa8eb1f94e127a86fd1ca1436c0beea839bde9c2d1a28384494ea8578b7bfebcd1f28667eec27230db7a9b3a678c080c0" "0xf9021fa00000000000000000000000000000000000000000000000000000000000000000f901f894033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5e9477ddc945a34a09d9b3f598bb84df9a47326c0514947f9c49ebb106e62d1bfdf305212a8e3a618e55419480863526c055f767a2840ec6fd029ecbefb91203948460ba423ced5cb2f8618f3c0402779750996b6c948656c932ec452b56dc30d7520411c609cef37be8948f142be32db4ba3e39980488217ab182d9764b1094976b206e4ab8a620bc60c7cfdd5bdae24122188f949e0cc13250ced5c7dc887c3002fda9ee716c865b94a6244cdb6695c3ba1ec1b755191dde1918fb3a0a94a9179cb6dc3d9a72120cc33be8d04070318c396f94af485edc5e3945931bf3dd97f236bee3288c5da994afab35a28c17797182cb32d3b4322227b5f2905294b10a8dab74e7f1d4c055bb04ace0e2dfe1d9cc4694d653532ef4937ec9b6e5ac84963d4ce2eaa8eb1f94e127a86fd1ca1436c0beea839bde9c2d1a28384494ea8578b7bfebcd1f28667eec27230db7a9b3a67894f605b41d896d9031ca9390d3211f02bbe8fd9e26c080c0" "0xf90234a00000000000000000000000000000000000000000000000000000000000000000f9020d94033c007add93008949e50420cb8cb719f1437b3d941adc1efb2e45e4465f1d7dbe861fe108377d0d6494279e295979c94b3a6f4602f35cad8660bff762db943ec844a79db1f0371cacf5b63b4cc9a42a2dfa8e945ca4b4d85d68b21571b7a1cd6b77f3fce7de15e5945ee364876ad13587ac27ee3b2b1251147c3797ca94704340fb15e92cb0850b490ad1ee72ee1fa06a5e9477ddc945a34a09d9b3f598bb84df9a47326c0514947f9c49ebb106e62d1bfdf305212a8e3a618e55419480863526c055f767a2840ec6fd029ecbefb91203948460ba423ced5cb2f8618f3c0402779750996b6c948656c932ec452b56dc30d7520411c609cef37be8948f142be32db4ba3e39980488217ab182d9764b1094976b206e4ab8a620bc60c7cfdd5bdae24122188f949e0cc13250ced5c7dc887c3002fda9ee716c865b94a6244cdb6695c3ba1ec1b755191dde1918fb3a0a94a9179cb6dc3d9a72120cc33be8d04070318c396f94af485edc5e3945931bf3dd97f236bee3288c5da994afab35a28c17797182cb32d3b4322227b5f2905294b10a8dab74e7f1d4c055bb04ace0e2dfe1d9cc4694d653532ef4937ec9b6e5ac84963d4ce2eaa8eb1f94e127a86fd1ca1436c0beea839bde9c2d1a28384494ea8578b7bfebcd1f28667eec27230db7a9b3a67894f605b41d896d9031ca9390d3211f02bbe8fd9e2694f74945c45d5160fc35f3ab85b3e6ea254bd71922c080c0")

##use array in script like this: ${accountArray[i]}

cat << EOF
apiVersion: v1
kind: List

items:

EOF

for (( i=0; i<=$NBNODES; i++ ))
do
   echo ""
   echo "# --------------------------=== POD DEPLOYMENT $i ===--------------------------"

    if [[ "$i" -eq 0 ]]; then
    #first node is bootnode

cat << EOF

#------------------- PersistentVolume for bootnode/genessis file ------------------
#shared among all nodes

- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: volume-bootnode
    namespace: ethereum-net
  spec:
    storageClassName: manual
    accessModes:
    - ReadWriteOnce
    resources:
      requests:
        storage: 20Gi

- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: bootnode
    labels:
      type: local
  spec:
    storageClassName: manual
    capacity:
      storage: 20Gi
    accessModes:
      - ReadWriteOnce
    persistentVolumeReclaimPolicy: Delete
    hostPath:
      #type: DirectoryOrCreate
      path: "/datas/bootnode"

#------------------- config for bootnode private key ------------------
- apiVersion: v1
  kind: ConfigMap
  metadata:
    name: keystore-config-bootnode
    namespace: ethereum-net
    labels:
      app: bootnode
      name: keystore-config-bootnode
  data:
    key: |-
      ${accountArrayPrivate[i]}

#------------------- config file for bootnode ------------------
- apiVersion: v1
  kind: ConfigMap
  metadata:
    name: besuconfig-bootnode
    namespace: ethereum-net
    labels:
      app: bootnode
      name: besuconfig-bootnode
  data:
    besuconfig: |-
      network-id=123456
      rpc-http-enabled=true
      rpc-http-api=["ETH","NET","IBFT","WEB3","ADMIN","TXPOOL"] 
      host-whitelist=["*"] 
      rpc-http-cors-origins=["*"]
      rpc-http-port=8545
      rpc-http-host="0.0.0.0"
      rpc-ws-enabled=true
      rpc-ws-host="0.0.0.0"
      rpc-ws-port=8546
      rpc-ws-api=["ETH","NET","CLIQUE","WEB3","ADMIN","TXPOOL"]
      min-gas-price=0
      target-gas-limit="715000000"
      tx-pool-max-size="80000000"
      tx-pool-hashes-max-size="80000000"
      
EOF
# Configure Gas Free Networks
# Gas Free Network
#https://besu.hyperledger.org/en/stable/HowTo/Configure/FreeGas/
cat << EOF
#---------------------------------= BOOT NODE SERVICE =---------------------------------------

- apiVersion: v1
  kind: Service
  metadata:
    namespace: ethereum-net
    name: besu-bootnode-svc
    labels:
      app: bootnode
      tier: backend
      name: besu-bootnode-svc
  spec:
    selector:
      app: bootnode
      tier: backend
      name: bootnode
    type: ClusterIP
    #externalTrafficPolicy: Cluster
    ports:
      - name: besu-bootnode-ipc-discovery
        protocol: UDP
        port: 30303
        targetPort: 30303

EOF

cat << EOF

- apiVersion: apps/v1
  kind: StatefulSet
  metadata:
    namespace: ethereum-net
    name: besu-bootnode
    labels:
      app: bootnode
      tier: backend
      name: besu-bootnode
  spec:
    selector:
      matchLabels:
        app: bootnode
    replicas: 1
    serviceName: besu-bootnode
    template:
      metadata:
        name: besu-bootnode
        labels:
          app: bootnode
          tier: backend
          name: bootnode
      spec:
        containers:
        - name: besu-bootnodeinit-container
          image: hyperledger/besu:latest
          imagePullPolicy: IfNotPresent
          securityContext:
            runAsUser: 0
          command: [ "sh" ]
          args:
          - "-cx"
          - "rm -rf /etc/besu/bootnode;rm -rf /etc/testnet/bootnode; mkdir -p /etc/testnet/bootnode;
            mkdir -p /etc/besu/bootnode;
            cp /etc/besuconfigmap/bootnode/besuconfig.toml /etc/besu/bootnode;
            /opt/besu/bin/besu --data-path=/etc/testnet/bootnode --genesis-file=/etc/besu/genesis/genesis-besu.json --config-file=/etc/besu/bootnode/besuconfig.toml;"
          volumeMounts:
          - name: bootnode-persistent-storage
            mountPath: /etc/testnet/bootnode/storage
          - name: bootnode-config-persistent-storage
            mountPath: /etc/besuconfigmap/bootnode
          - name: keystore-config-persistent-storage
            mountPath: /etc/testnet/bootnode/key
            subPath: key
          - name: besu-boot-node-persistent-storage
            mountPath: /etc/testnet/bootnode
          - name: genesis-config-persistent-storage
            mountPath: /etc/besu/genesis/genesis-besu.json
            subPath: genesis-besu.json
        volumes:
        - name: keystore-config-persistent-storage
          configMap:
            name: keystore-config-bootnode
            items:
            - key: key
              path: key
        - name: besu-boot-node-persistent-storage
          hostPath:
            path: /var/lib/docker/besu-storage/bootnode
        - name: genesis-config-persistent-storage
          configMap:
            name: genesis-config
            items:
            - key: genesis-besu.json
              path: genesis-besu.json
        - name: bootnode-persistent-storage
          persistentVolumeClaim:
          claimName: volume-bootnode
        - name: bootnode-config-persistent-storage
          configMap:
            name: besuconfig-bootnode
            items:
            - key: besuconfig
              path: besuconfig.toml
        
        

EOF


    else ##########################################################################end of boot node "if"
    #than we have all other nodes

cat << EOF

- apiVersion: v1
  kind: ConfigMap
  metadata:
    name: keystore-config-miner$i
    namespace: ethereum-net
    labels:
      app: miner
      name: keystore-config-miner$i
  data:
    key: |-
      ${accountArrayPrivate[i]}

EOF


cat << EOF
#---------------------------------=CONFIG MAP NODE $i=---------------------------------------
- apiVersion: v1
  kind: ConfigMap
  metadata:
    name: besuconfig-miner$i
    namespace: ethereum-net
    labels:
      app: miner
      name: besuconfig-miner$i
  data:
    besuconfig: |-
      network-id=123456
      rpc-http-enabled=true
      rpc-http-api=["ETH","NET","IBFT","WEB3","ADMIN","TXPOOL"] 
      host-whitelist=["*"]
      rpc-http-cors-origins=["*"] 
      rpc-http-port=8545
      rpc-http-host="0.0.0.0"
      rpc-ws-enabled=true
      rpc-ws-host="0.0.0.0"
      rpc-ws-port=8546
      rpc-ws-api=["ETH","NET","CLIQUE","WEB3","ADMIN","TXPOOL"]
      min-gas-price=0
      target-gas-limit="715000000"
      tx-pool-max-size="80000000"
      tx-pool-hashes-max-size="80000000"
      

EOF


cat << EOF
- apiVersion: apps/v1
  kind: StatefulSet
  metadata:
    namespace: ethereum-net
    labels:
      app: miner
      tier: backend
      name: besu-miner$i
      serviceSelector: ethereum-node
    name: besu-miner$i
  spec:
    selector:
      matchLabels:
        app: miner
    replicas: 1
    serviceName: besu-miner$i
    template:
      metadata:
        name: besu-miner$i
        labels:
          app: miner
          tier: backend
          name: miner$i
      spec:
        containers:
        - name: miner$i-init-container
          image: hyperledger/besu:latest
          imagePullPolicy: Always
          securityContext:
            runAsUser: 0
          command: [ "sh" ]
          args:
          - "-cx"
          - "rm -rf /etc/testnet/miner$i; mkdir /etc/testnet/miner$i; rm -rf /etc/besu/miner$i;
            mkdir -p /etc/besu/miner$i;
            cp /etc/besuconfigmap/miner$i/besuconfig.toml /etc/besu/miner$i;
            /opt/besu/bin/besu --data-path=/etc/testnet/miner$i/data --genesis-file=/etc/besu/genesis/genesis-besu.json --config-file=/etc/besu/miner$i/besuconfig.toml --bootnodes=enode://80492727fe2e43dfa991496b6bfa7cedd28d7a48a6582350226cf96a5157073cff1543a4689342d364b6fb0f671e5bf9b9fdecf44cb099ffe3e75d2719e199fc@\$BESU_BOOTNODE_SVC_SERVICE_HOST:30303;"
          ports:
            - containerPort: 8545
            - containerPort: 8546
              protocol: UDP
            - containerPort: 30303
          volumeMounts:
          - name: miner$i-persistent-storage
            mountPath: /etc/testnet/miner$i
          - name: miner$i-config-persistent-storage
            mountPath: /etc/besuconfigmap/miner$i
          - name: keystore-config-persistent-storage
            mountPath: /etc/testnet/miner$i/data/key
            subPath: key
          - name: besu-boot-node-persistent-storage
            mountPath: /etc/testnet/bootnode
          - name: genesis-config-persistent-storage
            mountPath: /etc/besu/genesis/genesis-besu.json
            subPath: genesis-besu.json
        
        volumes:
        - name: keystore-config-persistent-storage
          configMap:
            name: keystore-config-miner$i
            items:
            - key: key
              path: key
        - name: besu-boot-node-persistent-storage
          hostPath:
            path: /var/lib/docker/besu-storage/bootnode
        - name: genesis-config-persistent-storage
          configMap:
            name: genesis-config
            items:
            - key: genesis-besu.json
              path: genesis-besu.json
        - name: miner$i-persistent-storage
          persistentVolumeClaim:
          claimName: volume-miner$i
        - name: miner$i-config-persistent-storage
          configMap:
            name: besuconfig-miner$i
            items:
            - key: besuconfig
              path: besuconfig.toml
        
          
EOF

# define service for node
cat << EOF

#---------------------------------=NODES SERVICES $i=---------------------------------------
- apiVersion: v1
  kind: Service
  metadata:
    name: miner$i-svc
    namespace: ethereum-net
    labels:
      app: miner
      tier: backend
      name: miner$i-svc
  spec:
    selector:
      app: miner
      tier: backend
      name: miner$i
    ports:
      - name: miner$i-jsonrpc
        protocol: TCP
        port: 8545
        targetPort: 8545
      - name: miner$i-wsrpc
        protocol: TCP
        port: 8546
        targetPort: 8546
      - name: miner$i-ipc-discovery
        protocol: TCP
        port: 30303
        targetPort: 30303     
      - name: miner$i-prometheusrpc
        protocol: TCP
        port: 9545
        targetPort: 9545
      
EOF

#end else
fi # end if for boot node


# define volume for node
cat << EOF
#---------------------------------=NODES PERSISTANT VOLUME $i=---------------------------------------
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: miner$i
    labels:
      type: local
  spec:
    storageClassName: manual
    capacity:
      storage: 20Gi
    accessModes:
      - ReadWriteOnce
    persistentVolumeReclaimPolicy: Delete
    hostPath:
      #type: DirectoryOrCreate
      path: "/datas/miner$i"
EOF

# define volume claim for node
cat << EOF
#--------------------------=PERSISTENT VOLUME CLAIM $i=------------------------------

- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: volume-miner$i
    namespace: ethereum-net
  spec:
    storageClassName: manual
    accessModes:
    - ReadWriteOnce
    resources:
      requests:
        storage: 20Gi

EOF

done ############## end for loop

#####################Added a Single WebSocket Services to access
cat << EOF

#--------------------------=ONE SERVICE FOR ALL NODE (websocket)=--------------------------------

- apiVersion: v1
  kind: Service
  metadata:
    name: ethereum-ws-service
    namespace: ethereum-net
  spec:
    type: ClusterIP
    selector:
      app: miner 
    ports:
      - name: "8546"
        protocol: TCP
        port: 8546
        targetPort: 8546
EOF

#####################Added a Single WebSocket Services to access
cat << EOF

#--------------------------=ONE SERVICE FOR ALL NODE (HTTP)=--------------------------------

- apiVersion: v1
  kind: Service
  metadata:
    name: ethereum-http-service
    namespace: ethereum-net
  spec:
    type: ClusterIP
    selector:
      app: miner 
    ports:
      - name: "8545"
        protocol: TCP
        port: 8545
        targetPort: 8545
EOF


###################### create weird extraData field
((valueextra=$NBNODES-3))
filed_extraData=${extraDataArray[$valueextra]}

###################### end create weird extraData field

###################### init balances
filed_balances=""
for (( i=0; i<=$NBNODES; i++ )) # start 0 => include bootnode
do
filed_balances+=$(cat <<EOF
            "${accountArrayAddress[i]}": {
              "balance": "0x200000000000000000000000000000000000000000000000000000000000000"
            },

EOF
)

done
filed_balances=${filed_balances::-1} #DON'T FORGET TO REMOVE LAST CHARACTER: ${filed_balances::-1}
###################### end init balances

cat << EOF
#--------------------------= genesis-config =--------------------------------
- apiVersion: v1
  kind: ConfigMap
  metadata:
    name: genesis-config
    namespace: ethereum-net
    labels:
      app: kuberneteth
      name: genesis-config
  data:
    genesis-besu.json: |-
      {
        "config": {
          "chainId": 123456,
          "homesteadBlock": 0,
          "eip150Block": 0,
          "eip155Block": 0,
          "eip158Block": 0,
          "byzantiumBlock": 0,
          "qbft": {
            "blockperiodseconds": 2,
            "epochlength": 30000,
            "requesttimeoutseconds": 4
            }
        },
        "nonce": "0x0",
        "timestamp": "0x5cdec502",
        "gasLimit": "0x2A9E08C0",
        "difficulty" : "0x1",
        "mixHash": "0x63746963616c2062797a616e74696e65206661756c7420746f6c6572616e6365",
        "coinbase": "0x0000000000000000000000000000000000000000",
        "extraData": "${filed_extraData}",
        "alloc": {
            ${filed_balances}
        },
        "number": "0x0",
        "gasUsed": "0x0",
        "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000"
      }
EOF

#https://ethereum.stackexchange.com/a/2377
#        "extraData" : "",




###################### app monitor config
app_monitor_config=""
for (( i=1; i<=$NBNODES; i++ )) # start 1 => no bootnode
do
app_monitor_config+=$(cat <<EOF
        {
          "name"              : "miner$i",
          "cwd"               : ".",
          "script"            : "app.js",
          "log_date_format"   : "YYYY-MM-DD HH:mm Z",
          "merge_logs"        : false,
          "watch"             : false,
          "exec_interpreter"  : "node",
          "exec_mode"         : "fork_mode",
          "env":
          {
            "NODE_ENV"        : "production",
            "RPC_HOST"        : "miner$i-rpchost",
            "RPC_PORT"        : "8545",
            "LISTENING_PORT"  : "30303",
            "INSTANCE_NAME"   : "miner$i",
            "CONTACT_DETAILS" : "",
            "WS_SERVER"       : "localhost:3001",
            "WS_SECRET"       : "123",
            "VERBOSITY"       : 3
          }
        },

EOF
)

done
app_monitor_config=${app_monitor_config::-1} #DON'T FORGET TO REMOVE LAST CHARACTER: ${app_monitor_config::-1}
###################### end app monitor config


###################### frontend monitor config
frontend_monitor_config=""
for (( i=1; i<=$NBNODES; i++ )) # start 1 => no bootnode
do
frontend_monitor_config+=$(cat <<EOF
            sed -i \"s/miner$i-rpchost/\$MINER${i}_SVC_SERVICE_HOST/g\" /ethmonitor/app.json;
 
EOF
)

done
###################### end frontend monitor config


cat << EOF
####################################### ETH MONITOR STUFF #########################
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    #creationTimestamp: null
    namespace: ethereum-net
    labels:
      name: volume-ethmonitor
    name: volume-ethmonitor
  spec:
    storageClassName: manual
    accessModes:
    - ReadWriteOnce
    resources:
      requests:
        storage: 10Gi

- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: monitor
    labels:
      type: local
  spec:
    storageClassName: manual
    capacity:
      storage: 10Gi
    accessModes:
      - ReadWriteOnce
    persistentVolumeReclaimPolicy: Delete
    hostPath:
      #type: DirectoryOrCreate
      path: "/datas/monitor"

- apiVersion: v1
  kind: ConfigMap
  metadata:
    name: monitor-config
    namespace: ethereum-net
    labels:
      app: kuberneteth
      name: monitor-config
  data:
    app.json: |-
      [
        ${app_monitor_config}
      ]

- apiVersion: v1
  kind: Service
  metadata:
    namespace: ethereum-net
    name: monitor-svc
    labels:
      app: kuberneteth
      tier: frontend
      name: monitor-svc
  spec:
    selector:
      app: kuberneteth
      tier: frontend
    type: ClusterIP
    ports:
      - name: monitor-port
        protocol: TCP
        port: 3001


- apiVersion: apps/v1
  kind: StatefulSet
  metadata:
    namespace: ethereum-net
    name: monitor
  spec:
    selector:
      matchLabels:
        app: kuberneteth
    replicas: 1
    serviceName: monitor
    template:
      metadata:
        name: monitor
        labels:
          app: kuberneteth
          tier: frontend
          name: monitor
      spec:
        initContainers:
        - name: monitor-init-container
          image: ijsfd/eth-netstats
          imagePullPolicy: IfNotPresent
          command: [ "sh" ]
          args:
          - "-cx"
          - "cp -r /eth-net-intelligence-api/* /ethmonitor;
            cp /monitor-configmap/app.json /ethmonitor/app.json;
            $frontend_monitor_config
            exit 0;"
          volumeMounts:
          - name: monitor-configmap-volume
            mountPath: /monitor-configmap/app.json
            subPath: app.json
          - name: monitor-config-temp
            mountPath: /ethmonitor
        containers:
        - name: eth-netstats-container
          image: ijsfd/eth-netstats
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 3001
          env:
          - name: WS_SECRET
            value: "123"
          - name: PORT
            value: "3001"
        - name: eth-net-intelligence-api-container
          image: ijsfd/eth-net-intelligence-api
          imagePullPolicy: IfNotPresent
          volumeMounts:
          - name: monitor-config-temp 
            mountPath: /eth-net-intelligence-api/app.json
            subPath: app.json
        volumes:
        - name: monitor-configmap-volume
          configMap:
            name: monitor-config
            items:
            - key: app.json
              path: app.json
        - name: monitor-config-persistent-storage
          persistentVolumeClaim:
            claimName: volume-ethmonitor
        - name: monitor-config-temp
          emptyDir: {} 

EOF

cat << EOF
####################################### BENCHMARK MACHINE #########################

- apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: ubuntu
    namespace: ethereum-net
  spec:
    replicas: 1
    selector:
        matchLabels:
          name: ubuntu-deployment
    template:
      metadata:
        name: ubuntu-deployment
        labels:
          app: ubuntu
          tier: backend
          name: ubuntu-deployment
      spec:
        containers:
        - name: ubuntu
          image: ubuntu
          command:
            - "sleep"
            - "604800"
          resources:
            limits:
              cpu: "12"
              memory: "12Gi"
            requests:
              cpu: "10"
              memory: "10Gi"
          imagePullPolicy: IfNotPresent
        restartPolicy: Always
EOF

cat << EOF
####################################### MongoDB MACHINE #########################
- apiVersion: apps/v1
  kind: StatefulSet
  metadata:
    name: mongodb-standalone
  spec:
    serviceName: database
    replicas: 1
    selector:
      matchLabels:
        app: database
    template:
      metadata:
        labels:
          app: database
          selector: mongodb-standalone
      spec:
        containers:
        - name: mongodb-standalone
          image: mongo:4.0.8
          env:
            - name: MONGO_INITDB_ROOT_USERNAME
              value: guest
            - name: MONGO_INITDB_ROOT_PASSWORD
              value: guest
          resources:
              limits:
                cpu: "12"
                memory: "12Gi"
              requests:
                cpu: "10"
                memory: "10Gi"
          imagePullPolicy: IfNotPresent
        restartPolicy: Always

EOF

#####################Added a Single WebSocket Services to access
cat << EOF

#--------------------------= SERVICE FOR MONGODB=--------------------------------

- apiVersion: v1
  kind: Service
  metadata:
    name: mongodb-service
    namespace: ethereum-net
  spec:
    type: ClusterIP
    selector:
      app: database 
    ports:
      - name: "27017"
        protocol: TCP
        port: 27017
        targetPort: 27017
EOF