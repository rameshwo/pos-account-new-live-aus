import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/dashboard/dashboard_res.dart';
import 'package:pos_account/providers/dashboard/dashboard_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';

class ConfigChannelDia extends StatelessWidget {
  final AvailiableChannel? channel;
  final bool isConnect;
  const ConfigChannelDia({
    super.key,
    this.channel,
    this.isConnect = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final dashPro = Provider.of<DashboardPro>(context);
    return Processing(
      loading: dashPro.diaLoading,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height / 1.14,
          minHeight: size.height / 5,
        ),
        width: size.width * 0.8,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isConnect
                        ? "Connect to ${channel?.channelName ?? ''}"
                        : "Configure Channels",
                    style: TextStyle(
                      fontSize: size.getS(20),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close))
                ],
              ),
              Divider(),
              Center(
                child: Text(
                  "Add your preferences",
                  style: TextStyle(
                    fontSize: size.getS(18),
                    color: Colors.black,
                  ),
                ),
              ),
              if (dashPro.filterSec?.cuisineTypes != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cuisines",
                      style: TextStyle(
                        fontSize: size.getS(20),
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: size.getH(8),
                    ),
                    Wrap(
                      spacing: size.getW(16),
                      runSpacing: size.getH(12),
                      children: [
                        ...List.generate(
                            dashPro.filterSec!.cuisineTypes!.length, (index) {
                          final cType = dashPro.filterSec!.cuisineTypes![index];

                          return _buttonSec(
                            size,
                            title: cType.name,
                            isSelect: cType.isSelected ?? false,
                            onTap: () {
                              cType.isSelected = !(cType.isSelected ?? false);
                              dashPro.notify;
                            },
                          );
                        })
                      ],
                    )
                  ],
                ),
              SizedBox(
                height: size.getH(32),
              ),
              if (dashPro.filterSec?.channelFilters != null)
                ...List.generate(dashPro.filterSec!.channelFilters!.length,
                    (i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dashPro.filterSec!.channelFilters![i].name ?? '',
                        style: TextStyle(
                          fontSize: size.getS(20),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: size.getH(8),
                      ),
                      if (dashPro.filterSec!.channelFilters![i]
                              .channelFilterOptions !=
                          null)
                        Wrap(
                          spacing: size.getW(16),
                          runSpacing: size.getH(12),
                          children: [
                            ...List.generate(
                                dashPro.filterSec!.channelFilters![i]
                                    .channelFilterOptions!.length, (j) {
                              final fiterOption = dashPro.filterSec!
                                  .channelFilters![i].channelFilterOptions![j];

                              return _buttonSec(
                                size,
                                title: fiterOption.name,
                                isSelect: fiterOption.isSelected ?? false,
                                onTap: () {
                                  fiterOption.isSelected =
                                      !(fiterOption.isSelected ?? false);
                                  dashPro.notify;
                                },
                              );
                            })
                          ],
                        ),
                      SizedBox(
                        height: size.getH(32),
                      ),
                    ],
                  );
                }),
              SizedBox(
                height: size.getH(32),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: LoadButton(
                  btnText: "Connect",
                  loading: dashPro.diaLoading,
                  onsave: dashPro.diaLoading
                      ? null
                      : () async {
                          final status = await dashPro.updateChannel(
                              channelId: channel?.id);
                          if (status && Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                ),
              ),
              SizedBox(
                height: size.getH(12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonSec(
    Ssize size, {
    bool isSelect = false,
    String? title,
    Function()? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isSelect ? kSecondaryColor.withAlpha(50) : Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: kSecondaryColor.withAlpha(isSelect ? 15 : 70),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.getW(16), vertical: size.getH(8)),
          child: Text(
            title ?? '',
            style: TextStyle(
              fontSize: size.getS(20),
              fontWeight: isSelect ? FontWeight.bold : FontWeight.w400,
              color: isSelect ? kSecondaryColor : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
