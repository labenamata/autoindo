import 'package:auto_indo/model/ohcl_model.dart';

List<double> calculateRSI(List<Ohcl> prices, int period) {
  List<double> gains = [];
  List<double> losses = [];

  for (int i = 1; i < prices.length; i++) {
    double change = prices[i].close! - prices[i - 1].close!;
    if (change > 0) {
      gains.add(change);
      losses.add(0);
    } else {
      gains.add(0);
      losses.add(-change);
    }
  }

  double avgGain = gains.sublist(0, period).reduce((a, b) => a + b) / period;
  double avgLoss = losses.sublist(0, period).reduce((a, b) => a + b) / period;

  List<double> rsi = [];

  for (int i = period; i < prices.length; i++) {
    double rs = avgLoss == 0 ? 100 : avgGain / avgLoss;
    rsi.add(100 - (100 / (1 + rs)));

    if (i + 1 < prices.length) {
      avgGain = ((avgGain * (period - 1)) + gains[i]) / period;
      avgLoss = ((avgLoss * (period - 1)) + losses[i]) / period;
    }
  }

  return rsi;
}
