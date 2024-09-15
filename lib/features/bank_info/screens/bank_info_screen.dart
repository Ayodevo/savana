
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/bank_info/screens/bank_editing_screen.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/bank_info/controllers/bank_info_controller.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';

import 'package:sixvalley_vendor_app/features/bank_info/widgets/bank_info_widget.dart';

class BankInfoScreen extends StatelessWidget {
  const BankInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title:getTranslated('bank_info', context), isBackButtonExist: true,),
        body: Consumer<BankInfoController>(
          builder: (context, bankProvider, child) {
            String name = bankProvider.bankInfo!.holderName?? '';
            String bank = bankProvider.bankInfo!.bankName?? '';
            String branch = bankProvider.bankInfo!.branch?? '';
            String accountNo = bankProvider.bankInfo!.accountNo?? '';
            return Column(children: [
                GestureDetector(
                  onTap: ()=>Navigator.push(context,
                      MaterialPageRoute(builder: (_) => BankEditingScreen(sellerModel: bankProvider.bankInfo))),
                  child: Padding(
                    padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text(getTranslated('edit_info', context)!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge,
                          color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                          Theme.of(context).hintColor: Theme.of(context).primaryColor)),
                      Icon(Icons.edit, color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                      Theme.of(context).hintColor: Theme.of(context).primaryColor)
                    ],),
                  ),
                ),

                BankInfoWidget(name: name,bank: bank,branch: branch,accountNo: accountNo,),
              ],
            );
          }
        ));
  }
}


