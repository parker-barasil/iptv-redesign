import 'package:another_iptv_player/core/style/app_colors.dart';
import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:apphud/models/apphud_models/apphud_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:another_iptv_player/feature/premium/domain/apphud_service.dart';
import 'package:another_iptv_player/feature/premium/domain/premium_service.dart';

class BrowseContentScreen extends StatefulWidget {
  const BrowseContentScreen({super.key});

  @override
  State<BrowseContentScreen> createState() => _BrowseContentScreenState();
}

class _BrowseContentScreenState extends State<BrowseContentScreen> {
  @override
  Widget build(BuildContext context) {
    return const IptvPaywallScreen();
  }
}

class IptvPaywallScreen extends StatefulWidget {
  const IptvPaywallScreen({super.key});

  @override
  State<IptvPaywallScreen> createState() => _IptvPaywallScreenState();
}

class _IptvPaywallScreenState extends State<IptvPaywallScreen> {
  int selectedPlan = 1; // 0 = weekly, 1 = monthly (default), 2 = yearly
  bool _isLoading = false;
  List<ApphudProduct> _apphudProducts = [];

  @override
  void initState() {
    super.initState();
    _loadApphudProducts();
  }

  Future<void> _loadApphudProducts() async {
    debugPrint('💳 BrowseContent: Loading Apphud products...');
    final products = ApphudService().products;
    debugPrint('💳 BrowseContent: Found ${products.length} products');

    if (products.isNotEmpty) {
      setState(() {
        _apphudProducts = products;
      });
      for (var product in products) {
        debugPrint('💳 Product: ${product.productId} - ${product.name}');
      }
    } else {
      debugPrint('⚠️ BrowseContent: No products available!');
    }
  }

  String _getSelectedProductId() {
    switch (selectedPlan) {
      case 0:
        return ApphudService.weekProductId;
      case 1:
        return ApphudService.monthProductId;
      case 2:
        return ApphudService.yearProductId;
      default:
        return ApphudService.monthProductId;
    }
  }

  Future<void> _purchaseProduct() async {
    debugPrint('💳 BrowseContent: Purchase button pressed');

    if (_apphudProducts.isEmpty) {
      debugPrint('⚠️ BrowseContent: No products loaded, showing error');
      _showErrorDialog('Products not available. Please try again later.');
      return;
    }

    final selectedProductId = _getSelectedProductId();
    debugPrint('💳 BrowseContent: Selected plan index: $selectedPlan');
    debugPrint('💳 BrowseContent: Selected product ID: $selectedProductId');

    setState(() => _isLoading = true);

    try {
      final success = await PremiumService().purchaseSubscription(selectedProductId);
      debugPrint('💳 BrowseContent: Purchase result: $success');

      if (success && mounted) {
        _showSuccessDialog();
      } else if (mounted) {
        _showErrorDialog('Purchase failed. Please try again.');
      }
    } catch (e) {
      debugPrint('❌ BrowseContent: Purchase error: $e');
      if (mounted) {
        _showErrorDialog('Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _restorePurchases() async {
    setState(() => _isLoading = true);
    try {
      final success = await PremiumService().restorePurchases();
      if (mounted) {
        if (success) {
          _showSuccessDialog();
        } else {
          _showErrorDialog('No purchases found to restore.');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Error restoring purchases: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success!'),
        content: const Text('Your purchase was successful.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  LinearGradient get buttonGradient {
    switch (selectedPlan) {
      case 0:
        return AppColors.accentGradient; // pink gradient for weekly
      case 1:
        return AppColors.blueGradient; // blue gradient for monthly
      case 2:
        return AppColors.orangeGradient; // orange gradient for yearly
      default:
        return AppColors.primaryGradient;
    }
  }

  Color get cardColor {
    switch (selectedPlan) {
      case 0:
        return AppColors.accentGradientList[1].withValues(alpha: 0.25); // pink
      case 1:
        return AppColors.blueGradient.colors[0].withValues(alpha: 0.25); // blue
      case 2:
        return AppColors.orangeGradient.colors[0].withValues(alpha: 0.25); // orange
      default:
        return Colors.white10;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0033),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0033),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // TOP BIG TV BANNER
                  Container(
                    width: double.infinity,
                    height: 180,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: NetworkImage(
                            "https://images.pexels.com/photos/399187/pexels-photo-399187.jpeg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (i) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      "https://picsum.photos/seed/thumb$i/200/200",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(Icons.play_circle_fill,
                                      color: Colors.white, size: 30),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Get IPTV Premium",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.pinkAccent),
                  ),
                  const SizedBox(height: 8),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Check(
                        icon: SvgPicture.asset(
                          'assets/svg/loop.svg',
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            Colors.greenAccent,
                            BlendMode.srcIn,
                          ),
                        ),
                        text: context.loc.premium_unlimited_playlists,
                      ),
                      _Check(
                        icon: const Text(
                          '🔒',
                          style: TextStyle(fontSize: 18),
                        ),
                        text: context.loc.premium_password_protected,
                      ),
                      _Check(
                        icon: const Text(
                          '🚫',
                          style: TextStyle(fontSize: 18),
                        ),
                        text: context.loc.premium_ad_free,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // PLANS
                  _PlanTile(
                    index: 0,
                    selected: selectedPlan == 0,
                    title: "1 Week",
                    price: "\$4.99 / week",
                    sub: "Auto-renewing",
                    colorResolver: () => cardColor,
                    onTap: () => setState(() => selectedPlan = 0),
                  ),
                  const SizedBox(height: 10),

                  _PlanTile(
                    index: 1,
                    selected: selectedPlan == 1,
                    title: "1 Month",
                    price: "\$14.99 / month",
                    sub: "Most Popular",
                    colorResolver: () => cardColor,
                    onTap: () => setState(() => selectedPlan = 1),
                  ),
                  const SizedBox(height: 10),

                  _PlanTile(
                    index: 2,
                    selected: selectedPlan == 2,
                    title: "1 Year",
                    price: "\$39.99 / year",
                    sub: "Best Value",
                    colorResolver: () => cardColor,
                    onTap: () => setState(() => selectedPlan = 2),
                  ),

                  const SizedBox(height: 140),
                ],
              ),
            ),

            // Bottom button fixed
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A0033),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: _isLoading ? null : _purchaseProduct,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: buttonGradient,
                        ),
                        child: Center(
                          child: _isLoading
                              ? const CupertinoActivityIndicator(color: Colors.white)
                              : const Text(
                                  "Continue",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _isLoading ? null : _restorePurchases,
                      child: const Text(
                        'Restore Purchases',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  final int index;
  final bool selected;
  final String title;
  final String price;
  final String sub;
  final VoidCallback onTap;
  final Color Function() colorResolver;

  const _PlanTile({
    required this.index,
    required this.selected,
    required this.title,
    required this.price,
    required this.sub,
    required this.colorResolver,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? colorResolver() : Colors.white10,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? Colors.white : Colors.white24,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? Colors.white : Colors.white54,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                if (sub.isNotEmpty)
                  Text(
                    sub,
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              price,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class _Check extends StatelessWidget {
  final Widget icon;
  final String text;

  const _Check({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: icon,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
