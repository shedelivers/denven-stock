import 'package:denvin_stock/exports.dart';

class TextView extends StatelessWidget {
  String text;
  TextStyle? style;
  int? maxLine;
  TextAlign? textAlign;
   TextView(this.text,{Key? key,this.style,this.maxLine,this.textAlign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style:style ,maxLines:maxLine,textAlign: textAlign,overflow: TextOverflow.ellipsis);
  }
}
