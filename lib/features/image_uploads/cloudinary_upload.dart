import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

final cloudinary = CloudinaryPublic('dmnvphmdi', 'lvqrgqrr', cache: false);

Future<String> imageUpload(img) async {
  try {
    CloudinaryResponse response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(img.path,
          resourceType: CloudinaryResourceType.Image),
    );

    print(response.secureUrl);
    return response.secureUrl;
  } on CloudinaryException catch (e) {
    print("Ye kya hogya");
    print(e.message);
    print(e.request);
    return "Err";
  }
}
