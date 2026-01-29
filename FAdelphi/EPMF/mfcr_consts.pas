unit mfcr_consts;

interface

const

  CAPICOM_MEMORY_STORE = $00000000;
  CAPICOM_LOCAL_MACHINE_STORE = $00000001;
  CAPICOM_CURRENT_USER_STORE = $00000002;
  CAPICOM_ACTIVE_DIRECTORY_USER_STORE = $00000003;
  CAPICOM_SMART_CARD_USER_STORE = $00000004;

  CAPICOM_STORE_OPEN_READ_ONLY = $00000000;
  CAPICOM_STORE_OPEN_READ_WRITE = $00000001;
  CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED = $00000002;
  CAPICOM_STORE_OPEN_EXISTING_ONLY = $00000080;
  CAPICOM_STORE_OPEN_INCLUDE_ARCHIVED = $00000100;

  CAPICOM_CHECK_TRUSTED_ROOT = $00000001;
  CAPICOM_CHECK_TIME_VALIDITY = $00000002;
  CAPICOM_CHECK_SIGNATURE_VALIDITY = $00000004;
  CAPICOM_CHECK_COMPLETE_CHAIN = $00000020;
  CAPICOM_CHECK_NAME_CONSTRAINTS = $00000040;
  CAPICOM_CHECK_BASIC_CONSTRAINTS = $00000080;
  CAPICOM_CHECK_NESTED_VALIDITY_PERIOD = $00000100;

  CAPICOM_AUTHENTICATED_ATTRIBUTE_SIGNING_TIME = $00000000;
  CAPICOM_AUTHENTICATED_ATTRIBUTE_DOCUMENT_NAME = $00000001;
  CAPICOM_AUTHENTICATED_ATTRIBUTE_DOCUMENT_DESCRIPTION = $00000002;

  CAPICOM_ENCODE_BASE64 = $00000000;
  CAPICOM_ENCODE_BINARY = $00000001;
  CAPICOM_ENCODE_ANY = $FFFFFFFF;

  CAPICOM_STORE = 'CAPICOM.Store';
  CAPICOM_SIGNEDDATA = 'CAPICOM.SignedData';
  CAPICOM_SIGNER = 'CAPICOM.Signer';
  CAPICOM_ATTRIBUTE = 'CAPICOM.Attribute';

  // testovaci mfwwwit-1.mfcr.cz presunuto 17.2.2016 na novou adresum ep1ww1z.mfcr.cz

  //sMFCREPOSendURLtest = 'https://ep1ww1z.mfcr.cz/servlet/epo_podani'; // testovaci
  sMFCREPOSendURLtest = 'https://adisspr.zkus.mfcr.cz/dpr/epo_podani'; // testovaci
  //sMFCREPOSendURLtest_2 = 'https://ep1ww1z.mfcr.cz'; // testovaci
  sMFCREPOSendURLtest_2 = 'https://adisspr.zkus.mfcr.cz'; // testovaci
  //sMFCREPOSendURLtestParams_2 = '/servlet/epo_podani'; // testovaci
  sMFCREPOSendURLtestParams_2 = '/dpr/epo_podani'; // testovaci

  {platne do 31.12.2021
  sMFCREPOSendURL = 'https://adisepo.mfcr.cz/adistc/epo_podani'; // ostre
  sMFCREPOSendURL_2 = 'https://adisepo.mfcr.cz'; // ostre
  sMFCREPOSendURLParams_2 = '/adistc/epo_podani'; // ostre
  }

  sMFCREPOSendURL = 'https://adisspr.mfcr.cz/dpr/epo_podani'; // ostre
  sMFCREPOSendURL_2 = 'https://adisspr.mfcr.cz'; // ostre
  sMFCREPOSendURLParams_2 = '/dpr/epo_podani'; // ostre

  {platne do 31.12.2021
  sMFCREPOStateURL = 'https://adisepo.mfcr.cz/adistc/epo_stav?C=%s&H=%s';
  sMFCREPOStateURL_2 = 'https://adisepo.mfcr.cz';
  sMFCREPOStateURLParams_2 = '/adistc/epo_stav?C=%s&H=%s';
  }

  sMFCREPOStateURL = 'https://adisspr.mfcr.cz/dpr/epo_stav?C=%s&H=%s';
  sMFCREPOStateURL_2 = 'https://adisspr.mfcr.cz';
  sMFCREPOStateURLParams_2 = '/dpr/epo_stav?C=%s&H=%s';

  //Dotaz na stav prijeti offline pod·nÌ
  sMFCREPOStateOfflineURLTest = 'https://ep1ww1z.mfcr.cz/servlet/epo_prijeti?C=%s&H=%s';
  sMFCREPOStateOfflineURLParamsTest = '/servlet/epo_prijeti?C=%s&H=%s';

  {platne do 31.12.2021
  sMFCREPOStateOfflineURL = 'https://adisepo.mfcr.cz/adistc/epo_prijeti?C=%s&H=%s';
  sMFCREPOStateOfflineURLParams = '/adistc/epo_prijeti?C=%s&H=%s';
  }

  sMFCREPOStateOfflineURL = 'https://adisspr.mfcr.cz/dpr/epo_prijeti?C=%s&H=%s';
  sMFCREPOStateOfflineURLParams = '/dpr/epo_prijeti?C=%s&H=%s';

  sContentTypePKCS7 = 'application/pkcs7-signature';
  sContentTypeAsk ='application/x-www-form-urlencoded';
  sContentTypeXML = 'application/xml';

  sCertificateStoreName = 'My';
  sMFCertCA = 'I.CA - Qualified root certificate';
  sCertificateMPSVOID = '1.3.6.1.5.5.7.1.3';

  sFileFieldStart = '<Soubor';
  sFileFieldEnd = '/>';
  sFileFieldName = 'Nazev';
  sReceiptFieldStart = '<Podani';
  sReceiptFieldEnd = '/>';
  sReceiptFieldNumber = 'Cislo';
  sReceiptFieldDate = 'Datum';
  sReceiptFieldEmail = 'Email';
  sReceiptFieldPassword = 'Heslo';
  sReceiptFieldCheck = 'KC';

  sXMLStart = '<?xml';
  sErrorFindChyby = '<Chyby>';
  sErrorFindTypeStart = '<Chyba Typ="';
  sErrorFindTypeEnd = '">';
  sErrorFindTextStart = '<Text>';
  sErrorFindTextEnd = '</Text>';

  sDeliveryFind_por_podani = 'por_podani';
  sDeliveryFind_apl_oblpod = 'apl_oblpod';
  sDeliveryFind_typ_podani = 'typ_podani';
  sDeliveryFind_c_ufo_prij = 'c_ufo_prij';
  sDeliveryFind_email_ext = 'email_ext';
  sDeliveryFind_d_podani = 'd_podani';
  sDeliveryFind_cas_podani = 'cas_podani';
  sDeliveryFind_stav_podpre = 'stav_podpre';
  sDeliveryFind_stav_podpre_text = 'stav_podpre_text';
  sDeliveryFind_p_zareppod = 'p_zareppod';
  sDeliveryFind_p_platnostpod = 'p_platnostpod';
  sDeliveryFind_p_chybapod = 'p_chybapod';
  sDeliveryFind_stav_podapl = 'stav_podapl';
  sDeliveryFind_stav_podapl_text = 'stav_podapl_text';
  sDeliveryFind_d_pripodapl = 'd_pripodapl';
  sDeliveryFind_pozn_pripodapl = 'pozn_pripodapl';
  sDeliveryFind_p_testpod = 'p_testpod';

  XMLReplaceStrings: Array[0..48] of record O, N: String; end = (
  ( O: '&apos;';   N: '''' ),
  ( O: '&#x011B;'; N: 'Ï' ),
  ( O: '&#x11B;';  N: 'Ï' ),
  ( O: '&#x0161;'; N: 'ö' ),
  ( O: '&#x161;';  N: 'ö' ),
  ( O: '&#x010D;'; N: 'Ë' ),
  ( O: '&#x10D;';  N: 'Ë' ),
  ( O: '&#x0159;'; N: '¯' ),
  ( O: '&#x159;';  N: '¯' ),
  ( O: '&#x017E;'; N: 'û' ),
  ( O: '&#x17E;';  N: 'û' ),
  ( O: '&#xFD;';   N: '˝' ),
  ( O: '&#xE1;';   N: '·' ),
  ( O: '&#xED;';   N: 'Ì' ),
  ( O: '&#xE9;';   N: 'È' ),
  ( O: '&#xFA;';   N: '˙' ),
  ( O: '&#x016F;'; N: '˘' ),
  ( O: '&#x16F;';  N: '˘' ),
  ( O: '&#xF3;';   N: 'Û' ),
  ( O: '&#x0165;'; N: 'ù' ),
  ( O: '&#x165;';  N: 'ù' ),
  ( O: '&#x0148;'; N: 'Ú' ),
  ( O: '&#x148;';  N: 'Ú' ),
  ( O: '&#x010F;'; N: 'Ô' ),
  ( O: '&#x10F;';  N: 'Ô' ),
  ( O: '&#x011A;'; N: 'Ã' ),
  ( O: '&#x11A;';  N: 'Ã' ),
  ( O: '&#x0160;'; N: 'ä' ),
  ( O: '&#x160;';  N: 'ä' ),
  ( O: '&#x010C;'; N: '»' ),
  ( O: '&#x10C;';  N: '»' ),
  ( O: '&#x0158;'; N: 'ÿ' ),
  ( O: '&#x158;';  N: 'ÿ' ),
  ( O: '&#x017D;'; N: 'é' ),
  ( O: '&#x17D;';  N: 'é' ),
  ( O: '&#xDD;';   N: '›' ),
  ( O: '&#xC1;';   N: '¡' ),
  ( O: '&#xCD;';   N: 'Õ' ),
  ( O: '&#xC9;';   N: '…' ),
  ( O: '&#xDA;';   N: '⁄' ),
  ( O: '&#x016E;'; N: 'Ÿ' ),
  ( O: '&#x16E;';  N: 'Ÿ' ),
  ( O: '&#xD3;';   N: '”' ),
  ( O: '&#x0164;'; N: 'ç' ),
  ( O: '&#x164;';  N: 'ç' ),
  ( O: '&#x0147;'; N: '“' ),
  ( O: '&#x147;';  N: '“' ),
  ( O: '&#x010E;'; N: 'œ' ),
  ( O: '&#x10E;';  N: 'œ' ) );

implementation

end.

