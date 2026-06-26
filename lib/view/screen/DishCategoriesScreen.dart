import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/DishCategoriesController.dart';
import '../../core/functions/dialogDelete.dart';
import '../widget/dish_categories/DishCategoryCard.dart';
import '../widget/dish_categories/DishCategoryFormDialog.dart';
import '../widget/dish_categories/DishCategoriesHeader.dart';

class DishCategoriesScreen extends StatelessWidget {
  const DishCategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isArabic = Get.locale?.languageCode == 'ar';

    // Inject the DishCategoriesController
    Get.delete<DishCategoriesController>();
    final ctrl = Get.put(DishCategoriesController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 600;
            return Container(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Widget
              DishCategoriesHeader(
                onAddPressed: () {
                  Get.dialog(
                    const DishCategoryFormDialog(),
                    barrierDismissible: true,
                  );
                },
              ),
              const SizedBox(height: 36),

              // Responsive Category Grid Widget
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Responsive column counts based on width
                    int crossAxisCount = 3;
                    if (constraints.maxWidth < 600) {
                      crossAxisCount = 1;
                    } else if (constraints.maxWidth < 800) {
                      crossAxisCount = 2;
                    } else if (constraints.maxWidth < 1100) {
                      crossAxisCount = 3;
                    }

                    return Obx(() {
                      final categories = ctrl.dishCategories;

                      return GridView.builder(
                        itemCount: categories.length,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: constraints.maxWidth < 600 ? 16 : 24,
                          mainAxisSpacing: constraints.maxWidth < 600 ? 16 : 24,
                          mainAxisExtent: constraints.maxWidth < 600 ? 145 : 265,
                        ),
                        itemBuilder: (context, index) {
                          final category = categories[index];

                          return DishCategoryCard(
                            item: category,
                            onEdit: () {
                              ctrl.setEditData(category);
                              Get.dialog(
                                const DishCategoryFormDialog(isEdit: true),
                                barrierDismissible: true,
                              );
                            },
                            onDelete: () {
                              dialogDelete(
                                title: 'delete_confirm_btn'.tr,
                                content: 'delete_category_confirm_title'.tr,
                                onConfirm: () {
                                  ctrl.deletecat(category.uuid!);
                                },
                              );
                            },
                          );
                        },
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        );
          },
        ),
      ),
    );
  }
}
