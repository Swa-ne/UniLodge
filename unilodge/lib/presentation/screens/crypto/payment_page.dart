import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart' as apkit;
import 'package:unilodge/core/configs/assets/app_images.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/core/utils/smart_contract.dart';
import 'package:lottie/lottie.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/widgets/crypto/payment_details.dart';
import 'package:unilodge/presentation/widgets/crypto/send_payment_button.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.listing});

  final Listing listing;
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  apkit.ReownAppKitModal? appKit;
  String walletAddress = 'No Address';
  String balance = '0';
  BigInt? gasPrice;
  bool isLoading = false;

  final String etherscanApiKey = 'VMVKI11F5IVSQUVQ5Q9CTB4KGKAEM46TTA';

  final customNetwork = apkit.ReownAppKitModalNetworkInfo(
    name: 'Sepolia',
    chainId: '11155111',
    currency: 'ETH',
    rpcUrl: 'https://rpc.sepolia.org/',
    explorerUrl: 'https://sepolia.etherscan.io/',
    isTestNetwork: true,
  );

  @override
  void initState() {
    super.initState();
    apkit.ReownAppKitModalNetworks.addNetworks('eip155', [customNetwork]);
    initializeAppKitModal();
    fetchGasPrice();
  }

  Widget homeLoading() {
    return isLoading
        ? Center(
            child: SizedBox(
              width: 360,
              height: 200,
              child: Lottie.asset(
                'assets/animation/home_loading.json',
                width: 200,
                height: 200,
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  void initializeAppKitModal() async {
    appKit = apkit.ReownAppKitModal(
      context: context,
      projectId: '51d85f4aa1e21fb201984e437e4c4061',
      metadata: const apkit.PairingMetadata(
        name: 'Unilodge Crypto',
        description: 'A Crypto Flutter Unilodge',
        url: 'https://www.reown.com/',
        icons: ['https://reown.com/reown-logo.png'],
        redirect: apkit.Redirect(
          native: 'unilodge://',
          universal: 'https://reown.com',
          linkMode: true,
        ),
      ),
    );

    if (appKit != null) {
      await appKit!.init();
    } else {
      print('appKit is null, cannot initialize.');
    }

    appKit?.addListener(() {
      updateWalletAddress();
      print("goods na apkit");
    });

    setState(() {});
  }

  // Future<void> fetchTransactionHistory(String address) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse(
  //           'https://api-sepolia.etherscan.io/api?module=account&action=txlist&address=$address&startblock=0&endblock=99999999&page=1&offset=10&sort=asc&apikey=$etherscanApiKey'),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       printTransactionHistory(data);
  //     } else {
  //       debugPrint(
  //           'Failed to fetch transaction history: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     debugPrint('Error fetching transaction history: $e');
  //   }
  // }

  // void printTransactionHistory(dynamic data) {
  //   if (data != null && data['result'] != null) {
  //     List transactions = data['result'];

  //     if (transactions.isNotEmpty) {
  //       for (var transaction in transactions) {
  //         debugPrint('Transaction Hash: ${transaction['hash']}');
  //         debugPrint('From: ${transaction['from']}');
  //         debugPrint('To: ${transaction['to']}');
  //         debugPrint('Value: ${transaction['value']}');
  //         debugPrint('Block Number: ${transaction['blockNumber']}');
  //         debugPrint('---');
  //       }
  //     } else {
  //       debugPrint('No transactions found.');
  //     }
  //   } else {
  //     debugPrint('No data found.');
  //   }
  // }

  Future<BigInt> fetchGasPrice() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.etherscan.io/api?module=proxy&action=eth_gasPrice&apikey=$etherscanApiKey'));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        String gasPriceHex = jsonResponse['result'];
        if (gasPriceHex.isEmpty) {
          throw Exception('Gas price is empty.');
        }
        BigInt gasPrice = BigInt.parse(gasPriceHex);
        gasPrice = gasPrice;
        debugPrint('Current Gas Price: $gasPrice');
        return gasPrice;
      } else {
        debugPrint('Failed to fetch gas price: ${response.statusCode}');
        throw Exception('Failed to fetch gas price: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching gas price: $e');
      throw Exception('Error fetching gas price: $e');
    }
  }

  void updateWalletAddress() {
    setState(() {
      walletAddress = appKit?.session?.address ?? 'No Address';
      if (walletAddress.length > 10) {
        walletAddress =
            '${walletAddress.substring(0, 10)}...${walletAddress.substring(walletAddress.length - 10)}';
      }
      balance = appKit?.balanceNotifier.value.isEmpty ?? true
          ? '0'
          : appKit!.balanceNotifier.value;

      debugPrint('Wallet address updated: $walletAddress');
      debugPrint('Balance updated: $balance');
    });
  }

  void openWalletApp() {
    if (appKit?.isConnected ?? false) {
      try {
        appKit!.launchConnectedWallet();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to launch wallet: $e')),
        );
      }
    } else {
      debugPrint('No wallet connected or session is invalid.');
    }
  }

  Future<void> sendTransaction(String receiver, String amount) async {
    if (receiver.isEmpty || amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid receiver address or amount!')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    appKit!.launchConnectedWallet();

    try {
      double amountInEther = double.parse(amount);
      BigInt amountInWei = BigInt.from((amountInEther * pow(10, 18)).toInt());
      debugPrint('Transaction: Amount in Wei: $amountInWei');

      final senderAddress = appKit!.session!.address!;
      debugPrint('Transaction: Sender Address: $senderAddress');

      final currentBalance = appKit!.balanceNotifier.value;
      if (currentBalance.isEmpty) {
        throw Exception('Unable to fetch wallet balance.');
      }

      double balanceInEther = double.parse(currentBalance.split(' ')[0]);
      BigInt balanceInWei = BigInt.from((balanceInEther * pow(10, 18)).toInt());
      debugPrint('Transaction: Balance in Wei: $balanceInWei');

      BigInt gasPrice = await fetchGasPrice();
      if (gasPrice == BigInt.zero) {
        throw Exception('Failed to fetch gas price.');
      }

      final gasLimit = BigInt.from(200000);
      final totalCost = amountInWei + (gasPrice * gasLimit);

      if (balanceInWei < totalCost) {
        throw Exception(
          'Insufficient funds for transaction! Balance: $balanceInWei, Total Cost: $totalCost',
        );
      }

      final deployedContract = apkit.DeployedContract(
        apkit.ContractAbi.fromJson(
          jsonEncode(SepoliaTestContract.readContractAbi),
          'ETH',
        ),
        apkit.EthereumAddress.fromHex(receiver),
      );

      final result = await appKit!.requestWriteContract(
        topic: appKit!.session!.topic,
        chainId: appKit!.selectedChain!.chainId,
        deployedContract: deployedContract,
        functionName: 'transfer',
        transaction: apkit.Transaction(
          from: apkit.EthereumAddress.fromHex(senderAddress),
          to: apkit.EthereumAddress.fromHex(receiver),
          value: apkit.EtherAmount.fromBigInt(apkit.EtherUnit.wei, amountInWei),
          maxGas: gasLimit.toInt(),
        ),
        parameters: [
          apkit.EthereumAddress.fromHex(receiver),
          amountInWei,
        ],
      );

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction successful!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction failed.')),
        );
      }
    } catch (e) {
      debugPrint('Transaction error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Awaiting Payment'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (appKit == null || !(appKit?.isConnected ?? false))
              Container(
                width: screenWidth,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration:
                    BoxDecoration(color: AppColors.primary.withOpacity(0.1)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("No wallet connected",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.textColor,
                          )),
                    ),
                    apkit.AppKitModalConnectButton(appKit: appKit!),
                  ],
                ),
              ),
     
            if (appKit != null && appKit!.isConnected)
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Image.asset(
                                  AppImages.wallet,
                                  height: 35,
                                )),
                            Expanded(
                              flex: 9,
                              child: Container(
                                padding: EdgeInsets.all(12),
                                height: 45,
                                decoration: BoxDecoration(
                                    color: AppColors.lightBackground,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text("$walletAddress"),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Image.asset(
                                  AppImages.ethereum,
                                  height: 35,
                                )),
                            Expanded(
                              flex: 9,
                              child: Container(
                                padding: EdgeInsets.all(12),
                                height: 45,
                                decoration: BoxDecoration(
                                    color: AppColors.lightBackground,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text("$balance"),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: apkit.AppKitModalConnectButton(
                                    appKit: appKit!),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    openWalletApp();
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 24.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Open wallet",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Divider(height: 20, color: Color.fromARGB(68, 168, 168, 168)),
            ),
            PaymentDetails(listing: widget.listing),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SendPaymentCrypto(
                text: 'Send Payment',
                onPressed: appKit?.isConnected == true
                    ? () {
                        sendTransaction(
                          widget.listing.walletAddress!,
                          widget.listing.price!,
                        );
                      }
                    : null,
                backgroundColor: appKit?.isConnected == true
                    ? AppColors.primary
                    : const Color.fromARGB(195, 113, 117, 121),
              ),
            ),
            homeLoading(),
          ],
        ),
      ),
    );
  }
}
