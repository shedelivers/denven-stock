import 'package:denvin_stock/exports.dart';
import 'package:denvin_stock/pages/settings_module/video_player.dart';
import 'controller/training_videos_controller.dart';


class TrainingVideosScreen extends GetView<TrainingVideosController> {
  const TrainingVideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(showLogo: false,title: "Training Videos", centerLogo: true),

      body: ListView.separated(
          itemCount: controller.trainingVideos.length,
          separatorBuilder: (context, i)=> const SizedBox(height: 0,),
        itemBuilder: (context, index){
            final data = controller.trainingVideos[index];
            return ListTile(
              onTap: (){Get.to(()=> VideoPlayerScreen(title: data['title']??"", url: data['url']??""));},
              title: Text(data['title']??""),
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            );
        },
      )
    );
  }
}
