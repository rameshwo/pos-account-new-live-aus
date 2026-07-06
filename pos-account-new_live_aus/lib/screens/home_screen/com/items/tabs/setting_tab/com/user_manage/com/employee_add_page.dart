import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/text_formatter.dart';
import 'package:pos_account/model/ui_model/screen_time_model.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/image/profile_img_sec.dart';
import 'package:pos_account/widgets/input/dropdown/dropdown_with_text_form.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import '../../../../../../../../../config/size_config.dart';
import '../../../../../../../../../constant/constant.dart';
import '../../../../../../../../../ln.dart';
import '../../../../../../../../../providers/cus_val_pro.dart';
import '../../../../../../../../../providers/profile/user_manage_pro.dart';
import '../../../../../../../../../widgets/input/dropdown/title_drop_down.dart';
import '../../../../../../../../../widgets/input/text_form/title_text_form.dart';
import '../../../../../../../../../widgets/load_btn.dart';
import '../../../../../../../../../widgets/loading.dart';
import '../../general/common/common_header.dart';

class EmployeeAddPage extends StatefulWidget {
  final PageController pageController;
  final UserManagePro userManagePro;
  const EmployeeAddPage({
    super.key,
    required this.pageController,
    required this.userManagePro,
  });

  @override
  State<EmployeeAddPage> createState() => EmployeeAddPageState();
}

class EmployeeAddPageState extends State<EmployeeAddPage> {
  dynamic curSym;

  final empFormKey = GlobalKey<FormState>();

  UserManagePro get userPro => widget.userManagePro;

  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() async {
    await getCurSym();
    // userPro.getEmpData();
  }

  getCurSym() async {
    curSym = await SharedPrefs.curSym;
    userPro.notify;
  }

  @override
  void dispose() {
    userPro.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);

    return Processing(
      loading: userPro.loading,
      align: Alignment.topLeft,
      child: Form(
        key: empFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonHeader(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        userPro.clear();
                        widget.pageController.jumpToPage(0);
                      },
                      icon: Icon(Icons.arrow_back, size: size.getS(24))),
                  SizedBox(width: size.getW(8)),
                  Text(
                    userPro.empId.isNotEmpty
                        ? "Update Employee"
                        : "Create a New Employee",
                    style: TextStyle(
                      fontSize: size.getS(18),
                      // fontFamily: ,ph
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.getH(8)),
            Flexible(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                        vertical: size.getH(12.0), horizontal: size.getW(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: size.getH(5),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.all(size.getS(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Personal Information",
                                  style: TextStyle(
                                    fontSize: size.getS(16),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: size.getH(4)),
                                Text(
                                  "Enter the employee's basic details for identification and communication",
                                  style: TextStyle(
                                    fontSize: size.getS(12),
                                    color: Colors.black54,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: size.getH(8)),
                                          Wrap(
                                            spacing: size.getW(24),
                                            runSpacing: size.getH(16),
                                            // GridView.count(
                                            // crossAxisCount: 3,
                                            // crossAxisSpacing: size.getW(24),
                                            // mainAxisSpacing: size.getH(0),
                                            // childAspectRatio: 4,
                                            // shrinkWrap: true,
                                            // physics:
                                            //     NeverScrollableScrollPhysics(),
                                            children: [
                                              TitleTextForm(
                                                title: LN.employeeCode,
                                                isReq: true,
                                                hintText: LN.employeeCode,
                                                textCltr: userPro.empCodeCltr,
                                                borderColor: Colors.black12,
                                                pWidth: 0.22,
                                                fontSize: 16,
                                                hPad: 10,
                                                textInputType:
                                                    TextInputType.text,
                                                readOnly: true,
                                                fillColor: Colors.grey.shade100,
                                              ),
                                              TitleTextForm(
                                                title: LN.fullName,
                                                isReq: true,
                                                hintText: LN.fullname,
                                                textCltr: userPro.nameCltr,
                                                borderColor: Colors.black12,
                                                pWidth: 0.22,
                                                fontSize: 16,
                                                hPad: 10,
                                                textInputType:
                                                    TextInputType.text,
                                              ),
                                              TitleTextForm(
                                                title: LN.preferredName,
                                                isReq: true,
                                                hintText: LN.preferredName,
                                                textCltr:
                                                    userPro.preferNameCltr,
                                                borderColor: Colors.black12,
                                                pWidth: 0.22,
                                                fontSize: 16,
                                                hPad: 10,
                                                textInputType:
                                                    TextInputType.text,
                                              ),
                                              TitleTextForm(
                                                title: LN.jobTitle,
                                                isReq: true,
                                                hintText: LN.jobTitle,
                                                textCltr: userPro.jobTitleCltr,
                                                borderColor: Colors.black12,
                                                pWidth: 0.22,
                                                fontSize: 16,
                                                hPad: 10,
                                                textInputType:
                                                    TextInputType.text,
                                              ),
                                              SearchTitleDropDown(
                                                pWidth: 0.22,
                                                title: LN.country,
                                                isReq: true,
                                                list: userPro.empAddSec
                                                            ?.countryCityStates ==
                                                        null
                                                    ? []
                                                    : userPro.empAddSec!
                                                        .countryCityStates!
                                                        .map(
                                                            (e) => e.name ?? '')
                                                        .toList(),
                                                indexVal: userPro.countryIndex,
                                                onChanged: (p0) {
                                                  userPro.countryIndex = p0;
                                                  userPro.phoneCodeIndex = p0;
                                                  userPro.stateIndex = null;
                                                  userPro.cityIndex = null;
                                                  // userPro.suburbIndex = null;
                                                  userPro.notify;
                                                },
                                                borderColor: Colors.black12,
                                              ),
                                              SearchTitleDropDown(
                                                title: LN.state,
                                                pWidth: 0.22,
                                                isReq: true,
                                                borderColor: Colors.black12,
                                                indexVal: userPro.stateIndex,
                                                list: userPro.countryIndex ==
                                                            null ||
                                                        userPro
                                                                .empAddSec
                                                                ?.countryCityStates?[
                                                                    userPro
                                                                        .countryIndex!]
                                                                .states ==
                                                            null ||
                                                        userPro
                                                            .empAddSec!
                                                            .countryCityStates![
                                                                userPro
                                                                    .countryIndex!]
                                                            .states!
                                                            .isEmpty
                                                    ? []
                                                    : userPro
                                                        .empAddSec!
                                                        .countryCityStates![
                                                            userPro
                                                                .countryIndex!]
                                                        .states!
                                                        .map(
                                                            (e) => e.name ?? '')
                                                        .toList(),
                                                onChanged: (p0) {
                                                  userPro.stateIndex = p0;
                                                  userPro.cityIndex = null;
                                                  // userPro.suburbIndex = null;
                                                  userPro.notify;
                                                },
                                              ),
                                              SearchTitleDropDown(
                                                title: LN.city,
                                                pWidth: 0.22,
                                                isReq: true,
                                                borderColor: Colors.black12,
                                                indexVal: userPro.cityIndex,
                                                list: userPro.countryIndex == null ||
                                                        userPro.stateIndex ==
                                                            null ||
                                                        userPro
                                                                .empAddSec
                                                                ?.countryCityStates?[
                                                                    userPro
                                                                        .countryIndex!]
                                                                .states?[userPro
                                                                    .stateIndex!]
                                                                .cities ==
                                                            null ||
                                                        userPro
                                                            .empAddSec!
                                                            .countryCityStates![
                                                                userPro
                                                                    .countryIndex!]
                                                            .states![userPro
                                                                .stateIndex!]
                                                            .cities!
                                                            .isEmpty
                                                    ? []
                                                    : userPro
                                                        .empAddSec!
                                                        .countryCityStates![
                                                            userPro
                                                                .countryIndex!]
                                                        .states![
                                                            userPro.stateIndex!]
                                                        .cities!
                                                        .map(
                                                            (e) => e.name ?? '')
                                                        .toList(),
                                                onChanged: (p0) {
                                                  userPro.cityIndex = p0;
                                                  // userPro.suburbIndex = null;
                                                  userPro.notify;
                                                },
                                              ),
                                              TitleTextForm(
                                                title: LN.postalCode,
                                                isReq: true,
                                                hintText: "",
                                                textCltr: userPro.postalCltr,
                                                borderColor: Colors.black12,
                                                pWidth: 0.22,
                                              ),
                                              TitleDropDown(
                                                title: LN.gender,
                                                pWidth: 0.22,
                                                isReq: false,
                                                borderColor: Colors.black12,
                                                indexVal: userPro.genderIndex,
                                                list: userPro.empAddSec?.genders
                                                        ?.map(
                                                            (e) => e.name ?? '')
                                                        .toList() ??
                                                    [],
                                                onChanged: (p0) {
                                                  userPro.genderIndex = p0;
                                                  userPro.notify;
                                                },
                                              ),
                                              TitleDropDown(
                                                title: "Employee Type",
                                                pWidth: 0.22,
                                                isReq: false,
                                                borderColor: Colors.black12,
                                                indexVal: userPro.userTypeIndex,
                                                list: userPro.empAddSec
                                                            ?.employmentTypes ==
                                                        null
                                                    ? []
                                                    : userPro.empAddSec!
                                                        .employmentTypes!
                                                        .map(
                                                            (e) => e.name ?? '')
                                                        .toList(),
                                                onChanged: (p0) {
                                                  userPro.userTypeIndex = p0;
                                                  userPro.notify;
                                                },
                                              ),
                                              TitleTextForm(
                                                title: LN.annualSalary,
                                                isReq: false,
                                                hintText: "",
                                                textCltr: userPro.salaryCltr,
                                                borderColor: Colors.black12,
                                                pWidth: 0.22,
                                                prefixText: Text(
                                                  "$curSym",
                                                  style: TextStyle(
                                                    fontSize: size.getS(16),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                textInputType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      10),
                                                ],
                                              ),
                                              TitleTextForm(
                                                title: LN.hourlyRate,
                                                isReq: false,
                                                hintText: "",
                                                textCltr:
                                                    userPro.hourlyRateCltr,
                                                borderColor: Colors.black12,
                                                pWidth: 0.22,
                                                prefixText: Text(
                                                  "$curSym",
                                                  style: TextStyle(
                                                    fontSize: size.getS(16),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                textInputType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      10),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: size.getW(12)),
                                    Flexible(
                                      flex: 1,
                                      child: Center(
                                        child: ProfileImageSec(
                                          size: size,
                                          radius: 144,
                                          pickImage: () =>
                                              userPro.getFilePick(),
                                          filePath: userPro.getFilePath,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.getH(16),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.all(size.getS(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Login & Security",
                                  style: TextStyle(
                                    fontSize: size.getS(16),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: size.getH(4)),
                                Text(
                                  "Set up login credentials and security settings to protect the user account.",
                                  style: TextStyle(
                                    fontSize: size.getS(12),
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: size.getH(8)),
                                Wrap(
                                  spacing: size.getW(24),
                                  runSpacing: size.getH(16),
                                  // GridView.count(
                                  //   crossAxisCount: 4,
                                  //   crossAxisSpacing: size.getW(24),
                                  //   mainAxisSpacing: size.getH(0),
                                  //   childAspectRatio: 4,
                                  //   shrinkWrap: true,
                                  //   physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    TitleTextForm(
                                      title: LN.emailAddress,
                                      isReq: false,
                                      hintText: LN.enterEmail,
                                      textCltr: userPro.emailCltr,
                                      borderColor: Colors.black12,
                                      pWidth: 0.22,
                                      fontSize: 16,
                                      hPad: 10,
                                      textInputType: TextInputType.emailAddress,
                                    ),
                                    DropDownWiTextForm(
                                      title: LN.phoneNumber,
                                      isReq: true,
                                      ratio: 0.3,
                                      pWidth: 0.22,
                                      borderColor: Colors.black12,
                                      indexVal: userPro.phoneCodeIndex,
                                      list: userPro.empAddSec == null ||
                                              userPro.empAddSec!
                                                      .countryCityStates ==
                                                  null
                                          ? []
                                          : userPro
                                              .empAddSec!.countryCityStates!
                                              .map((e) => Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      NetworkImageSec(
                                                        image: e.image,
                                                        height: size.isProt
                                                            ? size.getW(12)
                                                            : size.getW(16),
                                                        width: size.isProt
                                                            ? size.getW(12)
                                                            : size.getW(16),
                                                      ),
                                                      if (e.additionalValue
                                                          is String)
                                                        Flexible(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              e.additionalValue ??
                                                                  '',
                                                              style: TextStyle(
                                                                fontSize: size
                                                                        .isProt
                                                                    ? size.getW(
                                                                        12)
                                                                    : size.getS(
                                                                        16),
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  ))
                                              .toList(),
                                      onChanged: (p0) {
                                        userPro.phoneCodeIndex = p0;
                                        userPro.notify;
                                      },
                                      textCltr: userPro.phoneCltr,
                                    ),
                                    TitleDropDown(
                                      isReq: true,
                                      title: "Employee Role",
                                      list: userPro.empAddSec?.roles == null
                                          ? []
                                          : userPro.empAddSec!.roles!
                                              .map((e) => e.value ?? '')
                                              .toList(),
                                      indexVal: userPro.userRoleIndex,
                                      onChanged: (p0) {
                                        userPro.userRoleIndex = p0;
                                        userPro.notify;
                                      },
                                      borderColor: Colors.black12,
                                      pWidth: 0.22,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.24,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${userPro.isActive ? LN.active : LN.inActive} Account',
                                            style: TextStyle(
                                              color: userPro.isActive
                                                  ? Colors.green.shade600
                                                  : Colors.red.shade600,
                                              fontFamily: kFontFMedium,
                                              fontSize: size.getS(16),
                                            ),
                                          ),
                                          SizedBox(
                                            width: size.getW(12),
                                          ),
                                          SwitchAdap(
                                              height: 32,
                                              size: size,
                                              value: userPro.isActive,
                                              onChanged: (val) {
                                                userPro.isActive = val;
                                                userPro.notify;
                                              }),
                                        ],
                                      ),
                                    ),
                                    if (userPro.empId.isEmpty) ...[
                                      TitleTextForm(
                                        title: LN.password,
                                        isReq: true,
                                        hintText: LN.password,
                                        textCltr: userPro.passCltr,
                                        borderColor: Colors.black12,
                                        pWidth: 0.22,
                                        suffix: InkWell(
                                          onTap: () {
                                            userPro.generatePass();
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.key,
                                                  size: size.getS(18)),
                                              Text(
                                                "Generate password",
                                                style: TextStyle(
                                                  fontSize: size.getS(14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            userPro.showPass =
                                                !userPro.showPass;
                                            userPro.notify;
                                          },
                                          child: Icon(
                                            userPro.showPass
                                                ? Icons.visibility
                                                : Icons.visibility_off_outlined,
                                            size: size.getS(24),
                                          ),
                                        ),
                                        obsecure: !userPro.showPass,
                                        validator: passwordValidator,
                                      ),
                                      TitleTextForm(
                                        title: "Confirm Password",
                                        isReq: true,
                                        hintText: "Confirm Password",
                                        textCltr: userPro.confirmPassCltr,
                                        borderColor: Colors.black12,
                                        pWidth: 0.22,
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            userPro.showConfrimPass =
                                                !userPro.showConfrimPass;
                                            userPro.notify;
                                          },
                                          child: Icon(
                                            userPro.showConfrimPass
                                                ? Icons.visibility
                                                : Icons.visibility_off_outlined,
                                            size: size.getS(24),
                                          ),
                                        ),
                                        obsecure: !userPro.showConfrimPass,
                                        validator: (String? val) =>
                                            confirmPasswordValidator(
                                                val, userPro.passCltr.text),
                                      )
                                    ],
                                  ],
                                ),
                                SizedBox(
                                  height: size.getH(16),
                                ),
                                Wrap(
                                  spacing: size.getW(24),
                                  runSpacing: size.getH(16),
                                  // GridView.count(
                                  //   crossAxisCount: 4,
                                  //   crossAxisSpacing: size.getW(24),
                                  //   mainAxisSpacing: size.getH(0),
                                  //   childAspectRatio: 4,
                                  //   shrinkWrap: true,
                                  //   physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    TitleTextForm(
                                      title: "Login Pin",
                                      isReq: false,
                                      hintText: "Pin code",
                                      textCltr: userPro.pinCltr,
                                      borderColor: Colors.black12,
                                      pWidth: 0.22,
                                      textInputType: TextInputType.number,
                                      inputFormatters: [
                                        NonNegativeTextInputFormatter(),
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(4),
                                      ],
                                      suffix: InkWell(
                                        onTap: () {
                                          userPro.generatePin();
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.key,
                                                size: size.getS(18)),
                                            Text(
                                              "Generate random 4 digit",
                                              style: TextStyle(
                                                fontSize: size.getS(14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    TitleTextForm(
                                      title: " Confirm Login Pin",
                                      isReq: false,
                                      hintText: "Confirm Pin code",
                                      textCltr: userPro.confirmPinCltr,
                                      borderColor: Colors.black12,
                                      pWidth: 0.22,
                                      textInputType: TextInputType.number,
                                      inputFormatters: [
                                        NonNegativeTextInputFormatter(),
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(4),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.getH(16),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.all(size.getS(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pos Device Controls and Permissions",
                                  style: TextStyle(
                                    fontSize: size.getS(16),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: size.getH(4)),
                                Text(
                                  "Define what this employee can do in the system by assigning appropriate roles.",
                                  style: TextStyle(
                                    fontSize: size.getS(12),
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: size.getH(8)),
                                Wrap(
                                  spacing: size.getW(24),
                                  runSpacing: size.getH(16),
                                  // GridView.count(
                                  //   crossAxisCount: 4,
                                  //   crossAxisSpacing: size.getW(24),
                                  //   mainAxisSpacing: size.getH(0),
                                  //   childAspectRatio: 4,
                                  //   shrinkWrap: true,
                                  //   physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    TitleDropDown(
                                        title: "POS Tab Default Screen Name",
                                        list: userPro.empAddSec
                                                    ?.posTabDefaultScreens ==
                                                null
                                            ? []
                                            : userPro.empAddSec!
                                                .posTabDefaultScreens!
                                                .map((e) => e.name ?? '')
                                                .toList(),
                                        borderColor: Colors.black12,
                                        pWidth: 0.22,
                                        indexVal: userPro.defaultScreenIndex,
                                        onChanged: (p0) {
                                          userPro.defaultScreenIndex = p0;
                                          userPro.notify;
                                        },
                                        sufIcon: InkWell(
                                            onTap: () {
                                              userPro.defaultScreenIndex = null;
                                              userPro.notify;
                                            },
                                            child: Icon(Icons.close,
                                                size: size.getS(24)))),
                                    TitleDropDown(
                                      title: LN.screenTime,
                                      list: ScreenTimeOut.map((e) => e.title)
                                          .toList(),
                                      indexVal: userPro.intervalIndex,
                                      onChanged: (p0) {
                                        userPro.intervalIndex = p0;
                                        userPro.notify;
                                      },
                                      borderColor: Colors.black12,
                                      pWidth: 0.22,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.22,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Login Pin Code Popup Screen",
                                              style: TextStyle(
                                                fontSize: size.getS(18),
                                                color: Colors.black,
                                              )),
                                          SizedBox(
                                            height: size.getH(12),
                                          ),
                                          SwitchAdap(
                                              height: 32,
                                              size: size,
                                              value: userPro.enablePinCode,
                                              onChanged: (val) {
                                                userPro.enablePinCode = val;
                                                userPro.notify;
                                              }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.getH(16),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.all(size.getS(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Emergency Contacts",
                                  style: TextStyle(
                                    fontSize: size.getS(16),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: size.getH(4)),
                                Text(
                                  "Add emergency contacts for regional settings and shipping",
                                  style: TextStyle(
                                    fontSize: size.getS(12),
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: size.getH(8)),
                                Wrap(
                                  spacing: size.getW(24),
                                  runSpacing: size.getH(16),
                                  // GridView.count(
                                  //   crossAxisCount: 4,
                                  //   crossAxisSpacing: size.getW(24),
                                  //   mainAxisSpacing: size.getH(0),
                                  //   childAspectRatio: 4,
                                  //   shrinkWrap: true,
                                  //   physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    TitleTextForm(
                                      title: LN.emergencyContactName,
                                      isReq: false,
                                      hintText: LN.emergencyContactName,
                                      textCltr: userPro.emergNameCltr,
                                      borderColor: Colors.black12,
                                      pWidth: 0.22,
                                      fontSize: 16,
                                      hPad: 10,
                                      textInputType: TextInputType.text,
                                    ),
                                    DropDownWiTextForm(
                                      title: LN.emergencyPhone,
                                      isReq: false,
                                      ratio: 0.3,
                                      pWidth: 0.22,
                                      borderColor: Colors.black12,
                                      indexVal: userPro.phoneCodeIndex,
                                      list: userPro.empAddSec == null ||
                                              userPro.empAddSec!
                                                      .countryCityStates ==
                                                  null
                                          ? []
                                          : userPro
                                              .empAddSec!.countryCityStates!
                                              .map((e) => Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      NetworkImageSec(
                                                        image: e.image,
                                                        height: size.isProt
                                                            ? size.getW(12)
                                                            : size.getW(16),
                                                        width: size.isProt
                                                            ? size.getW(12)
                                                            : size.getW(16),
                                                      ),
                                                      if (e.additionalValue
                                                          is String)
                                                        Flexible(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              e.additionalValue ??
                                                                  '',
                                                              style: TextStyle(
                                                                fontSize: size
                                                                        .isProt
                                                                    ? size.getW(
                                                                        12)
                                                                    : size.getS(
                                                                        16),
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  ))
                                              .toList(),
                                      onChanged: (p0) {
                                        userPro.phoneCodeIndex = p0;
                                        userPro.notify;
                                      },
                                      textCltr: userPro.emergPhoneCltr,
                                    ),
                                    TitleTextForm(
                                      title: LN.emergencyEmail,
                                      isReq: false,
                                      hintText: LN.emergencyEmail,
                                      textCltr: userPro.emergEmailCltr,
                                      borderColor: Colors.black12,
                                      pWidth: 0.22,
                                      fontSize: 16,
                                      hPad: 10,
                                      textInputType: TextInputType.emailAddress,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.getH(16),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.all(size.getS(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Configure Notifications and 2FA",
                                  style: TextStyle(
                                    fontSize: size.getS(16),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: size.getH(4)),
                                Text(
                                  "Configure notifications and two factor authentication for your employee.",
                                  style: TextStyle(
                                    fontSize: size.getS(12),
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: size.getH(8)),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Enable Push Notifications",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: kFontFMedium,
                                        fontSize: size.getS(16),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.getW(24),
                                    ),
                                    SwitchAdap(
                                        size: size,
                                        height: 32,
                                        value: userPro.pushNotificationEnable,
                                        onChanged: (val) {
                                          userPro.pushNotificationEnable = val;
                                          userPro.notify;
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.getH(24),
                        ),
                        Row(
                          children: [
                            if (GlobalCVP.viewWidget.viewAddUserTabSaveButton)
                              IgnorePointer(
                                ignoring: userPro.loading,
                                child: LoadButton(
                                  hPad: 2,
                                  btnText: userPro.empId.isNotEmpty
                                      ? LN.update
                                      : LN.create,
                                  btnColor: kUserColor,
                                  loading: userPro.updateLoad,
                                  onsave: () async {
                                    FocusScope.of(context).unfocus();
                                    if (empFormKey.currentState!.validate()) {
                                      final status =
                                          await userPro.addUpEmployee();
                                      if (status) {
                                        userPro.clear();
                                        userPro.notify;
                                        widget.pageController.jumpToPage(0);
                                        userPro.getAllEmployees(page: 1);
                                      }
                                    }
                                  },
                                ),
                              ),
                            SizedBox(
                              width: size.getW(12),
                            ),
                            if (userPro.empId.isNotEmpty)
                              LoadButton(
                                btnText: LN.cancel,
                                btnColor: Colors.red.shade600,
                                onsave: () {
                                  userPro.clear();
                                  widget.pageController.jumpToPage(0);
                                },
                              ),
                          ],
                        ),
                        SizedBox(
                          height: size.getH(24),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
