// library oscilloscopepsv;

// import 'package:flutter/material.dart';

// // ignore: must_be_immutable
// class OscilloscopePsv extends StatefulWidget {
//   List<double> dataSet;
//   double yAxisMin;
//   double yAxisMax;
//   double padding;
//   Color backgroundColor;
//   Color traceColor;
//   Color yAxisColor;
//   bool showYAxis;

//   OscilloscopePsv(
//       {this.traceColor = Colors.white,
//       this.backgroundColor = Colors.black,
//       this.yAxisColor = Colors.grey,
//       this.padding = 20.0,
//       this.yAxisMax = 3000.0,
//       this.yAxisMin = -3000.0,
//       this.showYAxis = true,
//       @required this.dataSet});

//   @override
//   _OscilloscopeState createState() => _OscilloscopeState();
// }

// class _OscilloscopeState extends State<OscilloscopePsv> {
//   double yRange;
//   double yScale;

//   @override
//   void initState() {
//     super.initState();
//     yRange = widget.yAxisMax - widget.yAxisMin;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(widget.padding),
//       width: double.infinity,
//       height: double.infinity,
//       color: widget.backgroundColor,
//       child: ClipRect(
//         child: CustomPaint(
//           painter: _TracePainter(
//               showYAxis: widget.showYAxis,
//               yAxisColor: widget.yAxisColor,
//               dataSet: widget.dataSet,
//               traceColor: widget.traceColor,
//               yMin: widget.yAxisMin,
//               yRange: yRange),
//         ),
//       ),
//     );
//   }
// }

// /// A Custom Painter used to generate the trace line from the supplied dataset
// class _TracePainter extends CustomPainter {
//   final List dataSet;
//   final double xScale;
//   final double yMin;
//   final Color traceColor;
//   final Color yAxisColor;
//   final bool showYAxis;
//   final double yRange;

//   _TracePainter(
//       {this.showYAxis,
//       this.yAxisColor,
//       this.yRange,
//       this.yMin,
//       this.dataSet,
//       this.xScale = 5.0,
//       this.traceColor = Colors.white});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final tracePaint = Paint()
//       ..strokeJoin = StrokeJoin.round
//       ..strokeWidth = 3.0
//       ..color = traceColor
//       ..style = PaintingStyle.stroke;

//     final axisPaint = Paint()
//       ..strokeWidth = 2
//       ..color = yAxisColor;

//     double yScale = (size.height / yRange);

//     // only start plot if dataset has data
//     int length = dataSet.length;
//     if (length > 0) {
//       // transform data set to just what we need if bigger than the width(otherwise this would be a memory hog)
//       if (length > 150) {
//         dataSet.removeAt(0);
//         length = dataSet.length;
//       }

//       // Create Path and set Origin to first data point
//       Path trace = Path();
//       trace.moveTo(0.0, size.height - (dataSet[0].toDouble() - yMin) * yScale);

//       // generate trace path
//       for (int p = 0; p < length; p++) {
//         double plotPoint =
//             size.height - ((dataSet[p].toDouble() - yMin) * yScale);
//         // double plotPointx =
//         //     size.height - ((dataset1[p].toDouble() - yMin) * xScale);
//         trace.lineTo(p.toDouble() * xScale, plotPoint);
//       }

//       // display the trace
//       canvas.drawPath(trace, tracePaint);

//       // if yAxis required draw it here
//       if (showYAxis) {
//         Offset yStart = Offset(0.0, size.height - (0.0 - yMin) * yScale);
//         Offset yEnd = Offset(size.width, size.height - (0.0 - yMin) * yScale);
//         canvas.drawLine(yStart, yEnd, axisPaint);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(_TracePainter old) => true;
// }
