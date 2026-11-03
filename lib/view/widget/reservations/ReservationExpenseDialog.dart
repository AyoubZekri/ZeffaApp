import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/constant/AppTheme.dart';
import '../../../core/functions/valiedinput.dart';
import '../CustemDropDownField.dart';
import '../CustemTextField.dart';

/// Small dialog to add / edit one expense inside the reservation form.
/// Returns {type, description, value} (plus the original uuid when editing).
class ReservationExpenseDialog extends StatefulWidget {
  final Map<String, dynamic>? initial;

  const ReservationExpenseDialog({super.key, this.initial});

  @override
  State<ReservationExpenseDialog> createState() =>
      _ReservationExpenseDialogState();
}

class _ReservationExpenseDialogState extends State<ReservationExpenseDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _amount;
  int? _type;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(
      text: widget.initial?['description']?.toString() ?? '',
    );
    final value = widget.initial?['value'] as num?;
    _amount = TextEditingController(text: value?.toInt().toString() ?? '');
    _type = widget.initial?['type'] as int?;
  }

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Get.back(
      result: {
        if (widget.initial?['uuid'] != null) 'uuid': widget.initial!['uuid'],
        'type': _type,
        'description': _name.text.trim(),
        'value': double.tryParse(_amount.text) ?? 0.0,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>() ?? AppColors.light;
    final textColor = theme.colorScheme.onSurface;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: theme.colorScheme.surface,
      child: Container(
        width: 460,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.initial == null ? 'add_expense'.tr : 'edit_expense'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 20),
              CustemTextField(
                controller: _name,
                label: 'expense_name'.tr,
                hint: 'expense_name'.tr,
                icon: Icons.description_outlined,
                validator: (val) => validInput(val!, 1000, 1, "Text"),
              ),
              const SizedBox(height: 16),
              Text(
                'category'.tr,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              CustemDropDownField<int>(
                value: _type,
                onChanged: (val) => setState(() => _type = val),
                validator: (val) =>
                    val == null ? "please_select_category".tr : null,
                items: [
                  DropdownMenuItem(value: 1, child: Text('workers'.tr)),
                  DropdownMenuItem(value: 4, child: Text('maintenance'.tr)),
                  DropdownMenuItem(
                    value: 2,
                    child: Text('cleaning_materials'.tr),
                  ),
                  DropdownMenuItem(value: 3, child: Text('other_expenses'.tr)),
                ],
              ),
              const SizedBox(height: 16),
              CustemTextField(
                controller: _amount,
                label: 'amount_da'.tr,
                hint: '0',
                icon: Icons.monetization_on_outlined,
                keyboardType: TextInputType.number,
                validator: (val) => validInput(val!, 1000, 1, "number"),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'cancel'.tr,
                      style: TextStyle(color: colors.subtitleColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryPurple,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('save'.tr),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
