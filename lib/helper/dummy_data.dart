import 'package:manage_devices_app/enums/device_type.dart';
import 'package:manage_devices_app/enums/healthy_status.dart';
import 'package:manage_devices_app/enums/role.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/model/team.dart';
import 'package:manage_devices_app/model/user.dart';

class DummyData {
  static final user = User(
    id: '',
    name: 'name',
    age: 20,
    address: 'address',
    teamId: '',
    role: Role.user,
    startWork: DateTime.now(),
    createdAt: DateTime.now(),
  );
  static final team = Team(id: '', name: 'Flutter');
  static final device = Device(
    id: '',
    name: 'ASUS VZ24EHE 24" IPS 75Hz',
    imagePaths: [
      'https://www.asus.com/campaign/best-gaming-monitor/upload/kv/20190829140532_m2.jpg'
    ],
    info:
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
    deviceType: DeviceType.pc,
    healthyStatus: HealthyStatus.good,
    ownerId: '',
    deviceCategoryId: '',
    transferDate: null,
    manufacturingDate: DateTime.now(),
  );
}
