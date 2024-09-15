import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/emergency_contract/domain/models/emergency_contact_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/emergency_contract/controllers/emergency_contact_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';

class AddEmergencyContactWidget extends StatefulWidget {
  final ContactList? contactList;
  final int? index;
  const AddEmergencyContactWidget({Key? key,  this.index, this.contactList}) : super(key: key);

  @override
  State<AddEmergencyContactWidget> createState() => _AddEmergencyContactWidgetState();
}

class _AddEmergencyContactWidgetState extends State<AddEmergencyContactWidget> {

  TextEditingController contactNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();

  @override
  void initState() {
    if(widget.contactList != null){
      contactNameController.text = widget.contactList!.name!;
      phoneController.text = widget.contactList!.phone!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        surfaceTintColor: Theme.of(context).cardColor,
        child: Consumer<EmergencyContactController>(
          builder: (context, emergencyContactProvider, _) {
            return Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [

                Container(
                    margin: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge,
                    bottom: Dimensions.paddingSizeSmall),
                    child: CustomTextFieldWidget(
                      border: true,
                      hintText: getTranslated('contact_name', context),
                      focusNode: nameFocus,
                      nextNode: phoneFocus,
                      textInputType: TextInputType.name,
                      controller: contactNameController,
                      textInputAction: TextInputAction.next,
                    )),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(margin: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge,
                    bottom: Dimensions.paddingSizeSmall),
                    child: CustomTextFieldWidget(
                      border: true,
                      hintText: getTranslated('phone', context),
                      focusNode: phoneFocus,
                      textInputType: TextInputType.phone,
                      controller: phoneController,
                      textInputAction: TextInputAction.next,
                    )),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                  child: emergencyContactProvider.isLoading? const CircularProgressIndicator():
                  CustomButtonWidget(btnTxt: widget.contactList != null?  getTranslated('update', context) : getTranslated('add', context),
                  onTap: (){
                    int? id = widget.contactList?.id;
                    String name = contactNameController.text.trim();
                    String phone = phoneController.text.trim();
                    if(name.isEmpty){
                      showCustomSnackBarWidget(getTranslated('contact_name_is_required', context), context);
                    }
                    else if(phone.isEmpty){
                      showCustomSnackBarWidget(getTranslated('phone_is_required', context), context);
                    }else{
                      emergencyContactProvider.addNewEmergencyContact(context, name, phone, id, isUpdate: widget.contactList != null);
                    }
                  },),
                )
              ],),
            );
          }
        ));
  }
}
