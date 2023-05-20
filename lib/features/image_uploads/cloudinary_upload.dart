import 'package:cloudinary_public/cloudinary_public.dart';

import '../../common/debug_print.dart';
import '../../server_ip.dart';

final cloudinary = CloudinaryPublic(cloudName, uploadPreset, cache: true);

Future<String> imageUpload(img) async {
  try {
    CloudinaryResponse response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(img.path,
          resourceType: CloudinaryResourceType.Image),
    );

    prints(response.secureUrl);
    return response.secureUrl;
  } on CloudinaryException catch (e) {
    prints(e.message);
    prints(e.request);
    return "Err";
  }
}
