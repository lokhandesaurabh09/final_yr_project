import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.weatherBlueMuted,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.weatherBlue.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.wb_sunny_rounded,
                      color: AppColors.warning, size: 16),
                  const SizedBox(width: 6),
                  const Text(
                    'VINEYARD WEATHER',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              Text(
                'Nashik, MH',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.weatherBlue.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Temperature big
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '28',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1,
                  letterSpacing: -2,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  '°C',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Spacer(),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Partly Cloudy',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Good for field work',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Metrics row
          Row(
            children: [
              _WeatherMetric(
                icon: Icons.water_drop_rounded,
                label: 'Humidity',
                value: '72%',
                color: AppColors.weatherBlue,
              ),
              const SizedBox(width: 8),
              _WeatherMetric(
                icon: Icons.air_rounded,
                label: 'Wind',
                value: '12 km/h',
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              _WeatherMetric(
                icon: Icons.thermostat_rounded,
                label: 'Feels like',
                value: '31°C',
                color: AppColors.warning,
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Disease risk from weather
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 14, color: AppColors.warning),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'High humidity increases Powdery Mildew risk today',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.warning,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _WeatherMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
