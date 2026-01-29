unit mfcr_resources;

interface

resourcestring
  errExceptBase64Length = 'Neplatná délka dat pro konverzi z Base64';

  errCertificateNotFound = 'Certifikát se sériovým èíslem %s nebyl nalezen v úložišti';
  errReceiptFileExists = 'Soubor %s pro potvrzení již existuje a nelze jej smazat';
  errReceiptFileNotFound = 'Soubor %s s potvrzením podání neexistuje';
  errReceiptFileTooSmall = 'Soubor %s s potvrzením podání je pøíliš malý';
  errReceiptNoXMLData = 'Soubor %s s potvrzením neobsahuje data ve formátu XML, nebo došlo k chybnému pøijetí';
  errReceiptBadXMLData = 'Soubor %s s potvrzením neobsahuje ukonèení sekce Pisemnost';
  errReceiptFileDoesNotContainFile = 'Soubor %s s potvrzením podání neobsahuje informace o souboru';
  errReceiptFileDoesNotContainInfo = 'Soubor %s s potvrzením podání neobsahuje informace o podání';
  errBadReceiptLogin = 'Podací èíslo a/nebo heslo nebylo vyplnìno';

  errWSPostEx = 'Chyba pøi odesílání dat na server MFÈR: %s. Soubor nebyl odeslán.';
  errWSPostRC = 'Nepodaøilo se odeslat data na server MFÈR, kód: %d';
  errWSXMLDelka = 'Ze serveru MFÈR byl vrácen špatný XML soubor';
  errWSGetEx = 'Chyba pøi naèítání dat ze serveru MFÈR: %s';
  errWSGetRC = 'Nepodaøilo se pøijmout data ze serveru MFÈR, kód: %d';

implementation

end.
