import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_icons.dart';
import '../../core/widgets/n_button.dart';
import '../security/set_pin_screen.dart';
import '../settings/settings_controller.dart';

class _Slide {
  const _Slide(this.icon, this.title, this.text);
  final IconData icon;
  final String title;
  final String text;
}

/// Онбординг при первом запуске.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _slides = [
    _Slide(AppIcons.gaugeFill, 'Строевая записка',
        'Расход личного состава в реальном времени: по штату, налицо, в отпуске, в командировке — с разбивкой по категориям.'),
    _Slide(AppIcons.usersFill, 'Штат подразделения',
        'Полный список личного состава по взводам. Свайп по карточке — правка, перевод, смена статуса, исключение. Долгое нажатие — выбор нескольких.'),
    _Slide(AppIcons.umbrellaFill, 'Всё связано',
        'Отметил бойца «отпуск» или «командировка» — он сразу появляется в нужной вкладке, где вы уточняете сроки.'),
    _Slide(AppIcons.shield, 'Только на устройстве',
        'Все данные хранятся локально, без сервера и интернета. Доступ можно защитить кодом.'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish({bool withPin = false}) async {
    if (withPin) {
      final ok = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const SetPinScreen()),
      );
      if (ok != true) return;
    }
    await ref.read(settingsActionsProvider).completeOnboarding();
    if (withPin) ref.read(lockedProvider.notifier).unlock();
  }

  @override
  Widget build(BuildContext context) {
    final last = _page == _slides.length - 1;
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppDimens.lg, AppDimens.lg, AppDimens.lg, 0),
              child: Row(
                children: [
                  Text('ТАБЕЛЬ · Л/С', style: AppTypography.kicker),
                  const Spacer(),
                  if (!last)
                    TextButton(
                      onPressed: _finish,
                      child: Text('Пропустить',
                          style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                    ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _slideView(_slides[i]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _slides.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _page ? 22 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: i == _page ? AppColors.accentPrimary : AppColors.stroke,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.lg),
              child: last
                  ? Column(
                      children: [
                        NButton(label: 'ЗАЩИТИТЬ КОДОМ', icon: AppIcons.lock, onPressed: () => _finish(withPin: true)),
                        const SizedBox(height: AppDimens.sm),
                        NButton(label: 'НАЧАТЬ БЕЗ КОДА', outline: true, onPressed: _finish),
                      ],
                    )
                  : NButton(
                      label: 'ДАЛЕЕ',
                      onPressed: () => _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slideView(_Slide s) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: AppColors.panelGradient,
              borderRadius: BorderRadius.circular(AppDimens.rXl),
              border: Border.all(color: AppColors.stroke),
              boxShadow: [
                BoxShadow(color: AppColors.accentPrimary.withValues(alpha: 0.18), blurRadius: 30),
              ],
            ),
            child: Icon(s.icon, color: AppColors.accentPrimary, size: 44),
          ),
          const SizedBox(height: AppDimens.xl),
          Text(s.title, style: AppTypography.display, textAlign: TextAlign.center),
          const SizedBox(height: AppDimens.md),
          Text(s.text,
              style: AppTypography.body.copyWith(color: AppColors.textSecondary, height: 1.5),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
