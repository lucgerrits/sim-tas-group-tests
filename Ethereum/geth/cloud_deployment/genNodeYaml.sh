#!/bin/bash

NBNODES=24
#list of validators available
# Boot Node Key generated
bootnodekey="82a5635ba83da5d215c1588692fb0c7e9b244af0c265731dac69c39ad7dcf83f"
bootnodeaddress="enode://b35312c02f067d69549fb4c68d494af4ea2f758075ce925246ce62ce73ed2a5f25d5fc935bacab20d39bb734f78f1d131203b4f2ee6482de9367092271f21454@'\$GETH_BOOTNODE_SVC_SERVICE_HOST':0?discport=30301"
accountArray=("UTC--2021-07-19T13-43-12.906030662Z--284971d0df1bf4a2e5b053261b8beffdc6ca8e0a" "UTC--2021-07-19T13-43-14.403483777Z--6c72e4c3c645a5d84b44f6f143ce559c9e8d8153" "UTC--2021-07-19T13-43-15.836608918Z--77c1113fb3da88e6a0f6b8b1af7c5f15286f5253" "UTC--2021-07-19T13-43-17.272480165Z--5708c9ed0dc25097f24903d27c13c9b4c18f3e54" "UTC--2021-07-19T13-43-18.733289023Z--5e99b8f68e317e40f5b64fb427d6ddd86fb6d89b" "UTC--2021-07-19T13-43-20.173237944Z--c36194ca819c884d556eab67a0a3a1d760dcdff4" "UTC--2021-07-19T13-43-21.680518625Z--b5c9fcfe7acf4473f6369a93e947f73aebb4646c" "UTC--2021-07-19T13-43-23.192190232Z--e6b1c4a245d8ddab785dc321b3b87c066e91cacd" "UTC--2021-07-19T13-43-24.690592771Z--3eeb48c7eaa2b850fe3b1bfd69c1dedc93cf8333" "UTC--2021-07-19T13-43-26.149719800Z--ff8ebc1a54092d738680c9092abae5cefa0005b2" "UTC--2021-07-19T13-43-27.606926482Z--efe7a9c39ec64864d23eb306054d2570b234d3f2" "UTC--2021-07-19T13-43-29.037045391Z--b42a184af3bd28c96f4904025d3833a83ebfd74e" "UTC--2021-07-19T13-43-30.587820322Z--1dc8a2ae48ec97f2ef5c3a5712abbf02667d11d2" "UTC--2021-07-19T13-43-32.248838399Z--d1dfa6cdbb5ce03c9629a52a3fff5793146cb89f" "UTC--2021-07-19T13-43-33.937131558Z--cb856028b25efde34192df0722abeb583033ee52" "UTC--2021-07-19T13-43-35.397423354Z--d113a83240df4cbf61ea093664d97737662ad52b" "UTC--2021-07-19T13-43-36.848791366Z--878348425db945254ee759040e383c8897839454" "UTC--2021-07-19T13-43-38.319624156Z--d70abedc871f939abd60b36164ca443cfe6063ea" "UTC--2021-07-19T13-43-39.806519212Z--5e71729cf96c2fdb16265cb708d1df2cb91cd6a9" "UTC--2021-07-19T13-43-41.251379528Z--697a5d50fcea7d9ab93fcefd6570f0fa15e945ab" "UTC--2021-07-19T13-43-42.691489781Z--58d5a1fda3be5ac1ef6d9bd4f575c2321e44b1c6" "UTC--2021-07-19T13-43-44.181275897Z--c6962fd176d408568bf32642ccfdbad501eec92d" "UTC--2021-07-19T13-43-45.615766742Z--928cf91fa667b5b82cc745f0a1503fed4faffbf6" "UTC--2021-07-19T13-43-47.043056095Z--7e4f41306fb48540a317e0f96a89f0ffa3db12fc" "UTC--2021-07-19T13-43-48.514673902Z--9ba86e41f9b1dda4e6c93b34d3e1653d88112a0a")
accountArrayPublic=("284971d0df1bf4a2e5b053261b8beffdc6ca8e0a" "6c72e4c3c645a5d84b44f6f143ce559c9e8d8153" "77c1113fb3da88e6a0f6b8b1af7c5f15286f5253" "5708c9ed0dc25097f24903d27c13c9b4c18f3e54" "5e99b8f68e317e40f5b64fb427d6ddd86fb6d89b" "c36194ca819c884d556eab67a0a3a1d760dcdff4" "b5c9fcfe7acf4473f6369a93e947f73aebb4646c" "e6b1c4a245d8ddab785dc321b3b87c066e91cacd" "3eeb48c7eaa2b850fe3b1bfd69c1dedc93cf8333" "ff8ebc1a54092d738680c9092abae5cefa0005b2" "efe7a9c39ec64864d23eb306054d2570b234d3f2" "b42a184af3bd28c96f4904025d3833a83ebfd74e" "1dc8a2ae48ec97f2ef5c3a5712abbf02667d11d2" "d1dfa6cdbb5ce03c9629a52a3fff5793146cb89f" "cb856028b25efde34192df0722abeb583033ee52" "d113a83240df4cbf61ea093664d97737662ad52b" "878348425db945254ee759040e383c8897839454" "d70abedc871f939abd60b36164ca443cfe6063ea" "5e71729cf96c2fdb16265cb708d1df2cb91cd6a9" "697a5d50fcea7d9ab93fcefd6570f0fa15e945ab" "58d5a1fda3be5ac1ef6d9bd4f575c2321e44b1c6" "c6962fd176d408568bf32642ccfdbad501eec92d" "928cf91fa667b5b82cc745f0a1503fed4faffbf6" "7e4f41306fb48540a317e0f96a89f0ffa3db12fc" "9ba86e41f9b1dda4e6c93b34d3e1653d88112a0a")
accountArrayData=("{\"address\":\"284971d0df1bf4a2e5b053261b8beffdc6ca8e0a\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"06ae995a68b9ceae39b496d40cb913d7e92a27852b5ebc9144555f7e86144078\",\"cipherparams\":{\"iv\":\"8a2db752fc1f4eb77f4f4151ddbfe977\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"b05b78b23158b1ff7f66b3d3711070212511a929832c2763186437b6ef31636f\"},\"mac\":\"9b835a5c889f6ca7b36aa2286303d906ea6a113e5dfd843e301d6e37399e4580\"},\"id\":\"1f90a98e-9fb7-4f49-88e3-9dddeddc98d5\",\"version\":3}" "{\"address\":\"6c72e4c3c645a5d84b44f6f143ce559c9e8d8153\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"66aee84f2d3f5c931738848650282ac7e55aa6423d585188525bd14b0f056500\",\"cipherparams\":{\"iv\":\"9f12d12dff26469f89369a43c55ae48b\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"1f4f3690dd3b59839e53c458f7be8a398d8487303740325c9f1d762c4dff6f04\"},\"mac\":\"47ccc219265d0800f6df292abd4a47a1ef629322b32bc8a7d08630ce211d34b3\"},\"id\":\"13f5148b-bda5-4279-9777-fdf4f37f0038\",\"version\":3}" "{\"address\":\"77c1113fb3da88e6a0f6b8b1af7c5f15286f5253\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"e10ea88900480bf2a9236740aefa0f7ce81e506bb70559cb2b6960b4c335a3f7\",\"cipherparams\":{\"iv\":\"c04febbe8b5c2d4014ddd0d4c36bbc67\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"577c66b49aa956267f6cfbf112c39ac41ae9eb8a508fcc9b89763891f0917d5c\"},\"mac\":\"02bd56eb20400a0620d2d3456e89734af5eb364f2dd7c3d3e858447f9399f8f8\"},\"id\":\"83d18bc3-625d-4954-9425-ee81bdc84a16\",\"version\":3}" "{\"address\":\"5708c9ed0dc25097f24903d27c13c9b4c18f3e54\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"7a3871137b029dc9acddac9267b119345b7533f31e7e0a178e19e32e59f8d392\",\"cipherparams\":{\"iv\":\"e30060b19ea0c0742dcd48ae2c951cdb\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a2d035a694b419f4333fc6aaa5dd2b94475d614a897efb6f36556d78abb51c49\"},\"mac\":\"01f215f0ccb707fcf7822bb8adb8aa05f2806c17cf697d783356e2c842f3a950\"},\"id\":\"4a671d59-728f-41f3-99c6-6b01733e849d\",\"version\":3}" "{\"address\":\"5e99b8f68e317e40f5b64fb427d6ddd86fb6d89b\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"2a967eeb1dbd3b9dd3d484c721072e4eafc0ea2b23729b4ed9b93e5ad1201500\",\"cipherparams\":{\"iv\":\"c9b7bf63b0e913ea00e0cb4d128a0408\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"e37b448590113e34d70825e0527bf5e63e7dc3728f167d2667959b811e385398\"},\"mac\":\"f3963e30f72a345a56a09216f9fabc8d6ca2d46af43471d57ff0af00d95e9001\"},\"id\":\"e0a62ddb-6eb5-4e6d-9637-e189d6a5e9bc\",\"version\":3}" "{\"address\":\"c36194ca819c884d556eab67a0a3a1d760dcdff4\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"bdc7a07020b23c3401ffc95423a08c4f8fd15e2dd401691ba51d83d661828016\",\"cipherparams\":{\"iv\":\"edb9823a2bd03d6d5f4678b728992f5b\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"25ff6dddda11ca5debc8a2051140eb380672af5f63b739feaa103e886fd242d5\"},\"mac\":\"778e1d1a1d1f4aafd39ac2c84b7172a587d563e81b1714ee23666f69a6568393\"},\"id\":\"fc45e16e-f1bf-40ef-9e51-2217d5e64088\",\"version\":3}" "{\"address\":\"b5c9fcfe7acf4473f6369a93e947f73aebb4646c\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"cbf7968cda3b145f14806c41580c17b73956a6cf8320574f1ea8432f25f68102\",\"cipherparams\":{\"iv\":\"d0ee52345a7f4ec5735917fa4d6d6211\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"413bc0c1bfb2ad076233bfc5eb855be9c9621e6a3efc1c2f82c5103177b121da\"},\"mac\":\"220ce100b0a4132e0c2577029178b06c5f6898b67db4cb43fd26ae55bcc7cdfa\"},\"id\":\"e19410cb-fe01-41eb-bef7-453a49b94614\",\"version\":3}" "{\"address\":\"e6b1c4a245d8ddab785dc321b3b87c066e91cacd\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"06c2ba6f5108e028a911b9669b272a632f630341ac9681684b0f6d2a3eea1a00\",\"cipherparams\":{\"iv\":\"e7e972e3b15f8e7911a436f6d151c6e2\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"c2b90155299136bcd13c03b1d36955cf5b60e8af44646d5148dd5a32ebd31f33\"},\"mac\":\"59e337d521cf6da12a7bc4cba82b3b02311713ce5217613b5471a813058b6333\"},\"id\":\"98522431-d944-4d16-8ee6-cde46bf6ebaf\",\"version\":3}" "{\"address\":\"3eeb48c7eaa2b850fe3b1bfd69c1dedc93cf8333\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"66346480043a453223008f5dd06da4d4833aee97a99c07d5d9d0559d80b62e6c\",\"cipherparams\":{\"iv\":\"17c1b87a004b7348624370945fdb200d\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"92867d6a271bcd14230ce0d72cf54cebfd11888e5086ec6ae257e853008d8c5b\"},\"mac\":\"707528a26f819f86fa504753657f35d8aec697d0b96ea348d70da120ce4591b8\"},\"id\":\"f2cc17f0-e50b-4bdf-9562-482df1b5bbfb\",\"version\":3}" "{\"address\":\"ff8ebc1a54092d738680c9092abae5cefa0005b2\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"5e84917aca6b6cf52b962717a0e3764d49d377eed7ede946b835c14b46c02f58\",\"cipherparams\":{\"iv\":\"b8bd495aeace30f98b1aa73ff6ee9e5a\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"7845bcf6278ab42a12875315159e558f91c30c8beb00802c6c08ac15e916a6ea\"},\"mac\":\"3fdffa52287310d038a7f7d3553db830cc1365824b07cedff56dae28970f5c63\"},\"id\":\"73b397f3-d901-43ee-8c6e-43c7f7a67390\",\"version\":3}" "{\"address\":\"efe7a9c39ec64864d23eb306054d2570b234d3f2\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"08d545adfe868c89f32c1e0529d7826da376ff875a5ffd37aaf66d3706b97c44\",\"cipherparams\":{\"iv\":\"3f42e69018927232ae28ae8c5103b0c4\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"05cf24eb47955f4165acd1919b848074a6d610251fbf46a498232a3320db75da\"},\"mac\":\"6ba7b772df4c3176e7e836c566dd57300a473e507f9456760dc1a80192e7eea7\"},\"id\":\"c067786f-41cd-486b-850a-aadb82c87f8a\",\"version\":3}" "{\"address\":\"b42a184af3bd28c96f4904025d3833a83ebfd74e\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"9ccab8a02f4e14654c8d310b1c4707a15d632c5c8f22bc962dadd7ab07ae13ac\",\"cipherparams\":{\"iv\":\"adedbb80fad9a7ef0644cf6459ee014d\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a62aa79dc7694fabb511b703e01217543b60a27b97d5e3d9cd95666f751b8407\"},\"mac\":\"17f40206093ab4d2ea63bb160d3ecfbca00b8ede290d554d6ac48ccae253bec9\"},\"id\":\"2b62f844-3961-40f6-9f2f-88041125025d\",\"version\":3}" "{\"address\":\"1dc8a2ae48ec97f2ef5c3a5712abbf02667d11d2\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"00a7e72b3feaba42d4c98a153f7f6240a1f236c1c311e1d3ae71e6069c3ccbf1\",\"cipherparams\":{\"iv\":\"7705e1235ec83e00b6e0c91adfe2accd\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"783c017a115313d5719a9a172e07b4d13a1f86549657c3972888e8e7db6f9ff4\"},\"mac\":\"9381ae8aab2f2697c5a7669671376b3fdf821cae39d58b2aa8dc6f46331dc90a\"},\"id\":\"fa9baa02-089d-49e4-879f-7821d72637b5\",\"version\":3}" "{\"address\":\"d1dfa6cdbb5ce03c9629a52a3fff5793146cb89f\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"e4c17cffdfadb79efca910df36b593e61a332cd245786319dafcfde2e3dd4b9a\",\"cipherparams\":{\"iv\":\"6939bc1cfb8fdaa0e419ceea36a8c727\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"e942fe2243a1a2d8c082244b9ab51f1932164b496f9245f458ee302faf29e002\"},\"mac\":\"bd85d73d85031661c15ed7107d5ff49599ff7149afa63a15d1fd53b27de1f1f0\"},\"id\":\"af306475-4c99-4344-a47c-79afac0f0c89\",\"version\":3}" "{\"address\":\"cb856028b25efde34192df0722abeb583033ee52\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"77e686b0147ff9972d879887879ad7fa98112eab34861463fd8586b279ce1bd7\",\"cipherparams\":{\"iv\":\"03e01e0b30ac30ca109d72123152e305\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"76498dc2971fa7a5690d0edbb2767f020e3223e20d9e7e097dc735cb1804ade2\"},\"mac\":\"1e866a4ea63c9a2379ecc640b30aed17c81358cffecf9a576ba70ff9fa35ccdb\"},\"id\":\"07215e7e-32ad-4c79-9caf-7bd992991be6\",\"version\":3}" "{\"address\":\"d113a83240df4cbf61ea093664d97737662ad52b\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"c7f2153d7db3b115be912e8c4877207e6d331e58fbe8bf3691450455da1e15bf\",\"cipherparams\":{\"iv\":\"4b058dbf1b362fa10c895d7b4cbd047c\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"e62344dc8f9b9091d23ac08baee51962a2f01c02eac66e9e361cb4e733d63c95\"},\"mac\":\"949334feae4fa2fcf8af46dcbcbda1e581c4ead909631f370ce6ffd5eb887d2c\"},\"id\":\"92ba3c4e-9f75-4e10-88ad-761b77c3da24\",\"version\":3}" "{\"address\":\"878348425db945254ee759040e383c8897839454\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"96f0837676b80d002bf19a78858a85d5a671e543e63c18952b14d26d3e1b9170\",\"cipherparams\":{\"iv\":\"b8dc2b4bf4399578762f8c99eab232c0\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a9212d74978ef66c9c9cb545058a0b6b4644eaedaaaf6534b236e02ce23dddfe\"},\"mac\":\"f309bbd3e61a5a38f9549700d4adc61d2504ccbaabf59c1fabf1fffd3d868529\"},\"id\":\"9d2296e7-6765-48f2-8d03-1059ea7f4918\",\"version\":3}" "{\"address\":\"d70abedc871f939abd60b36164ca443cfe6063ea\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"d6804c9a0fd888b4d6d7982c673ae1376a77045248260f2a1fc7bcf56a83d888\",\"cipherparams\":{\"iv\":\"1302b401966653c629854966f7537411\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"53af52193f918839fecfbbd5edb66c6d0a745f5f7097d1f2748d4101c3c825e5\"},\"mac\":\"9576054c3bfd338ce363876541e9ea8cee0394caa2073cf5f1d63b094ded8116\"},\"id\":\"7f9a93e6-35d1-4995-ab2d-a47fef55f182\",\"version\":3}" "{\"address\":\"5e71729cf96c2fdb16265cb708d1df2cb91cd6a9\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"8596e3b28e251fea6364ee33aa5b2e236178f164bfe2e819210909aad1ac2f30\",\"cipherparams\":{\"iv\":\"5a1d7fe90826f1f51d94480cfe94a2b9\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a69a285a28a776e50655c07333fcf4b2c63fb66744ddad357f8afc92054dc0a4\"},\"mac\":\"b9fad838a95ba88c13cc82513349e53e12df8d907680b5adae72126ae0fadc31\"},\"id\":\"49134d12-3c0f-4244-8719-99b53637ef7a\",\"version\":3}" "{\"address\":\"697a5d50fcea7d9ab93fcefd6570f0fa15e945ab\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"8813f0d4b66339e378c7cebfa1c7dc8037bde001f40bcff4e382307069545444\",\"cipherparams\":{\"iv\":\"5fd9c4da6430e37df7b7a35aa79fdf41\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"9458d4b65c54bb839df864a6c8c0fce4ddad0d73d51c657d4268addfce333ffa\"},\"mac\":\"e457c4204c707dded5979271eec2ba238e87d58e8a432ebb549ee74a98ef0951\"},\"id\":\"ef5a2b3d-9153-4d05-8c55-342d30f83497\",\"version\":3}" "{\"address\":\"58d5a1fda3be5ac1ef6d9bd4f575c2321e44b1c6\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"a9bc37ee30526be469bc315cf02417b57d6107531e7760cda06332d57d941bd9\",\"cipherparams\":{\"iv\":\"80b9d143e8a5ab09e2260778fb02e882\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"c1b967267b70a76178b25b8f4c962c6c7e99e428c74f13bf530b76c74b9bbc7f\"},\"mac\":\"e2510b63139bc4324eab43621512a9e2aea5a6f77d89dffd6a0a31973d3f9f38\"},\"id\":\"7e904997-ea62-450d-93d9-072229b0acac\",\"version\":3}" "{\"address\":\"c6962fd176d408568bf32642ccfdbad501eec92d\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"dfc683fa24db309de1131e5ab77a28701e2e1c4727d6e8e0397434bf44260e0e\",\"cipherparams\":{\"iv\":\"cb9a3f00f8b7c7301b96964cd3686f26\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"2ccc2624851d2e0d714a55d158677443098394b574bd5897eee9f1038dcc0da4\"},\"mac\":\"3911a259bd0113c8ff3f0f38e63bdda19934e6e5cd00f552204765acf18c8147\"},\"id\":\"cabce96e-c536-42eb-955d-983c497b4bd9\",\"version\":3}" "{\"address\":\"928cf91fa667b5b82cc745f0a1503fed4faffbf6\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"c21a594cde3f3a0d5cba9e41c8b10b7ee52dfa1b8594d3b0ec5ce6bd067232ae\",\"cipherparams\":{\"iv\":\"70e3d5372ddd7d51b22f8e2fb1fdf4b4\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"c4b10c274095c8179e91004b2cd7b86e3ccc4c3335e29b11d807355a5df6a642\"},\"mac\":\"cc72dd685efeec1a1bfb8a76fa8d140bf965a73280ecab4b05cf1d5c6317eff7\"},\"id\":\"a773b62e-f31d-4eef-9401-441889a410ab\",\"version\":3}" "{\"address\":\"7e4f41306fb48540a317e0f96a89f0ffa3db12fc\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"69cc50b485810e8c635932b9e040fd1aa86abbc6b7092fbdbe4cc4accc124e35\",\"cipherparams\":{\"iv\":\"929e2fb1228beff68a6dc265ede3f4a9\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"bb46b4f6b36dabf79b4e931ac106da3c3c60562e50f8fb4cf7a72d64e409f44b\"},\"mac\":\"fa64e1754ca76ace55e8c8d5862f5b785aee09fb478d21aca73182ca83099d08\"},\"id\":\"91066e28-8281-4cb1-ad3f-86fbc2774c76\",\"version\":3}" "{\"address\":\"9ba86e41f9b1dda4e6c93b34d3e1653d88112a0a\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"874f88584d57fe33917465fd4311c77fff0df1c9696f760d8a02918e7fc4b5e5\",\"cipherparams\":{\"iv\":\"93792502a39da77c196a9362a8959a5d\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"353dc55d597089d1da5f511b254cf24fc953f5bab1ddc85cf321259bdf645dc0\"},\"mac\":\"3c19aa660f2162389d2f2f156dd3cca65292d4668c43a4dd03c98893910a2475\"},\"id\":\"78fdc24e-f914-4564-bc6c-3384c2350340\",\"version\":3}")

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
    bootnode.key: |-
      $bootnodekey

#------------------- config file for bootnode ------------------
- apiVersion: v1
  kind: ConfigMap
  metadata:
    name: gethconfig-bootnode
    namespace: ethereum-net
    labels:
      app: bootnode
      name: gethconfig-bootnode
  data:
    gethconfig: |-
      [Eth]
      NetworkId = 123456
      SyncMode = "full"
      LightPeers = 100
      DatabaseCache = 768
      EnablePreimageRecording = false
      
      [Eth.Ethash]
      CacheDir = "ethash"
      CachesInMem = 2
      CachesOnDisk = 3
      DatasetDir = "/root/.ethash"
      DatasetsInMem = 1
      DatasetsOnDisk = 2
      PowMode = 0
      
      [Eth.TxPool]
      Locals = []
      NoLocals = false
      Journal = "transactions.rlp"
      Rejournal = 3600000000000
      PriceLimit = 0
      PriceBump = 0
      AccountSlots = 1000000
      GlobalSlots = 1000000
      AccountQueue = 1000000
      GlobalQueue = 1000000
      Lifetime = 10800000000000
      
      [Eth.GPO]
      Blocks = 20
      Percentile = 60
      
      
      [Node]
      UserIdent = "bootnode"
      DataDir = "/etc/testnet/bootnode"
      IPCPath = "/etc/testnet/bootnode/geth.ipc"
      HTTPHost = "0.0.0.0"
      HTTPPort = 8545
      HTTPCors = ["*"]
      HTTPVirtualHosts = ["*"]
      HTTPModules = ["eth", "net", "web3", "personal", "miner", "admin", "clique"]
      WSHost = "0.0.0.0"
      WSPort = 8546
      WSOrigins = ["*"]
      WSModules = ["net", "web3", "eth"]
      
      [Node.P2P]
      MaxPeers = 25
      NoDiscovery = false
      BootstrapNodes = []
      BootstrapNodesV5 = []
      StaticNodes = []
      TrustedNodes = []
      ListenAddr = ":30303"
      EnableMsgEvents = false

EOF

cat << EOF
#---------------------------------= BOOT NODE SERVICE =---------------------------------------

- apiVersion: v1
  kind: Service
  metadata:
    namespace: ethereum-net
    name: geth-bootnode-svc
    labels:
      app: bootnode
      tier: backend
      name: geth-bootnode-svc
  spec:
    selector:
      app: bootnode
      tier: backend
      name: bootnode
    type: ClusterIP
    #externalTrafficPolicy: Cluster
    ports:
      - name: geth-bootnode-ipc-discovery
        protocol: UDP
        port: 30303
        targetPort: 30303
      - name: geth-bootnode-discovery
        protocol: UDP
        port: 30301
        targetPort: 30301

EOF

cat << EOF  

- apiVersion: apps/v1
  kind: StatefulSet
  metadata:
    namespace: ethereum-net
    name: geth-bootnode
    labels:
      app: bootnode
      tier: backend
      name: geth-bootnode
  spec:
    selector:
      matchLabels:
        app: bootnode
    replicas: 1
    serviceName: geth-bootnode
    template:
      metadata:
        name: geth-bootnode
        labels:
          app: bootnode
          tier: backend
          name: bootnode
      spec:
        containers:
        - name: geth-bootnode-container
          image: ethereum/client-go:alltools-stable
          imagePullPolicy: IfNotPresent
          command: [ "sh" ]
          args:
          - "-cx"
          - " rm -rf /etc/testnet/bootnode;
            echo $bootnodekey > /etc/testnet/bootnode/bootnode.key;
            /usr/local/bin/bootnode -nodekey /etc/testnet/bootnode/bootnode.key;"
          volumeMounts:
          - name: bootnode-persistent-storage
            mountPath: /etc/testnet/bootnode/storage
          - name: bootnode-config-persistent-storage
            mountPath: /etc/gethconfigmap/bootnode
          - name: geth-boot-node-persistent-storage
            mountPath: /etc/testnet/bootnode
          - name: genesis-config-persistent-storage
            mountPath: /etc/geth/genesis/genesis-geth.json
            subPath: genesis-geth.json
        volumes:
        - name: keystore-config-persistent-storage
          configMap:
            name: keystore-config-bootnode
            items:
            - key: ${accountArray[i]}
              path: ${accountArray[i]}
        - name: geth-boot-node-persistent-storage
          hostPath:
            path: /var/lib/docker/geth-storage/bootnode
        - name: genesis-config-persistent-storage
          configMap:
            name: genesis-config
            items:
            - key: genesis-geth.json
              path: genesis-geth.json
        - name: bootnode-persistent-storage
          persistentVolumeClaim:
          claimName: volume-bootnode
        - name: bootnode-config-persistent-storage
          configMap:
            name: gethconfig-bootnode
            items:
            - key: gethconfig
              path: gethconfig.toml

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
    ${accountArray[i]}: |-
      ${accountArrayData[i]}

EOF


cat << EOF
#---------------------------------=CONFIG MAP NODE $i=---------------------------------------
- apiVersion: v1
  kind: ConfigMap
  metadata:
    name: gethconfig-miner$i
    namespace: ethereum-net
    labels:
      app: miner
      name: gethconfig-miner$i
  data:
    gethconfig: |-
      [Eth]
      NetworkId = 123456
      SyncMode = "full"
      LightPeers = 100
      DatabaseCache = 1024
      EnablePreimageRecording = false
      
      [Eth.Ethash]
      CacheDir = "ethash"
      CachesInMem = 2
      CachesOnDisk = 3
      DatasetDir = "/root/.ethash"
      DatasetsInMem = 1
      DatasetsOnDisk = 2
      PowMode = 0
      
      [Eth.TxPool]
      Locals = []
      NoLocals = false
      Journal = "transactions.rlp"
      Rejournal = 3600000000000
      PriceLimit = 0
      PriceBump = 0
      AccountSlots = 1000000
      GlobalSlots = 1000000
      AccountQueue = 100000
      GlobalQueue = 100000
      Lifetime = 10800000000000
      
      [Eth.GPO]
      Blocks = 20
      Percentile = 60
      
      [Node]
      UserIdent = "miner$i"
      DataDir = "/etc/testnet/miner$i"
      IPCPath = "/etc/testnet/miner$i/geth.ipc"
      HTTPHost = "0.0.0.0"
      HTTPPort = 8545
      HTTPCors = ["*"]
      HTTPVirtualHosts = ["*"]
      HTTPModules = ["eth", "net", "web3", "personal", "miner", "admin", "clique", "personal", "txpool", "debug"]
      WSHost = "0.0.0.0"
      WSPort = 8546
      WSOrigins = ["*"]
      WSModules = ["net", "web3", "eth", "clique", "web3", "personal", "miner", "txpool" , "admin", "debug"]
      
      [Node.P2P]
      MaxPeers = 25
      NoDiscovery = false
      BootstrapNodes = []
      BootstrapNodesV5 = []
      StaticNodes = []
      TrustedNodes = []
      ListenAddr = ":30303"
      EnableMsgEvents = false
      

EOF


cat << EOF
- apiVersion: apps/v1
  kind: StatefulSet
  metadata:
    namespace: ethereum-net
    labels:
      app: miner
      tier: backend
      name: geth-miner$i
      serviceSelector: ethereum-node
    name: geth-miner$i
  spec:
    selector:
      matchLabels:
        app: miner
    replicas: 1
    serviceName: geth-miner$i
    template:
      metadata:
        name: geth-miner$i
        labels:
          app: miner
          tier: backend
          name: miner$i
      spec:
        containers:
        - name: miner$i-container
          image: ethereum/client-go:stable
          imagePullPolicy: Always
          command: [ "sh" ]
          args:
          - "-cx"
          - "rm -rf /etc/testnet/miner$i; /usr/local/bin/geth --datadir /etc/testnet/miner$i init /etc/geth/genesis/genesis-geth.json;
            touch /etc/testnet/miner$i/genesis_created;
            echo 123 > /etc/testnet/miner$i/password.txt;
            mkdir -p /etc/geth/miner$i;
            cp /etc/gethconfigmap/miner$i/gethconfig.toml /etc/geth/miner$i;
            /usr/local/bin/geth --datadir /etc/testnet/miner$i \\
            --mine \\
            --nousb \\
            --rpc \\
            --ws \\
            --metrics --metrics.influxdb --metrics.influxdb.endpoint 'http://influxdb.monitoring:8086' --metrics.influxdb.username 'admin' --metrics.influxdb.password 'admin' \\
            --unlock 0x${accountArrayPublic[i]} --allow-insecure-unlock --password /etc/testnet/miner$i/password.txt --miner.gasprice '0x0' --miner.gaslimit '357500000' --miner.gastarget '357500000' --bootnodes '$bootnodeaddress' \\
            --config /etc/geth/miner$i/gethconfig.toml --maxpendpeers 25 ;"
          ports:
            - containerPort: 8545
            - containerPort: 8546
              protocol: UDP
            - containerPort: 30303
          volumeMounts:
          - name: miner$i-persistent-storage
            mountPath: /etc/testnet/miner$i
          - name: miner$i-config-persistent-storage
            mountPath: /etc/gethconfigmap/miner$i
          - name: keystore-config-persistent-storage
            mountPath: /etc/testnet/miner$i/keystore/${accountArray[i]}
            subPath: ${accountArray[i]}
          - name: geth-boot-node-persistent-storage
            mountPath: /etc/testnet/bootnode
          - name: genesis-config-persistent-storage
            mountPath: /etc/geth/genesis/genesis-geth.json
            subPath: genesis-geth.json
        volumes:
        - name: keystore-config-persistent-storage
          configMap:
            name: keystore-config-miner$i
            items:
            - key: ${accountArray[i]}
              path: ${accountArray[i]}
        - name: geth-boot-node-persistent-storage
          hostPath:
            path: /var/lib/docker/geth-storage/bootnode
        - name: genesis-config-persistent-storage
          configMap:
            name: genesis-config
            items:
            - key: genesis-geth.json
              path: genesis-geth.json
        - name: miner$i-persistent-storage
          persistentVolumeClaim:
          claimName: volume-miner$i
        - name: miner$i-config-persistent-storage
          configMap:
            name: gethconfig-miner$i
            items:
            - key: gethconfig
              path: gethconfig.toml
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
filed_extraData=""
for (( i=1; i<=$NBNODES; i++ )) # start 1 => no bootnode
do
filed_extraData+=${accountArrayPublic[i]}
done
###################### end create weird extraData field

###################### init balances
filed_balances=""
for (( i=1; i<=$NBNODES; i++ )) # start 0 => include bootnode
do
filed_balances+=$(cat <<EOF
            "${accountArrayPublic[i]}": {
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
    genesis-geth.json: |-
      {
        "config": {
          "chainId": 123456,
          "homesteadBlock": 0,
          "eip150Block": 0,
          "eip150Hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
          "eip155Block": 0,
          "eip158Block": 0,
          "byzantiumBlock": 0,
          "constantinopleBlock": 0,
          "petersburgBlock": 0,
          "istanbulBlock": 0,
          "berlinBlock": 0,
          "clique": {
            "period": 2,
            "epoch": 30000
          }
        },
        "nonce": "0x0",
        "timestamp": "0x5cdec502",
        "gasLimit": "0x154F0460",
        "difficulty" : "0x1",
        "mixHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "coinbase": "0x0000000000000000000000000000000000000000",
        "extraData": "0x0000000000000000000000000000000000000000000000000000000000000000${filed_extraData}0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
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