import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class DisplayPage extends StatelessWidget {
  final String orgName;
  final String orderNumber;
  final String startDate;
  final String endDate;
  final String currency;
  final String days;

  DisplayPage({
    required this.orgName,
    required this.orderNumber,
    required this.startDate,
    required this.endDate,
    required this.currency,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () async {
              try {
                if (await _requestPermissions()) {
                  final pdf = await _generatePdf();
                  final dir = await _getSaveDirectory();
                  final file = File('${dir.path}/$orgName.pdf');
                  await file.writeAsBytes(await pdf.save());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('PDF saved as ${file.path}')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Permission denied')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('An error occurred: $e')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assest/img.png'),
              SizedBox(height: 0),


              Text('20 July 2024', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Dear $orgName', style: TextStyle(fontSize: 18, color: Colors.red)),
              SizedBox(height: 8),
              Text(
                'We hope this message finds you well.',
                style: TextStyle(fontSize: 8),
              ),
              SizedBox(height: 8),
              Text(
                'We are pleased to confirm that $orgName $orderNumber; will begin using the Swipejobb Job App to match with more candidates effectively. As mentioned your business will enjoy a free trial period of $days days starting from $startDate. This trial period will allow you to explore some of the features and benefits of our app without any initial cost.',
                style: TextStyle(fontSize: 8),
              ),
              SizedBox(height: 8),
              Text(
                'Please be aware of the following terms regarding the trial period and subscription:',
                style: TextStyle(fontSize: 8, ),
              ),
              SizedBox(height: 8),
              Text(
                'Free Trial Period: Your $days days free trial will commence on $startDate 2024 and conclude on $endDate 2024.',
                style: TextStyle(fontSize: 8),
              ),
              SizedBox(height:8),
              Text(
                'Notification Requirement: If you decide not to continue using the Swipejobb Job App after the trial period you must notify us before the end of the trial period which is $endDate through email at support@swipejobb.se or info@swipejobb.se. Failure to do so will result in automatic continuation of the service and the minimum payment will be a basic subscription pack for six months which is $currency SEK. Please note that deletion of your account, posted job, or app will still continue the subscription until we receive a confirmation email from you. If you wish to choose a premium or 12-month subscription after the free trial please contact our sales department at sales@swipejobb.se.',
                style: TextStyle(fontSize: 8),
              ),
              SizedBox(height: 8),
              Text(
                'Subscription and Invoicing: Should you choose to continue using the app after the trial period or if we do not receive any email notification of cancellation, Swipejobb AB will send an invoice for the subscription or you can pay directly from the app. This invoice must be paid as the free trial period is included within the subscription framework if you choose to continue. In the event of choosing not to continue please note that while we do not delete any accounts the usage of your account will be restricted meaning you will be unable to match hire and communicate through the app.',
                style: TextStyle(fontSize: 8),
              ),
              SizedBox(height: 8),
              Text(
                'To confirm to us that you agree to these terms and conditions and would like to start a free trial please reply to this email with either "Yes" to start the trial or "No" if you choose not to proceed with the trial period. We are confident that Swipejobb Job App will significantly aid in your HR management process and look forward to supporting your hiring needs.',
                style: TextStyle(fontSize: 8),
              ),
              SizedBox(height: 8),
              Text(
                'For any kind of support feel free to reach out to support@swipejobb.se',
                style: TextStyle(fontSize: 8),
              ),
              SizedBox(height: 8),
              Text(
                'Thank you for choosing Swipejobb. We are excited to have you on board and look forward to a successful partnership.',
                style: TextStyle(fontSize: 8),
              ),
              SizedBox(height: 8),
              Text('Best regards', style: TextStyle(fontSize: 14)),
              Text('Swipejobb AB', style: TextStyle(fontSize: 8)),
              SizedBox(height: 20),
              Divider(thickness: 2),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.green),
                  SizedBox(width: 10),
                  Text('+46 73 977 56 67', style: TextStyle(fontSize: 14)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.email, color: Colors.green),
                  SizedBox(width: 10),
                  Text('support@swipejobb.se', style: TextStyle(fontSize: 14)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.web, color: Colors.green),
                  SizedBox(width: 10),
                  Text('www.swipejobb.se', style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
      }

      if (await Permission.manageExternalStorage.isRestricted) {
        var result = await Permission.manageExternalStorage.request();
        if (!result.isGranted) {
          return false;
        }
      }
      return true;
    } else {
      return true;
    }
  }

  Future<Directory> _getSaveDirectory() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Documents');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    return directory!;
  }

  Future<pw.Document> _generatePdf() async {
    final pdf = pw.Document();

    final image = (await rootBundle.load('assest/img.png')).buffer.asUint8List();
    final headerImage = pw.MemoryImage(image);

    final phoneIcon = (await rootBundle.load('assest/phone.png')).buffer.asUint8List();
    final phoneImage = pw.MemoryImage(phoneIcon);

    final emailIcon = (await rootBundle.load('assest/email.png')).buffer.asUint8List();
    final emailImage = pw.MemoryImage(emailIcon);

    final webIcon = (await rootBundle.load('assest/web.png')).buffer.asUint8List();
    final webImage = pw.MemoryImage(webIcon);

    // final font = await rootBundle.load('assest/fonts/NotoSans-Regular.ttf');
    // final ttf = pw.Font.ttf(font);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Image(headerImage),
              pw.SizedBox(height: 0),

              pw.Text('20 July 2024', style: pw.TextStyle(fontSize: 18, )),
              pw.SizedBox(height: 8),
              pw.Text('Dear $orgName', style: pw.TextStyle(fontSize: 18, color: PdfColors.black, )),

              pw.SizedBox(height: 8),
              pw.Text(
                'We hope this message finds you well.',
                style: pw.TextStyle(fontSize: 8),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'We are pleased to confirm that $orgName $orderNumber; will begin using the Swipejobb Job App to match with more candidates effectively. As mentioned your business will enjoy a free trial period of $days days starting from $startDate. This trial period will allow you to explore some of the features and benefits of our app without any initial cost.',
                style: pw.TextStyle(fontSize: 8, ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Please be aware of the following terms regarding the trial period and subscription:',
                style: pw.TextStyle(fontSize: 8, ),
              ),

              pw.SizedBox(height: 8),
              pw.Text(
                'Free Trial Period: Your $days days free trial will commence on $startDate 2024 and conclude on $endDate 2024.',
                style: pw.TextStyle(fontSize: 8, ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Notification Requirement: If you decide not to continue using the Swipejobb Job App after the trial period you must notify us before the end of the trial period which is $endDate through email at support@swipejobb.se or info@swipejobb.se. Failure to do so will result in automatic continuation of the service and the minimum payment will be a basic subscription pack for six months which is $currency SEK. Please note that deletion of your account, posted job, or app will still continue the subscription until we receive a confirmation email from you. If you wish to choose a premium or 12-month subscription after the free trial please contact our sales department at sales@swipejobb.se.',
                style: pw.TextStyle(fontSize: 8, ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Subscription and Invoicing: Should you choose to continue using the app after the trial period or if we do not receive any email notification of cancellation, Swipejobb AB will send an invoice for the subscription or you can pay directly from the app. This invoice must be paid as the free trial period is included within the subscription framework if you choose to continue. In the event of choosing not to continue please note that while we do not delete any accounts the usage of your account will be restricted meaning you will be unable to match hire and communicate through the app.',
                style: pw.TextStyle(fontSize: 8,),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'To confirm to us that you agree to these terms and conditions and would like to start a free trial please reply to this email with either "Yes" to start the trial or "No" if you choose not to proceed with the trial period. We are confident that Swipejobb Job App will significantly aid in your HR management process and look forward to supporting your hiring needs.',
                style: pw.TextStyle(fontSize: 8, ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'For any kind of support feel free to reach out to support@swipejobb.se',
                style: pw.TextStyle(fontSize: 8, ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Thank you for choosing Swipejobb. We are excited to have you on board and look forward to a successful partnership.',
                style: pw.TextStyle(fontSize: 8, ),
              ),
              pw.SizedBox(height: 8),
              pw.Text('Best regards', style: pw.TextStyle(fontSize: 14, )),
              pw.Text('Swipejobb AB', style: pw.TextStyle(fontSize: 10, )),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(phoneImage, width: 20, height: 20),
                  pw.SizedBox(width: 10),
                  pw.Text('+46 73 977 56 67', style: pw.TextStyle(fontSize: 14,)),
                  pw.SizedBox(width: 20),
                  pw.Image(emailImage, width: 20, height: 20),
                  pw.SizedBox(width: 10),
                  pw.Text('support@swipejobb.se', style: pw.TextStyle(fontSize: 14,)),
                  pw.SizedBox(width: 20),
                  pw.Image(webImage, width: 20, height: 20),
                  pw.SizedBox(width: 10),
                  pw.Text('www.swipejobb.se', style: pw.TextStyle(fontSize: 14, )),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }
}