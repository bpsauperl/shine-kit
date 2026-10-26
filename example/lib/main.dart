import 'package:flutter/material.dart';
import 'package:shine_kit/shine_kit.dart';

/// The kit gallery: every piece on one phone-sized page, for either app, in
/// light or dark. Example data only.
void main() => runApp(const Gallery());

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  KitAccent _brand = KitAccent.myShine;
  Brightness _mode = Brightness.light;
  int _tab = 0;
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    final my = _brand == KitAccent.myShine;
    return MaterialApp(
      title: 'Shine kit',
      debugShowCheckedModeBanner: false,
      theme: kitTheme(_brand, _mode),
      home: Builder(
        builder: (context) {
          final p = context.kit;
          return Scaffold(
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.fromLTRB(KitSize.gutter, 24, KitSize.gutter, 120),
                      children: [
                        Row(
                          children: [
                            KitWordmark(prefix: my ? 'my' : 'dr', word: my ? 'Shine' : 'shine'),
                            const Spacer(),
                            KitRoundButton(
                              icon: my ? Icons.spa_outlined : Icons.medical_services_outlined,
                              label: 'Switch app',
                              onPressed: () => setState(() => _brand = my ? KitAccent.drShine : KitAccent.myShine),
                            ),
                            const SizedBox(width: 8),
                            KitRoundButton(
                              icon: p.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                              label: 'Light or dark',
                              dot: true,
                              onPressed: () => setState(() => _mode = p.isDark ? Brightness.light : Brightness.dark),
                            ),
                          ],
                        ),
                        const KitArchHero(height: 230),
                        Text('Series 1 · day 1 of 10', style: KitType.eyebrow(color: p.accentText)),
                        const SizedBox(height: 4),
                        Text.rich(
                          TextSpan(children: [
                            const TextSpan(text: 'Aligner 04'),
                            TextSpan(text: '/08', style: TextStyle(color: p.hairline)),
                          ]),
                          style: KitType.display(64, color: p.ink),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(child: KitButton.secondary(label: 'Aligners out', icon: Icons.timer_outlined, height: 46, onPressed: () {})),
                            const SizedBox(width: 8),
                            Expanded(child: KitButton(label: 'Check in', icon: Icons.check_rounded, height: 46, onPressed: () {})),
                          ],
                        ),
                        const SizedBox(height: 22),
                        KitPanel(
                          child: GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: KitSize.gap,
                            crossAxisSpacing: KitSize.gap,
                            childAspectRatio: 1.55,
                            children: const [
                              KitStat(inset: true, icon: Icons.timer_outlined, label: 'Worn yesterday', value: '21:40'),
                              KitStat(inset: true, icon: Icons.event_outlined, label: 'Next aligner', value: '5 Nov'),
                              KitStat(inset: true, icon: Icons.trending_up_rounded, label: 'Treatment', value: '38', unit: '%'),
                              KitStat(inset: true, icon: Icons.flag_outlined, label: 'Last aligner', value: '2 Dec'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        const KitHeadline(
                          eyebrow: 'Shine clear aligners',
                          title: 'Your smile,',
                          muted: 'revealed.',
                          body: 'See your new smile in a minute. Then follow every aligner, day by day, with your clinic.',
                        ),
                        const SizedBox(height: 24),
                        KitListGroup(
                          title: 'Order',
                          children: [
                            KitListRow(icon: Icons.photo_camera_outlined, title: 'Photos', detail: 'Face, mouth and X-ray', state: '8 / 12', highlight: true, onTap: () {}),
                            KitListRow(icon: Icons.view_in_ar_outlined, title: 'Scans', detail: 'Upper and lower jaw', state: 'Done', onTap: () {}),
                            KitListRow(icon: Icons.description_outlined, title: 'Prescription', detail: 'Shine Planning · both arches', state: 'Done', onTap: () {}),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text('Due now · Shine Planning', style: KitType.eyebrow(color: p.accentText)),
                        Text('€100', style: KitType.display(84, color: p.ink)),
                        const SizedBox(height: 18),
                        KitSlideToConfirm(
                          label: _sent ? 'Sent for planning' : 'Slide to send for planning',
                          enabled: !_sent,
                          onConfirmed: () => setState(() => _sent = true),
                        ),
                        const SizedBox(height: 12),
                        KitButton(label: 'Connect', trailingIcon: Icons.arrow_forward_rounded, onPressed: () {}),
                        const SizedBox(height: 8),
                        KitButton.secondary(label: 'Clinic code', onPressed: () {}),
                      ],
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 24,
                      child: Center(
                        child: KitTabBar(
                          index: _tab,
                          onSelect: (i) => setState(() => _tab = i),
                          tabs: const [
                            KitTab(icon: Icons.wb_sunny_outlined, label: 'Today'),
                            KitTab(icon: Icons.view_in_ar_outlined, label: 'Plan'),
                            KitTab(icon: Icons.calendar_month_outlined, label: 'Schedule'),
                            KitTab(icon: Icons.chat_bubble_outline_rounded, label: 'Messages', dot: true),
                            KitTab(icon: Icons.person_outline_rounded, label: 'Profile'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
