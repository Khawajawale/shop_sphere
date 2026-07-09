import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/security/input_validators.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/providers/remote_config_provider.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../routes/route_names.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../../../payment/domain/entities/payment_models.dart';
import '../../../payment/presentation/providers/payment_provider.dart';
import '../../../payment/presentation/widgets/sandbox_payment_section.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expMonthController = TextEditingController(text: '12');
  final _expYearController = TextEditingController(text: '30');
  final _cvcController = TextEditingController(text: '123');

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _cardNumberController.dispose();
    _expMonthController.dispose();
    _expYearController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cartItems = ref.read(cartControllerProvider);
    final totalPrice = ref.read(cartTotalPriceProvider);
    final config = ref.read(remoteConfigProvider);
    final shippingFee =
        totalPrice >= config.freeShippingThreshold ? 0.0 : 5.0;
    final grandTotal = totalPrice + shippingFee;
    final fullAddress =
        '${_addressController.text}, ${_cityController.text}, ${_zipController.text}';
    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

    final paymentResult =
        await ref.read(paymentControllerProvider.notifier).processCheckoutPayment(
              amount: grandTotal,
              card: SandboxCardDetails(
                cardNumber: _cardNumberController.text,
                expMonth: _expMonthController.text,
                expYear: _expYearController.text,
                cvc: _cvcController.text,
              ),
              orderId: orderId,
            );

    if (!mounted) return;

    if (paymentResult == null || !paymentResult.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            paymentResult?.failureReason ??
                ref.read(paymentControllerProvider).error ??
                'Payment failed. Please try another card.',
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    await ref.read(ordersControllerProvider.notifier).placeOrder(
          cartItems,
          grandTotal,
          fullAddress,
          orderId: orderId,
          paymentId: paymentResult.paymentId,
          paymentStatus: paymentResult.status.value,
          cardLast4: paymentResult.last4,
        );

    await AnalyticsService.logPurchase(
      transactionId: orderId,
      value: grandTotal,
      itemCount: cartItems.length,
    );

    await ref.read(cartControllerProvider.notifier).clearCart();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            paymentResult.last4 != null
                ? 'Payment approved •••• ${paymentResult.last4}'
                : 'Order placed successfully!',
          ),
          backgroundColor: Colors.green,
        ),
      );
      context.go(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartControllerProvider);
    final subtotal = ref.watch(cartTotalPriceProvider);
    final config = ref.watch(remoteConfigProvider);
    final isProcessing = ref.watch(paymentControllerProvider).isProcessing;
    final shippingFee =
        subtotal >= config.freeShippingThreshold ? 0.0 : 5.0;
    final grandTotal = subtotal + shippingFee;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Add items to cart to start checkout.'))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppSizes.md),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Text(
                        'Delivery Address Details',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(AppSizes.md),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppSizes.cardRadius,
                        boxShadow: const [
                          BoxShadow(color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            validator: InputValidators.validateName,
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _addressController,
                            label: 'Street Address',
                            validator: (val) => InputValidators.sanitizeText(
                              val,
                              fieldName: 'Street address',
                              maxLength: InputValidators.maxAddressLength,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: _cityController,
                                  label: 'City',
                                  validator: (val) => InputValidators.sanitizeText(
                                    val,
                                    fieldName: 'City',
                                    maxLength: InputValidators.maxCityLength,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTextField(
                                  controller: _zipController,
                                  label: 'Zip Code',
                                  keyboardType: TextInputType.number,
                                  validator: (val) => InputValidators.sanitizeText(
                                    val,
                                    fieldName: 'Zip code',
                                    maxLength: InputValidators.maxZipLength,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    SandboxPaymentSection(
                      cardNumberController: _cardNumberController,
                      expMonthController: _expMonthController,
                      expYearController: _expYearController,
                      cvcController: _cvcController,
                    ),
                    const SizedBox(height: AppSizes.lg),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Text(
                        'Billing Information Summary',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(AppSizes.md),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppSizes.cardRadius,
                        boxShadow: const [
                          BoxShadow(color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildPriceItem(
                            'Cart Subtotal',
                            '\$${subtotal.toStringAsFixed(2)}',
                          ),
                          const SizedBox(height: 8),
                          _buildPriceItem(
                            subtotal >= config.freeShippingThreshold
                                ? 'Postal Delivery (Free)'
                                : 'Postal Delivery',
                            shippingFee == 0
                                ? 'FREE'
                                : '\$${shippingFee.toStringAsFixed(2)}',
                          ),
                          if (subtotal < config.freeShippingThreshold) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Add \$${(config.freeShippingThreshold - subtotal).toStringAsFixed(2)} more for free shipping',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Final Grand Total',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '\$${grandTotal.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.xl),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isProcessing ? null : _submitOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: isProcessing
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Pay & Place Order',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildPriceItem(String title, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ],
    );
  }
}
