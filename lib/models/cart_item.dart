
import 'product.dart';
import 'lens_options.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

class CartItem {
  final String id;
  final Product product;
  final LensType? lensType;
  final List<LensTreatment> treatments;
  final XFile? prescriptionFile;

  CartItem({
    String? id,
    required this.product,
    this.lensType,
    this.treatments = const [],
    this.prescriptionFile,
  }) : id = id ?? const Uuid().v4();

  double get totalPrice {
    double total = product.price;
    if (lensType != null) {
      total += lensType!.price;
    }
    for (var t in treatments) {
      total += t.price;
    }
    return total;
  }
}
