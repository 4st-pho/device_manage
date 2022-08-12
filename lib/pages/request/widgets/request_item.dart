import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_devices_app/constants/app_font.dart';
import 'package:manage_devices_app/helper/get_status_color.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/resource/route_manager.dart';

class RequestItem extends StatelessWidget {
  final Request request;
  const RequestItem({Key? key, required this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(Routes.detailRequestRoute, arguments: request),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: getStatusColor(request.requestStatus),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request.title.toUpperCase(),
                style: AppFont.whiteText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Status: ${request.requestStatus.name}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(DateFormat('dd MMM yyyy').format(request.createdAt)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
