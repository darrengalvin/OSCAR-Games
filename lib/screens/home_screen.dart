import 'package:flutter/material.dart';
import '../models/game_info.dart';
import '../services/save_service.dart';
import '../theme/app_theme.dart';
import '../widgets/game_card.dart';
import '../games/tic_tac_toe/tic_tac_toe_screen.dart';
import '../games/memory_match/memory_match_screen.dart';
import '../games/snake/snake_screen.dart';
import '../games/reaction/reaction_screen.dart';
import '../games/target_shooter/world_select_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _titleController;
  late Animation<double> _titleAnimation;

  late final List<GameInfo> games = [
    GameInfo(
      id: 'tic_tac_toe',
      title: 'Tic Tac Toe',
      subtitle: 'Classic strategy game',
      description: 'Challenge the AI or a friend in this timeless classic!',
      icon: Icons.grid_3x3_rounded,
      color: AppTheme.accent,
      secondaryColor: AppTheme.accentDark,
      screenBuilder: () => const TicTacToeScreen(),
      minPlayers: 1,
      maxPlayers: 2,
      difficulty: 'Easy',
    ),
    GameInfo(
      id: 'memory_match',
      title: 'Memory Match',
      subtitle: 'Test your memory',
      description: 'Flip cards and find all matching pairs!',
      icon: Icons.psychology_rounded,
      color: AppTheme.purple,
      secondaryColor: AppTheme.pink,
      screenBuilder: () => const MemoryMatchScreen(),
      difficulty: 'Medium',
    ),
    GameInfo(
      id: 'snake',
      title: 'Snake',
      subtitle: 'Classic arcade action',
      description: 'Guide the snake to eat food and grow longer!',
      icon: Icons.linear_scale_rounded,
      color: AppTheme.success,
      secondaryColor: AppTheme.accent,
      screenBuilder: () => const SnakeScreen(),
      difficulty: 'Medium',
    ),
    GameInfo(
      id: 'reaction',
      title: 'Reaction Speed',
      subtitle: 'How fast are you?',
      description: 'Test your reflexes with this speed challenge!',
      icon: Icons.flash_on_rounded,
      color: AppTheme.warning,
      secondaryColor: AppTheme.danger,
      screenBuilder: () => const ReactionScreen(),
      difficulty: 'Easy',
    ),
    GameInfo(
      id: 'target_shooter',
      title: 'Target Shooter',
      subtitle: '3 Worlds • 20 Levels',
      description: 'Shoot targets across The Playground, Jupiter & The Backrooms!',
      icon: Icons.track_changes_rounded,
      color: AppTheme.danger,
      secondaryColor: AppTheme.warning,
      screenBuilder: () => const WorldSelectScreen(),
      difficulty: 'Hard',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _titleAnimation = CurvedAnimation(
      parent: _titleController,
      curve: Curves.elasticOut,
    );
    _titleController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  int? _getHighScore(String gameId) {
    final save = SaveService.instance;
    switch (gameId) {
      case 'snake':
        final s = save.snakeHighScore;
        return s > 0 ? s : null;
      case 'tic_tac_toe':
        final total = save.tttWinsX + save.tttWinsO + save.tttDraws;
        return total > 0 ? save.tttWinsX : null;
      case 'memory_match':
        return save.memoryBestMoves(4);
      case 'reaction':
        return save.reactionBest;
      case 'target_shooter':
        final s = save.totalLevelsCompleted;
        return s > 0 ? s : null;
      default:
        return null;
    }
  }

  void _openGame(GameInfo game) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            game.screenBuilder(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.82,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildGameCard(index),
                    childCount: games.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _buildComingSoon()),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScaleTransition(
            scale: _titleAnimation,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.accent.withValues(alpha: 0.3),
                        AppTheme.purple.withValues(alpha: 0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.accent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.sports_esports_rounded,
                    color: AppTheme.accent,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OSCAR',
                      style: TextStyle(
                        color: AppTheme.accent,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ),
                    Text(
                      'GAME CENTER',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 6,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.accent.withValues(alpha: 0.08),
                  AppTheme.purple.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.accent.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.local_fire_department_rounded,
                  color: AppTheme.warning.withValues(alpha: 0.8),
                  size: 20,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Pick a game and start playing!',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${games.length} Games',
                    style: const TextStyle(
                      color: AppTheme.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildGameCard(int index) {
    final game = games[index];
    return GameCard(
      game: game,
      highScore: _getHighScore(game.id),
      onTap: () => _openGame(game),
    );
  }

  Widget _buildComingSoon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surface.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.textSecondary.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.rocket_launch_rounded,
              color: AppTheme.textSecondary.withValues(alpha: 0.4),
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              'More Games Coming Soon',
              style: TextStyle(
                color: AppTheme.textSecondary.withValues(alpha: 0.6),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Puzzle, Quiz, Racing & more!',
              style: TextStyle(
                color: AppTheme.textSecondary.withValues(alpha: 0.4),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
