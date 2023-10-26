import 'package:flutter/material.dart';
import 'package:product_manager_app/AllScreens/text_form.dart';
import 'package:product_manager_app/Helper/sql_helper.dart';
import 'package:image_picker/image_picker.dart';

class AddProductBottomSheet extends StatefulWidget {
  int? id;
  List produuct;
   AddProductBottomSheet({super.key, required this.id, required this.produuct});

  @override
  State<AddProductBottomSheet> createState() => _AddProductBottomSheetState();
}

class _AddProductBottomSheetState extends State<AddProductBottomSheet> {
  TextEditingController _name = TextEditingController();
  TextEditingController _quantity = TextEditingController();
    TextEditingController _price = TextEditingController();
  //TextEditingController _ = TextEditingController();

  @override
  void initState() {
    
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(widget.id != null){
      final existingProduuct = widget.produuct.firstWhere((element) => element['id']==widget.id);
    _price.text= existingProduuct['price'].toString();
    _name.text = existingProduuct ['name'];
    _quantity.text  = existingProduuct ['quantity'].toString();
    }
    return SingleChildScrollView(
      child: Padding(
     padding: MediaQuery.of(context).viewInsets,
        child: Container(
          child:  Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Add Product'),
                 SizedBox(height: 15,),
                CustomTextField(controller: _name,hint: 'Product Name',),
                SizedBox(height: 10,),
                CustomTextField(controller: _quantity,hint: 'Product quantity',),
                SizedBox(height: 10,),
                CustomTextField(controller: _price,hint: 'Product Price',),
                SizedBox(height: 10,),
               widget.id==null? GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: Container(
                    height: 50,
                    width: 1000,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black54)
                    ),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child:imagePath.isEmpty? Text('Upload Product Image'):Text(imagePath, overflow: TextOverflow.ellipsis,),
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),
               
                 SizedBox(height: 20,),
                 ElevatedButton(onPressed: ()async{
                  if(widget.id == null){
                   await  addNewProduct();
                  }else{
                  await  updateProduct(widget.id!);
                  }
                 }, child: Text(widget.id == null?'Add Product':"Update Item"))
              ],
            ),
          ),
        ),
      ),
    );
  }
  
 Future<void> addNewProduct() async{
await SQLHelper.createItem(imagePath,_price.text.toString(),_quantity.text.toString(),  _name.text.toString(), );
 Navigator.pop(context, true);
  }

String imagePath = "";
Future<void> _pickImage() async {
  final imagePicker = ImagePicker();
  final image = await imagePicker.pickImage(source: ImageSource.gallery);

  if (image == null) {
    // User canceled the image picking.
    return;
  }

  setState(() {
    // Save the image path.
    imagePath = image.path;
  });
}

  Future<void> updateProduct(int ID)async {
    await SQLHelper.updateItem(ID, _price.text.toString(),_quantity.text.toString(),  _name.text.toString() );
 Navigator.pop(context, true);
  }

}