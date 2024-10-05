import 'package:Awady/features/home/data/phone_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ItemDetailsView extends StatelessWidget {
  final PhoneModel phone;
  const ItemDetailsView({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(phone.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  phone.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Name: ${phone.name}",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Price: ${phone.price} LE.",
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(16.h),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      phone.description ?? "No description",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  Gap(16.h),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Picked on: ${DateFormat('yyyy-MM-dd – kk:mm').format(phone.dateTime)}",
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
