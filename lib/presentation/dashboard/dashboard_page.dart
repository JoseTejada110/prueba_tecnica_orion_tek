import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orion_tek_app/core/constants.dart';
import 'package:orion_tek_app/data/models/chart_data.dart';
import 'package:orion_tek_app/presentation/dashboard/dashboard_controller.dart';
import 'package:orion_tek_app/presentation/widgets/custom_card.dart';
import 'package:orion_tek_app/presentation/widgets/custom_shimmer.dart';
import 'package:orion_tek_app/presentation/widgets/input_title.dart';
import 'package:orion_tek_app/presentation/widgets/placeholders_widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController(apiRepository: Get.find()));
    //
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: controller.obx(
        onLoading: const _LoadingPlaceholder(),
        onError: (errorString) => ErrorPlaceholder(
          errorString ?? '',
          tryAgain: controller.getDashboardData,
        ),
        (_) => RefreshIndicator(
          onRefresh: controller.getDashboardData,
          child: ListView(
            padding: Constants.bodyPadding,
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              _DataCardsRow(),
              SizedBox(height: 20),
              _ChartsColumn(),
              // _ClientsByMonthChart(),
              // SizedBox(height: 20),
              // _CircularChart(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DataCardsRow extends StatelessWidget {
  const _DataCardsRow();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    return FadeInDown(
      child: Row(
        children: [
          Expanded(
            child: _DashboardCard(
              title: 'Clientes \nActivos',
              data: controller.totalClients.toStringAsFixed(0),
              icon: Icons.people,
              iconBackgroundColor: Constants.green,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _DashboardCard(
              title: 'Direcciones \nRegistradas',
              data: controller.totalAddresses.toStringAsFixed(0),
              icon: Icons.location_on,
              iconBackgroundColor: Constants.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.data,
    this.iconBackgroundColor,
  });
  final String title;
  final IconData icon;
  final String data;
  final Color? iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor:
                iconBackgroundColor ?? Theme.of(context).primaryColor,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 10),
                Text(
                  data,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
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

class _ChartsColumn extends StatelessWidget {
  const _ChartsColumn();

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: const Column(
        children: [
          _ClientsByMonthChart(),
          SizedBox(height: 20),
          _CircularChart(),
        ],
      ),
    );
  }
}

class _ClientsByMonthChart extends StatelessWidget {
  const _ClientsByMonthChart();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    return CustomCard(
      padding: Constants.bodyPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InputTitle('Clientes activos últimos 6 meses'),
          SizedBox(
            height: 250,
            child: SfCartesianChart(
              legend: const Legend(isVisible: false),
              primaryYAxis: NumericAxis(),
              primaryXAxis: CategoryAxis(),
              trackballBehavior: TrackballBehavior(
                enable: true,
                lineColor: Colors.transparent,
                markerSettings: const TrackballMarkerSettings(
                  markerVisibility: TrackballVisibilityMode.visible,
                  height: 10,
                  width: 10,
                  borderWidth: 1,
                ),
                hideDelay: 2000,
                activationMode: ActivationMode.singleTap,
              ),
              series: [
                ColumnSeries(
                  color: const Color(0XFF7078c2), //525bb6
                  dataSource: controller.chartData,
                  xValueMapper: (ChartData point, _) => point.x,
                  yValueMapper: (ChartData point, _) => point.y,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularChart extends GetView<DashboardController> {
  const _CircularChart();

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: Constants.bodyPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InputTitle('Distribución de tipos de direcciones'),
          SizedBox(
            height: 250,
            child: SfCircularChart(
              margin: EdgeInsets.zero,
              legend: Legend(
                isVisible: true,
                width: '30%',
                legendItemBuilder: (legendText, series, point, seriesIndex) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Row(
                      children: [
                        Icon(
                          Icons.donut_large,
                          color: point.pointColor,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            legendText,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              series: [
                DoughnutSeries<ChartData, String>(
                  dataSource: controller.addressByTypeChartData,
                  enableTooltip: true,
                  xValueMapper: (ChartData point, _) => point.x,
                  yValueMapper: (ChartData point, _) => point.y,
                  pointColorMapper: (ChartData point, _) => point.color,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
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

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _CardPlaceholder(
                  height: 90,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _CardPlaceholder(
                  height: 90,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _CardPlaceholder(
            height: 250,
          ),
          SizedBox(height: 20),
          _CardPlaceholder(
            height: 250,
          ),
        ],
      ),
    );
  }
}

class _CardPlaceholder extends StatelessWidget {
  const _CardPlaceholder({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
        ),
      ),
    );
  }
}
