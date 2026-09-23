import 'package:flutter/material.dart';
import 'package:local_fork/core/theme/app_spacing.dart';
import 'package:local_fork/core/util/logo.dart';
import 'package:local_fork/core/util/overall_padding.dart';
import 'package:local_fork/features/authentication/signup/signup_page.dart';
import 'package:local_fork/features/onboarding/onboarding_repository.dart';
import 'package:local_fork/features/onboarding/onboarding_slide.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  final _onboardingRepository = OnboardingRepository();

  int _currentPage = 0;

  bool get _isLastPage => _currentPage == OnboardingSlide.all.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // move forward one slide or leave the intro if this was the last
  void _next() {
    if (_isLastPage) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  //  intro is done, so go to signup
  Future<void> _finish() async {
    await _onboardingRepository.completeOnboarding();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SignupPage(title: 'Local Fork')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: OverallPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 48,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _isLastPage
                      ? null
                      : TextButton(
                          onPressed: _finish,
                          child: const Text('Skip'),
                        ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: OnboardingSlide.all.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) =>
                      _SlideView(slide: OnboardingSlide.all[index]),
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              _DotIndicator(
                count: OnboardingSlide.all.length,
                currentIndex: _currentPage,
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: _next,
                child: Text(_isLastPage ? 'Get Started' : 'Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  final OnboardingSlide slide;

  const _SlideView({required this.slide});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (slide.isLogo) {
      return const Center(child: Logo(radius: 120));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 176,
          height: 176,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.secondary.withValues(alpha: 0.14),
          ),
          child: Icon(slide.icon, size: 88, color: colorScheme.primary),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          slide.headline!,
          style: textTheme.titleLarge?.copyWith(color: colorScheme.primary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.m),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: Text(
            slide.description!,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _DotIndicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;

        // the active dot stretches into a pill
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
