import 'package:aplikasi_manajemen_sdm/config/const.dart';
import 'package:aplikasi_manajemen_sdm/config/theme/color.dart';
import 'package:aplikasi_manajemen_sdm/view/global_widgets.dart';
import 'package:flutter/material.dart';

GenericCard authCard(ThemeData theme, TextEditingController nipController,
    TextEditingController passwordController, VoidCallback lupaPass) {
  return GenericCard(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        children: [
          Text(
            "Masuk ke akun anda",
            style: theme.textTheme.displayMedium!.copyWith(fontSize: 24),
          ),
          SizedBox(height: 26),
          CustomTextField(
            label: "NIP",
            controller: nipController,
            hint: "2241760089",
            isPassword: false, // or true for password fields
            inputType: TextInputType.number, // For numeric input
          ),
          SizedBox(height: 30),
          CustomTextField(
            controller: passwordController,
            label: "Password",
            hint: "password",
            isPassword: true, // or true for password fields
            inputType: TextInputType.text, // For numeric input
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: lupaPass,
                child: Text(
                  'Lupa password',
                  textAlign: TextAlign.right,
                  style: theme.textTheme.bodySmall!.copyWith(
                      fontSize: 13, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Padding loginButton(ThemeData theme, VoidCallback login, VoidCallback belumPunyaAkun) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: 64,
    ),
    child: Column(
      children: [
        CustomBigButton(
          wasElevated: true,
          padding: EdgeInsets.only(
            left: 34,
            top: 8,
            bottom: 8,
            right: 6,
          ),
          onPressed: login,
          wasIconOnRight: true,
          otherWidget: [
            Padding(
              padding: const EdgeInsets.only(right: 35),
              child: Text(
                "Masuk",
                style: theme.textTheme.displayLarge!.copyWith(
                  color: ColorNeutral.white,
                  fontSize: 24,
                ),
              ),
            )
          ],
          icon: CustomIconButton(
            "assets/icon/arrow-right.svg",
            colorBackground: ColorNeutral.gray,
            size: IconSize.large,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextButton(
          onPressed: belumPunyaAkun,
          child: Text(
            'Belum punya akun?',
            style: theme.textTheme.bodySmall!.copyWith(fontSize: 12),
          ),
        ),
      ],
    ),
  );
}
