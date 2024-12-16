import 'package:url_launcher/url_launcher.dart';
import '../exports.dart';

getAppAccessPopUp () {
  return showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            vGap(20.0),
            TextView('App Access', style: black_17_600(),).marginSymmetric(horizontal: 20.0),
            vGap(10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                textAlign: TextAlign.start,
                text:  TextSpan(
                  text: "You do not have access to our Stock Application. Please contact us at",
                  style: black_14_600()?.copyWith(color: Colors.black.withOpacity(0.7)),
                  children:  <TextSpan>[
                    TextSpan(
                      text: ' info@denven.com ',
                      style: black_14_600()?.copyWith(color: primaryColor),
                    ),
                    TextSpan(
                      text: 'to request access.',
                      style: black_14_600()?.copyWith(color: Colors.black.withOpacity(0.7)),
                    ),
                  ],
                ),
              ),
            ),
            vGap(10.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      borderRadius: BorderRadius.circular(6.0),
                      onTap: (){

                        String? encodeQueryParameters(Map<String, String> params) {
                          return params.entries
                              .map((MapEntry<String, String> e) =>
                          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                              .join('&');
                        }

                        try{
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'info@denven.com',
                            query: encodeQueryParameters(<String, String>{
                              'App Access': '',
                            }),
                          );

                          launchUrl(emailLaunchUri);
                        }catch (err){
                          Utils.showSnackBar(Strings.somethingWentWrong);
                        }
                      },
                      child: Text("Contact Us", style: primaryColor_16_700()).paddingSymmetric(horizontal: 20.0,vertical: 10.0)),
                ],
              ),
            ).marginSymmetric(horizontal: 10.0),
            vGap(10.0),
          ],
        ),
      );
    },
  );
}

