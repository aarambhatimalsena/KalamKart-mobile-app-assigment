import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Orders', 'Offers', 'Updates', 'Reminders'];

  final List<Map<String, dynamic>> notifications = [
    {
      "id": 1,
      "title": "Order Shipped! 📦",
      "message": "Your order #KK2024001 has been shipped and is on its way to you.",
      "time": "2 minutes ago",
      "type": "Orders",
      "isRead": false,
      "icon": Icons.local_shipping,
      "iconColor": Colors.blue,
      "priority": "high",
    },
    {
      "id": 2,
      "title": "Flash Sale Alert! ⚡",
      "message": "50% off on all Art Supplies! Limited time offer ending in 2 hours.",
      "time": "15 minutes ago",
      "type": "Offers",
      "isRead": false,
      "icon": Icons.local_offer,
      "iconColor": Colors.red,
      "priority": "high",
    },
    {
      "id": 3,
      "title": "New Products Added 🎨",
      "message": "Check out our latest collection of premium watercolor sets.",
      "time": "1 hour ago",
      "type": "Updates",
      "isRead": true,
      "icon": Icons.new_releases,
      "iconColor": Colors.green,
      "priority": "medium",
    },
    {
      "id": 4,
      "title": "Payment Successful ✅",
      "message": "Your payment of \$45.99 for order #KK2024002 was processed successfully.",
      "time": "3 hours ago",
      "type": "Orders",
      "isRead": true,
      "icon": Icons.payment,
      "iconColor": Colors.green,
      "priority": "medium",
    },
    {
      "id": 5,
      "title": "Cart Reminder 🛒",
      "message": "You have 3 items waiting in your cart. Complete your purchase now!",
      "time": "6 hours ago",
      "type": "Reminders",
      "isRead": false,
      "icon": Icons.shopping_cart,
      "iconColor": Colors.orange,
      "priority": "low",
    },
    {
      "id": 6,
      "title": "Weekly Deals Update 📊",
      "message": "This week's top deals: Notebooks 30% off, Pens 25% off, Art supplies 40% off.",
      "time": "1 day ago",
      "type": "Offers",
      "isRead": true,
      "icon": Icons.trending_up,
      "iconColor": Colors.purple,
      "priority": "medium",
    },
    {
      "id": 7,
      "title": "Account Security 🔒",
      "message": "Your password was successfully updated. If this wasn't you, please contact support.",
      "time": "2 days ago",
      "type": "Updates",
      "isRead": true,
      "icon": Icons.security,
      "iconColor": Colors.indigo,
      "priority": "high",
    },
    {
      "id": 8,
      "title": "Wishlist Item on Sale! 💝",
      "message": "Good news! The Premium Fountain Pen from your wishlist is now 25% off.",
      "time": "3 days ago",
      "type": "Offers",
      "isRead": true,
      "icon": Icons.favorite,
      "iconColor": Colors.pink,
      "priority": "medium",
    },
    {
      "id": 9,
      "title": "Order Delivered 📍",
      "message": "Your order #KK2024000 has been delivered successfully. Rate your experience!",
      "time": "1 week ago",
      "type": "Orders",
      "isRead": true,
      "icon": Icons.check_circle,
      "iconColor": Colors.green,
      "priority": "low",
    },
    {
      "id": 10,
      "title": "Welcome to KalamKart! 🎉",
      "message": "Thank you for joining us! Enjoy 15% off on your first purchase with code WELCOME15.",
      "time": "2 weeks ago",
      "type": "Updates",
      "isRead": true,
      "icon": Icons.celebration,
      "iconColor": Colors.amber,
      "priority": "low",
    },
  ];

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter == 'All') {
      return notifications;
    }
    return notifications.where((notification) => notification['type'] == selectedFilter).toList();
  }

  int get unreadCount {
    return notifications.where((notification) => !notification['isRead']).length;
  }

  void markAsRead(int id) {
    setState(() {
      final index = notifications.indexWhere((notification) => notification['id'] == id);
      if (index != -1) {
        notifications[index]['isRead'] = true;
      }
    });
  }

  void markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification['isRead'] = true;
      }
    });
  }

  void deleteNotification(int id) {
    setState(() {
      notifications.removeWhere((notification) => notification['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1B2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Icon(Icons.notifications, color: Colors.amber, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Notifications',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Roboto_Condensed-Bold',
              ),
            ),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: markAllAsRead,
              child: const Text(
                'Mark All Read',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isSelected = selectedFilter == filter;
                final filterCount = filter == 'All' 
                    ? notifications.length 
                    : notifications.where((n) => n['type'] == filter).length;

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.amber : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.amber : Colors.white30,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            filter,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.black26 : Colors.white24,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              filterCount.toString(),
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Notifications List
          Expanded(
            child: filteredNotifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 64,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No notifications found',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 18,
                            fontFamily: 'Roboto_Condensed-Regular',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          selectedFilter == 'All' 
                              ? 'You\'re all caught up!'
                              : 'No $selectedFilter notifications',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isUnread = !notification['isRead'];
    final priority = notification['priority'];
    
    return Dismissible(
      key: Key(notification['id'].toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 24,
        ),
      ),
      onDismissed: (direction) {
        deleteNotification(notification['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification deleted'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.white,
              onPressed: () {
                // In a real app, you'd restore the notification here
              },
            ),
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          if (isUnread) {
            markAsRead(notification['id']);
          }
          // Handle notification tap - navigate to relevant screen
          _handleNotificationTap(notification);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUnread ? Colors.white : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: isUnread 
                ? Border.all(color: Colors.amber, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: notification['iconColor'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  notification['icon'],
                  color: notification['iconColor'],
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                              fontFamily: 'Roboto_Condensed-Bold',
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (priority == 'high')
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      notification['message'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.7),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              notification['time'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getTypeColor(notification['type']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            notification['type'],
                            style: TextStyle(
                              fontSize: 10,
                              color: _getTypeColor(notification['type']),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Unread indicator
              if (isUnread)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(left: 8, top: 4),
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Orders':
        return Colors.blue;
      case 'Offers':
        return Colors.red;
      case 'Updates':
        return Colors.green;
      case 'Reminders':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    // Handle different notification types
    switch (notification['type']) {
      case 'Orders':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening order details...')),
        );
        break;
      case 'Offers':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening deals page...')),
        );
        break;
      case 'Reminders':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening cart...')),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opened: ${notification['title']}')),
        );
    }
  }
}
