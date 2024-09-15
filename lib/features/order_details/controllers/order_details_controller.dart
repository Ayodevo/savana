import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/order/controllers/order_controller.dart';
import 'package:sixvalley_vendor_app/features/order_details/domain/models/order_details_model.dart';
import 'package:sixvalley_vendor_app/features/order_details/domain/services/order_details_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';

class OrderDetailsController extends ChangeNotifier{
  final OrderDetailsServiceInterface orderDetailsServiceInterface;
  OrderDetailsController({required this.orderDetailsServiceInterface});


  List<OrderDetailsModel>? _orderDetails;
  List<OrderDetailsModel>? get orderDetails => _orderDetails;
  List<String> _orderStatusList = [];
  List<String> get orderStatusList => _orderStatusList;
  String? _orderStatusType = '';
  String? get orderStatusType => _orderStatusType;
  int _paymentMethodIndex = 0;
  int get paymentMethodIndex => _paymentMethodIndex;
  File? _selectedFileForImport ;
  File? get selectedFileForImport =>_selectedFileForImport;
  bool _isLoading = false;
  bool get isLoading=> _isLoading;


  Future<ApiResponse> updateOrderStatus(int? id, String? status) async {
    ApiResponse apiResponse = await orderDetailsServiceInterface.orderStatus(id, status);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

      Map map = apiResponse.response!.data;
      String? message = map['message'];

      showCustomSnackBarWidget(message, Get.context!, isToaster: true,isError: false);
      Provider.of(Get.context!)<OrderController>().getOrderList(Get.context!, 1, 'all');
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<void> getOrderDetails( String orderID) async {
    _orderDetails = null;
    ApiResponse apiResponse = await orderDetailsServiceInterface.getOrderDetails(orderID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _orderDetails = [];
      apiResponse.response!.data.forEach((order) => _orderDetails!.add(OrderDetailsModel.fromJson(order)));
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }


  void initOrderStatusList(String type) async {
    ApiResponse apiResponse = await orderDetailsServiceInterface.getOrderStatusList(type);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _orderStatusList =[];
      _orderStatusList.addAll(apiResponse.response!.data);
      _orderStatusType = apiResponse.response!.data[0];
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void setPaymentMethodIndex(int index) {
    _paymentMethodIndex = index;
    notifyListeners();
  }

  Future updatePaymentStatus({int? orderId, String? status}) async {
    ApiResponse apiResponse = await orderDetailsServiceInterface.updatePaymentStatus(orderId: orderId, status: status);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Provider.of(Get.context!)<OrderController>().getOrderList(Get.context!, 1, 'all');
      String? message = getTranslated('payment_status_updated_successfully', Get.context!);
      showCustomSnackBarWidget(message, Get.context!, isToaster: true, isError: false);

    }else if(apiResponse.response!.statusCode == 202){
      Map map = apiResponse.response!.data;
      String? message = map['message'];
      showCustomSnackBarWidget(message, Get.context!, isError: true);

    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void setSelectedFileName(File? fileName){
    _selectedFileForImport = fileName;
    notifyListeners();
  }

  Future<ApiResponse> uploadReadyAfterSellDigitalProduct(BuildContext context, File? digitalProductAfterSellFile, String token, String orderId) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse  response = await orderDetailsServiceInterface.uploadAfterSellDigitalProduct(digitalProductAfterSellFile, token, orderId);
    if(response.response!.statusCode == 200) {
      _isLoading = false;
      showCustomSnackBarWidget(getTranslated("digital_product_uploaded_successfully", Get.context!), Get.context!, isError: false);
    }else {
      _isLoading = false;
    }
    _isLoading = false;
    notifyListeners();
    return response;
  }

}