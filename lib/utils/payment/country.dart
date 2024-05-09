// To parse this JSON data, do
//
//     final countryModel = countryModelFromJson(jsonString);

import 'dart:convert';

CountryModel countryModelFromJson(String str) =>
    CountryModel.fromJson(json.decode(str));

String countryModelToJson(CountryModel data) => json.encode(data.toJson());

class CountryModel {
  CountryModel({
    this.country,
  });

  List<Country>? country;

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        country: json["country"] == null
            ? []
            : List<Country>.from(
                json["country"]!.map((x) => Country.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "country": country == null
            ? []
            : List<dynamic>.from(country!.map((x) => x.toJson())),
      };
}

class Country {
  Country({
    this.country,
    this.id,
    this.currencyCode,
    this.fields,
  });

  String? country;
  String? id;
  String? currencyCode;
  List<Field>? fields;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        country: json["country"],
        id: json["id"],
        currencyCode: json["currencyCode"],
        fields: json["fields"] == null
            ? []
            : List<Field>.from(json["fields"]!.map((x) => Field.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "id": id,
        "currencyCode": currencyCode,
        "fields": fields == null
            ? []
            : List<dynamic>.from(fields!.map((x) => x.toJson())),
      };
}

class Field {
  Field({
    this.name,
    this.type,
    this.ex,
  });

  String? name;
  String? type;
  String? ex;

  factory Field.fromJson(Map<String, dynamic> json) => Field(
        name: json["name"],
        type: json["type"],
        ex: json["ex"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "ex": ex,
      };
}

List<Country> countrdata = CountryModel.fromJson(_country).country ?? [];

// List<String> allowedCoutrys = ["US", "QA", "AE"];

// List<Country> listedContrys = countrdata
//     .where((e) => allowedCoutrys.any(
//         (element) => element.toLowerCase() == e.id.toString().toLowerCase()))
//     .toList();

List<Country> listedContrys = countrdata;

final _country = {
  "country": [
    {
      "country": "Albania (AL)",
      "id": "AL",
      "currencyCode": "ALL",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAALTXXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "IBAN",
          "ex": "AL35202111090000000001234567 (28 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Algeria (DZ)",
      "id": "DZ",
      "currencyCode": "DZD",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAADZDZXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "00001234567890123456 (20 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Angola (AO)",
      "id": "AO",
      "currencyCode": "AOA",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAAOAOXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "IBAN",
          "ex": "AO06004400006729503010102 (25 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Antigua and Barbuda (AG)",
      "id": "AG",
      "currencyCode": "XCD",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAAGAGXYZ (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "000123456789 (1-32 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Argentina (AR)",
      "id": "AR",
      "currencyCode": "ARS",
      "fields": [
        {
          "name": "CBU",
          "ex": "0110000600000000000000 (22 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Armenia (AM)",
      "id": "AM",
      "currencyCode": "AMD",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAAMNNXXX (8-11 digits)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "00001234567 (11-16 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Australia (AU)",
      "id": "AU",
      "currencyCode": "AUD",
      "fields": [
        {
          "name": "BSB",
          "ex": "123456 (6 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "12345678 (4-9 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Austria (AT)",
      "id": "AT",
      "currencyCode": "EUR",
      "fields": [
        {"name": "IBAN", "ex": "AT611904300234573201", "type": "account_number"}
      ]
    },
    {
      "country": "Azerbaijan (AZ)",
      "id": "AZ",
      "currencyCode": "AZN",
      "fields": [
        {"name": "Bank code", "ex": "123456 (6 digits)"},
        {"name": "Branch code", "ex": "123456 (6 digits)"},
        {
          "name": "IBAN",
          "ex": "AZ77ADJE12345678901234567890 (28 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Bahamas (BS)",
      "id": "BS",
      "currencyCode": "BSD",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAABSNSXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "0001234 (1-10 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Bahrain (BH)",
      "id": "BH",
      "currencyCode": "BHD",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAABHBMXYZ (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "IBAN",
          "ex": "BH29BMAG1299123456BH00 (22 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Bangladesh (BD)",
      "id": "BD",
      "currencyCode": "BDT",
      "fields": [
        {"name": "Bank code", "ex": "110000000 (9 characters)"},
        {
          "name": "Account Number",
          "ex": "0000123456789 (13-17 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Belgium (BE)",
      "id": "BE",
      "currencyCode": "EUR",
      "fields": [
        {"name": "IBAN", "ex": "BE12345678912345", "type": "account_number"}
      ]
    },
    {
      "country": "Benin (BJ)",
      "id": "BJ",
      "currencyCode": "XOF",
      "fields": [
        {
          "name": "IBAN",
          "ex": "BJ66BJ0610100100144390000769 (28 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Bhutan (BT)",
      "id": "BT",
      "currencyCode": "BTN",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAABTBTXXX (8-11 digits)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "0000123456789 (1-17 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Bolivia (BO)",
      "id": "BO",
      "currencyCode": "BOB",
      "fields": [
        {"name": "Bank code", "ex": "040 (1-3 digits)"},
        {
          "name": "Account Number",
          "ex": "000123456789 (10-15 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Bosnia and Herzegovina (BA)",
      "id": "BA",
      "currencyCode": "BAM",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAABABAXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "IBAN",
          "ex": "BA095520001234567812 (20 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Botswana (BW)",
      "id": "BW",
      "currencyCode": "BWP",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAABWBWXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "000123456789 (1-16 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Brazil (BR)",
      "id": "BR",
      "currencyCode": "BRL",
      "fields": [
        {"name": "Bank code", "ex": "123 (3 characters)"},
        {
          "name": "Branch code",
          "ex": "4567 (4 characters, with 1 optional check digit)"
        },
        {
          "name": "Account Number",
          "ex": "Format varies by bank",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Brunei (BN)",
      "id": "BN",
      "currencyCode": "BND",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAABNBBXXX (8-11 digits)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "0000123456789 (1-13 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Bulgaria (BG)",
      "id": "BG",
      "currencyCode": "BGN",
      "fields": [
        {
          "name": "IBAN",
          "ex": "BG80BNBG96611020345678 (22 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Cambodia (KH)",
      "id": "KH",
      "currencyCode": "KHR",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAKHKHXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "000123456789 (5-15 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Canada (CA)",
      "id": "CA",
      "currencyCode": "CAD",
      "fields": [
        {"name": "Transit Number", "ex": "12345"},
        {"name": "Institution Number", "ex": "678"},
        {
          "name": "Account Number",
          "ex": "Format varies by bank",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Chile (CL)",
      "id": "CL",
      "currencyCode": "CLP",
      "fields": [
        {"name": "Bank code", "ex": "507 (3 digits)"},
        {
          "name": "Account Number",
          "ex": "000123456789 (5-25 digits)",
          "type": "account_number"
        },
        {"name": "Bank account type", "ex": "checking"}
      ]
    },
    {
      "country": "Colombia (CO)",
      "id": "CO",
      "currencyCode": "COP",
      "fields": [
        {"name": "Bank code", "ex": "060 (3 digits)"},
        {
          "name": "Account Number",
          "ex": "000123456789 (9-16 digits)",
          "type": "account_number"
        },
        {"name": "Bank account type", "ex": "savings"}
      ]
    },
    {
      "country": "Costa Rica (CR)",
      "id": "CR",
      "currencyCode": "CRC",
      "fields": [
        {
          "name": "IBAN",
          "ex": "CR04010212367856709123 (22 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Côte d'Ivoire (CI)",
      "id": "CI",
      "currencyCode": "XOF",
      "fields": [
        {
          "name": "IBAN",
          "ex": "CI93CI0080111301134291200589 (28 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Croatia (HR)",
      "id": "HR",
      "currencyCode": "HRK",
      "fields": [
        {
          "name": "IBAN",
          "ex": "HR1210010051863000160 (21 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Cyprus (CY)",
      "id": "CY",
      "currencyCode": "EUR",
      "fields": [
        {
          "name": "IBAN",
          "ex": "CY17002001280000001200527600 (28 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Czech Republic (CZ)",
      "id": "CZ",
      "currencyCode": "CZK",
      "fields": [
        {
          "name": "IBAN",
          "ex": "CZ6508000000192000145399 (24 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Denmark (DK)",
      "id": "DK",
      "currencyCode": "DKK",
      "fields": [
        {"name": "IBAN", "ex": "DK5000400440116243", "type": "account_number"}
      ]
    },
    {
      "country": "Dominican Republic (DO)",
      "id": "DO",
      "currencyCode": "DOP",
      "fields": [
        {"name": "Bank Code", "ex": "021 (1-3 digits)"},
        {"name": "Branch Code", "ex": "4232 (0-5 digits)"},
        {
          "name": "Account Number",
          "ex": "000123456788 (Up to 28 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Ecuador (EC)",
      "id": "EC",
      "currencyCode": "USD",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAECE1XXX (8-11 digits)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "000123456789 (5-18 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Egypt (EG)",
      "id": "EG",
      "currencyCode": "EGP",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "NBEGEGCX331 (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "IBAN",
          "ex": "EG573456789012345678901111111 (29 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "El Salvador (SV)",
      "id": "SV",
      "currencyCode": "USD",
      "fields": [
        {"name": "SWIFT / BIC", "ex": "AAAASVS1XXX (8-11 characters)"},
        {
          "name": "IBAN",
          "ex": "SV44BCIE12345678901234567890 (28 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Estonia (EE)",
      "id": "EE",
      "currencyCode": "EUR",
      "fields": [
        {
          "name": "IBAN",
          "ex": "EE382200221020145685 (20 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Ethiopia (ET)",
      "id": "ET",
      "currencyCode": "ETB",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAETETXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "0000000012345 (13-16 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Finland (FI)",
      "id": "FI",
      "currencyCode": "EUR",
      "fields": [
        {"name": "IBAN", "ex": "FI2112345600000785", "type": "account_number"}
      ]
    },
    {
      "country": "France (FR)",
      "id": "FR",
      "currencyCode": "EUR",
      "fields": [
        {
          "name": "IBAN",
          "ex": "FR1420041010050500013M02606 (27 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Gabon (GA)",
      "id": "GA",
      "currencyCode": "XAF",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAGAGAXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "00001234567890123456789 (23 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Gambia (GM)",
      "id": "GM",
      "currencyCode": "GMD",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AGIXGMGM (8 - 11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "000123000456000789 (18 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Germany (DE)",
      "id": "DE",
      "currencyCode": "EUR",
      "fields": [
        {
          "name": "IBAN",
          "ex": "DE89370400440532013000 (22 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Ghana (GH)",
      "id": "GH",
      "currencyCode": "GHS",
      "fields": [
        {"name": "Bank sort code", "ex": "022112 (6 digits)"},
        {
          "name": "Account Number",
          "ex": "000123456789 (8-20 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Gibraltar (GI)",
      "id": "GI",
      "currencyCode": "GIP",
      "fields": [
        {
          "name": "IBAN",
          "ex": "GI75NWBK000000007099453 (23 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Greece (GR)",
      "id": "GR",
      "currencyCode": "EUR",
      "fields": [
        {
          "name": "IBAN",
          "ex": "GR1601101250000000012300695 (27 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Guatemala (GT)",
      "id": "GT",
      "currencyCode": "GTQ",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAGTGCXYZ (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "IBAN",
          "ex": "GT20AGRO00000000001234567890 (28 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Guyana (GY)",
      "id": "GY",
      "currencyCode": "GYD",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAGYGGXYZ (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "000123456789 (1-32 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Hong Kong (HK)",
      "id": "HK",
      "currencyCode": "HKD",
      "fields": [
        {"name": "Clearing Code", "ex": "123 (3 characters)"},
        {"name": "Branch code", "ex": "456 (3 characters)"},
        {
          "name": "Account Number",
          "ex": "123456-789 (6-9 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Hungary (HU)",
      "id": "HU",
      "currencyCode": "HUF",
      "fields": [
        {
          "name": "IBAN",
          "ex": "HU42117730161111101800000000(28 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Iceland (IS)",
      "id": "IS",
      "currencyCode": "ISK",
      "fields": [
        {
          "name": "IBAN",
          "ex": "IS140159260076545510730339 (26 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "India (IN)",
      "id": "IN",
      "currencyCode": "INR",
      "fields": [
        {"name": "IFSC Code", "ex": "HDFC0004051 (11 characters)"},
        {
          "name": "Account Number",
          "ex": "Format varies by bank",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Indonesia (ID)",
      "id": "ID",
      "currencyCode": "IDR",
      "fields": [
        {"name": "Bank name", "ex": "UOB Buana"},
        {"name": "Bank code", "ex": "023 (3-4 characters)"},
        {
          "name": "Account Number",
          "ex": "Format varies by bank",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Ireland (IE)",
      "id": "IE",
      "currencyCode": "EUR",
      "fields": [
        {
          "name": "IBAN",
          "ex": "IE29AIBK93115212345678 (22 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Israel (IL)",
      "id": "IL",
      "currencyCode": "ILS",
      "fields": [
        {
          "name": "IBAN",
          "ex": "IL620108000000099999999  (23 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Italy (IT)",
      "id": "IT",
      "currencyCode": "EUR",
      "fields": [
        {
          "name": "IBAN",
          "ex": "IT60X0542811101000000123456 (27 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Jamaica (JM)",
      "id": "JM",
      "currencyCode": "JMD",
      "fields": [
        {"name": "Bank Code", "ex": "111 (3 digits)"},
        {"name": "Branch Code", "ex": "00000 (5 digits)"},
        {
          "name": "Account Number",
          "ex": "000123456789 (Up to 18 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Japan (JP)",
      "id": "JP",
      "currencyCode": "JPY",
      "fields": [
        {"name": "Bank name", "ex": "いろは銀行"},
        {"name": "Branch name", "ex": "東京支店"},
        {"name": "Bank code", "ex": "0123 (4 characters)"},
        {"name": "Branch code", "ex": "456 (3 characters)"},
        {
          "name": "Account Number",
          "ex": "1234567 (7-8 characters)",
          "type": "account_number"
        },
        {"name": "Account owner name", "ex": "ヤマダハナコ"}
      ]
    },
    {
      "country": "Jordan (JO)",
      "id": "JO",
      "currencyCode": "JOD",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAJOJOXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "IBAN",
          "ex": "JO32ABCJ0010123456789012345678 (30 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Kazakhstan (KZ)",
      "id": "KZ",
      "currencyCode": "KZT",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAKZKZXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "IBAN",
          "ex": "KZ221251234567890123 (20 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Kenya (KE)",
      "id": "KE",
      "currencyCode": "KES",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "BARCKENXMDR (8 - 11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "0123456789 (up to 32 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Kuwait (KW)",
      "id": "KW",
      "currencyCode": "KWD",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAKWKWXYZ (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "IBAN",
          "ex": "KW81CBKU0000000000001234560101 (30 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Laos (LA)",
      "id": "LA",
      "currencyCode": "LAK",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAALALAXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "000123456789 (1-18 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Latvia (LV)",
      "id": "LV",
      "currencyCode": "EUR",
      "fields": [
        {
          "name": "IBAN",
          "ex": "LV80BANK0000435195001 (21 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Liechtenstein (LI)",
      "id": "LI",
      "currencyCode": "CHF",
      "fields": [
        {
          "name": "IBAN",
          "ex": "LI21088100002324013AA (21 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Lithuania (LT)",
      "id": "LT",
      "currencyCode": "EUR",
      "fields": [
        {
          "name": "IBAN",
          "ex": "LT121000011101001000 (20 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Luxembourg (LU)",
      "id": "LU",
      "currencyCode": "EUR",
      "fields": [
        {
          "name": "IBAN",
          "ex": "LU280019400644750000 (20 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Macau (MO)",
      "id": "MO",
      "currencyCode": "MOP",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAMOMXXXX (11 digits)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "0000000001234567897 (1-19 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Madagascar (MG)",
      "id": "MG",
      "currencyCode": "MGA",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAMGMGXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "IBAN",
          "ex": "MG4800005000011234567890123 (27 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Malaysia (MY)",
      "id": "MY",
      "currencyCode": "MYR",
      "fields": [
        {"name": "Bank name", "ex": "HSBC Bank Malaysia Berhad"},
        {
          "name": "SWIFT / BIC Code",
          "ex": "HBMBMYKL (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "1234567890 (5-17 digits, format varies by bank)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Malta (MT)",
      "id": "MT",
      "currencyCode": "EUR",
      "fields": [
        {
          "name": "IBAN",
          "ex": "MT84MALT011000012345MTLCAST001S (31 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Mauritius (MU)",
      "id": "MU",
      "currencyCode": "MUR",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAMUMUXYZ (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "IBAN",
          "ex": "MU17BOMM0101101030300200000MUR (30 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Mexico (MX)",
      "id": "MX",
      "currencyCode": "MXN",
      "fields": [
        {
          "name": "CLABE",
          "ex": "123456789012345678 (18 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Moldova (MD)",
      "id": "MD",
      "currencyCode": "MDL",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAMDMDXXX (11 digits)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "MD07AG123456789012345678 (24 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Monaco (MC)",
      "id": "MC",
      "currencyCode": "EUR",
      "fields": [
        {
          "name": "IBAN",
          "ex": "MC5810096180790123456789085 (27 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Mongolia (MN)",
      "id": "MN",
      "currencyCode": "MNT",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAMNUBXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "0002222001 (1-12 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Morocco (MA)",
      "id": "MA",
      "currencyCode": "MAD",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAMAMAXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "MA64011519000001205000534921 (28 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Mozambique (MZ)",
      "id": "MZ",
      "currencyCode": "MZN",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAMZMXXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "001234567890123456789 (21 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Namibia (NA)",
      "id": "NA",
      "currencyCode": "NAD",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAANANXXYZ (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "000123456789 (8-13 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Netherlands (NL)",
      "id": "NL",
      "currencyCode": "EUR",
      "fields": [
        {
          "name": "IBAN",
          "ex": "NL39RABO0300065264 (18 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "New Zealand (NZ)",
      "id": "NZ",
      "currencyCode": "NZD",
      "fields": [
        {
          "name": "Account Number",
          "ex": "AABBBB3456789YZZ (15-16 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Niger (NE)",
      "id": "NE",
      "currencyCode": "XOF",
      "fields": [
        {
          "name": "IBAN",
          "ex": "NE58NE0380100100130305000268 (28 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Nigeria (NG)",
      "id": "NG",
      "currencyCode": "NGN",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAANGLAXXX (11 digits)",
          "type": "routing_number"
        },
        {"name": "Account Number (NUBAN)", "ex": "1111111112 (10 digits)"}
      ]
    },
    {
      "country": "North Macedonia (MK)",
      "id": "MK",
      "currencyCode": "MKD",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAMK2XXXX (11 digits)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "MK49250120000058907 (19 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Norway (NO)",
      "id": "NO",
      "currencyCode": "NOK",
      "fields": [
        {
          "name": "IBAN",
          "ex": "NO9386011117947 (15 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Oman (OM)",
      "id": "OM",
      "currencyCode": "OMR",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAOMOMXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "000123456789 (6-16 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Pakistan (PK)",
      "id": "PK",
      "currencyCode": "PKR",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAPKKAXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "IBAN",
          "ex": "PK36SCBL0000001123456702 (24 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Panama (PA)",
      "id": "PA",
      "currencyCode": "PAB",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAAPAPAXXX (11 digits)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "000123456789 (1-18 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Paraguay (PY)",
      "id": "PY",
      "currencyCode": "PYG",
      "fields": [
        {"name": "Bank code", "ex": "27 (1-2 digits)"},
        {
          "name": "Account Number",
          "ex": "0000000123456789 (up to 16 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Peru (PE)",
      "id": "PE",
      "currencyCode": "PEN",
      "fields": [
        {
          "name": "CCI",
          "ex": "99934500012345670024 (20 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Philippines (PH)",
      "id": "PH",
      "currencyCode": "PHP",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "BOPIPHMM (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "0123456789010 (up to 17 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Poland (PL)",
      "id": "PL",
      "currencyCode": "PLN",
      "fields": [
        {
          "name": "IBAN",
          "ex": "PL61109010140000071219812874 (28 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Portugal (PT)",
      "id": "PT",
      "currencyCode": "EUR",
      "fields": [
        {
          "name": "IBAN",
          "ex": "PT50123443211234567890172 (25 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Qatar (QA)",
      "id": "QA",
      "currencyCode": "QAR",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "type": "routing_number",
          "ex": "AAAAMK2XXXX (11 digits)"
        },
        {
          "name": "IBAN",
          "type": "account_number",
          "ex": "QA87CITI123456789012345678901 (29 digits)"
        }
      ]
    },
    {
      "country": "Romania (RO)",
      "id": "RO",
      "currencyCode": "RON",
      "fields": [
        {
          "name": "IBAN",
          "ex": "RO49AAAA1B31007593840000 (24 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Rwanda (RW)",
      "id": "RW",
      "currencyCode": "RWF",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAARWRWXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "000123456789 (1-15 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Saint Lucia (LC)",
      "id": "LC",
      "currencyCode": "XCD",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAALCLCXYZ (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "000123456789 (1-32 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Saudi Arabia (SA)",
      "id": "SA",
      "currencyCode": "SAR",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "NCBKSAJE101 (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "IBAN",
          "ex": "SA0380000000608010167519 (24 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "San Marino (SM)",
      "id": "SM",
      "currencyCode": "EUR",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAASMSMXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "IBAN",
          "ex": "SM86U0322509800000000270100 (27 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Senegal (SN)",
      "id": "SN",
      "currencyCode": "XOF",
      "fields": [
        {
          "name": "IBAN",
          "ex": "SN08SN0100152000048500003035 (28 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Serbia (RS)",
      "id": "RS",
      "currencyCode": "RSD",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "BKCHRSBG (8 - 11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "RS35260005601001611379 (22 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Singapore (SG)",
      "id": "SG",
      "currencyCode": "SGD",
      "fields": [
        {"name": "Bank code", "ex": "1234"},
        {"name": "Branch code", "ex": "567"},
        {
          "name": "Account Number",
          "ex": "1234567890123456789 (6-19 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Slovakia (SK)",
      "id": "SK",
      "currencyCode": "EUR",
      "fields": [
        {
          "name": "IBAN",
          "ex": "SK3112000000198742637541 (24 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Slovenia (SI)",
      "id": "SI",
      "currencyCode": "EUR",
      "fields": [
        {
          "name": "IBAN",
          "ex": "SI56263300012039086 (19 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "South Africa (ZA)",
      "id": "ZA",
      "currencyCode": "ZAR",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "FIRNZAJJ (8 - 11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "2140000054 (up to 16 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "South Korea (KR)",
      "id": "KR",
      "currencyCode": "KRW",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "TESTKR00123 (8 - 11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "012345678912 (11-15 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Spain (ES)",
      "id": "ES",
      "currencyCode": "EUR",
      "fields": [
        {
          "name": "IBAN",
          "ex": "ES9121000418450200051332 (24 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Sri Lanka (LK)",
      "id": "LK",
      "currencyCode": "LKR",
      "fields": [
        {"name": "Bank code", "ex": "AAAALKLXXXX (11 characters)"},
        {"name": "Branch code", "ex": "7010999 (7 characters)"},
        {
          "name": "Account Number",
          "ex": "0000012345 (10-18 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Sweden (SE)",
      "id": "SE",
      "currencyCode": "SEK",
      "fields": [
        {
          "name": "IBAN",
          "ex": "SE3550000000054910000003 (24 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Switzerland (CH)",
      "id": "CH",
      "currencyCode": "CHF",
      "fields": [
        {
          "name": "IBAN",
          "ex": "CH9300762011623852957 (21 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Taiwan (TW)",
      "id": "TW",
      "currencyCode": "TWD",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAATWTXXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "0001234567 (10-14 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Tanzania (TZ)",
      "id": "TZ",
      "currencyCode": "TZS",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "AAAATZTXXXX (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "Account Number",
          "ex": "0000123456789 (10-14 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Thailand (TH)",
      "id": "TH",
      "currencyCode": "THB",
      "fields": [
        {"name": "Bank name", "ex": "Bangkok Bank Public Company Limited"},
        {"name": "Bank code", "ex": "002 (3 characters)"},
        {
          "name": "Account Number",
          "ex": "12345678901236 (6-15 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Trinidad & Tobago (TT)",
      "id": "TT",
      "currencyCode": "TTD",
      "fields": [
        {"name": "Bank code", "ex": "999 (3 characters)"},
        {"name": "Branch code", "ex": "00001 (5 characters)"},
        {
          "name": "Account Number",
          "ex": "00001234123456788 (up to 17 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Tunisia (TN)",
      "id": "TN",
      "currencyCode": "TND",
      "fields": [
        {
          "name": "IBAN",
          "ex": "TN5904018104004942712345 (24 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Turkey (TR)",
      "id": "TR",
      "currencyCode": "TRY",
      "fields": [
        {
          "name": "SWIFT / BIC Code",
          "ex": "ADABTRIS (8-11 characters)",
          "type": "routing_number"
        },
        {
          "name": "IBAN",
          "ex": "TR330006100519786457841326 (26 characters)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "United Kingdom (GB)",
      "id": "GB",
      "currencyCode": "GBP",
      "fields": [
        {"name": "Sort Code", "ex": "12-34-56"},
        {"name": "Account Number", "ex": "01234567", "type": "account_number"}
      ]
    },
    {
      "country": "United States (US)",
      "id": "US",
      "currencyCode": "USD",
      "fields": [
        {
          "name": "Routing Number",
          "type": "routing_Number",
          "ex": "111000000 (9 characters)"
        },
        {
          "name": "Account Number",
          "type": "account_number",
          "ex": "Format varies by bank"
        }
      ]
    },
    {
      "country": "United Arab Emirates (AE)",
      "id": "AE",
      "currencyCode": "AED",
      "fields": [
        {
          "name": "IBAN",
          "type": "account_number",
          "ex": "AE070331234567890123456 (23 digits)"
        }
      ]
    },
    {
      "country": "Uruguay (UY)",
      "id": "UY",
      "currencyCode": "UYU",
      "fields": [
        {"name": "Bank code", "ex": "091 (3 digits)"},
        {
          "name": "Account Number",
          "ex": "000123456788 (Up to 12 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Uzbekistan (UZ)",
      "id": "UZ",
      "currencyCode": "UZS",
      "fields": [
        {"name": "Bank Code", "ex": "AAAAUZUZXXX (11 digits)"},
        {"name": "Branch Code", "ex": "00000 (5 digits)"},
        {
          "name": "Account Number",
          "ex": "99934500012345670024 (5-20 digits)",
          "type": "account_number"
        }
      ]
    },
    {
      "country": "Vietnam (VN)",
      "id": "VN",
      "currencyCode": "VND",
      "fields": [
        {"name": "Bank code", "ex": "01101100 (8 digits)"},
        {
          "name": "Account Number",
          "ex": "000123456789 (1-17 digits)",
          "type": "account_number"
        }
      ]
    }
  ]};
