import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../core/utils/platform_helper.dart';
import 'widgets/module_card.dart';
import 'widgets/grid_painter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  // Keep alive para evitar reconstrução da tela ao navegar
  @override
  bool get wantKeepAlive => true;

  // Constantes para tamanhos e duração de animações
  static const double _cardSpacing = 20.0;
  static const double _maxContentWidth = 1000.0;
  static const Duration _audioTimeout = Duration(seconds: 5);

  final _player = AudioPlayer();
  final _imageKey = GlobalKey();
  bool _isImagesLoaded = false;
  bool _isAudioLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeResources();
  }

  Future<void> _initializeResources() async {
    try {
      // No ambiente web, podemos ter problemas com formato de áudio,
      // então pulamos o carregamento do áudio na web
      if (!PlatformHelper.isWeb) {
        // Pré-carregar o áudio em paralelo com timeout para evitar bloqueio
        unawaited(
          _preloadAudio().timeout(
            _audioTimeout,
            onTimeout: () {
              debugPrint(
                'Timeout ao carregar áudio. Usando fallback silencioso.',
              );
              _isAudioLoaded = false;
            },
          ),
        );
      } else {
        debugPrint(
          'Audio desabilitado para ambiente web devido a possíveis problemas de formato',
        );
      }
    } catch (e) {
      debugPrint('Erro ao inicializar recursos: $e');
    }
  }

  Future<void> _preloadAudio() async {
    try {
      await _player.setSource(AssetSource(AppConstants.clickSoundPath));
      _isAudioLoaded = true;
      debugPrint('Áudio carregado com sucesso');
    } catch (e) {
      _isAudioLoaded = false;
      debugPrint('Erro ao carregar áudio: $e');
    }
  }

  Future<void> _playClickSound() async {
    // Só tenta tocar se o áudio foi carregado com sucesso e não estamos na web
    if (!_isAudioLoaded || PlatformHelper.isWeb) return;

    try {
      await _player
          .play(AssetSource(AppConstants.clickSoundPath))
          .timeout(
            _audioTimeout,
            onTimeout: () {
              debugPrint('Timeout ao reproduzir áudio.');
            },
          );
    } catch (e) {
      debugPrint('Erro ao reproduzir áudio: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Pré-carregar a imagem de fundo para melhor desempenho
    if (!_isImagesLoaded) {
      _isImagesLoaded = true;
      try {
        precacheImage(const AssetImage(AppConstants.matrixBgImage), context)
            .then((_) => debugPrint('Imagem de fundo carregada'))
            .onError(
              (error, _) => debugPrint('Erro ao carregar imagem: $error'),
            );
      } catch (e) {
        debugPrint('Erro ao iniciar carregamento de imagem: $e');
      }
    }
  }

  void _navigateToModule(BuildContext context, String route) {
    // Captura o router antes da operação assíncrona
    final router = GoRouter.of(context);
    final targetRoute = route;

    // Executa navegação imediatamente sem esperar pelo som/delay
    router.go(targetRoute);

    // Reproduz o som sem bloquear a navegação
    _playClickSound();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Necessário para AutomaticKeepAliveClientMixin

    final isWide = MediaQuery.of(context).size.width > 600;
    final isWeb = PlatformHelper.isWeb;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // Fundo animado (isolado com RepaintBoundary)
          RepaintBoundary(child: _buildAnimatedBackground()),

          // Conteúdo principal (escolhendo layout adequado para web ou mobile)
          isWeb
              ? _buildWebLayout(context)
              : _buildMobileLayout(context, isWide),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.code, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Text(
            "CodePlay",
            style: GoogleFonts.rajdhani(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => context.push(AppConstants.configRoute),
          icon: const Icon(Icons.info_outline, color: Colors.white),
          tooltip: 'Sobre',
        ),
      ],
      backgroundColor: Colors.black.withAlpha(51),
      elevation: 0,
      centerTitle: false,
    );
  }

  // Layout específico para versão web com Wrap em vez de Carousel
  Widget _buildWebLayout(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 40),

              // Cards em uma única linha usando Wrap para responsividade
              Container(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: _cardSpacing,
                  runSpacing: _cardSpacing,
                  children: _buildModuleCards(context, true),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Layout para dispositivos móveis com Carousel para telas largas
  Widget _buildMobileLayout(BuildContext context, bool isWide) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),

                // Layout diferente dependendo da largura da tela
                isWide
                    ? _buildCarouselModules(context)
                    : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _buildModuleCards(context, false),
                    ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget de carrossel para telas mais largas em dispositivos móveis
  Widget _buildCarouselModules(BuildContext context) {
    return RepaintBoundary(
      child: CarouselSlider(
            options: CarouselOptions(
              height: 270,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 7),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              pauseAutoPlayOnTouch: true,
              viewportFraction: 0.42,
              enlargeFactor: 0.35,
              aspectRatio: 16 / 9,
              padEnds: false,
              pageSnapping: true,
            ),
            items: _buildModuleCards(context, false),
          )
          .animate()
          .fadeIn(duration: 600.ms, curve: Curves.easeOut)
          .scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOut),
    );
  }

  // Fundo animado com gradiente e overlay
  Widget _buildAnimatedBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.darkBackgroundColor,
            const Color(0xFF000C66),
            const Color(0xFF0000FF).withAlpha(102),
            const Color(0xFF000C66),
            AppColors.darkBackgroundColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Grade de linhas horizontais e verticais (estilo Tron)
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(
                lineColor: Colors.blue.withAlpha(38),
                gridSpacing: 40,
              ),
            ),
          ),

          // Imagem de fundo com baixa opacidade
          Opacity(
            opacity: 0.08,
            child: Image.asset(
              AppConstants.matrixBgImage,
              key: _imageKey,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              cacheWidth: 1280,
              cacheHeight: 720,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ],
      ),
    );
  }

  // Construir módulos para os diferentes tipos de conteúdo
  List<Widget> _buildModuleCards(BuildContext context, bool isWeb) {
    final modules = [
      {
        'title': 'Binário',
        'icon': Icons.memory,
        'route': AppConstants.binaryRoute,
        'color': AppColors.binaryModuleColor,
        'description':
            'Aprenda como os computadores representam dados com 0s e 1s',
      },
      {
        'title': 'ASCII',
        'icon': Icons.keyboard,
        'route': AppConstants.asciiRoute,
        'color': AppColors.asciiModuleColor,
        'description': 'Descubra como letras são convertidas em números',
      },
      {
        'title': 'RGB',
        'icon': Icons.palette,
        'route': AppConstants.rgbRoute,
        'color': AppColors.rgbModuleColor,
        'description': 'Explore como as cores são formadas por números',
      },
    ];

    return modules.map((module) {
      return ModuleCard(
        title: module['title'] as String,
        icon: module['icon'] as IconData,
        color: module['color'] as Color,
        description: module['description'] as String,
        isWeb: isWeb,
        onTap: () => _navigateToModule(context, module['route'] as String),
      );
    }).toList();
  }
}
