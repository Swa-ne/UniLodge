import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:url_launcher/url_launcher.dart';

class BookedListings extends StatefulWidget {
  const BookedListings({super.key});

  @override
  State<BookedListings> createState() => _BookedListingsState();
}

class _BookedListingsState extends State<BookedListings> {
ReownAppKitModal? _appKitModal;
  String walletAddress = 'No Address';
  String _balance = '0';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initializeAppKitModal();
  }

  void initializeAppKitModal() async {
    _appKitModal = ReownAppKitModal(
      context: context,
      projectId:
          '51d85f4aa1e21fb201984e437e4c4061', 
      metadata: const PairingMetadata(
        name: 'Unilodge Crypto',
        description: 'A Crypto Flutter Unilodge',
        url: 'https://www.reown.com/',
        icons: ['https://reown.com/reown-logo.png'],
        redirect: Redirect(
          native: '/bookings',
          universal: 'https://reown.com',
          linkMode: true,
        ),
      ),
    );

    try {
      if (_appKitModal != null) {
        await _appKitModal!.init();
        debugPrint('appKitModal initialized successfully.');

        if (_appKitModal!.session != null) {
          debugPrint(
              'Current wallet address: ${_appKitModal!.session!.address}');
          updateWalletAddress();
        } else {
          debugPrint('Session is null after initialization.');
        }
      } else {
        debugPrint('appKitModal is null, skipping initialization.');
      }
    } catch (e) {
      debugPrint('Error during appKitModal initialization: $e');
    }

    _appKitModal?.addListener(() {
      updateWalletAddress();
    });

    setState(() {});
  }

  void updateWalletAddress() {
    setState(() {
      if (_appKitModal?.session != null) {
        walletAddress = _appKitModal!.session!.address ?? 'No Address';
        _balance = _appKitModal!.balanceNotifier.value.isEmpty
            ? '0'
            : _appKitModal!.balanceNotifier.value; // Use the balance
      } else {
        walletAddress = 'No Address';
        _balance = '0';
      }
      debugPrint('Wallet address updated: $walletAddress');
      debugPrint('Balance updated: $_balance');
    });
  }

  void openWalletApp() {
    final selectedWallet = _appKitModal?.selectedWallet?.listing.name;

    if (selectedWallet != null) {
      debugPrint('Selected wallet: $selectedWallet');

      if (selectedWallet.toLowerCase().contains('metamask')) {
        final Uri metamaskUri = Uri.parse("metamask://");
        launchUrl(metamaskUri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('No wallet app to open or unsupported wallet.');
      }
    } else {
      debugPrint('No wallet selected.');
    }
  }

  Widget loadingIndicator() {
    return isLoading
        ? const CircularProgressIndicator()
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('AppKitModal instance: $_appKitModal');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_appKitModal != null)
              AppKitModalNetworkSelectButton(appKit: _appKitModal!),

            const SizedBox(height: 20),

            if (_appKitModal != null)
              Visibility(
                visible: _appKitModal?.isConnected ?? false,
                child: AppKitModalConnectButton(appKit: _appKitModal!),
              ),

            const SizedBox(height: 20),

            Visibility(
              visible: _appKitModal?.isConnected ?? false,
              child: AppKitModalAccountButton(appKit: _appKitModal!),
            ),

            const SizedBox(height: 20),

            loadingIndicator(),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                openWalletApp();
                setState(() {
                  isLoading = false;
                });
              },
              child: const Text('Open Wallet App'),
            ),
          ],
        ),
      ),
    );
  }
}
