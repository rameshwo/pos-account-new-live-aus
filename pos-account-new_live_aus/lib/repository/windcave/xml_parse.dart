// ignore_for_file: deprecated_member_use

import 'package:xml/xml.dart';

class XmlParse {
  static String jsonToString(Map<String, dynamic> json) {
    final builder = XmlBuilder();
    builder.element('Scr', attributes: {
      'action': 'doScrHIT',
      'user': json['user'],
      'key': json['key'],
    }, nest: () {
      if (json['Amount'] != null)
        builder.element('Amount', nest: json['Amount']);
      if (json['Cur'] != null) builder.element('Cur', nest: json['Cur']);
      if (json['TxnType'] != null)
        builder.element('TxnType', nest: json['TxnType']);
      if (json['Station'] != null)
        builder.element('Station', nest: json['Station']);
      if (json['TxnRef'] != null)
        builder.element('TxnRef', nest: json['TxnRef']);
      if (json['DeviceId'] != null)
        builder.element('DeviceId', nest: json['DeviceId']);
      if (json['PosName'] != null)
        builder.element('PosName', nest: json['PosName']);
      if (json['VendorId'] != null)
        builder.element('VendorId', nest: json['VendorId']);

      if (json['PosVersion'] != null)
        builder.element('PosVersion', nest: json['PosVersion']);
      if (json['MRef'] != null) builder.element('MRef', nest: json['MRef']);
      if (json['UrlSuccess'] != null)
        builder.element('UrlSuccess', nest: json['UrlSuccess']);
      if (json['UrlFail'] != null)
        builder.element('UrlFail', nest: json['UrlFail']);

      // Buttons
      if (json['UiType'] != null)
        builder.element('UiType', nest: json['UiType']);
      if (json['Name'] != null) builder.element('Name', nest: json['Name']);
      if (json['Val'] != null) builder.element('Val', nest: json['Val']);

      //Matched Refund
      if (json['DpsTxnRef'] != null)
        builder.element('DpsTxnRef', nest: json['DpsTxnRef']);

      //Receipt
      if (json['DuplicateFlag'] != null)
        builder.element('DuplicateFlag', nest: json['DuplicateFlag']);
      if (json['ReceiptType'] != null)
        builder.element('ReceiptType', nest: json['ReceiptType']);
    });
    final xmlRequest = builder.buildDocument().toXmlString();

    return xmlRequest;
  }

  static Map<String, dynamic> xmlToJson(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final rootElement = document.rootElement;

    return {
      'TxnType': rootElement.getElement('TxnType')?.text ?? '',
      'TxnRef': rootElement.getElement('TxnRef')?.text ?? '',
      if (rootElement.getElement('StatusId') != null)
        'StatusId': rootElement.getElement('StatusId')?.text ?? '',
      if (rootElement.getElement('TxnStatusId') != null)
        'TxnStatusId': rootElement.getElement('TxnStatusId')?.text ?? '',
      if (rootElement.getElement('Complete') != null)
        'Complete': rootElement.getElement('Complete')?.text ?? '',
      if (rootElement.getElement('RcptW') != null)
        'RcptW': rootElement.getElement('RcptW')?.text ?? '',
      if (rootElement.getElement('Rcpt') != null)
        'Rcpt': rootElement.getElement('Rcpt')?.text ?? '',
      if (rootElement.getElement('Result') != null)
        'Result': {
          'AC': rootElement.getElement('Result')?.getElement('AC')?.text ?? '',
          'AP': rootElement.getElement('Result')?.getElement('AP')?.text ?? '',
          'CN': rootElement.getElement('Result')?.getElement('CN')?.text ?? '',
          'CT': rootElement.getElement('Result')?.getElement('CT')?.text ?? '',
          'CH': rootElement.getElement('Result')?.getElement('CH')?.text ?? '',
          'DT': rootElement.getElement('Result')?.getElement('DT')?.text ?? '',
          'DT_TZ':
              rootElement.getElement('Result')?.getElement('DT_TZ')?.text ?? '',
          'DS': rootElement.getElement('Result')?.getElement('DS')?.text ?? '',
          'DS_TZ':
              rootElement.getElement('Result')?.getElement('DS_TZ')?.text ?? '',
          'PIX':
              rootElement.getElement('Result')?.getElement('PIX')?.text ?? '',
          'RID':
              rootElement.getElement('Result')?.getElement('RID')?.text ?? '',
          'RRN':
              rootElement.getElement('Result')?.getElement('RRN')?.text ?? '',
          'ST': rootElement.getElement('Result')?.getElement('ST')?.text ?? '',
          'TR': rootElement.getElement('Result')?.getElement('TR')?.text ?? '',
          'DBID':
              rootElement.getElement('Result')?.getElement('DBID')?.text ?? '',
          'RC': rootElement.getElement('Result')?.getElement('RC')?.text ?? '',
          'RT': rootElement.getElement('Result')?.getElement('RT')?.text ?? '',
          'RTT':
              rootElement.getElement('Result')?.getElement('RTT')?.text ?? '',
          'AmtA':
              rootElement.getElement('Result')?.getElement('AmtA')?.text ?? '',
          'AmtS':
              rootElement.getElement('Result')?.getElement('AmtS')?.text ?? '',
          'AmtT':
              rootElement.getElement('Result')?.getElement('AmtT')?.text ?? '',
          'AmtC':
              rootElement.getElement('Result')?.getElement('AmtC')?.text ?? '',
          'MID':
              rootElement.getElement('Result')?.getElement('MID')?.text ?? '',
          'TID':
              rootElement.getElement('Result')?.getElement('TID')?.text ?? '',
          'AutoSig':
              rootElement.getElement('Result')?.getElement('AutoSig')?.text ??
                  '',
          'CaStan':
              rootElement.getElement('Result')?.getElement('CaStan')?.text ??
                  '',
        },
      if (rootElement.getElement('ReCo') != null)
        'ReCo': rootElement.getElement('ReCo')?.text ?? '',
      if (rootElement.getElement('Tmo') != null)
        'Tmo': rootElement.getElement('Tmo')?.text ?? '',
      if (rootElement.getElement('DL1') != null)
        'DL1': rootElement.getElement('DL1')?.text ?? '',
      if (rootElement.getElement('DL2') != null)
        'DL2': rootElement.getElement('DL2')?.text ?? '',
      if (rootElement.getElement('B1') != null)
        'B1': {
          'en': rootElement.getElement('B1')?.getAttribute('en') ?? '',
          'text': rootElement.getElement('B1')?.text ?? '',
        },
      if (rootElement.getElement('B2') != null)
        'B2': {
          'en': rootElement.getElement('B2')?.getAttribute('en') ?? '',
          'text': rootElement.getElement('B2')?.text ?? '',
        },
      //buttons
      if (rootElement.getElement('Success') != null)
        'Success': rootElement.getElement('Success')?.text ?? '',
      //refund
      if (rootElement.getElement('CID') != null)
        'CID': rootElement.getElement('CID')?.text ?? '',
      if (rootElement.getElement('CED') != null)
        'CED': rootElement.getElement('CED')?.text ?? '',
      if (rootElement.getElement('AccountId') != null)
        'AccountId': rootElement.getElement('AccountId')?.text ?? '',
      if (rootElement.getElement('AccountType') != null)
        'AccountType': rootElement.getElement('AccountType')?.text ?? '',
      if (rootElement.getElement('AmtMD') != null)
        'AmtMD': rootElement.getElement('AmtMD')?.text ?? '',
      if (rootElement.getElement('PANE') != null)
        'PANE': rootElement.getElement('PANE')?.text ?? '',
      if (rootElement.getElement('PINE') != null)
        'PINE': rootElement.getElement('PINE')?.text ?? '',
      if (rootElement.getElement('EOV') != null)
        'EOV': rootElement.getElement('EOV')?.text ?? '',
      //error
      if (rootElement.getElement('Response') != null)
        'Response': {
          'Code':
              rootElement.getElement('Response')?.getAttribute('Code') ?? '',
          'Message': rootElement.getElement('Response')?.text ?? '',
        },
      if (rootElement.getElement('TransactionIsComplete') != null)
        'TransactionIsComplete':
            rootElement.getElement('TransactionIsComplete')?.text ?? '',
    };
  }

  static String formatXml(String input) {
    try {
      final document = XmlDocument.parse(input);
      return document.toXmlString(pretty: true, indent: '  ');
    } catch (e) {
      return input;
    }
  }
}
