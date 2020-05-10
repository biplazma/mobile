import 'package:flutter/material.dart';
import 'package:biplazma/util/app_colors.dart';
import 'package:biplazma/widget/slider/sliderThumb.dart';

class SliderWidget extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;

  SliderWidget({this.sliderHeight = 42, this.max = 65, this.min = 18, this.fullWidth = true});

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double _value = 18;

  @override
  Widget build(BuildContext context) {
    double paddingFactor = .2;

    if (this.widget.fullWidth) paddingFactor = .3;

    return Container(
      width: this.widget.fullWidth ? double.infinity : (this.widget.sliderHeight) * 5.5,
      height: (this.widget.sliderHeight),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(Radius.circular((this.widget.sliderHeight * .3))),
        gradient: new LinearGradient(
          colors: [AppColors.gradient1, AppColors.gradient2],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 1.00),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(this.widget.sliderHeight * paddingFactor, 2, this.widget.sliderHeight * paddingFactor, 2),
        child: Row(
          children: <Widget>[
            Text(
              '${this.widget.min}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: this.widget.sliderHeight * .3, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            SizedBox(width: this.widget.sliderHeight * .1),
            Expanded(
              child: Center(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.white.withOpacity(1),
                    inactiveTrackColor: Colors.white.withOpacity(.5),
                    trackHeight: 4.0,
                    thumbShape: CustomSliderThumbCircle(thumbRadius: this.widget.sliderHeight * .4, min: this.widget.min, max: this.widget.max),
                    overlayColor: Colors.white.withOpacity(.4),
                    activeTickMarkColor: Colors.white,

                    inactiveTickMarkColor: Colors.red.withOpacity(.7),
                  ),
                  child: Slider(
                      min: double.parse(widget.min.toString()),
                      max: double.parse(widget.max.toString()),
                      divisions: 47,
                      value: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                      }),
                ),
              ),
            ),
            SizedBox(width: this.widget.sliderHeight * .1),
            Text(
              '${this.widget.max}+',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: this.widget.sliderHeight * .3, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
