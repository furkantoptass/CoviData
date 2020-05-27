import 'package:flutter/material.dart';

// Colors
const kBackgroundColor = Color(0xFFFEFEFE);
const kTitleTextColor = Color(0xFF303030);
const kBodyTextColor = Color(0xFF4B4B4B);
const kTextLightColor = Color(0xFF959595);
const kInfectedColor = Color(0xFFFF8748);
const kDeathsColor = Color(0xFFFF4848);
const kRecoveredColor = Color(0xFF36C12C);
const kPrimaryColor = Color(0xFF3382CC);
const kSickColor = Color(0xfff8b250);
final kShadowColor = Color(0xFFB7B7B7).withOpacity(.16);
final kActiveShadowColor = Color(0xFF4056C6).withOpacity(.15);

// Text Style
const kHeadingTextStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w600,
);

const kSubTextStyle = TextStyle(fontSize: 16, color: kTextLightColor);

const kTitleTextstyle = TextStyle(
  fontSize: 18,
  color: kTitleTextColor,
  fontWeight: FontWeight.bold,
);

const Map<String, String> kCountries = {
  'Tüm Dünya': 'Global',
  'Türkiye': 'Turkey',
  'ABD': 'US',
  'Almanya': 'Germany',
  'Avusturya': 'Austria',
  'Belçika': 'Belgium',
  'Birleşik Krallık': 'United Kingdom',
  'Brezilya': 'Brazil',
  'Bulgaristan': 'Bulgaria',
  'Çekya': 'Czechia',
  'Çin': 'China',
  'Danimarka': 'Denmark',
  'Estonya': 'Estonia',
  'Finlandiya': 'Finland',
  'Fransa': 'France',
  'Hırvatistan': 'Croatia',
  'Hollanda': 'Netherlands',
  'İrlanda': 'Ireland',
  'İspanya': 'Spain',
  'İsveç': 'Sweden',
  'İtalya': 'Italy',
  'Kanada': 'Canada',
  'Letonya': 'Latvia',
  'Litvanya': 'Lithuania',
  'Lüksemburg': 'Luxembourg',
  'Macaristan': 'Hungary',
  'Malta': 'Malta',
  'Polonya': 'Poland',
  'Portekiz': 'Portugal',
  'Romanya': 'Romania',
  'Rusya': 'Russia',
  'Slovakya': 'Slovakia',
  'Slovenya': 'Slovenia',
  'Yunanistan': 'Greece'
};
