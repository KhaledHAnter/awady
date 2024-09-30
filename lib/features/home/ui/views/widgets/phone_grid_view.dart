import 'package:Awady/core/helpers/extentions.dart';
import 'package:Awady/core/routing/routes.dart';
import 'package:Awady/core/theming/colors.dart';
import 'package:Awady/features/home/data/phone_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class PhoneGridView extends StatelessWidget {
  List<PhoneModel> phoneList;
  final void Function(int)? deleteCallback;
  PhoneGridView(
      {super.key, required this.phoneList, required this.deleteCallback});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 3x3 layout
        crossAxisSpacing: 12,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75, // Adjust aspect ratio to fit image and text
      ),
      itemCount: phoneList.length,
      itemBuilder: (ctx, index) {
        return GestureDetector(
          onTap: () {
            context.pushNamed(Routes.itemDetailView,
                arguments: phoneList[index]);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // border: Border.all(
              //   color: Colors.grey,
              //   width: 2,
              // ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      phoneList[index].image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${phoneList[index].price} LE.",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            phoneList[index].name,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () => deleteCallback!(index),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorsManager.mainBlue.withOpacity(.15)),
                      child: const Icon(
                        Icons.check,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
