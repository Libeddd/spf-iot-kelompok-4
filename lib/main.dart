import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

const primary = Color(0xFF0FA3A3);
const ink = Color(0xFF12343B);
const muted = Color(0xFF687F83);
const mint = Color(0xFFE6F7EF);
const canvas = Color(0xFFF4F8F9);
const warning = Color(0xFFF59E42);
const offline = Color(0xFFD95C5C);
const paleBlue = Color(0xFFEAF3FF);

void main() {
  runApp(const ProviderScope(child: PawFeedApp()));
}

enum DemoState { normal, low, offline, loading }

class PawFeedApp extends StatelessWidget {
  const PawFeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: canvas,
      colorScheme: ColorScheme.fromSeed(seedColor: primary).copyWith(
        primary: primary,
        onPrimary: Colors.white,
        surface: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme().apply(bodyColor: ink, displayColor: ink),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      }),
    );
    return MaterialApp(
      title: 'PawFeed',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        appBarTheme: const AppBarTheme(
            backgroundColor: canvas, elevation: 0, foregroundColor: ink),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool obscure = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void login() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PawFeedShell()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 728),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 62),
                      decoration: BoxDecoration(
                          color: Color(0xFFE1F5F4),
                          borderRadius: BorderRadius.circular(28)),
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const PawLogo(size: 72),
                              const SizedBox(width: 16),
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                      fontSize: 44,
                                      fontWeight: FontWeight.w800,
                                      color: ink),
                                  children: const [
                                    TextSpan(text: 'Paw'),
                                    TextSpan(
                                        text: 'Feed',
                                        style: TextStyle(color: primary))
                                  ],
                                ),
                              ),
                            ]),
                        const SizedBox(height: 28),
                        Text(
                            'Kontrol pemberian makan dan air Mochi\ndengan tenang, dari mana saja.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: 18, height: 1.5, color: muted)),
                      ]),
                    ),
                    const SizedBox(height: 38),
                    Text('Selamat datang kembali',
                        style: GoogleFonts.poppins(
                            fontSize: 30, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text('Masuk untuk terhubung ke PawFeed milik Mochi.',
                        style: GoogleFonts.inter(fontSize: 18, color: muted)),
                    const SizedBox(height: 28),
                    Text('Email', style: labelStyle),
                    const SizedBox(height: 8),
                    TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            'nama@email.com', Icons.mail_outline)),
                    const SizedBox(height: 22),
                    Text('Password', style: labelStyle),
                    const SizedBox(height: 8),
                    TextField(
                        controller: password,
                        obscureText: obscure,
                        decoration:
                            inputDecoration('••••••••••', Icons.lock_outline)
                                .copyWith(
                                    suffixIcon: IconButton(
                                        onPressed: () =>
                                            setState(() => obscure = !obscure),
                                        icon: Icon(obscure
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined)))),
                    Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () => showToast(context,
                                'Tautan reset password akan tersedia setelah backend terhubung.'),
                            child: const Text('Lupa password?'))),
                    const SizedBox(height: 8),
                    PrimaryButton(
                        icon: Icons.login, label: 'Masuk', onPressed: login),
                    const SizedBox(height: 12),
                    Center(
                        child: TextButton(
                            onPressed: () => showToast(context,
                                'Halaman daftar akan ditambahkan pada tahap autentikasi.'),
                            child: RichText(
                                text: TextSpan(
                                    style: GoogleFonts.inter(
                                        fontSize: 16, color: muted),
                                    children: const [
                                  TextSpan(text: 'Belum punya akun?  '),
                                  TextSpan(
                                      text: 'Daftar',
                                      style: TextStyle(
                                          color: primary,
                                          fontWeight: FontWeight.w600))
                                ])))),
                    const SizedBox(height: 18),
                    InfoNote(
                        icon: Icons.verified_user_outlined,
                        text:
                            'Koneksi terenkripsi. Kredensial perangkat tidak pernah ditampilkan.',
                        color: mint,
                        textColor: Color(0xFF117C80)),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class PawFeedShell extends StatefulWidget {
  const PawFeedShell({super.key});

  @override
  State<PawFeedShell> createState() => _PawFeedShellState();
}

class _PawFeedShellState extends State<PawFeedShell> {
  int tab = 0;
  DemoState demoState = DemoState.normal;

  void selectTab(int value) => setState(() => tab = value);

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
          state: demoState,
          onFeed: () => openFeed(context),
          onWater: () => setState(() => tab = 2),
          onSchedule: () => setState(() => tab = 1)),
      ScheduleScreen(state: demoState),
      MonitoringScreen(
          state: demoState,
          onHistory: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const HistoryScreen()))),
      SettingsScreen(
          state: demoState,
          onStateChanged: (value) => setState(() => demoState = value),
          onLogout: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginScreen()))),
    ];
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: BottomNavBar(selected: tab, onSelected: selectTab),
    );
  }

  void openFeed(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => FeedScreen(state: demoState)));
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen(
      {super.key,
      required this.state,
      required this.onFeed,
      required this.onWater,
      required this.onSchedule});
  final DemoState state;
  final VoidCallback onFeed;
  final VoidCallback onWater;
  final VoidCallback onSchedule;

  bool get isOffline => state == DemoState.offline;
  bool get isLoading => state == DemoState.loading;
  bool get isLow => state == DemoState.low;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Header(
            greeting: isLoading ? null : 'Selamat pagi, Naya 👋',
            title: isLoading ? null : 'Mochi',
            status: isLoading
                ? 'Mengambil status'
                : isOffline
                    ? 'Offline'
                    : 'Online',
            statusColor: isOffline ? offline : primary,
            statusIcon: isOffline ? Icons.wifi_off : Icons.wifi),
        if (isOffline) ...[
          const SizedBox(height: 24),
          OfflineBanner(
              onReconnect: () =>
                  showToast(context, 'Mencoba menghubungkan kembali…')),
        ] else if (isLow) ...[
          const SizedBox(height: 24),
          const LowFoodBanner(),
        ] else if (isLoading) ...[
          const SizedBox(height: 24),
          const LoadingBanner(),
        ],
        const SizedBox(height: 24),
        if (isLoading)
          const LoadingHomeContent()
        else ...[
          Row(children: [
            Expanded(
                child: LevelCard(
                    icon: Icons.inventory_2_outlined,
                    title: 'Sisa makanan',
                    percent: isLow ? 18 : 74,
                    caption: isOffline ? 'Terakhir 09:32' : 'Estimasi sensor',
                    accent: isLow ? warning : primary,
                    faded: isOffline)),
            const SizedBox(width: 14),
            Expanded(
                child: LevelCard(
                    icon: Icons.water_drop_outlined,
                    title: 'Level air',
                    percent: 62,
                    caption: isOffline ? 'Terakhir 09:32' : 'Diperbarui 1 mnt',
                    faded: isOffline)),
          ]),
          const SizedBox(height: 24),
          if (isLow) ...[
            const SupplyEstimateCard(),
            const SizedBox(height: 20),
            const NextScheduleCompact(),
            const SizedBox(height: 20),
            SecondaryButton(
                icon: Icons.inventory_2_outlined,
                label: 'Tandai akan isi ulang',
                onPressed: () => showToast(
                    context, 'Persediaan ditandai akan diisi ulang.')),
          ] else if (isOffline) ...[
            const LockedActionsCard(),
            const SizedBox(height: 18),
            const InfoNote(
                icon: Icons.info_outline,
                text:
                    'Jadwal tersimpan di perangkat, tetapi perubahan baru memerlukan koneksi.',
                color: paleBlue),
          ] else ...[
            NextScheduleCard(onTap: onSchedule),
            const SizedBox(height: 24),
            Text('Aksi cepat', style: sectionTitle),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(
                  flex: 3,
                  child: PrimaryButton(
                      icon: Icons.restaurant,
                      label: 'Beri Makan Sekarang',
                      onPressed: onFeed)),
              const SizedBox(width: 14),
              Expanded(
                  child: SecondaryButton(
                      icon: Icons.water_drop_outlined,
                      label: 'Isi Air',
                      onPressed: onWater)),
            ]),
            const SizedBox(height: 18),
            const InfoNote(
                icon: Icons.info_outline,
                text:
                    'Sensor memperkirakan persediaan. Riwayat mencatat makanan keluar, bukan apakah hewan sudah makan.',
                color: paleBlue),
          ],
        ],
      ]),
    );
  }
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key, required this.state});
  final DemoState state;

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool sheetOpen = true;
  final enabled = [true, true, true];

  @override
  Widget build(BuildContext context) {
    return AppPage(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Header(
            greeting: 'Jadwal makan',
            title: null,
            status: null,
            trailing: FloatingActionButton(
                onPressed: () => setState(() => sheetOpen = true),
                backgroundColor: primary,
                foregroundColor: Colors.white,
                elevation: 0,
                child: const Icon(Icons.add, size: 30))),
        Text('Otomatis berdasarkan waktu perangkat', style: subtitleStyle),
        const SizedBox(height: 24),
        ScheduleTile(
            time: '07:00',
            name: 'Sarapan',
            grams: '30 g',
            value: enabled[0],
            onChanged: (v) => setState(() => enabled[0] = v)),
        ScheduleTile(
            time: '12:00',
            name: 'Makan siang',
            grams: '35 g',
            value: enabled[1],
            onChanged: (v) => setState(() => enabled[1] = v)),
        ScheduleTile(
            time: '18:00',
            name: 'Makan malam',
            grams: '35 g',
            value: enabled[2],
            onChanged: (v) => setState(() => enabled[2] = v)),
        if (sheetOpen) ...[
          const SizedBox(height: 24),
          AddScheduleCard(onClose: () => setState(() => sheetOpen = false)),
        ],
      ]),
    );
  }
}

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key, required this.state});
  final DemoState state;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int selected = 35;
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    final locked =
        widget.state == DemoState.offline || widget.state == DemoState.loading;
    return AppPage(
      showBack: true,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Beri makan manual', style: pageTitle),
        const SizedBox(height: 6),
        Text('Pilih porsi yang akan dikeluarkan', style: subtitleStyle),
        const SizedBox(height: 26),
        Row(
            children: [20, 35, 50]
                .map((grams) => Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(right: grams == 50 ? 0 : 12),
                        child: PortionCard(
                            grams: grams,
                            selected: selected == grams,
                            onTap: locked
                                ? null
                                : () => setState(() => selected = grams)))))
                .toList()),
        const SizedBox(height: 28),
        PrimaryButton(
            icon: Icons.restaurant,
            label: 'Keluarkan $selected g',
            onPressed: locked || processing
                ? null
                : () => setState(() => processing = true)),
        const SizedBox(height: 24),
        ProcessCard(processing: processing),
        const SizedBox(height: 18),
        const DailyLimitCard(),
        const SizedBox(height: 22),
        Center(
            child: Text(
                'Catatan hanya mengonfirmasi makanan keluar dari perangkat.',
                style: TextStyle(color: muted, fontSize: 13),
                textAlign: TextAlign.center)),
      ]),
    );
  }
}

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen(
      {super.key, required this.state, required this.onHistory});
  final DemoState state;
  final VoidCallback onHistory;

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  bool filling = false;

  @override
  Widget build(BuildContext context) {
    final offlineMode = widget.state == DemoState.offline;
    final level = widget.state == DemoState.low ? 16 : 62;
    return AppPage(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Header(
            greeting: 'Monitoring air',
            title: null,
            status: offlineMode ? 'Offline' : 'Online',
            statusColor: offlineMode ? offline : primary,
            statusIcon: offlineMode ? Icons.wifi_off : Icons.wifi,
            trailing: IconButton(
                onPressed: widget.onHistory,
                icon: const Icon(Icons.notifications_none, size: 27))),
        Text('Status tangki dan pompa PawFeed', style: subtitleStyle),
        const SizedBox(height: 24),
        WaterTankCard(percent: level, offline: offlineMode),
        const SizedBox(height: 24),
        CardSurface(
            child: Column(children: [
          Row(children: [
            const Icon(Icons.power_settings_new, color: primary, size: 28),
            const SizedBox(width: 16),
            Text('Status pompa', style: cardTitle),
            const Spacer(),
            StatusChip(
                label: filling ? 'Mengisi' : 'Siap',
                icon: filling ? Icons.autorenew : Icons.check_circle_outline,
                color: filling ? primary : primary)
          ]),
          const SizedBox(height: 18),
          Row(children: [
            Expanded(
                child: PrimaryButton(
                    icon: Icons.play_arrow_outlined,
                    label: 'Isi Air',
                    onPressed: offlineMode || filling || level >= 90
                        ? null
                        : () => setState(() => filling = true))),
            const SizedBox(width: 14),
            Expanded(
                child: SecondaryButton(
                    icon: Icons.stop_outlined,
                    label: 'Hentikan',
                    onPressed:
                        filling ? () => setState(() => filling = false) : null))
          ]),
        ])),
        const SizedBox(height: 18),
        const InfoNote(
            icon: Icons.verified_user_outlined,
            text:
                'Pompa berhenti otomatis saat mencapai batas level 90% atau setelah 45 detik.',
            color: mint,
            textColor: Color(0xFF117C80)),
      ]),
    );
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String filter = 'Semua';

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Makanan keluar',
        '35 g dikeluarkan sesuai jadwal 12:00.',
        '12:01',
        Icons.restaurant,
        mint,
        primary
      ),
      (
        'Makanan menipis',
        'Sisa makanan diperkirakan 18%. Isi ulang segera.',
        '10:24',
        Icons.warning_amber_rounded,
        Color(0xFFFFF0E1),
        warning
      ),
      (
        'Air rendah',
        'Level air diperkirakan 16%.',
        'Kemarin',
        Icons.water_drop_outlined,
        Color(0xFFFFF0E1),
        warning
      ),
      (
        'Perangkat offline',
        'PawFeed terputus selama 8 menit.',
        'Kemarin',
        Icons.wifi_off,
        Color(0xFFFFE9EA),
        offline
      ),
    ];
    return AppPage(
        showBack: true,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Header(
              greeting: 'Notifikasi & Riwayat',
              title: null,
              status: null,
              trailing: IconButton(
                  onPressed: () => showToast(
                      context, 'Semua aktivitas ditandai sudah dibaca.'),
                  icon: const Icon(Icons.done_all, size: 28, color: primary))),
          Text('Aktivitas perangkat PawFeed', style: subtitleStyle),
          const SizedBox(height: 22),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Semua', 'Makanan', 'Air', 'Sistem'].map((value) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(value),
                    selected: filter == value,
                    onSelected: (_) => setState(() => filter = value),
                    selectedColor: primary,
                    labelStyle: TextStyle(
                        color: filter == value ? Colors.white : muted,
                        fontSize: 16),
                    side: BorderSide(
                        color: filter == value
                            ? primary
                            : const Color(0xFFD8E3E4)),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 22),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: ActivityTile(
                title: item.$1,
                message: item.$2,
                time: item.$3,
                icon: item.$4,
                iconBackground: item.$5,
                iconColor: item.$6,
              ),
            );
          }),
          const SizedBox(height: 8),
          const InfoNote(
              icon: Icons.info_outline,
              text:
                  'Riwayat makanan menunjukkan makanan keluar, bukan konfirmasi Mochi sudah makan.',
              color: paleBlue),
        ]));
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen(
      {super.key,
      required this.state,
      required this.onStateChanged,
      required this.onLogout});
  final DemoState state;
  final ValueChanged<DemoState> onStateChanged;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return AppPage(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Pengaturan', style: pageTitle),
      const SizedBox(height: 6),
      Text('Perangkat dan keamanan akun', style: subtitleStyle),
      const SizedBox(height: 24),
      CardSurface(
          child: Column(children: [
        Row(children: [
          const CircleIcon(icon: Icons.memory_outlined),
          const SizedBox(width: 16),
          const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('PawFeed ESP32', style: cardTitle),
                SizedBox(height: 3),
                Text('PF-ESP32-A19C',
                    style: TextStyle(color: muted, fontSize: 16))
              ])),
          StatusChip(label: 'Online', icon: Icons.wifi, color: primary)
        ]),
        const Divider(height: 30),
        SettingsRow(
            icon: Icons.wifi,
            title: 'Koneksi Wi-Fi',
            subtitle: 'Rumah_Naya • Sinyal kuat'),
        SettingsRow(
            icon: Icons.sync, title: 'Firmware', subtitle: 'v1.8.2 • Terbaru'),
      ])),
      const SizedBox(height: 20),
      CardSurface(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Batas notifikasi', style: cardTitle),
        const SizedBox(height: 18),
        SwitchRow(
            icon: Icons.inventory_2_outlined,
            title: 'Sisa makanan rendah',
            subtitle: 'Beri tahu saat di bawah 20%'),
        SwitchRow(
            icon: Icons.water_drop_outlined,
            title: 'Level air rendah',
            subtitle: 'Beri tahu saat di bawah 20%'),
      ])),
      const SizedBox(height: 20),
      CardSurface(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Akun & keamanan', style: cardTitle),
        const SizedBox(height: 16),
        SettingsRow(
            icon: Icons.key_outlined,
            title: 'Ubah password',
            subtitle: 'Terakhir diubah 3 bulan lalu'),
        SettingsRow(
            icon: Icons.shield_outlined,
            title: 'Keamanan akun',
            subtitle: 'Perlindungan login aktif'),
      ])),
      const SizedBox(height: 20),
      CardSurface(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Mode demo UI', style: cardTitle),
        const SizedBox(height: 6),
        const Text('Pilih state mock untuk meninjau seluruh desain.',
            style: TextStyle(color: muted)),
        const SizedBox(height: 14),
        Wrap(
            spacing: 8,
            runSpacing: 8,
            children: DemoState.values
                .map((value) => ChoiceChip(
                    label: Text(stateLabel(value)),
                    selected: state == value,
                    onSelected: (_) => onStateChanged(value),
                    selectedColor: primary,
                    labelStyle:
                        TextStyle(color: state == value ? Colors.white : muted),
                    side: BorderSide(
                        color: state == value ? primary : Color(0xFFD8E3E4))))
                .toList()),
      ])),
      const SizedBox(height: 20),
      SizedBox(
          width: double.infinity,
          child: TextButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout, color: offline),
              label: const Text('Keluar dari akun',
                  style: TextStyle(color: offline, fontSize: 17)),
              style: TextButton.styleFrom(
                  backgroundColor: Color(0xFFFFE9EA),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))))),
      const SizedBox(height: 18),
      const Center(
          child: Text('PawFeed v2.4.0 • ESP32 terhubung via Wi-Fi',
              style: TextStyle(color: muted))),
    ]));
  }

  String stateLabel(DemoState value) => switch (value) {
        DemoState.normal => 'Normal',
        DemoState.low => 'Menipis',
        DemoState.offline => 'Offline',
        DemoState.loading => 'Loading'
      };
}

class AppPage extends StatelessWidget {
  const AppPage({super.key, required this.child, this.showBack = false});
  final Widget child;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 728),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showBack)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: ink),
                  ),
                ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header(
      {super.key,
      this.greeting,
      this.title,
      this.status,
      this.statusColor,
      this.statusIcon,
      this.trailing});
  final String? greeting;
  final String? title;
  final String? status;
  final Color? statusColor;
  final IconData? statusIcon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (greeting != null) Text(greeting!, style: subtitleStyle),
        if (title != null) ...[
          const SizedBox(height: 4),
          Text(title!, style: pageTitle)
        ]
      ])),
      if (status != null)
        StatusChip(
            label: status!,
            icon: statusIcon ?? Icons.wifi,
            color: statusColor ?? primary),
      if (trailing != null) trailing!,
    ]);
  }
}

class PawLogo extends StatelessWidget {
  const PawLogo({super.key, this.size = 48});
  final double size;
  @override
  Widget build(BuildContext context) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: primary, borderRadius: BorderRadius.circular(size * .32)),
      child: Icon(Icons.pets, color: Colors.white, size: size * .55));
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar(
      {super.key, required this.selected, required this.onSelected});
  final int selected;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_outlined, Icons.home, 'Beranda'),
      (Icons.event_note_outlined, Icons.event_note, 'Jadwal'),
      (Icons.bar_chart_outlined, Icons.bar_chart, 'Monitoring'),
      (Icons.settings_outlined, Icons.settings, 'Pengaturan'),
    ];
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFD9E4E5)))),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: SafeArea(
        top: false,
        child: Row(
          children: items.indexed.map((entry) {
            final index = entry.$1;
            final item = entry.$2;
            final active = selected == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelected(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: active ? Color(0xFFE1F5F4) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(active ? item.$2 : item.$1,
                          color: active ? primary : muted, size: 28),
                      const SizedBox(height: 3),
                      Text(item.$3,
                          style: TextStyle(
                              color: active ? Color(0xFF08787D) : muted,
                              fontWeight:
                                  active ? FontWeight.w700 : FontWeight.w400,
                              fontSize: 14)),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class CardSurface extends StatelessWidget {
  const CardSurface(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(20)});
  final Widget child;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Color(0xFFDCE7E8)),
          boxShadow: const [
            BoxShadow(
                color: Color(0x120F343B), blurRadius: 18, offset: Offset(0, 5))
          ]),
      child: child);
}

class StatusChip extends StatelessWidget {
  const StatusChip(
      {super.key,
      required this.label,
      required this.icon,
      required this.color});
  final String label;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
          color: color == offline ? Color(0xFFFFE9EA) : Color(0xFFE3F6EE),
          borderRadius: BorderRadius.circular(24)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 7),
        Text(label,
            style: TextStyle(
                color: color == offline ? offline : Color(0xFF117C80),
                fontSize: 16))
      ]));
}

class LevelCard extends StatelessWidget {
  const LevelCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.percent,
      required this.caption,
      this.accent = primary,
      this.faded = false});
  final IconData icon;
  final String title;
  final int percent;
  final String caption;
  final Color accent;
  final bool faded;
  @override
  Widget build(BuildContext context) => CardSurface(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 16),
      child: Opacity(
          opacity: faded ? .58 : 1,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(icon, color: accent, size: 28),
              const SizedBox(width: 9),
              Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          color: muted,
                          fontSize: 16,
                          fontWeight: FontWeight.w600))),
              Text('$percent%',
                  style: TextStyle(
                      color: accent, fontSize: 30, fontWeight: FontWeight.w800))
            ]),
            const SizedBox(height: 16),
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                    value: percent / 100,
                    minHeight: 9,
                    backgroundColor: Color(0xFFECF1F2),
                    color: accent)),
            const SizedBox(height: 14),
            Text(caption, style: const TextStyle(color: muted, fontSize: 14))
          ])));
}

class NextScheduleCard extends StatelessWidget {
  const NextScheduleCard({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => CardSurface(
          child: Column(children: [
        Row(children: [
          const Icon(Icons.event_note_outlined, color: primary, size: 28),
          const SizedBox(width: 14),
          const Text('Jadwal berikutnya',
              style: TextStyle(color: muted, fontSize: 18)),
          const Spacer(),
          TextButton(
              onPressed: onTap,
              child: const Text('Lihat jadwal', style: TextStyle(fontSize: 16)))
        ]),
        const SizedBox(height: 24),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Text('12:00',
              style: TextStyle(
                  fontSize: 44, fontWeight: FontWeight.w800, color: ink)),
          const Spacer(),
          StatusChip(
              label: 'Aktif', icon: Icons.check_circle_outline, color: primary)
        ]),
        const SizedBox(height: 5),
        const Align(
            alignment: Alignment.centerLeft,
            child: Text('Siang • 35 g • Sedang',
                style: TextStyle(color: muted, fontSize: 17)))
      ]));
}

class NextScheduleCompact extends StatelessWidget {
  const NextScheduleCompact({super.key});
  @override
  Widget build(BuildContext context) => CardSurface(
          child: const Row(children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Jadwal berikutnya',
              style: TextStyle(color: muted, fontSize: 16)),
          SizedBox(height: 8),
          Text('18:00',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 34))
        ])),
        Text('35 g • Sedang', style: TextStyle(fontSize: 17, color: ink))
      ]));
}

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, required this.onReconnect});
  final VoidCallback onReconnect;
  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Color(0xFFFFE9EA),
          border: Border.all(color: offline, width: 1.5),
          borderRadius: BorderRadius.circular(24)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const CircleIcon(
              icon: Icons.wifi_off, background: Colors.white, color: offline),
          const SizedBox(width: 14),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Perangkat terputus',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            SizedBox(height: 3),
            Text('Offline sejak 09:33 • 8 menit',
                style: TextStyle(color: offline, fontSize: 15))
          ])
        ]),
        const SizedBox(height: 18),
        const Text(
            'Periksa daya ESP32 dan koneksi Wi-Fi. Status persediaan terakhir mungkin tidak terbaru.',
            style: TextStyle(color: muted, height: 1.45, fontSize: 15)),
        const SizedBox(height: 16),
        Center(
            child: TextButton.icon(
                onPressed: onReconnect,
                icon: const Icon(Icons.refresh, color: offline),
                label: const Text('Coba hubungkan lagi',
                    style: TextStyle(color: offline, fontSize: 17))))
      ]));
}

class LowFoodBanner extends StatelessWidget {
  const LowFoodBanner({super.key});
  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Color(0xFFFFF0E1),
          border: Border.all(color: warning, width: 1.5),
          borderRadius: BorderRadius.circular(24)),
      child: Row(children: [
        const CircleIcon(
            icon: Icons.warning_amber_rounded,
            background: Colors.white,
            color: warning),
        const SizedBox(width: 14),
        const Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Makanan menipis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          SizedBox(height: 4),
          Text('Sisa makanan diperkirakan 18%. Isi ulang sebelum jadwal 18:00.',
              style: TextStyle(color: muted, height: 1.35, fontSize: 15))
        ]))
      ]));
}

class LoadingBanner extends StatelessWidget {
  const LoadingBanner({super.key});
  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
          color: Color(0xFFE1F5F4), borderRadius: BorderRadius.circular(24)),
      child: const Row(children: [
        CircleIcon(icon: Icons.refresh, background: Colors.white),
        SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Mengambil status perangkat…',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
          SizedBox(height: 4),
          Text('Menunggu respons ESP32 melalui Wi-Fi',
              style: TextStyle(color: muted, fontSize: 14))
        ])
      ]));
}

class LoadingHomeContent extends StatelessWidget {
  const LoadingHomeContent({super.key});
  @override
  Widget build(BuildContext context) => Column(children: [
        Row(children: [
          Expanded(child: SkeletonCard()),
          const SizedBox(width: 14),
          Expanded(child: SkeletonCard())
        ]),
        const SizedBox(height: 24),
        SkeletonCard(height: 190),
        const SizedBox(height: 20),
        const InfoNote(
            icon: Icons.info_outline,
            text:
                'Belum ada nilai ditampilkan sampai data terbaru diterima. Aksi perangkat sementara tidak tersedia.',
            color: paleBlue)
      ]);
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key, this.height = 150});
  final double height;
  @override
  Widget build(BuildContext context) => CardSurface(
      child: SizedBox(
          height: height,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SkeletonBlock(width: 150),
            const SizedBox(height: 18),
            SkeletonBlock(width: 90, height: 28),
            const SizedBox(height: 18),
            const SkeletonBlock(width: double.infinity, height: 10)
          ])));
}

class SkeletonBlock extends StatelessWidget {
  const SkeletonBlock({super.key, this.width = 100, this.height = 18});
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Color(0xFFEDF3F3), borderRadius: BorderRadius.circular(12)));
}

class SupplyEstimateCard extends StatelessWidget {
  const SupplyEstimateCard({super.key});
  @override
  Widget build(BuildContext context) => CardSurface(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.balance_outlined, color: warning),
          const SizedBox(width: 12),
          const Text('Perkiraan persediaan',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
          const Spacer(),
          StatusChip(
              label: 'Rendah',
              icon: Icons.warning_amber_rounded,
              color: warning)
        ]),
        const SizedBox(height: 18),
        Row(children: [
          Expanded(child: MetricBox(value: '±120 g', label: 'tersisa')),
          const SizedBox(width: 14),
          Expanded(child: MetricBox(value: '2–3×', label: 'porsi sedang'))
        ]),
        const SizedBox(height: 16),
        const Text(
            'Nilai berasal dari sensor dan dapat berbeda sesuai bentuk serta kepadatan makanan.',
            style: TextStyle(color: muted, height: 1.4))
      ]));
}

class MetricBox extends StatelessWidget {
  const MetricBox({super.key, required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(18),
      decoration:
          BoxDecoration(color: canvas, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value,
            style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: muted, fontSize: 14))
      ]));
}

class LockedActionsCard extends StatelessWidget {
  const LockedActionsCard({super.key});
  @override
  Widget build(BuildContext context) => CardSurface(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.lock_outline, color: muted, size: 28),
          SizedBox(width: 14),
          Text('Aksi perangkat tidak tersedia',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800))
        ]),
        const SizedBox(height: 12),
        const Text(
            'Hubungkan kembali PawFeed untuk memberi makan atau mengisi air.',
            style: TextStyle(color: muted, height: 1.4, fontSize: 15)),
        const SizedBox(height: 22),
        Row(children: const [
          Expanded(
              child:
                  DisabledAction(icon: Icons.restaurant, label: 'Beri Makan')),
          Expanded(
              child: DisabledAction(
                  icon: Icons.water_drop_outlined, label: 'Isi Air'))
        ])
      ]));
}

class DisabledAction extends StatelessWidget {
  const DisabledAction({super.key, required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: muted, size: 27),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: muted, fontSize: 17))
      ]);
}

class ScheduleTile extends StatelessWidget {
  const ScheduleTile(
      {super.key,
      required this.time,
      required this.name,
      required this.grams,
      required this.value,
      required this.onChanged});
  final String time;
  final String name;
  final String grams;
  final bool value;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: CardSurface(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                decoration: BoxDecoration(
                    color: Color(0xFFE1F5F4),
                    borderRadius: BorderRadius.circular(18)),
                child: Text(time,
                    style: const TextStyle(
                        color: Color(0xFF08787D),
                        fontSize: 21,
                        fontWeight: FontWeight.w800))),
            const SizedBox(width: 16),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(name, style: const TextStyle(fontSize: 19)),
                  const SizedBox(height: 4),
                  Text('$grams • Setiap hari',
                      style: const TextStyle(color: muted, fontSize: 16))
                ])),
            Switch(
                value: value, onChanged: onChanged, activeThumbColor: primary)
          ])));
}

class AddScheduleCard extends StatefulWidget {
  const AddScheduleCard({super.key, required this.onClose});
  final VoidCallback onClose;
  @override
  State<AddScheduleCard> createState() => _AddScheduleCardState();
}

class _AddScheduleCardState extends State<AddScheduleCard> {
  int portion = 35;
  @override
  Widget build(BuildContext context) {
    return CardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: Text('Tambah jadwal', style: sectionTitle)),
            IconButton(
                onPressed: widget.onClose,
                icon: const Icon(Icons.close, color: muted))
          ]),
          const SizedBox(height: 18),
          Row(children: [
            Expanded(
                flex: 3,
                child: _PickerBox(
                    label: 'JAM', value: '07 : 00', highlighted: true)),
            const SizedBox(width: 14),
            Expanded(
                flex: 2, child: _PickerBox(label: 'HARI', value: 'Setiap hari'))
          ]),
          const SizedBox(height: 16),
          Row(
            children: [20, 35, 50].map((grams) {
              final label = grams == 20
                  ? 'Kecil'
                  : grams == 35
                      ? 'Sedang'
                      : 'Besar';
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: grams == 50 ? 0 : 8),
                  child: GestureDetector(
                    onTap: () => setState(() => portion = grams),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 19, horizontal: 4),
                      decoration: BoxDecoration(
                          color: portion == grams ? primary : canvas,
                          borderRadius: BorderRadius.circular(16)),
                      child: Text('$label · $grams g',
                          style: TextStyle(
                              color: portion == grams ? Colors.white : ink,
                              fontSize: 13)),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
              icon: Icons.check,
              label: 'Simpan jadwal',
              onPressed: () =>
                  showToast(context, 'Jadwal mock berhasil disimpan.')),
        ],
      ),
    );
  }
}

class _PickerBox extends StatelessWidget {
  const _PickerBox(
      {required this.label, required this.value, this.highlighted = false});
  final String label;
  final String value;
  final bool highlighted;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
          color: highlighted ? Color(0xFFE1F5F4) : canvas,
          borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: muted, fontSize: 13)),
        const SizedBox(height: 8),
        Text(value,
            style: TextStyle(
                color: highlighted ? Color(0xFF08787D) : ink,
                fontSize: highlighted ? 26 : 16,
                fontWeight: highlighted ? FontWeight.w800 : FontWeight.w400))
      ]));
}

class PortionCard extends StatelessWidget {
  const PortionCard(
      {super.key,
      required this.grams,
      required this.selected,
      required this.onTap});
  final int grams;
  final bool selected;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final label = grams == 20
        ? 'Kecil'
        : grams == 35
            ? 'Sedang'
            : 'Besar';
    return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 8),
            decoration: BoxDecoration(
                color: selected ? primary : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: selected ? primary : Color(0xFFDCE7E8), width: 1.5)),
            child: Column(children: [
              Icon(Icons.cake_outlined,
                  color: selected ? Colors.white : primary, size: 30),
              const SizedBox(height: 12),
              Text(label,
                  style: TextStyle(
                      color: selected ? Colors.white : ink,
                      fontWeight: FontWeight.w800,
                      fontSize: 17)),
              const SizedBox(height: 5),
              Text('$grams g',
                  style: TextStyle(
                      color: selected ? Colors.white : muted, fontSize: 15))
            ])));
  }
}

class ProcessCard extends StatelessWidget {
  const ProcessCard({super.key, required this.processing});
  final bool processing;
  @override
  Widget build(BuildContext context) {
    final steps = ['Menunggu', 'Servo membuka', 'Makanan keluar', 'Selesai'];
    return CardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: Text('Status proses', style: cardTitle)),
            StatusChip(
                label: processing ? 'Memproses' : 'Siap',
                icon: processing ? Icons.refresh : Icons.check_circle_outline,
                color: primary)
          ]),
          const SizedBox(height: 20),
          ...steps.indexed.map((entry) {
            final active = entry.$1 == 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  CircleIcon(
                      icon:
                          active ? Icons.refresh : Icons.radio_button_unchecked,
                      background: active ? primary : Color(0xFFEEF3F4),
                      color: active ? Colors.white : Color(0xFFB5C7C9)),
                  const SizedBox(width: 16),
                  Text(entry.$2,
                      style: TextStyle(
                          color: active ? ink : muted,
                          fontSize: 17,
                          fontWeight:
                              active ? FontWeight.w700 : FontWeight.w400)),
                  const SizedBox(width: 8),
                  if (active)
                    const Text('›',
                        style: TextStyle(fontSize: 22, color: muted)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class DailyLimitCard extends StatelessWidget {
  const DailyLimitCard({super.key});
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: Color(0xFFFFF0E1), borderRadius: BorderRadius.circular(20)),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.speed_outlined, color: warning, size: 28),
            SizedBox(width: 14),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Batas harian: 150 g',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
              SizedBox(height: 4),
              Text('Terpakai 65 g • Tersisa 85 g hari ini',
                  style: TextStyle(color: muted, fontSize: 15))
            ]),
          ],
        ),
      );
}

class WaterTankCard extends StatelessWidget {
  const WaterTankCard(
      {super.key, required this.percent, required this.offline});
  final int percent;
  final bool offline;
  @override
  Widget build(BuildContext context) => CardSurface(
          child: Row(children: [
        Container(
            width: 116,
            height: 230,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: Border.all(color: primary, width: 5),
                borderRadius: BorderRadius.circular(28)),
            alignment: Alignment.bottomCenter,
            child: Container(
                height: 145 * percent / 62,
                decoration: BoxDecoration(
                    color: Color(0xFFE1F5F4),
                    borderRadius: BorderRadius.circular(20)))),
        const SizedBox(width: 28),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const CircleIcon(icon: Icons.water_drop_outlined),
          const SizedBox(height: 18),
          Text('$percent%',
              style: const TextStyle(
                  color: primary, fontSize: 48, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text(percent < 20 ? 'Level air rendah' : 'Level air cukup',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          Text(
              offline
                  ? 'Terakhir 09:32'
                  : 'Estimasi sensor • diperbarui 1 menit lalu',
              style: const TextStyle(color: muted, fontSize: 14, height: 1.45))
        ]))
      ]));
}

class ActivityTile extends StatelessWidget {
  const ActivityTile(
      {super.key,
      required this.title,
      required this.message,
      required this.time,
      required this.icon,
      required this.iconBackground,
      required this.iconColor});
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  @override
  Widget build(BuildContext context) => CardSurface(
      padding: const EdgeInsets.all(16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleIcon(icon: icon, background: iconBackground, color: iconColor),
        const SizedBox(width: 14),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 17))),
            Text(time, style: const TextStyle(color: muted, fontSize: 13))
          ]),
          const SizedBox(height: 6),
          Text(message,
              style: const TextStyle(color: muted, fontSize: 15, height: 1.35))
        ]))
      ]));
}

class SettingsRow extends StatelessWidget {
  const SettingsRow(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(children: [
        CircleIcon(icon: icon),
        const SizedBox(width: 16),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
          const SizedBox(height: 3),
          Text(subtitle, style: const TextStyle(color: muted, fontSize: 15))
        ])),
        const Icon(Icons.chevron_right, color: muted, size: 28)
      ]));
}

class SwitchRow extends StatefulWidget {
  const SwitchRow(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;
  @override
  State<SwitchRow> createState() => _SwitchRowState();
}

class _SwitchRowState extends State<SwitchRow> {
  bool value = true;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Row(
          children: [
            CircleIcon(icon: widget.icon),
            const SizedBox(width: 16),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(widget.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 17)),
                  const SizedBox(height: 3),
                  Text(widget.subtitle,
                      style: const TextStyle(color: muted, fontSize: 15))
                ])),
            Switch(
                value: value,
                onChanged: (v) => setState(() => value = v),
                activeThumbColor: primary),
          ],
        ),
      );
}

class CircleIcon extends StatelessWidget {
  const CircleIcon(
      {super.key,
      required this.icon,
      this.background = const Color(0xFFE1F5F4),
      this.color = primary});
  final IconData icon;
  final Color background;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
          color: background, borderRadius: BorderRadius.circular(20)),
      child: Icon(icon, color: color, size: 28));
}

class InfoNote extends StatelessWidget {
  const InfoNote(
      {super.key,
      required this.icon,
      required this.text,
      required this.color,
      this.textColor = muted});
  final IconData icon;
  final String text;
  final Color color;
  final Color textColor;
  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: textColor, size: 25),
        const SizedBox(width: 12),
        Expanded(
            child: Text(text,
                style: TextStyle(color: textColor, height: 1.4, fontSize: 14)))
      ]));
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed});
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(
        height: 60,
        child: FilledButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 25),
          label: Text(label, style: const TextStyle(fontSize: 17)),
          style: FilledButton.styleFrom(
              backgroundColor: primary,
              disabledBackgroundColor: Color(0xFFE5EEEE),
              disabledForegroundColor: muted,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
        ),
      );
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed});
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(
        height: 60,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 25),
          label: Text(label, style: const TextStyle(fontSize: 17)),
          style: OutlinedButton.styleFrom(
              foregroundColor: primary,
              disabledForegroundColor: muted,
              side: BorderSide(
                  color: onPressed == null ? Color(0xFFE5EEEE) : primary,
                  width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
        ),
      );
}

InputDecoration inputDecoration(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: muted, fontSize: 17),
    prefixIcon: Icon(icon, color: muted, size: 27),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFDCE7E8), width: 1.5)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFDCE7E8), width: 1.5)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: primary, width: 1.5)));

final labelStyle =
    GoogleFonts.inter(fontSize: 16, color: ink, fontWeight: FontWeight.w500);
final pageTitle =
    GoogleFonts.poppins(fontSize: 30, color: ink, fontWeight: FontWeight.w800);
final sectionTitle =
    GoogleFonts.poppins(fontSize: 24, color: ink, fontWeight: FontWeight.w800);
const subtitleStyle = TextStyle(color: muted, fontSize: 18);
const cardTitle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: ink);

void showToast(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: ink));
