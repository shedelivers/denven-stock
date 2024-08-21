import 'package:denvin_stock/exports.dart';

class GetInkWell extends StatelessWidget {
  Widget child;
  Function? onTap;
   GetInkWell({Key? key,required this.child,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(onTap!=null){
          onTap!()??(){

          };
        }
      },
      child: child,
    );
  }
}
