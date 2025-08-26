import '../../../../core/base/base_mixin.dart';
import '../../models/user_model.dart';

class UserCard extends StatelessWidget with BaseMixin {
  final UserModel user;
  final VoidCallback? onTap;

  const UserCard({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: color.primary,
                    child: Text(
                      user.name.substring(0, 1).toUpperCase(),
                      style: textStyle.bold(color: Colors.white, size: 18),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: textStyle.bold(size: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '@${user.username}',
                          style: textStyle.regular(
                            color: Colors.grey,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
              SizedBox(height: 12),
              _buildInfoRow(Icons.email, user.email),
              SizedBox(height: 8),
              _buildInfoRow(Icons.phone, user.phone),
              SizedBox(height: 8),
              _buildInfoRow(
                Icons.location_on,
                '${user.address.city}, ${user.address.street}',
              ),
              SizedBox(height: 8),
              _buildInfoRow(Icons.business, user.company.name),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: textStyle.regular(size: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
