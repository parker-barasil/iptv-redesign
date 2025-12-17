import 'package:flutter/material.dart';

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
  int selectedPlan = 0; // 0 = weekly, 1 = trial, 2 = yearly

  Color get cardColor {
    switch (selectedPlan) {
      case 0:
        return Colors.pinkAccent.withOpacity(0.25);
      case 1:
        return Colors.blueAccent.withOpacity(0.25);
      case 2:
        return Colors.orangeAccent.withOpacity(0.25);
      default:
        return Colors.white10;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0033),
      body: SafeArea(
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
                  image: NetworkImage("https://images.pexels.com/photos/399187/pexels-photo-399187.jpeg"),
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
                            child: Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // // PHONE MOCKUP
            // Container(
            //   width: 260,
            //   height: 150,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(20),
            //     image: const DecorationImage(
            //       image: NetworkImage("https://images.pexels.com/photos/607812/pexels-photo-607812.jpeg"),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),

            const SizedBox(height: 20),

            const Text(
              "Get IPTV Premium",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.pinkAccent),
            ),
            const SizedBox(height: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _check("Private channel with passcode"),
                _check("Unlimited playlist, EPG, stream"),
                _check("Unlimited watch channel"),
                _check("Remove Ads"),
              ],
            ),

            const SizedBox(height: 24),

            // PLANS
            _planTile(
              index: 0,
              selected: selectedPlan == 0,
              title: "Weekly",
              price: "4,99 \$/week",
              sub: "Auto-renewing",
              colorResolver: () => cardColor,
              onTap: () => setState(() => selectedPlan = 0),
            ),
            const SizedBox(height: 10),

            _planTile(
              index: 1,
              selected: selectedPlan == 1,
              title: "Free Trial 3-days",
              price: "14,99 \$/month",
              sub: "",
              colorResolver: () => cardColor,
              onTap: () => setState(() => selectedPlan = 1),
            ),
            const SizedBox(height: 10),

            _planTile(
              index: 2,
              selected: selectedPlan == 2,
              title: "Yearly",
              price: "49,99 \$/year",
              sub: "Auto-renewing",
              colorResolver: () => cardColor,
              onTap: () => setState(() => selectedPlan = 2),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: LinearGradient(
                  colors: [
                    selectedPlan == 0
                        ? Colors.pinkAccent
                        : selectedPlan == 1
                            ? Colors.blueAccent
                            : Colors.orangeAccent,
                    Colors.white.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text(
                  "Continue",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _planTile extends StatelessWidget {
  final int index;
  final bool selected;
  final String title;
  final String price;
  final String sub;
  final VoidCallback onTap;
  final Color Function() colorResolver;

  const _planTile({
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
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: selected ? Colors.white : Colors.white54,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
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

class _check extends StatelessWidget {
  final String text;
  const _check(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.greenAccent, size: 20),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 15)),
        ],
      ),
    );
  }
}
