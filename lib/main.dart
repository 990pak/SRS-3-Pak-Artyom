import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 3 App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          primary: Colors.indigo,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        cardTheme: const CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// Главный экран с TabBar и Drawer
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Map<String, String>> _items = List.generate(
    10,
        (index) => {
      'title': 'Товар №${index + 1}',
      'subtitle': 'Описание или дополнительная информация товара ${index + 1}',
    },
  );

  void _addNewItem(String itemName) {
    setState(() {
      _items.add({
        'title': itemName,
        'subtitle': 'Пользовательский элемент',
      });
    });
    Fluttertoast.showToast(
      msg: 'Добавлен элемент: $itemName',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showAddDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Новый элемент'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Введите название',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _addNewItem(controller.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Мое приложение (Lab 3)'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Список', icon: Icon(Icons.list)),
              Tab(text: 'Сетка', icon: Icon(Icons.grid_view)),
            ],
          ),
        ),
        drawer: const AppDrawer(),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: _items.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Icon(Icons.shopping_bag, color: Colors.white),
                    ),
                    title: Text(_items[index]['title']!),
                    subtitle: Text(_items[index]['subtitle']!),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Fluttertoast.showToast(
                        msg: 'Вы выбрали элемент №${index + 1}: ${_items[index]['title']}',
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    },
                  ),
                );
              },
            ),
            const GridScreen(),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'helloBtn',
              backgroundColor: Colors.orange,
              onPressed: () {
                Fluttertoast.showToast(
                  msg: 'Hello, Flutter!',
                  toastLength: Toast.LENGTH_SHORT,
                );
              },
              child: const Icon(Icons.waving_hand, color: Colors.white),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'addBtn',
              onPressed: _showAddDialog,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

class GridScreen extends StatefulWidget {
  const GridScreen({super.key});

  @override
  State<GridScreen> createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  final List<bool> _isClicked = List.generate(6, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.3,
        ),
        itemBuilder: (context, index) {
          final color = _isClicked[index] ? Colors.green : Colors.indigo;
          return GestureDetector(
            onTap: () {
              setState(() {
                _isClicked[index] = !_isClicked[index];
              });
              Fluttertoast.showToast(
                msg: 'Нажата ячейка №${index + 1}',
                toastLength: Toast.LENGTH_SHORT,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            accountName: Text('Иван Иванов'),
            accountEmail: Text('ivan.ivanov@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.indigo),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Главная'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Профиль'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Настройки'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Выход', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: 'Выход из аккаунта',
                toastLength: Toast.LENGTH_SHORT,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard),
            title: const Text('Каталог карточек'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CardsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль пользователя')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: const [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.indigo,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Text('Иван Иванов', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Email: ivan.ivanov@example.com', style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 10),
            Text('Статус: Студент / Разработчик', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Включить уведомления'),
            subtitle: const Text('Получать системные пуш-уведомления'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
              Fluttertoast.showToast(
                msg: 'Настройки сохранены',
                toastLength: Toast.LENGTH_SHORT,
              );
            },
          ),
        ],
      ),
    );
  }
}

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> products = [
      {'name': 'Смартфон', 'desc': 'Современный смартфон с отличной камерой и мощным процессором.'},
      {'name': 'Ноутбук', 'desc': 'Производительный ноутбук для работы, учебы и программирования.'},
      {'name': 'Наушники', 'desc': 'Беспроводные наушники с активным шумоподавлением.'},
      {'name': 'Планшет', 'desc': 'Легкий и компактный планшет для чтения и просмотра медиа.'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Каталог карточек')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.indigo.shade100,
                  child: const Icon(Icons.image, size: 64, color: Colors.indigo),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        products[index]['name']!,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        products[index]['desc']!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailProductScreen(
                                  productName: products[index]['name']!,
                                  productDesc: products[index]['desc']!,
                                ),
                              ),
                            );
                          },
                          child: const Text('Подробнее'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DetailProductScreen extends StatelessWidget {
  final String productName;
  final String productDesc;

  const DetailProductScreen({
    super.key,
    required this.productName,
    required this.productDesc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(productName)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.indigo),
            ),
            const SizedBox(height: 20),
            Text(
              productName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              productDesc,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            const Text(
              'Характеристики:\n• Гарантия: 1 год\n• Доставка: бесплатная\n• В наличии: много',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}